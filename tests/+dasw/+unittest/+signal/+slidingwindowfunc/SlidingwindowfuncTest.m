classdef SlidingwindowfuncTest < matlab.unittest.TestCase
%SLIDINGWINDOWFUNCTEST Unit tests for dasw.signal.slidingwindowfunc.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testSlidingMean(testCase)
            % Windows [i, i+2) for i = 0..8 over X = Y = 1:10.
            [Yn, Xn] = dasw.signal.slidingwindowfunc(1:10, 1:10, 0, 1, 10, 2, 'mean', 0);
            testCase.verifyEqual(Xn, 1:9);
            testCase.verifyEqual(Yn, [1 1.5:1:8.5], 'AbsTol', 1e-12);
        end

        function testOtherFunction(testCase)
            Yn = dasw.signal.slidingwindowfunc(1:10, 1:10, 0, 1, 10, 2, 'max', 0);
            testCase.verifyEqual(Yn, 1:9);
        end

        function testZeropadFillsEmptyWindows(testCase)
            [Yn, Xn] = dasw.signal.slidingwindowfunc([0.5 5.5], [1 2], 0, 1, 7, 1, 'mean', 1);
            testCase.verifyEqual(Yn, [1 0 0 0 0 2 0]);
            testCase.verifyEqual(Xn, 0.5:1:6.5);
        end

        function testNoZeropadSkipsEmptyWindows(testCase)
            [Yn, Xn] = dasw.signal.slidingwindowfunc([0.5 5.5], [1 2], 0, 1, 7, 1, 'mean', 0);
            testCase.verifyEqual(Yn, [1 2]);
            testCase.verifyEqual(Xn, [0.5 5.5]);
        end
    end
end
