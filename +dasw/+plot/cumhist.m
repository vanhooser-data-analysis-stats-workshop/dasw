function [X,Y] = cumhist(data)
% CUMHIST - Make data for a cumulative histogram plot
%
%   [X,Y]=CUMHIST(DATA)
%
%    Generates X and Y variables suitable for plotting with
%    the plot function. Y values represent the percentage of
%    data points (from 0 to 100) that are less than or equal
%    to the corresponding X value.
%
%    Example:
%
%      r=randn(1000,1); % 1000 normally-distributed random numbers
%
%      [X,Y] = cumhist(r);
%      figure;
%      plot(X,Y,'k-');
%      hold on;
%      plot([-4 4],[50 50],'k--'); % add 'median' (50%-tile) dashed line
%      box off;
%      ylabel('Percentage');
%      xlabel('Values');
%
%    See also: PRCTILE, CUMSUM, HIST    

data = data(:); % make it a column
bin_edges = unique(data);
bin_counts = histcounts(data, [bin_edges; inf])';
X = [bin_edges bin_edges]'; % two points at each X location
counts = 100 * cumsum(bin_counts) / sum(bin_counts);
Y = [[0;counts(1:end-1)] counts]';
X = X(:); % put the points into single columns
Y = Y(:); % put the points into single columns
