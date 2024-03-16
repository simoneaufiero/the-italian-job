%% standard daily data blending

bayesPriorMean=portfolioAssetMeans+sqrt(diag(portfolioAssetCovariance));
bayesPriorCovariance=2*(portfolioAssetCovariance);
bayesPosteriorMean=inv(numobs*inv(portfolioAssetCovariance)+inv(bayesPriorCovariance))*(numobs*inv(portfolioAssetCovariance)*portfolioAssetMeans+inv(bayesPriorCovariance)*portfolioAssetMeans);
bayesPosteriorCovariance=inv(inv(bayesPriorCovariance)+numobs*inv(portfolioAssetCovariance));

%% standard monthly data blending

mBayesPriorMean=mPortfolioAssetMeans+sqrt(diag(mPortfolioAssetCovariance));
mBayesPriorCovariance=2*(mPortfolioAssetCovariance);
mBayesPosteriorMean=inv(mNumobs*inv(mPortfolioAssetCovariance)+inv(mBayesPriorCovariance))*(mNumobs*inv(mPortfolioAssetCovariance)*mPortfolioAssetMeans+inv(mBayesPriorCovariance)*mPortfolioAssetMeans);
mBayesPosteriorCovariance=inv(inv(mBayesPriorCovariance)+mNumobs*inv(mPortfolioAssetCovariance));

%% Jorion daily data blending

h=1;
jorionPriorMean = noShortSellingFrontierPortsReturn(1)*ones(numAssets,1);
jorionPriorCovariance = (1/h)*portfolioAssetCovariance;
jorionPosteriorMean=inv(numobs*inv(portfolioAssetCovariance)+inv(jorionPriorCovariance))*(numobs*inv(portfolioAssetCovariance)*portfolioAssetMeans+inv(jorionPriorCovariance)*portfolioAssetMeans);
jorionPosteriorCovariance=inv(inv(jorionPriorCovariance)+numobs*inv(portfolioAssetCovariance));

%% Jorion monthly data blending

h=1;
mJorionPriorMean = noShortSellingFrontierPortsReturn(1)*ones(numAssets,1);
mJorionPriorCovariance = (1/h)*mPortfolioAssetCovariance;
mJorionPosteriorMean=inv(mNumobs*inv(mPortfolioAssetCovariance)+inv(mJorionPriorCovariance))*(mNumobs*inv(mPortfolioAssetCovariance)*mPortfolioAssetMeans+inv(mJorionPriorCovariance)*mPortfolioAssetMeans);
mJorionPosteriorCovariance=inv(inv(mJorionPriorCovariance)+mNumobs*inv(mPortfolioAssetCovariance));

%% renaming for ease

bayesMu=bayesPosteriorMean;
bayesCov=bayesPosteriorCovariance;
mBayesMu=mBayesPosteriorMean;
mBayesCov=mBayesPosteriorCovariance;

%% get bayesOpt, NOSS daily portfolio

bayesNOSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily bayes NOSS','AssetMean',bayesMu,'AssetCovar',bayesCov);
bayesNOSSPortfolio = setDefaultConstraints(bayesNOSSPortfolio);
%bayesNOSSPortfolio.LowerBound = ones(numAssets,1);
bayesNOSSOptimalPortfolio=estimateMaxSharpeRatio(bayesNOSSPortfolio);
[bayesNOSSOptimalPortfolioRisk,bayesNOSSOptimalPortfolioReturn]=estimatePortMoments(bayesNOSSPortfolio,bayesNOSSOptimalPortfolio);
bayesNOSSOptimalPortfolioTT=getPortfolioTT(bayesNOSSOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
bayesNOSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(bayesNOSSOptimalPortfolioTT,'Method','continuous'));

%% get bayesOpt, SS daily portfolio

bayesSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily bayes SS','AssetMean',bayesMu,'AssetCovar',bayesCov);
bayesSSPortfolio = setDefaultConstraints(bayesSSPortfolio);
bayesSSPortfolio.LowerBound = -lb*ones(numAssets,1);
bayesSSOptimalPortfolio=estimateMaxSharpeRatio(bayesSSPortfolio);
[bayesSSOptimalPortfolioRisk,bayesSSOptimalPortfolioReturn]=estimatePortMoments(bayesSSPortfolio,bayesSSOptimalPortfolio);
bayesSSOptimalPortfolioTT=getPortfolioTT(bayesSSOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
bayesSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(bayesSSOptimalPortfolioTT,'Method','continuous'));

%% get bayesOpt, NOSS monthly portfolio

mBayesNOSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL NOSS','AssetMean',mBayesMu,'AssetCovar',mBayesCov);
mBayesNOSSPortfolio = setDefaultConstraints(mBayesNOSSPortfolio);
%mBayesNOSSPortfolio.LowerBound = ones(numAssets,1);
mBayesNOSSOptimalPortfolio=estimateMaxSharpeRatio(mBayesNOSSPortfolio);
[mBayesNOSSOptimalPortfolioRisk,mBayesNOSSOptimalPortfolioReturn]=estimatePortMoments(mBayesNOSSPortfolio,mBayesNOSSOptimalPortfolio);
mBayesNOSSOptimalPortfolioTT=getPortfolioTT(mBayesNOSSOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mBayesNOSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mBayesNOSSOptimalPortfolioTT,'Method','continuous'));

%% get BLOpt, SS monthly portfolio

mBayesSSPortfolio = Portfolio('AssetNames',portfolioAssetNames,'NumAssets',numAssets,'Name','Daily BL SS','AssetMean',mBayesMu,'AssetCovar',mBayesCov);
mBayesSSPortfolio = setDefaultConstraints(mBayesSSPortfolio);
mBayesSSPortfolio.LowerBound = -lb*ones(numAssets,1);
mBayesSSOptimalPortfolio=estimateMaxSharpeRatio(mBayesSSPortfolio);
[mBayesSSOptimalPortfolioRisk,mBayesSSOptimalPortfolioReturn]=estimatePortMoments(mBayesSSPortfolio,mBayesSSOptimalPortfolio);
mBayesSSOptimalPortfolioTT=getPortfolioTT(mBayesSSOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mBayesSSOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mBayesSSOptimalPortfolioTT,'Method','continuous'));


