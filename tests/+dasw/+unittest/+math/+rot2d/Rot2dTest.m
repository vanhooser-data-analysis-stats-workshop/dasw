classdef Rot2dTest < matlab.unittest.TestCase
%ROT2DTEST Unit tests for dasw.math.rot2d.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testIdentityAtZero(testCase)
            testCase.verifyEqual(dasw.math.rot2d(0), eye(2), 'AbsTol', 1e-12);
        end

        function testNinetyDegrees(testCase)
            testCase.verifyEqual(dasw.math.rot2d(pi/2), [0 -1; 1 0], 'AbsTol', 1e-12);
        end

        function testRotatesUnitVector(testCase)
            % Rotating [1;0] by theta yields [cos(theta); sin(theta)].
            theta = pi/6;
            testCase.verifyEqual(dasw.math.rot2d(theta)*[1;0], ...
                [cos(theta); sin(theta)], 'AbsTol', 1e-12);
        end

        function testOrthonormal(testCase)
            % A rotation matrix is orthonormal with determinant +1.
            R = dasw.math.rot2d(0.7);
            testCase.verifyEqual(R.'*R, eye(2), 'AbsTol', 1e-12);
            testCase.verifyEqual(det(R), 1, 'AbsTol', 1e-12);
        end
    end
end
