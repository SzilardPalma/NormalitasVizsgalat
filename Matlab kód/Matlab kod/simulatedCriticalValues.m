m = 50000;
n = 10:10:100;
alpha = 0.05;
filename ='criticalValues.xlsx';
stats = zeros(length(n),9);

warning('off', 'all');

for i = n
    rowIndex = i/10;
    simSamples = normrnd(0,1,m,i);

    % Left-tailed tests: critical values at the alpha-th percentile
    criticalValueInputOperatorLeft = @(y) criticalValue(simSamples,y, alpha, false);

    % 100(1-alpha)th percentile:
    criticalValueInputOperatorRight = @(y) criticalValue(simSamples,y, 1-alpha, false);
    criticalValueInputOperatorChi2Test = @(x) criticalValue(simSamples,x, 1-alpha, true);
    
    % Shapiro-Wilk, Shapiro-Francia tests:
    stats(rowIndex,1:2) = arrayfun(criticalValueInputOperatorLeft, ["swTest","sfTest"]);
    
    % Anderson-Darling, Cramér-von mises, Kolmogorov-Smirnov tests 
    % and Jarque-Bera, D'Agostino-Pearson tests 
    % and Vasicek tests:
    stats(rowIndex,3:4) = arrayfun(criticalValueInputOperatorRight, ["adtest","cvmTest"]);
    stats(rowIndex,5:8) = arrayfun(criticalValueInputOperatorRight, ["kstest","jbtest","DagosPtest", "vasicekTest"]);

    % Chi-square test:
    stats(rowIndex,9) = arrayfun(criticalValueInputOperatorChi2Test, ["chi2gof"]); 
end

xlswrite(filename, stats, 'Sheet1', ['A' num2str(1)]);

