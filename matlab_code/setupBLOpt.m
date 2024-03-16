viewCount=5;

%% general view setup

pickMatrix = zeros(viewCount, numAssets);
viewCol = zeros(viewCount, 1);
%blViewUncert = zeros(viewCount);

% Hera +10% annuum
pickMatrix(1, portfolioAssetNames=="HERA") = 1; 
viewCol(1) = 0.10;
%blViewUncert(1, 1) = 1e-4;

% Leonardo +15% annuum
pickMatrix(2, portfolioAssetNames=="LEONARDO") = 1; 
viewCol(2) = 0.15;
%blViewUncert(2, 2) = 1e-5;

% ENAV -10% annuum
pickMatrix(3, portfolioAssetNames=="ENAV") = 1; 
viewCol(3) = -0.1;
%blViewUncert(3, 3) = 1e-5;

% Ecosuntek OUTP Prelli 35% annuum
pickMatrix(4, portfolioAssetNames=="ECOSUNTEK") = 1; 
pickMatrix(4, portfolioAssetNames=="PIRELLIC") = -1; 
viewCol(4) = 0.35;
%blViewUncert(4, 4) = 1e-5;

% Datalogic OUTP Tods 20% annuum
pickMatrix(5, portfolioAssetNames=="DATALOGIC") = 1; 
pickMatrix(5, portfolioAssetNames=="TODS") = -1; 
viewCol(5) = 0.2;
%blViewUncert(5, 5) = 5e-4;

aViewCol=viewCol;

%% setting up reliability data
blReliabilityFactor= 0.5;  % belongs in (0,1]: ovveride views confidence 
% blReliabilityFactor= (1 - numobs/(numobs+1));   % this is the usual tau=1/T, daily
blViewReliability = (1/blReliabilityFactor - 1);

%% daily data blending
viewCol=aViewCol/252;
blViewUncert=blViewReliability*pickMatrix*portfolioAssetCovariance*pickMatrix';
viewTable = array2table([pickMatrix viewCol diag(blViewUncert)], 'VariableNames', [portfolioAssetNames "View_Return" "View_Uncertainty"]);
blMu=portfolioAssetMeans+portfolioAssetCovariance*pickMatrix'*inv(pickMatrix*portfolioAssetCovariance*pickMatrix' + blViewUncert)*(viewCol-pickMatrix*portfolioAssetMeans);
blCov=portfolioAssetCovariance-portfolioAssetCovariance*pickMatrix'*inv(pickMatrix*portfolioAssetCovariance*pickMatrix' + blViewUncert)*pickMatrix*portfolioAssetCovariance;
blCov=(blCov+blCov')/2;
blBlendingSummary=table(portfolioAssetNames', portfolioAssetMeans, blMu, 'VariableNames', ["Asset_Name", "Prior_Belief_of_Expected_Return", "Black_Litterman_Blended_Expected_Return"]);

%% monthly data blending

blReliabilityFactor= 0.5;  % belongs in (0,1]: ovveride views confidence 
%blReliabilityFactor= (1 - mNumobs/(mNumobs+1));   % this is the usual tau=1/T, monthly
blViewReliability = (1/blReliabilityFactor - 1);

mViewCol=aViewCol/12;
mBlViewUncert=blViewReliability*pickMatrix*mPortfolioAssetCovariance*pickMatrix';
mViewTable = array2table([pickMatrix mViewCol diag(mBlViewUncert)], 'VariableNames', [portfolioAssetNames "View_Return" "View_Uncertainty"]);
mBlMu=mPortfolioAssetMeans+mPortfolioAssetCovariance*pickMatrix'*inv(pickMatrix*mPortfolioAssetCovariance*pickMatrix' + mBlViewUncert)*(mViewCol-pickMatrix*mPortfolioAssetMeans);
mBlCov=mPortfolioAssetCovariance-mPortfolioAssetCovariance*pickMatrix'*inv(pickMatrix*mPortfolioAssetCovariance*pickMatrix' + mBlViewUncert)*pickMatrix*mPortfolioAssetCovariance;
mBlCov=(mBlCov+mBlCov')/2; % account for error propagation:(
mBlBlendingSummary=table(portfolioAssetNames', mPortfolioAssetMeans, mBlMu, 'VariableNames', ["Asset_Name", "Prior_Belief_of_Expected_Return", "Black_Litterman_Blended_Expected_Return"]);

%% get BLOpt, NOSS daily portfolio

blNOSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL NOSS','AssetMean',blMu,'AssetCovar',blCov);
blNOSSPortfolio = setDefaultConstraints(blNOSSPortfolio);
%blNOSSPortfolio.LowerBound = ones(numAssets,1);
blNOSSOptimalPortfolio=estimateMaxSharpeRatio(blNOSSPortfolio);
[blNOSSOptimalPortfolioRisk,blNOSSOptimalPortfolioReturn]=estimatePortMoments(blNOSSPortfolio,blNOSSOptimalPortfolio);
blNOSSOptimalPortfolioTT=getPortfolioTT(blNOSSOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
blNOSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(blNOSSOptimalPortfolioTT,'Method','continuous'));

%% get BLOpt, SS daily portfolio

blSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL SS','AssetMean',blMu,'AssetCovar',blCov);
blSSPortfolio = setDefaultConstraints(blSSPortfolio);
blSSPortfolio.LowerBound = -lb*ones(numAssets,1);
blSSOptimalPortfolio=estimateMaxSharpeRatio(blSSPortfolio);
[blSSOptimalPortfolioRisk,blSSOptimalPortfolioReturn]=estimatePortMoments(blSSPortfolio,blSSOptimalPortfolio);
blSSOptimalPortfolioTT=getPortfolioTT(blSSOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
blSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(blSSOptimalPortfolioTT,'Method','continuous'));

%% get BLOpt, NOSS monthly portfolio

mBlNOSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL NOSS','AssetMean',mBlMu,'AssetCovar',mBlCov);
mBlNOSSPortfolio = setDefaultConstraints(mBlNOSSPortfolio);
%mBlNOSSPortfolio.LowerBound = ones(numAssets,1);
mBlNOSSOptimalPortfolio=estimateMaxSharpeRatio(mBlNOSSPortfolio);
[mBlNOSSOptimalPortfolioRisk,mBlNOSSOptimalPortfolioReturn]=estimatePortMoments(mBlNOSSPortfolio,mBlNOSSOptimalPortfolio);
mBlNOSSOptimalPortfolioTT=getPortfolioTT(mBlNOSSOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mBlNOSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mBlNOSSOptimalPortfolioTT,'Method','continuous'));

%% get BLOpt, SS monthly portfolio

mBlSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL SS','AssetMean',mBlMu,'AssetCovar',mBlCov);
mBlSSPortfolio = setDefaultConstraints(mBlSSPortfolio);
mBlSSPortfolio.LowerBound = -lb*ones(numAssets,1);
mBlSSOptimalPortfolio=estimateMaxSharpeRatio(mBlSSPortfolio);
[mBlSSOptimalPortfolioRisk,mBlSSOptimalPortfolioReturn]=estimatePortMoments(mBlSSPortfolio,mBlSSOptimalPortfolio);
mBlSSOptimalPortfolioTT=getPortfolioTT(mBlSSOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mBlSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mBlSSOptimalPortfolioTT,'Method','continuous'));







