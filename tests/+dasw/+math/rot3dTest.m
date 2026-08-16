function tests = rot3dTest
% ROT3DTEST - Tests for dasw.math.rot3d
tests = functiontests(localfunctions);

function testIdentityAtZero(testCase)
% Zero rotation about any axis is the identity.
for ax = 1:3
    verifyEqual(testCase, dasw.math.rot3d(0, ax), eye(3), 'AbsTol', 1e-12);
end

function testZAxisNinety(testCase)
verifyEqual(testCase, dasw.math.rot3d(pi/2, 3), ...
    [0 -1 0; 1 0 0; 0 0 1], 'AbsTol', 1e-12);

function testRotationAxisIsFixed(testCase)
% Rotating about an axis leaves a vector along that axis unchanged.
theta = 0.6;
verifyEqual(testCase, dasw.math.rot3d(theta, 1)*[1;0;0], [1;0;0], 'AbsTol', 1e-12);
verifyEqual(testCase, dasw.math.rot3d(theta, 3)*[0;0;1], [0;0;1], 'AbsTol', 1e-12);

function testOrthonormal(testCase)
for ax = 1:3
    R = dasw.math.rot3d(0.5, ax);
    verifyEqual(testCase, R.'*R, eye(3), 'AbsTol', 1e-12);
    verifyEqual(testCase, det(R), 1, 'AbsTol', 1e-12);
end
