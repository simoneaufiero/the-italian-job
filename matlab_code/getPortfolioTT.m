function portfolioTT = getPortfolioTT(pWeights,assetsTT,numobs,numasset)
    tmparray=zeros(numobs,1);
    beginningIndexes=zeros(numasset,1);

    for j=1:numasset
        beginningIndexes(j) = table2array(varfun(@(x) find(~isnan(x), 1 ),assetsTT(:,j),'OutputFormat','table'));
    end
    bIndex=max(beginningIndexes);

    for j=1:numasset
        tmparray=tmparray + table2array(varfun(@(x) (x.*pWeights(j))/x(bIndex),assetsTT(:,j),'OutputFormat','table'));
    end
    
    portfolioTT=array2timetable(tmparray,'RowTimes',assetsTT.date);

end