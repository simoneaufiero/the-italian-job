%% prepare scatterplot and frontier data for NOSS Portfolio

%smoothness factor, higher is better (but slower)
smoothness=300;

% optimal portfolio is obtained as the sharpe ratio maximizing portfolio
noShortSellingOptimalPortfolio = estimateMaxSharpeRatio(noShortSellingPortfolio);
[noShortSellingOptimalPortfolioRisk, noShortSellingOptimalPortfolioReturn] = estimatePortMoments(noShortSellingPortfolio,noShortSellingOptimalPortfolio);

% evaluate other frontier points
noShortSellingFrontierPorts=estimateFrontier(noShortSellingPortfolio,smoothness);
[noShortSellingFrontierPortsRisk, noShortSellingFrontierPortsReturn] = estimatePortMoments(noShortSellingPortfolio,noShortSellingFrontierPorts);

noShortSellingOptimalPortfolioTT=getPortfolioTT(noShortSellingOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
noShortSellingOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(noShortSellingOptimalPortfolioTT,'Method','continuous'));

%% prepare scatterplot and frontier data for SS Portfolio

% optimal portfolio is obtained as the sharpe ratio maximizing portfolio
shortSellingOptimalPortfolio = estimateMaxSharpeRatio(shortSellingPortfolio);
[shortSellingOptimalPortfolioRisk, shortSellingOptimalPortfolioReturn] = estimatePortMoments(shortSellingPortfolio,shortSellingOptimalPortfolio);

% evaluate other frontier points
[sSRiskBound,sSRetBound]=estimatePortMoments(shortSellingPortfolio,estimateFrontierLimits(shortSellingPortfolio));
shortSellingFrontierPorts=estimateFrontierByRisk(shortSellingPortfolio,linspace(min(sSRiskBound),1.1*shortSellingOptimalPortfolioRisk,smoothness));
[shortSellingFrontierPortsRisk, shortSellingFrontierPortsReturn] = estimatePortMoments(shortSellingPortfolio,shortSellingFrontierPorts);

shortSellingOptimalPortfolioTT=getPortfolioTT(shortSellingOptimalPortfolio,dailyPortfolioTT,numobs,numAssets);
shortSellingOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(shortSellingOptimalPortfolioTT,'Method','continuous'));


%% format single asset informations;
[assetPortsRisk, assetPortsReturn] = estimatePortMoments(shortSellingPortfolio,eye(numAssets));

%% prepare scatterplot and frontier data for monthly NOSS Portfolio

% optimal portfolio is obtained as the sharpe ratio maximizing portfolio
mNoShortSellingOptimalPortfolio = estimateMaxSharpeRatio(mNoShortSellingPortfolio);
[mNoShortSellingOptimalPortfolioRisk, mNoShortSellingOptimalPortfolioReturn] = estimatePortMoments(mNoShortSellingPortfolio,mNoShortSellingOptimalPortfolio);

% evaluate other frontier points
mNoShortSellingFrontierPorts=estimateFrontier(mNoShortSellingPortfolio,smoothness);
[mNoShortSellingFrontierPortsRisk, mNoShortSellingFrontierPortsReturn] = estimatePortMoments(mNoShortSellingPortfolio,mNoShortSellingFrontierPorts);

mNoShortSellingOptimalPortfolioTT=getPortfolioTT(mNoShortSellingOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mNoShortSellingOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mNoShortSellingOptimalPortfolioTT,'Method','continuous'));

%% prepare scatterplot and frontier data for monthly SS Portfolio

% optimal portfolio is obtained as the sharpe ratio maximizing portfolio
mShortSellingOptimalPortfolio = estimateMaxSharpeRatio(mShortSellingPortfolio);
[mShortSellingOptimalPortfolioRisk, mShortSellingOptimalPortfolioReturn] = estimatePortMoments(mShortSellingPortfolio,mShortSellingOptimalPortfolio);


[mSSRiskBound,mSSRetBound]=estimatePortMoments(mShortSellingPortfolio,estimateFrontierLimits(mShortSellingPortfolio));

% evaluate other frontier points
mShortSellingFrontierPorts=estimateFrontierByRisk(mShortSellingPortfolio,linspace(min(mSSRiskBound),1.1*mShortSellingOptimalPortfolioRisk,smoothness));
[mShortSellingFrontierPortsRisk, mShortSellingFrontierPortsReturn] = estimatePortMoments(mShortSellingPortfolio,mShortSellingFrontierPorts);

mShortSellingOptimalPortfolioTT=getPortfolioTT(mShortSellingOptimalPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mShortSellingOptimalPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mShortSellingOptimalPortfolioTT,'Method','continuous'));

%% format single asset monthly informations;
[mAssetPortsRisk, mAssetPortsReturn] = estimatePortMoments(mShortSellingPortfolio,eye(numAssets));