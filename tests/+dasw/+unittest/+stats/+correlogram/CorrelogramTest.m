classdef CorrelogramTest < matlab.unittest.TestCase
%CORRELOGRAMTEST Unit tests for dasw.stats.correlogram.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testSineAutocorrelation(testCase)
            % A 1 Hz sine is perfectly correlated with itself at lag 0,
            % anti-correlated at a half-period lag, and uncorrelated at a
            % quarter-period lag.
            t = 0:0.01:10;
            y = sin(2*pi*t);
            R = dasw.stats.correlogram(t, y, t, y, [0 0.5 0.25], 0.001, 0.05);
            testCase.verifyEqual(R(1:2), [1 -1], 'AbsTol', 1e-9);
            testCase.verifyEqual(R(3), 0, 'AbsTol', 0.05);
        end

        function testSineVsCosine(testCase)
            t = 0:0.01:10;
            R = dasw.stats.correlogram(t, sin(2*pi*t), t, cos(2*pi*t), [0 -0.25], 0.001, 0.05);
            testCase.verifyEqual(R(1), 0, 'AbsTol', 0.05);
            testCase.verifyEqual(R(2), 1, 'AbsTol', 1e-9);
        end

        function testSignificanceThreshold(testCase)
            % SIG is the |r| needed for significance, from the t distribution.
            t = 0:0.01:10;
            y = sin(2*pi*t);
            [~, SIG] = dasw.stats.correlogram(t, y, t, y, 0, 0.001, 0.05);
            df = numel(t) - 2;
            T2 = tinv(0.05, df)^2;
            testCase.verifyEqual(SIG, sqrt((T2/df)/(1+T2/df)), 'AbsTol', 1e-12);
            testCase.verifyGreaterThan(SIG, 0);
            testCase.verifyLessThan(SIG, 1);
        end

        function testNoOverlapGivesNaN(testCase)
            t = 0:0.01:1;
            [R, SIG] = dasw.stats.correlogram(t, t, t, t, 100, 0.001, 0.05);
            testCase.verifyTrue(isnan(R));
            testCase.verifyTrue(isnan(SIG));
        end
    end
end
