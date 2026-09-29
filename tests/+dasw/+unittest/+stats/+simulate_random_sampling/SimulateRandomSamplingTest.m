classdef SimulateRandomSamplingTest < matlab.unittest.TestCase
%SIMULATERANDOMSAMPLINGTEST Unit tests for dasw.stats.simulate_random_sampling.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (TestMethodSetup)

        function hideAndCloseFigures(testCase)
            % simulate_random_sampling opens its own figure, so make new figures
            % invisible and close any it creates once the test is done.
            origVisible = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@set, groot, 'DefaultFigureVisible', origVisible);
            before = findall(groot, 'Type', 'figure');
            testCase.addTeardown(@() closeNewFigures(before));
        end
    end

    methods (Test)

        function testTrueMean(testCase)
            rng(0);
            [~, true_mean] = dasw.stats.simulate_random_sampling([2 4 6 8], 1, 20);
            testCase.verifyEqual(true_mean, 5);
        end

        function testSingleSampleMeansComeFromPopulation(testCase)
            % With N=1, each sample mean is one member of the population.
            rng(1);
            true_d = [2 4 6 8];
            samplemeans = dasw.stats.simulate_random_sampling(true_d, 1, 50);
            testCase.verifySize(samplemeans, [1 50]);
            testCase.verifyTrue(all(ismember(samplemeans, true_d)));
        end

        function testSampleMeansCenterOnTrueMean(testCase)
            % The average of many sample means is close to the true mean.
            rng(2);
            true_d = randn(1,1000) + 3;
            [samplemeans, true_mean] = dasw.stats.simulate_random_sampling(true_d, 25, 500);
            testCase.verifyEqual(true_mean, mean(true_d), 'AbsTol', 1e-12);
            testCase.verifyEqual(mean(samplemeans), true_mean, 'AbsTol', 0.05);
        end

        function testCreatesLabeledFigure(testCase)
            rng(3);
            dasw.stats.simulate_random_sampling(1:20, 3, 100);
            ax = gca;
            testCase.verifyEqual(ax.XLabel.String, 'Sample mean');
            testCase.verifyEqual(ax.YLabel.String, 'Percent of experiments');
            testCase.verifyEqual(ax.YLim, [0 100]);
            lgd = legend(ax);
            testCase.verifyEqual(numel(lgd.String), 3);
        end
    end
end

function closeNewFigures(before)
figs = findall(groot, 'Type', 'figure');
delete(figs(~ismember(figs, before)));
end
