rng(4); %set seed
sampleLength = 10:10:100;
xlsConversion = 1:1:10;

contRatio = [0.05 0.1];
contParam = 3;
m = 1000;

d1 = {'T', 1};
d2 = {'T', 3};
d3 = {'Logistic', 0, 1};
d4 = {'Laplace'};

g1 = {d1, d2,d3,d4};

d5 = {'GeneralizedExtremeValue',0,1,0}; %shape, scale, location
d6 = {'GeneralizedExtremeValue',0,2,0};
d7 = {'GeneralizedExtremeValue',0,1/2,0};
g2 = {d5, d6, d7};

d8 = {'Exponential', 1}; %1/lambda =1
d9 = {'Gamma', 1,2};
d10 = {'Gamma',1, 1/2};
d11 = {'LogNormal', 0, 1};
d12 = {'LogNormal', 0, 2};
d13 = {'LogNormal',0, 1/2};
d14 = {'Weibull', 1, 1/2};
d15 = {'Weibull', 1, 2};

g3 = {d8, d9, d10, d11, d12, d13, d14, d15};

d16 = {'Uniform', 0, 1};
d17 = {'Beta', 2 2};
d18 = {'Beta', 0.5, 0.5};
d19 = {'Beta', 3, 1.5};
d20 = {'Beta', 2, 1};

g4 = {d16, d17, d18, d19, d20};

simulatedDistributions(g1,sampleLength,10000,1,1);
simulatedDistributions(g2,sampleLength,10000,5,2);
simulatedDistributions(g3,sampleLength,10000,8,3);
simulatedDistributions(g4,sampleLength,10000,16,4);


for i = contRatio
   xlsName_location = 40*i; %2,4
   xlsName_scalar = xlsName_location -1;
   simSamples = arrayfun(@(x) contaminatedDist(contParam, i, x,1000,true), sampleLength, 'UniformOutput',false);
   simSamples = reshape(simSamples, [10 1]);
   arrayfun(@(x) xlswrite(['d2' num2str(xlsName_location) '.xlsx'], cell2mat(simSamples(x)), 'Sheet1', ['A', num2str((x-1)*m+1)]), xlsConversion);
   simSamples = arrayfun(@(x) contaminatedDist(contParam, i, x,1000,false), sampleLength, 'UniformOutput',false);
   simSamples = reshape(simSamples, [10 1]);
   arrayfun(@(x) xlswrite(['d2' num2str(xlsName_scalar) '.xlsx'], cell2mat(simSamples(x)), 'Sheet1', ['A', num2str((x-1)*m+1)]), xlsConversion);
end



