assetReg=zeros(numAssets,2);
mAssetReg=zeros(numAssets,2);

mNoShortSellingOptimalPortfolioReg=regress(tick2ret(table2array(timetable2table(mNoShortSellingOptimalPortfolioTT,'ConvertRowTimes',false)))-mrf,[ones(mNumobs-1,1) monthlyIndexRet.FTSEITALIAALLSHAREPRICEINDEX(mEarliestNoNaN:end)-mrf]);
mShortSellingOptimalPortfolioReg=regress(tick2ret(table2array(timetable2table(mShortSellingOptimalPortfolioTT,'ConvertRowTimes',false)))-mrf,[ones(mNumobs-1,1) monthlyIndexRet.FTSEITALIAALLSHAREPRICEINDEX(mEarliestNoNaN:end)-mrf]);
noShortSellingOptimalPortfolioReg=regress(tick2ret(table2array(timetable2table(noShortSellingOptimalPortfolioTT,'ConvertRowTimes',false)))-rf,[ones(numobs-1,1) dailyIndexRet.FITASHERI(earliestNoNaN:end)-rf]);
shortSellingOptimalPortfolioReg=regress(tick2ret(table2array(timetable2table(shortSellingOptimalPortfolioTT,'ConvertRowTimes',false)))-rf,[ones(numobs-1,1) dailyIndexRet.FITASHERI(earliestNoNaN:end)-rf]);

for j=1:numAssets
    assetReg(j,:)=regress(tick2ret(table2array(timetable2table(dailyPortfolioTT(:,j),'ConvertRowTimes',false)))-rf,[ones(numobs-1,1) (dailyIndexRet.FITASHERI(earliestNoNaN:end))-rf]);
end

for j=1:numAssets
    mAssetReg(j,:)=regress(tick2ret(table2array(timetable2table(monthlyPortfolioTT(:,j),'ConvertRowTimes',false)))-mrf,[ones(mNumobs-1,1) (monthlyIndexRet.FTSEITALIAALLSHAREPRICEINDEX(mEarliestNoNaN:end))-mrf]);
end

clear j