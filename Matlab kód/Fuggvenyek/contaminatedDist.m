function [R] = contaminatedDist(contaminationParam, contaminationRatio, sampleSize, totalSampleSize, location)
% The function generate mixed samples from two normal distributions
% contaminationParam: the parameter used as the expected value and standard
% deviation.
% contaminationRaio: an array that defines the ratio of contamination.
% sampleSizes: a vector indicating the size of the random variables
% totalSampleSize: number of total samples generated e.g.: 1000
% shape: logical variable indicating the location contanimation

m = totalSampleSize;     %e.g.: 1000

if length(contaminationParam) > 1
    warning("Only one contamination parameter is possible.")
    return
end

R = zeros(m,sampleSize);
r = rand(m, sampleSize);
ind = (r <= contaminationRatio); % contaminated sample

if location
    R1= normrnd(0,1, m, sampleSize);
    R2= normrnd(contaminationParam,1, m, sampleSize);
    R(ind) = R2(ind);
    R(~ind) = R1(~ind);
else
    R1= normrnd(0,1, m, sampleSize);
    R2= normrnd(0,contaminationParam, m, sampleSize);
    R(ind) = R2(ind);
    R(~ind) = R1(~ind);
end
end