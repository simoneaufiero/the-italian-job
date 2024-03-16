balancedPortfolio=(GMVP+bayesSSOptimalPortfolio+blSSOptimalPortfolio+shortSellingOptimalPortfolio)/4;
[balancedPortfolioRisk,balancedPortfolioReturn]=estimatePortMoments(noShortSellingPortfolio,balancedPortfolio);
balancedPortfolioTT=getPortfolioTT(balancedPortfolio,dailyPortfolioTT,numobs,numAssets);
balancedPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(balancedPortfolioTT,'Method','continuous'));

mBalancedPortfolio=(mGMVP+mBayesSSOptimalPortfolio+mBlSSOptimalPortfolio+mShortSellingOptimalPortfolio)/4;
[mBalancedPortfolioRisk,mBalancedPortfolioReturn]=estimatePortMoments(noShortSellingPortfolio,mBalancedPortfolio);
mBalancedPortfolioTT=getPortfolioTT(mBalancedPortfolio,monthlyPortfolioTT,mNumobs,numAssets);
mBalancedPortfolioSummaryStatistic=getSummaryStatistics(tick2ret(mBalancedPortfolioTT,'Method','continuous'));