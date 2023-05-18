function [] = simulatedDistributions(distArray, sampleSizes, totalSampleSize, csvNumInit, groupNum)
% The function simulates the given number of samples for each dsitribution
%  disArray: a cell of cells that contrains the specification of each
%  distribution
%   sampleSizes: a vector indicating the size of the random variables
%   totalSampleSize: number of total samples generated e.g.: 10 000
%   csvNumInit: numering of the created csv files
%   groupNum: csv file number for the group of dsitributions

%subindex the cell of cell output of the simulation
subindex = @(A, r, c) A(r, c); 

k = length(sampleSizes);  %10 
m = totalSampleSize/k;     %1000
n = subindex(size(distArray),1,2);
xlsConversion = 1:1:k;
forLoop = 1:n;
disp(n)

%Simulate the sample by calling the "random" function and using the cells
%of cell values to define the distribution:
for i = forLoop
    distSpec = distArray{i};
    csvName = csvNumInit+i-1;
    %matlab cannot generate laplace and logistic distribution
    switch sum(strcmp(string(distSpec), 'Laplace'))
        case 0
            simSample = arrayfun(@(x) random(distSpec{:}, m, x), sampleSizes, 'UniformOutput',false);
        otherwise
            simSample = arrayfun(@(x) randl(m, x), sampleSizes, 'UniformOutput',false);
    end

    simSample = reshape(simSample, [k 1]);
    arrayfun(@(x) xlswrite(['d' num2str(csvName) '.xlsx'], cell2mat(simSample(x)), 'Sheet1', ['A', num2str((x-1)*m+1)]), xlsConversion);
    
    %select the 1/n size of the sample for the group of distributions
    selectionCriteria = 1:n:m;
    disp(['Selected from each ', num2str(n), ' distributions ', num2str(length(selectionCriteria)), ' elements. In total: ' num2str(m)])
    xlsRowIndex = floor(m/n)*(i-1)+1;
    disp(m/n);
    arrayfun(@(x) xlswrite(['g' num2str(groupNum) '.xlsx'], subindex(cell2mat(simSample(x)), 1:n:m, ':'), 'Sheet1', ['A', num2str((x-1)*m+xlsRowIndex)]), xlsConversion);
end


end
