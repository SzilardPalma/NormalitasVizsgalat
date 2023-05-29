function [cValue] = criticalValue(x, testName, percentile, chi2Test)
%   The percentile is used to obtain the ctical values:
%   (1- alpha) for right-tailed, (alpha) for right-tailed 

if ~isempty(chi2Test)
   if ~islogical(chi2Test)
      error(' chi2Test must be logical indicating whether the Pearson ch2gof test is performed.');
   end
else
   chi2Test = 0;
end

%applytoRows operator:
applyToGivenRow = @(func, matrix) @(row) func(matrix(row, :));
applyToRows = @(func, matrix) arrayfun(applyToGivenRow(func, matrix), 1:size(matrix,1));

%Convert string to the normality test function:
funcHandler = str2func(testName);

switch chi2Test
    case false
        [~, ~, testStats] = applyToRows(funcHandler,x);
    otherwise
         [~, ~, chistats] = applyToRows(@chi2gof,x);
         testStats = vertcat(chistats.chi2stat);
end

% calculate empirical cumulative distribution function of the test
% statistics:
[f,xValues]=ecdf(testStats);

% approximate the given percentile:
%A = repmat(percentile,[1 length(f)]);
%[minValue,closestIndex] = min(abs(A-f'));
%cValue = xValues(closestIndex);
cValue = prctile(testStats, percentile*100);
end