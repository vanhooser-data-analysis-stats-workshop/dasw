function [power_estimate, se] = power_ttest2(n, effect_size, sigma, alpha, num_experiments)
% POWER_TTEST2 - Estimate the power of a 2-sample t-test by simulation
%  [POWER_ESTIMATE, SE] = dasw.stats.power_ttest2(N, EFFECT_SIZE, SIGMA, ALPHA, NUM_EXPERIMENTS)
%
%  Simulates NUM_EXPERIMENTS studies. In each simulated study, N subjects
%  per group are drawn from 2 normal ("true") distributions whose means
%  differ by EFFECT_SIZE and whose standard deviation is SIGMA, and the 2
%  groups are compared with a 2-sample t-test at significance level ALPHA.
%
%  POWER_ESTIMATE is the fraction of those studies in which the test noticed the
%  difference (P < ALPHA); that is, the probability that a study of this
%  size detects an effect of this size. Passing EFFECT_SIZE of 0 instead
%  measures the Type I error rate, which should come back near ALPHA.
%
%   Inputs: N               : the number of subjects in each group
%           EFFECT_SIZE     : the difference between the true means
%           SIGMA           : the standard deviation of the true distributions
%           ALPHA           : the significance level of the test (such as 0.05)
%           NUM_EXPERIMENTS : the number of studies to simulate
%   Outputs:
%           POWER_ESTIMATE : the fraction of simulated studies with P < ALPHA
%           SE             : the standard error of POWER_ESTIMATE, which is
%                            sqrt(P*(1-P)/NUM_EXPERIMENTS) for that P.
%                            Simulating more experiments makes this
%                            smaller; it is how close an answer this
%                            simulation can give you.
%
%  The samples are drawn with dasw.stats.generate_random_data, the same
%  function used to simulate experiments in Labs 1.5 and 1.6. Changing
%  'normal' there simulates the same study on data from another
%  distribution.
%
%  The mean of the reference group does not appear anywhere: only the
%  difference between the 2 means matters to the t-test, so a study of
%  scores near 100 and a study of scores near 0 have the same power.
%
%  Example:
%     % Drug B scores 1 standard deviation (25 points) above drug A,
%     % where the population standard deviation is 25 points:
%     [power_estimate,se] = dasw.stats.power_ttest2(17, 25, 25, 0.05, 10000)
detected = zeros(num_experiments,1);
for i=1:num_experiments
    group_A = dasw.stats.generate_random_data(n,'normal',0,sigma);
    group_B = dasw.stats.generate_random_data(n,'normal',effect_size,sigma);
    [h,pvalue] = ttest2(group_A, group_B);
    detected(i) = pvalue < alpha;
end
power_estimate = mean(detected);
se = sqrt(power_estimate*(1-power_estimate)/num_experiments);
