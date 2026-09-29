classdef FourierCoefficientsTest < matlab.unittest.TestCase
%FOURIERCOEFFICIENTSTEST Unit tests for dasw.signal.fourier_coefficients.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testFrequencies(testCase)
            t = (0:99)/100;
            [an, bn, fn] = dasw.signal.fourier_coefficients(t, zeros(size(t)));
            testCase.verifyEqual(fn, (0:99), 'AbsTol', 1e-9);
            testCase.verifyNumElements(an, 100);
            testCase.verifyNumElements(bn, 100);
        end

        function testRecoversCosineAndSine(testCase)
            % mean(A*cos^2) = A/2, so amplitudes 3 and 2 give 1.5 and 1.
            t = (0:99)/100;
            S = 3*cos(2*pi*5*t) + 2*sin(2*pi*7*t);
            [an, bn, fn] = dasw.signal.fourier_coefficients(t, S);
            testCase.verifyEqual(fn([6 8]), [5 7], 'AbsTol', 1e-9);
            testCase.verifyEqual(an(6), 1.5, 'AbsTol', 1e-9);
            testCase.verifyEqual(bn(8), 1, 'AbsTol', 1e-9);
            testCase.verifyEqual(bn(6), 0, 'AbsTol', 1e-9);
            testCase.verifyEqual(an(8), 0, 'AbsTol', 1e-9);
            testCase.verifyEqual(an(1), 0, 'AbsTol', 1e-9);
        end

        function testConstantSignal(testCase)
            t = (0:9)/10;
            an = dasw.signal.fourier_coefficients(t, 4*ones(size(t)));
            testCase.verifyEqual(an(1), 4, 'AbsTol', 1e-12);
        end
    end
end
