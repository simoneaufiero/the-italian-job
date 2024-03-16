function covMatrix = getCovarianceMatrix(timetableData)
%getCovarianceMatrix Get covariance matrix from timetable

%extract raw data from timetable, then evaluate covariance omitting only
%pairwise missing observations

rawCovMatrix=cov(table2array(timetable2table(timetableData,'ConvertRowTimes',false)),'omitrows');

%add labels and convert to table
covMatrix=array2table(rawCovMatrix,'VariableNames',convertCharsToStrings(timetableData.Properties.VariableNames),'RowNames',convertCharsToStrings(timetableData.Properties.VariableNames));


end