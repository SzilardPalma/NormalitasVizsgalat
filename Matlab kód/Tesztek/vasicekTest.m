function [H, pValue, testStat] = vasicekTest(x, alpha)
% performs Vasicek-Song test 
% Based on the R function entropy.test

%based on swTest
if (nargin >= 2) && ~isempty(alpha)
   if ~isscalar(alpha)
      error(' Significance level ''Alpha'' must be a scalar.');
   end
   if (alpha <= 0 || alpha >= 1)
      error(' Significance level ''Alpha'' must be between 0 and 1.'); 
   end
else
   alpha  =  0.05;
end

n = length(x);
m = min(max(1,floor(n^(1/3 - 1/12))),n/2);

%mle estimate of the parameters of the parameters for the specified ditribution
avgMLE = mean(x);
stdMLE = sqrt((n-1)*var(x)/n);
param = [avgMLE stdMLE];

vasicekEntrophy = vasicekEstimate(x, m);
testStat = - vasicekEntrophy - mean(log(normpdf(x, avgMLE, stdMLE)));
bias1 = log(2*m) - log(n) ;
bias2 =  psi(n+1) - psi(2*m) + 2*m/n * sum(1./(1:(2*m-1))) ;
bias3 = - 2* m * sum(1./(1:(m-1)))/n - 2*sum((sort(1:(m-1),'descend'))./(m:(2*m-2)))./n ;
bias = bias1 + bias2 + bias3;
pValue = 1 - normcdf((6*m*n)^(1/2)*(testStat-bias)) ; %normcdf
H  = (alpha >= pValue);
%1, if rejects the null hypothesis: pval<alpha
end