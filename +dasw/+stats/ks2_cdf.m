function thecdf = ks2_cdf(n1,n2,ks_diff)
%KS2_CDF - Cumulative distribution function of Kolmogorov-Smirnov 2 sample test
%  CDF = KS2_CDF(N1,N2, KS_DIFF)
%
%  Returns the cumulative distribution function for 2 samples of size N1 and N2
%  respectively, evaluated at each value of the K-S statistic D in KS_DIFF
%  (the maximum difference between the two empirical CDFs).
%
%  Approximation has been borrowed from MATLAB's KSTEST2 function.

n      =  n1 * n2 /(n1 + n2);

j       =  (1:101)';

thecdf = zeros(size(ks_diff));

for k=1:numel(ks_diff),
    KSstatistic = ks_diff(k);

    lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);
    pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
    pValue  =  min(max(pValue, 0), 1);

    thecdf(k) = 1-pValue;
end;


