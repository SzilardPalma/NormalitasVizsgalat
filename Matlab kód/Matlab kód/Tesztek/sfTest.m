function [H, pValue, W] = sfTest(x,alpha)

if numel(x) == length(x)
    x  =  x(:);               % Ensure a column vector.
else
    error(' Input sample ''X'' must be a vector.');
end

% Remove missing observations indicated by NaN's and check sample size.

x  =  x(~isnan(x));

if length(x) < 3
   error(' Sample vector ''X'' must have at least 3 valid observations.');
end

% Ensure the significance level, ALPHA, is a 
% scalar, and set default if necessary.

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

% First, calculate the a's for weights as a function of the m's
% See Royston (1992, p. 117) and Royston (1993b, p. 38) for details
% in the approximation.

x       =   sort(x); % Sort the vector X in ascending order.
n       =   length(x);
mtilde  =   norminv(((1:n)' - 3/8) / (n + 1/4));
weights =   zeros(n,1); % Preallocate the weights.

% The Shapiro-Francia test.
    
weights =   1/sqrt(mtilde'*mtilde) * mtilde;

% The Shapiro-Francia statistic W' is calculated to avoid excessive
% rounding errors for W' close to 1 (a potential problem in very
    % large samples).

W   =   (weights' * x)^2 / ((x - mean(x))' * (x - mean(x)));

% Royston (1993a, p. 183):
nu      =   log(n);
u1      =   log(nu) - nu;
u2      =   log(nu) + 2/nu;
mu      =   -1.2725 + (1.0521 * u1);
sigma   =   1.0308 - (0.26758 * u2);
newSFstatistic  =   log(1 - W);

% Compute the normalized Shapiro-Francia statistic and its p-value.

NormalSFstatistic =   (newSFstatistic - mu) / sigma;
    
% Computes the p-value, Royston (1993a, p. 183).
pValue   =   1 - normcdf(NormalSFstatistic, 0, 1);
    
% To maintain consistency with existing Statistics Toolbox hypothesis
% tests, returning 'H = 0' implies that we 'Do not reject the null 
% hypothesis at the significance level of alpha' and 'H = 1' implies 
% that we 'Reject the null hypothesis at significance level of alpha.'

H  = (alpha >= pValue);

end