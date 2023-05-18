function [H, pValue, W] = swTest(x, alpha)

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

%Shapiro-Wilk test statistic:
c    =   1/sqrt(mtilde'*mtilde) * mtilde;
u    =   1/sqrt(n);

% Royston (1992, p. 117) and Royston (1993b, p. 38):
PolyCoef_1   =   [-2.706056 , 4.434685 , -2.071190 , -0.147981 , 0.221157 , c(n)];
PolyCoef_2   =   [-3.582633 , 5.682633 , -1.752461 , -0.293762 , 0.042981 , c(n-1)];

% Royston (1992, p. 118) and Royston (1993b, p. 40, Table 1)
PolyCoef_3   =   [-0.0006714 , 0.0250540 , -0.39978 , 0.54400];
PolyCoef_4   =   [-0.0020322 , 0.0627670 , -0.77857 , 1.38220];
PolyCoef_5   =   [0.00389150 , -0.083751 , -0.31082 , -1.5861];
PolyCoef_6   =   [0.00303020 , -0.082676 , -0.48030];
PolyCoef_7   =   [0.459 , -2.273];

weights(n)   =   polyval(PolyCoef_1 , u);
weights(1)   =   -weights(n);
    
if n > 5
    weights(n-1) =   polyval(PolyCoef_2 , u);
    weights(2)   =   -weights(n-1);
    
    count  =   3;
    phi    =   (mtilde'*mtilde - 2 * mtilde(n)^2 - 2 * mtilde(n-1)^2) / ...
        (1 - 2 * weights(n)^2 - 2 * weights(n-1)^2);
else
    count  =   2;
    phi    =   (mtilde'*mtilde - 2 * mtilde(n)^2) / ...
        (1 - 2 * weights(n)^2);
end
        
% Special attention when n = 3 (this is a special case).
% Royston (1992, p. 117)
if n == 3
    weights(1)  =   1/sqrt(2);
    weights(n)  =   -weights(1);
    phi = 1;
end

% The vector 'WEIGHTS' obtained next corresponds to the same coefficients
% listed by Shapiro-Wilk in their original test for small samples.

weights(count : n-count+1)  =  mtilde(count : n-count+1) / sqrt(phi);

% The Shapiro-Wilk statistic W is calculated to avoid excessive rounding
% errors for W close to 1 (a potential problem in very large samples).

W   =   (weights' * x) ^2 / ((x - mean(x))' * (x - mean(x)));

    % Calculate the normalized W and its significance level (exact for
    % n = 3). Royston (1992, p. 118) and Royston (1993b, p. 40, Table 1).

newn    =   log(n);

if (n >= 4) && (n <= 11)
    mu      =   polyval(PolyCoef_3 , n);
    sigma   =   exp(polyval(PolyCoef_4 , n));    
    gam     =   polyval(PolyCoef_7 , n);
    newSWstatistic  =   -log(gam-log(1-W));
    
elseif n > 11
    mu      =   polyval(PolyCoef_5 , newn);
    sigma   =   exp(polyval(PolyCoef_6 , newn));
    newSWstatistic  =   log(1 - W);
    
elseif n == 3
    mu      =   0;
    sigma   =   1;
    newSWstatistic  =   0;
end

% Compute the normalized Shapiro-Wilk statistic and its p-value.

NormalSWstatistic   =   (newSWstatistic - mu) / sigma;
    
% NormalSWstatistic is referred to the upper tail of N(0,1),
% Royston (1992, p. 119).
pValue       =   1 - normcdf(NormalSWstatistic, 0, 1);
    
% Special attention when n = 3 (this is a special case).
if n == 3
    pValue  =   6/pi * (asin(sqrt(W)) - asin(sqrt(3/4)));
        % Royston (1982a, p. 121)
end
    
% To maintain consistency with existing Statistics Toolbox hypothesis
% tests, returning 'H = 0' implies that we 'Do not reject the null 
% hypothesis at the significance level of alpha' and 'H = 1' implies 
% that we 'Reject the null hypothesis at significance level of alpha.'

H  = (alpha >= pValue);

end