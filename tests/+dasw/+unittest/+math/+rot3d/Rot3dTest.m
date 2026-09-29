classdef Rot3dTest < matlab.unittest.TestCase
%ROT3DTEST Unit tests for dasw.math.rot3d.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testIdentityAtZero(testCase)
            % Zero rotation about any axis is the identity.
            for ax = 1:3
                testCase.verifyEqual(dasw.math.rot3d(0, ax), eye(3), 'AbsTol', 1e-12);
            end
        end

        function testZAxisNinety(testCase)
            testCase.verifyEqual(dasw.math.rot3d(pi/2, 3), ...
                [0 -1 0; 1 0 0; 0 0 1], 'AbsTol', 1e-12);
        end

        function testRotationAxisIsFixed(testCase)
            % Rotating about an axis leaves a vector along that axis unchanged.
            theta = 0.6;
            testCase.verifyEqual(dasw.math.rot3d(theta, 1)*[1;0;0], [1;0;0], 'AbsTol', 1e-12);
            testCase.verifyEqual(dasw.math.rot3d(theta, 3)*[0;0;1], [0;0;1], 'AbsTol', 1e-12);
        end

        function testOrthonormal(testCase)
            for ax = 1:3
                R = dasw.math.rot3d(0.5, ax);
                testCase.verifyEqual(R.'*R, eye(3), 'AbsTol', 1e-12);
                testCase.verifyEqual(det(R), 1, 'AbsTol', 1e-12);
            end
        end
    end
end
