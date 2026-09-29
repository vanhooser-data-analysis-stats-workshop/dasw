classdef Refl2dTest < matlab.unittest.TestCase
%REFL2DTEST Unit tests for dasw.math.refl2d.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testZero(testCase)
            % Reflection about the x-axis (theta = 0).
            testCase.verifyEqual(dasw.math.refl2d(0), [1 0; 0 -1], 'AbsTol', 1e-12);
        end

        function testInvolution(testCase)
            % Reflecting twice returns the original: R*R = I.
            R = dasw.math.refl2d(0.9);
            testCase.verifyEqual(R*R, eye(2), 'AbsTol', 1e-12);
        end

        function testDeterminantMinusOne(testCase)
            testCase.verifyEqual(det(dasw.math.refl2d(0.4)), -1, 'AbsTol', 1e-12);
        end

        function testFixesReflectionLine(testCase)
            % A vector along the line of reflection (angle theta) is unchanged.
            theta = pi/5;
            v = [cos(theta); sin(theta)];
            testCase.verifyEqual(dasw.math.refl2d(theta)*v, v, 'AbsTol', 1e-12);
        end
    end
end
