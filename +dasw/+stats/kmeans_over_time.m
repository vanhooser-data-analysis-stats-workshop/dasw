function [indx,c] = kmeans_over_time(data, K)
% KMEANS_OVER_TIME
%
%  [IDX, C] = dasw.stats.kmeans_over_time(DATA,K)
%
%  Shows the progress of the K-means algorithm over each iteration
%  for 15 iterations.
%
%  DATA and K should be arguments that could be fed to KMEANS.
%
%  See also: KMEANS
  % pick 3 distinct points at random
r = randperm(size(data,1));
r = r(1:K);
f = figure;
for t=1:15,       
    [indx,c]=kmeans(data,K,'Start',data(r,:),'MaxIter',t);
    figure(f);
    clf;
    dasw.plot.scatterplot(data,'class',indx,'markersize',4,'marker','o');
    dasw.plot.scatterplot(c,'class',[1:size(c,1)]','marker','o','markersize',8,'shrink',0);
    pause(1);
end;
