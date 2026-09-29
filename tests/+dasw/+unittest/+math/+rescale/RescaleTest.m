classdef RescaleTest < matlab.unittest.TestCase
%RESCALETEST Unit tests for dasw.math.rescale.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testMapsIntervalLinearly(testCase)
            testCase.verifyEqual(dasw.math.rescale(5, [0 10], [0 1]), 0.5, 'AbsTol', 1e-12);
            testCase.verifyEqual(dasw.math.rescale([0 10], [0 10], [2 4]), [2 4], 'AbsTol', 1e-12);
        end

        function testClipsByDefault(testCase)
            % Values outside INT1 are clipped to the ends of INT2.
            testCase.verifyEqual(dasw.math.rescale([-5 15], [0 10], [0 1]), [0 1]);
        end

        function testNoclipExtrapolates(testCase)
            testCase.verifyEqual(dasw.math.rescale([-5 15], [0 10], [0 1], 'noclip'), ...
                [-0.5 1.5], 'AbsTol', 1e-12);
        end

        function testPreservesShape(testCase)
            vals = magic(3);
            testCase.verifySize(dasw.math.rescale(vals, [1 9], [0 255]), [3 3]);
        end
    end
end
