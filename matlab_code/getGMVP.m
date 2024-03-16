GMVP=shortSellingFrontierPorts(:,1);
[GMVPRisk,GMVPReturn]=estimatePortMoments(noShortSellingPortfolio,GMVP);
GMVPTT=getPortfolioTT(GMVP,dailyPortfolioTT,numobs,numAssets);
GMVPSummaryStatistic=getSummaryStatistics(tick2ret(GMVPTT));

mGMVP=mShortSellingFrontierPorts(:,1);
[mGMVPRisk,mGMVPReturn]=estimatePortMoments(mNoShortSellingPortfolio,mGMVP);
mGMVPTT=getPortfolioTT(mGMVP,monthlyPortfolioTT,mNumobs,numAssets);
mGMVPSummaryStatistic=getSummaryStatistics(tick2ret(mGMVPTT));