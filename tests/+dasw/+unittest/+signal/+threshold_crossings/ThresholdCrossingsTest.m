classdef ThresholdCrossingsTest < matlab.unittest.TestCase
%THRESHOLDCROSSINGSTEST Unit tests for dasw.signal.threshold_crossings.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testUpwardCrossings(testCase)
            % The index returned is the first sample at or above threshold.
            idx = dasw.signal.threshold_crossings([0 1 3 1 3 3 0], 2);
            testCase.verifyEqual(idx, [3 5]);
        end

        function testReachingThresholdCounts(testCase)
            testCase.verifyEqual(dasw.signal.threshold_crossings([0 2], 2), 2);
        end

        function testDownwardCrossingsIgnored(testCase)
            testCase.verifyEmpty(dasw.signal.threshold_crossings([5 0 0], 2));
        end

        function testNoCrossings(testCase)
            testCase.verifyEmpty(dasw.signal.threshold_crossings([0 1 0], 2));
        end
    end
end
