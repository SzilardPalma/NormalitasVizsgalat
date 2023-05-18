function [testSize] = testSize(x,testName)
% This function computes the size of a normality test
% x: the sample (usually N(0,1))
% testName: the name of the noralityTest function e.g.:jbtest

%subindex the cell of cell output of the simulation
subindex = @(A, r, c) A(r, c); 

%applytoRows operator:
applyToGivenRow = @(func, matrix) @(row) func(matrix(row, :));
applyToRows = @(func, matrix) arrayfun(applyToGivenRow(func, matrix), 1:size(matrix,1));

n = subindex(size(x),1,1);

%Convert string to the normality test function:
funcHandler = str2func(testName);

testSize = sum(applyToRows(funcHandler,x))/n;

end