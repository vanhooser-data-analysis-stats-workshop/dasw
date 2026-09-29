classdef CumulativeHistDiffTest < matlab.unittest.TestCase
%CUMULATIVEHISTDIFFTEST Unit tests for dasw.stats.cumulative_hist_diff.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (TestMethodSetup)

        function restoreRandomState(testCase)
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
        end
    end

    methods (Test)

        function testSeparatedSamples(testCase)
            % Non-overlapping samples: the CDFs differ by 1 just after the
            % last value of SAMPLE1.
            [maxdiff, loc, X, c1, c2] = dasw.stats.cumulative_hist_diff([1;2;3], [4;5;6]);
            testCase.verifyEqual(maxdiff, 1, 'AbsTol', 1e-12);
            testCase.verifyEqual(X, (1:6)');
            testCase.verifyEqual(X(loc), 3);
            testCase.verifyEqual(c1, [1;2;3;3;3;3]/3, 'AbsTol', 1e-12);
            testCase.verifyEqual(c2, [0;0;0;1;2;3]/3, 'AbsTol', 1e-12);
        end

        function testIdenticalSamples(testCase)
            maxdiff = dasw.stats.cumulative_hist_diff([1;2;3], [3;2;1]);
            testCase.verifyEqual(maxdiff, 0);
        end

        function testCdfsEndAtOne(testCase)
            rng(0);
            [~, ~, ~, c1, c2] = dasw.stats.cumulative_hist_diff(randn(20,1), randn(30,1)+1);
            testCase.verifyEqual(c1(end), 1, 'AbsTol', 1e-12);
            testCase.verifyEqual(c2(end), 1, 'AbsTol', 1e-12);
            testCase.verifyTrue(all(diff(c1) >= 0) && all(diff(c2) >= 0));
        end
    end
end
