function tests = refl2dTest
% REFL2DTEST - Tests for dasw.math.refl2d
tests = functiontests(localfunctions);

function testZero(testCase)
% Reflection about the x-axis (theta = 0).
verifyEqual(testCase, dasw.math.refl2d(0), [1 0; 0 -1], 'AbsTol', 1e-12);

function testInvolution(testCase)
% Reflecting twice returns the original: R*R = I.
R = dasw.math.refl2d(0.9);
verifyEqual(testCase, R*R, eye(2), 'AbsTol', 1e-12);

function testDeterminantMinusOne(testCase)
verifyEqual(testCase, det(dasw.math.refl2d(0.4)), -1, 'AbsTol', 1e-12);

function testFixesReflectionLine(testCase)
% A vector along the line of reflection (angle theta) is unchanged.
theta = pi/5;
v = [cos(theta); sin(theta)];
verifyEqual(testCase, dasw.math.refl2d(theta)*v, v, 'AbsTol', 1e-12);
