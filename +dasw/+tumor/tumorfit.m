function [ change, rate, a, b, c, d ] = tumorfit( tumordata, reps )
%TUMORFIT - Fit an exponential curve to data
%  [CHANGE, RATE, A, B, C, D] = TUMORFIT(TUMORDATA,REPS)
%
%  First extracts X = TUMORDATA(1,:)
%  Y = TUMORDATA(2,:)
%  
%  Returns in CHANGE the raw percentage change in Y
%
%  Also performa an exponential fit that minimizes the
%  squared error:
%
%   Y=A+B*exp(C*x^D)
%
%  RATE is equal to the halving time (if C is negative)
%  or the doubling time (if C is positive).
%      

x = tumordata(1,:);
y = tumordata(2,:);

bestfit = [];
lowerror = Inf;

i = 0;

f = fittype('a+b*exp(x^d*c)');
fo = fitoptions(f);
fo.Lower = [-10000; 0; -10; 0];
fo.Upper = [10000; 10000; 10; 1.2];
f = setoptions(f,fo);

while i<reps,
    % will choose new start point randomly
    fo = fitoptions(f);
    c_start = randn;
    fo.StartPoint = [ 0 y(1)/(exp(c_start)) c_start 1];
    current_f = f;
    current_f = setoptions(current_f,fo);
    [currentfit,currentgof] = fit(x(:),y(:),current_f);
    if currentgof.sse < lowerror,
        bestfit = currentfit;
        lowerror = currentgof.sse;
    end;
    i = i + 1;
end;

fit_coeffs = coeffvalues(bestfit);
a = fit_coeffs(1);
b = fit_coeffs(2);
c = fit_coeffs(3);
d = fit_coeffs(4);
if c<=0, factor = 0.5; else, factor = 2; end;
 %log(((0.5*(a+b*exp(c)))-a)/b)/c

if ~isreal(log(((factor*(a+b*exp(c)))-a)/b)/c),
    rate = Inf;
else,
    rate = nthroot(log(((factor*(a+b*exp(c)))-a)/b)/c ,d);
end;
change = 100 * (y(end)-y(1))/y(1);