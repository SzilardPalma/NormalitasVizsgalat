function [S] = contaminatedDist(contaminationParam, contaminationRatio, sampleSize, totalSampleSize, location)
% The function generate mixed samples from two normal distributions
% contaminationParam: the parameter used as the expected value and standard
% deviation.
% contaminationRaio: an array that defines the ratio of contamination.
% sampleSizes: a vector indicating the size of the random variables
% totalSampleSize: number of total samples generated e.g.: 1000
% shape: logical variable indicating the location contanimation

n = length(sampleSize);  %10 

if length(contaminationParam) > 1 || length(contaminationRatio) > 1
    warning("Only one contamination parameter an ratio is possible.")
    return
end

if location
    r = rand(totalSampleSize,1)>= contaminationRatio;
    R1 = normrnd(0,1,totalSampleSize,n);
    R2 = normrnd(contaminationParam,1,totalSampleSize,n);
    S = (1-r).*R1+r.*R2;
else
    r = rand(totalSampleSize,1)>= contaminationRatio;
    R1 = normrnd(0,1,totalSampleSize,n);
    R2 = normrnd(0,contaminationParam,totalSampleSize,n);
    S = (1-r).*R1+r.*R2;
end