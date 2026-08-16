function [counts,bin_centers] = autohistogram(data)
%AUTOHISTOGRAM - Choose bins based on Freedman-Diaconis' choice
%  [COUNTS,BIN_CENTERS] = dasw.plot.autohistogram(DATA)
%     Automatically chooses bin sizes based on Freedman-Diaconis' choice,
%        defined to be
%        WIDTH = 2*IQR(DATA)/CUBE ROOT OF NUMBER OF DATAPOINTS
%              (see Histogram on Wikipedia)
%   Inputs:  DATA, a set of samples
%   Outputs: COUNTS, the number of DATA samples in each bin
%            BIN_CENTERS - the center location of each bin
data = data(:); % accept either a row or a column input
bin_min = min(data);
bin_max = max(data);
num_datapoints = numel(data);
bin_width = 2*iqr(data)/power(num_datapoints,1/3); % Freedman-Diaconis
bin_edges = (bin_min-bin_width):bin_width:(bin_max+bin_width);
bin_centers = (bin_edges(1:end-1) + bin_edges(2:end))/2;
counts = histcounts(data,bin_edges);
