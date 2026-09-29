classdef HistbinsTest < matlab.unittest.TestCase
%HISTBINSTEST Unit tests for dasw.plot.histbins.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testCountsAndCenters(testCase)
            % Edges [0 1 2 3 4] give bins [0,1) [1,2) [2,3) [3,4]; data 1,2,3 land
            % in the last three bins.
            [N, centers] = dasw.plot.histbins([1 2 3], [0 1 2 3 4]);
            testCase.verifyEqual(N, [0 1 1 1]);
            testCase.verifyEqual(centers, [0.5 1.5 2.5 3.5], 'AbsTol', 1e-12);
        end

        function testCenterCount(testCase)
            % There is one bin center per bin (one fewer than the number of edges).
            [N, centers] = dasw.plot.histbins(randn(1,50), -3:0.5:3);
            testCase.verifyEqual(numel(centers), numel(N));
        end
    end
end
