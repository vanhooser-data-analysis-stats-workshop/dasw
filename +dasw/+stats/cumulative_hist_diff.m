function [maxdiff, maxdiff_location, Xvalues, sample1CDF, sample2CDF] = cumulative_hist_diff(sample1,sample2)
% CUMULATIVE_HIST_DIFF - Calculates the maximum difference b/w 2 samples
%    [MAXDIFF,MAXDIFF_LOCATION, XVALUES, SAMPLE1CDF, SAMPLE2CDF] = ...
%          dasw.stats.cumulative_hist_diff(SAMPLE1, SAMPLE2)
%
%   Inputs:  SAMPLE1 - an array of sample data
%            SAMPLE2 - an array of sample data
%   Outputs: MAXDIFF - The maximum (absolute) difference between the samples
%            MAXDIFF_LOCATION - The x-axis location of the maximum difference
%            XVALUES - The X-axis values for the cumulative density functions
%            SAMPLE1CDF - The cumulative density function of SAMPLE1
%            SAMPLE2CDF - The cumulative density function of SAMPLE2
bin_edges = unique([sample1; sample2]);
bin_counts1 = histcounts(sample1, [bin_edges; inf])';
bin_counts2 = histcounts(sample2, [bin_edges; inf])';
Xvalues = bin_edges;
sample1CDF = cumsum(bin_counts1) / sum(bin_counts1);
sample2CDF = cumsum(bin_counts2) / sum(bin_counts2);
[maxdiff, maxdiff_location] = max( abs(sample1CDF-sample2CDF) );
