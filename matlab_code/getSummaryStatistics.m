function summaryTable = getSummaryStatistics(timetableData)
%getSummaryStatistics Evaluate summary statistics for data in timetable

%apply function to timetable variables (ie name series), then flip table
%and convert names to variables and results to variables. Then extract the
%results (stored in default name variable Var1)

mu=rows2vars(varfun(@(x) mean(x,"omitnan"),timetableData,'OutputFormat','table')).Var1;
sigma2=rows2vars(varfun(@(x) var(x,"omitnan"),timetableData,'OutputFormat','table')).Var1;
sigma=rows2vars(varfun(@(x) sqrt(var(x,"omitnan")),timetableData,'OutputFormat','table')).Var1;
sk=rows2vars(varfun(@(x) skewness(x,0),timetableData,'OutputFormat','table')).Var1;
kurt=rows2vars(varfun(@(x) kurtosis(x,0),timetableData,'OutputFormat','table')).Var1;
jb=rows2vars(varfun(@(x) jbtest(x,.05),timetableData,'OutputFormat','table')).Var1;
%jb=rows2vars(varfun(@(x) 1,timetableData,'OutputFormat','table')).Var1; %
%use for debug purposes
%recover original names from parameter. Apply appropriate type conversions,
%then rename and format output table
summaryTable=table(convertCharsToStrings(timetableData.Properties.VariableNames'),mu,sigma2,sigma,sk,kurt,jb);
summaryTable=renamevars(summaryTable,["Var1","mu","sigma2","sigma","sk","kurt","jb"],["Name","Mean","Variance","SD","Skewness","Kurtosis","JBPassFail"]);
end