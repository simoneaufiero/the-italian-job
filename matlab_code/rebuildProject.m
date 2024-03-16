%% format initial data
dailyIndexRet=tick2ret(dailyIndexTT,'Method','continuous');
dailyStockRet=tick2ret(dailyStockTT,'Method','continuous');
dailyStockRetDelist=tick2ret(dailyStockTTDelist,'Method','continuous');
monthlyIndexRet=tick2ret(monthlyIndexTT,'Method','continuous');
monthlyStockRet=tick2ret(monthlyStockTT,'Method','continuous');
monthlyStockRetDelist=tick2ret(monthlyStockTTDelist,'Method','continuous');

monthlyStockCorrMatrixDelist=getCorrelationMatrix(monthlyStockRetDelist);
monthlyStockCorrMatrix=getCorrelationMatrix(monthlyStockRet);
dailyStockCorrMatrixDelist=getCorrelationMatrix(dailyStockRetDelist);
dailyStockCorrMatrix=getCorrelationMatrix(dailyStockRet);

monthlyStockCovMatrixDelist=getCovarianceMatrix(monthlyStockRetDelist);
monthlyStockCovMatrix=getCovarianceMatrix(monthlyStockRet);
dailyStockCovMatrixDelist=getCovarianceMatrix(dailyStockRetDelist);
dailyStockCovMatrix=getCovarianceMatrix(dailyStockRet);

monthlyStockSummaryStatistics=getSummaryStatistics(monthlyStockRet);
monthlyStockSummaryStatisticsDelist=getSummaryStatistics(monthlyStockRetDelist);
dailyStockSummaryStatistics=getSummaryStatistics(dailyStockRet);
dailyStockSummaryStatisticsDelist=getSummaryStatistics(dailyStockRetDelist);

monthlyIndexSummaryStatistics=getSummaryStatistics(monthlyIndexRet);
dailyIndexSummaryStatistics=getSummaryStatistics(dailyIndexRet);
%% rebuilds all milestones from 5 to 15

% discard rows with NaNs
earliestNoNaN=720;
mEarliestNoNaN=35;
numAssets=11;

portfolioAssetsTTNoNaN = dailyStockTT(earliestNoNaN:end, portfolioAssetCodes);
%portfolioAssetMeans=mean(table2array(timetable2table(tick2ret(dailyStockTT(earliestNoNaN:end, portfolioAssetCodes),'Method','continuous'),'ConvertRowTimes',false)));
%portfolioAssetMeans=portfolioAssetMeans';
%portfolioAssetCovariance=cov(table2array(timetable2table(tick2ret(dailyStockTT(earliestNoNaN:end, portfolioAssetCodes),'Method','continuous'),'ConvertRowTimes',false)));
portfolioAssetCorrelation=corrcov(portfolioAssetCovariance);

mPortfolioAssetsTTNoNaN = monthlyStockTT(mEarliestNoNaN:end, portfolioAssetCodes);
%mPortfolioAssetMeans=mean(table2array(timetable2table(tick2ret(monthlyStockTT(mEarliestNoNaN:end, portfolioAssetCodes),'Method','continuous'),'ConvertRowTimes',false)));
%mPortfolioAssetMeans=mPortfolioAssetMeans';
%mPortfolioAssetCovariance=cov(table2array(timetable2table(tick2ret(monthlyStockTT(mEarliestNoNaN:end, portfolioAssetCodes),'Method','continuous'),'ConvertRowTimes',false)));
mPortfolioAssetCorrelation=corrcov(mPortfolioAssetCovariance);

%% update all base portfolios
lb=10;
shortSellingPortfolio= Portfolio;
shortSellingPortfolio.NumAssets=numAssets;
shortSellingPortfolio= setDefaultConstraints(shortSellingPortfolio);
shortSellingPortfolio.LowerBound=-lb*ones(numAssets,1);
shortSellingPortfolio=estimateAssetMoments(shortSellingPortfolio,portfolioAssetsTTNoNaN,'dataformat','prices');
[portfolioAssetMeans,portfolioAssetCovariance]=getAssetMoments(shortSellingPortfolio);

noShortSellingPortfolio= Portfolio;
noShortSellingPortfolio.NumAssets=numAssets;
noShortSellingPortfolio= setDefaultConstraints(noShortSellingPortfolio);
noShortSellingPortfolio=estimateAssetMoments(noShortSellingPortfolio,portfolioAssetsTTNoNaN,'dataformat','prices');

mShortSellingPortfolio= Portfolio;
mShortSellingPortfolio.NumAssets=numAssets;
mShortSellingPortfolio= setDefaultConstraints(mShortSellingPortfolio);
mShortSellingPortfolio.LowerBound=-lb*ones(numAssets,1);
mShortSellingPortfolio=estimateAssetMoments(mShortSellingPortfolio,mPortfolioAssetsTTNoNaN,'dataformat','prices');
[mPortfolioAssetMeans,mPortfolioAssetCovariance]=getAssetMoments(mShortSellingPortfolio);

mNoShortSellingPortfolio= Portfolio;
mNoShortSellingPortfolio.NumAssets=numAssets;
mNoShortSellingPortfolio= setDefaultConstraints(mNoShortSellingPortfolio);
mNoShortSellingPortfolio=estimateAssetMoments(mNoShortSellingPortfolio,mPortfolioAssetsTTNoNaN,'dataformat','prices');


mNumobs=max(size(mPortfolioAssetsTTNoNaN));
numobs=max(size(portfolioAssetsTTNoNaN));

%% rebuild project

setupMVOpt
setupBetas
setupBLOpt
setupBayesOpt
getGMVP
setupBalancedPortfolio