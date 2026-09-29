function [R, SIG] = correlogram(t1, data1, t2, data2, lags, tolerance, alpha)
% CORRELOGRAM - Compute correlations at different time offsets
%    [R,CONF] = dasw.stats.correlogram(T1,DATA1,T2,DATA2,LAGS,TOL,ALPHA)
%
%  Returns in R the values of the correlation at different time
%  lags specified in LAGS for the 2 time series with time values
%  T1 and T2 and data values DATA1 and DATA2. 2 time values are
%  considered to be the same if they are within TOL of one another.
%
%  SIG is the value that R would need to exceed to be significant
%  at level ALPHA at each lag location.
%
%  Example:
%      t = 0:0.01:10;
%      y1 = sin(2*pi*t);
%      y2 = cos(2*pi*t);
%      R=correlogram(t,y1,t,y2,[-1:0.01:1],0.001,0.05);
%    
for j=1:numel(lags),
    x = [];  % start with an empty matrix
    y = [];
    for i=1:numel(t1),
        target_time = t1(i) + lags(j);
        inds = find( abs(t2-(target_time))< tolerance);
        if numel(inds)>0, % if we have a match (because we might not)
           if numel(inds)>1, % if we have more than one match, pick the nearest in time
               % replace inds with the single index whose time is closest to target_time;
               % minvalue (the distance itself) is discarded
               [minvalue,inds] = min(abs(t2-(target_time)));
           end;
           x(end+1) = data1(i);
           y(end+1) = data2(inds);
        end;
    end;
    if numel(x)>2,
        Rfull = corrcoef(x,y);
        R(j) = Rfull(1,2);
        % now significance
        T2 = (tinv(alpha, numel(x)-2))^2;
        df = numel(x) - 2;
        SIG(j) = sqrt((T2/df)/(1+T2/df));
    else, % no data, return NaN for this lag position
        R(j) = NaN; 
        SIG(j) = NaN;
    end;
end;
