function tests = histbinsTest
% HISTBINSTEST - Tests for dasw.plot.histbins
tests = functiontests(localfunctions);

function testCountsAndCenters(testCase)
% Edges [0 1 2 3 4] give bins [0,1) [1,2) [2,3) [3,4]; data 1,2,3 land
% in the last three bins.
[N, centers] = dasw.plot.histbins([1 2 3], [0 1 2 3 4]);
verifyEqual(testCase, N, [0 1 1 1]);
verifyEqual(testCase, centers, [0.5 1.5 2.5 3.5], 'AbsTol', 1e-12);

function testCenterCount(testCase)
% There is one bin center per bin (one fewer than the number of edges).
[N, centers] = dasw.plot.histbins(randn(1,50), -3:0.5:3);
verifyEqual(testCase, numel(centers), numel(N));
