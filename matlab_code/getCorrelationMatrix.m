function corrMatrix = getCorrelationMatrix(timetableData)
%getCovarianceMatrix Get covariance matrix from timetable

%extract raw data from timetable, then evaluate covariance omitting only
%pairwise missing observations

rawCorrMatrix=corrcoef(table2array(timetable2table(timetableData,'ConvertRowTimes',false)),'Rows','complete');

%add labels and convert to table
corrMatrix=array2table(rawCorrMatrix,'VariableNames',convertCharsToStrings(timetableData.Properties.VariableNames),'RowNames',convertCharsToStrings(timetableData.Properties.VariableNames));


end