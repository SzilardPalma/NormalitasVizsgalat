clear all;
rng(4);
sampleLength = 10:10:100;
sampleSizes = 1000;
critValues = xlsread("criticalValues.xlsx");

for i = 1:4
    power = [];
    simSamples = arrayfun(@(x) xlsread(['g' num2str(i) '.xlsx'], 'Sheet1', ['A' num2str((x/10-1)*sampleSizes+1) ':' xlsColNum2Str(x) num2str(x/10*sampleSizes)]), sampleLength, 'UniformOutput',false);
    %left-tail tests:
    power(1,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "swTest", false)< critValues(x,1)))/1000 , 1:1:10);
    power(2,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "sfTest", false)< critValues(x,2)))/1000 , 1:1:10);
    %right-tail tests:
    power(3,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "adtest", false)> critValues(x,3)))/1000 , 1:1:10);
    power(4,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "cmtest", false)> critValues(x,4)))/1000 , 1:1:10);
    power(5,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "kstest", false)> critValues(x,5)))/1000 , 1:1:10);
    power(6,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "jbtest", false)> critValues(x,6)))/1000 , 1:1:10);
    power(7,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "DagosPtest", false)> critValues(x,7)))/1000 , 1:1:10);
    power(8,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "vasicekTest", false)> critValues(x,8)))/1000 , 1:1:10);
    power(9,:) = arrayfun(@(x) sum((testStatistic(cell2mat(simSamples(x)), "chi2gof", true)> critValues(x,9)))/1000 , 1:1:10);

    xlswrite( ['pgroups' num2str(i) '.xlsx'], power, 'Sheet1', 'A1');
end
