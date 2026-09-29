classdef StderrTest < matlab.unittest.TestCase
%STDERRTEST Unit tests for dasw.stats.stderr.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testColumnVector(testCase)
            % The standard error is std(data)/sqrt(N).
            data = [1; 2; 3; 4];
            testCase.verifyEqual(dasw.stats.stderr(data), std(data)/2, 'AbsTol', 1e-12);
        end

        function testEachColumn(testCase)
            % Each column gets its own standard error.
            data = [1 10; 2 20; 3 30; 4 40];
            se = dasw.stats.stderr(data);
            testCase.verifySize(se, [1 2]);
            testCase.verifyEqual(se, std(data)/sqrt(4), 'AbsTol', 1e-12);
            testCase.verifyEqual(se(2), 10*se(1), 'AbsTol', 1e-12);
        end

        function testConstantDataIsZero(testCase)
            testCase.verifyEqual(dasw.stats.stderr(5*ones(10,1)), 0, 'AbsTol', 1e-12);
        end

        function testShrinksWithSampleSize(testCase)
            % Repeating the same data 4 times leaves std nearly unchanged but
            % quadruples N, so the standard error roughly halves.
            data = [1; 2; 3; 4; 5];
            se1 = dasw.stats.stderr(data);
            se4 = dasw.stats.stderr(repmat(data, 4, 1));
            testCase.verifyLessThan(se4, se1);
            testCase.verifyEqual(se4, std(repmat(data,4,1))/sqrt(20), 'AbsTol', 1e-12);
        end
    end
end
