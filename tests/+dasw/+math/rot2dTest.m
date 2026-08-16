function tests = rot2dTest
% ROT2DTEST - Tests for dasw.math.rot2d
tests = functiontests(localfunctions);

function testIdentityAtZero(testCase)
verifyEqual(testCase, dasw.math.rot2d(0), eye(2), 'AbsTol', 1e-12);

function testNinetyDegrees(testCase)
verifyEqual(testCase, dasw.math.rot2d(pi/2), [0 -1; 1 0], 'AbsTol', 1e-12);

function testRotatesUnitVector(testCase)
% Rotating [1;0] by theta yields [cos(theta); sin(theta)].
theta = pi/6;
verifyEqual(testCase, dasw.math.rot2d(theta)*[1;0], ...
    [cos(theta); sin(theta)], 'AbsTol', 1e-12);

function testOrthonormal(testCase)
% A rotation matrix is orthonormal with determinant +1.
R = dasw.math.rot2d(0.7);
verifyEqual(testCase, R.'*R, eye(2), 'AbsTol', 1e-12);
verifyEqual(testCase, det(R), 1, 'AbsTol', 1e-12);
