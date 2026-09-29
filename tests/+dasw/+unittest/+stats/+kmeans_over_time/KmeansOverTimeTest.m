classdef KmeansOverTimeTest < matlab.unittest.TestCase
%KMEANSOVERTIMETEST Unit tests for dasw.stats.kmeans_over_time.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (TestMethodSetup)

        function hideAndCloseFigures(testCase)
            % kmeans_over_time opens its own figure and pauses between
            % iterations, so hide new figures, turn pausing off, silence
            % kmeans's "failed to converge" warnings from the capped early
            % iterations, and close any figure it creates.
            origVisible = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@set, groot, 'DefaultFigureVisible', origVisible);
            origPause = pause('query');
            pause('off');
            testCase.addTeardown(@pause, origPause);
            origWarn = warning('off', 'stats:kmeans:FailedToConverge');
            testCase.addTeardown(@warning, origWarn);
            before = findall(groot, 'Type', 'figure');
            testCase.addTeardown(@() closeNewFigures(before));
        end

        function restoreRandomState(testCase)
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
        end
    end

    methods (Test)

        function testSeparatesClusters(testCase)
            rng(0);
            data = [randn(30,2); randn(30,2) + 10];
            [idx, c] = dasw.stats.kmeans_over_time(data, 2);
            testCase.verifySize(idx, [60 1]);
            testCase.verifySize(c, [2 2]);
            testCase.verifyNumElements(unique(idx(1:30)), 1);
            testCase.verifyNumElements(unique(idx(31:60)), 1);
            testCase.verifyNotEqual(idx(1), idx(31));
        end

        function testPlotsPointsAndCenters(testCase)
            % Each iteration redraws one line per cluster for the points and
            % one per cluster for the centers.
            rng(1);
            data = [randn(20,2); randn(20,2) + 8; randn(20,2) - 8];
            dasw.stats.kmeans_over_time(data, 3);
            lines = findobj(gcf, 'Type', 'line');
            testCase.verifyNumElements(lines, 6);
        end
    end
end

function closeNewFigures(before)
figs = findall(groot, 'Type', 'figure');
delete(figs(~ismember(figs, before)));
end
