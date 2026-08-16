function [samplemeans, true_mean] = simulate_random_sampling(true_d, N, M)
% SIMULATE_RANDOM_SAMPLING - Simulate a random sampling experiment
%  [SAMPLEMEANS, TRUE_MEAN] = dasw.stats.simulate_random_sampling(TRUE_D, N, M)
%
%   Inputs: TRUE_D: the "true distribution"
%           N : the number of samples in each experiment
%           M : the number of experiments to simulate
%   Outputs:
%          SAMPLEMEANS : The distribution of M sample means (1 for each experiment)
%          TRUE_MEAN   : The true mean; that is, the mean of the true distribution
true_mean = mean(true_d);
samplemeans = zeros(1,M);
for i=1:M
    randompermutation = randperm(numel(true_d));
    sample = true_d(randompermutation(1:N));
    samplemeans(i) = mean(sample);
end
figure;
[counts,bin_centers] = dasw.plot.autohistogram(samplemeans);
hBar = bar(bin_centers,100*counts/sum(counts));
xlabel('Sample mean');
ylabel('Percent of experiments');
hold on;
[X,Y] = dasw.plot.cumhist(samplemeans);
hCum  = plot(X,Y,'r-');
hMean = plot([true_mean true_mean], [0 100],'k--','LineWidth',2);
axis([bin_centers(1) bin_centers(end) 0 100]);
legend([hBar hCum hMean], ...
    {'% of experiments per bin','Cumulative % at or below X','True mean'}, ...
    'Location','northwest');
