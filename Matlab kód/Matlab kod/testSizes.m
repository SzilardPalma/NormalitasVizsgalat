rng(4);
m = 50000;
n = 10:10:100;
filename ='testSize.xlsx';
statsSizes = zeros(length(n),9);

warning('off', 'all');

for i = n
    rowIndex = i/10;
    simSamples = normrnd(0,1,m,i);
    testSizeOperator = @(y) testSize(simSamples,y);

    statsSizes(rowIndex,1:9)= arrayfun(testSizeOperator, ["swTest", "sfTest","adtest","cvmTest", "kstest","jbtest","DagosPtest", "vasicekTest","chi2gof"]);
    
end

xlswrite(filename, statsSizes, 'Sheet1', ['A' num2str(1)]);


