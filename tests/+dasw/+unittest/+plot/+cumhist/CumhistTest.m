classdef CumhistTest < matlab.unittest.TestCase
%CUMHISTTEST Unit tests for dasw.plot.cumhist.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testDistinctValues(testCase)
            % Each X appears twice, so Y steps up vertically at each value.
            [X, Y] = dasw.plot.cumhist([3 1 2]);
            testCase.verifyEqual(X, [1; 1; 2; 2; 3; 3]);
            testCase.verifyEqual(Y, [0; 100/3; 100/3; 200/3; 200/3; 100], 'AbsTol', 1e-12);
        end

        function testRepeatedValues(testCase)
            % Repeated values produce a single, larger step.
            [X, Y] = dasw.plot.cumhist([1 1 2]);
            testCase.verifyEqual(X, [1; 1; 2; 2]);
            testCase.verifyEqual(Y, [0; 200/3; 200/3; 100], 'AbsTol', 1e-12);
        end

        function testRowAndColumnAgree(testCase)
            data = [4 2 7 2 9 1];
            [Xr, Yr] = dasw.plot.cumhist(data);
            [Xc, Yc] = dasw.plot.cumhist(data');
            testCase.verifyEqual(Xr, Xc);
            testCase.verifyEqual(Yr, Yc);
        end

        function testRangeAndMonotonic(testCase)
            rng(3);
            [X, Y] = dasw.plot.cumhist(randn(200,1));
            testCase.verifyEqual(Y(1), 0);
            testCase.verifyEqual(Y(end), 100, 'AbsTol', 1e-12);
            testCase.verifyGreaterThanOrEqual(diff(X), 0);
            testCase.verifyGreaterThanOrEqual(diff(Y), -1e-12);
        end
    end
end
