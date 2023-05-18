function [H,pValue,AdjCvM] = cvmTest(x, alpha)
% CRAMER - VON MISES TEST
% Based on the Matlab mathwork:
% Normality test package

% Alpha value can be changed as required
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

y=sort(x);
n=length(x);
 
adj=1+0.5/n;
i=1:n;
fx=normcdf(zscore(y),0,1);
gx=(fx-((2*i-1)/(2*n))).^2;
CvMteststat=(1/(12*n))+sum(gx);
AdjCvM=CvMteststat*adj;
 
if AdjCvM<0.0275
    pValue=1-exp(-13.953+775.5*AdjCvM-12542.61*(AdjCvM^2));
elseif AdjCvM<0.051
    pValue=1-exp(-5.903+179.546*AdjCvM-1515.29*(AdjCvM^2));
elseif AdjCvM<0.093
    pValue=exp(0.886-31.62*AdjCvM+10.897*(AdjCvM^2));
else 
    pValue=exp(1.111-34.242*AdjCvM+12.832*(AdjCvM^2));
end

H  = (alpha >= pValue);
%1, if rejects the null hypothesis: pval<alpha

end