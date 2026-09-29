classdef FouriercoeffsTest < matlab.unittest.TestCase
%FOURIERCOEFFSTEST Unit tests for dasw.signal.fouriercoeffs.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testConstantTerm(testCase)
            [fc, freqs] = dasw.signal.fouriercoeffs(4*ones(1,100), 0.01);
            testCase.verifyEqual(fc(1), 4, 'AbsTol', 1e-12);
            testCase.verifyEqual(freqs(1), 0);
            testCase.verifyNumElements(freqs, 100);
            testCase.verifyNumElements(fc, 100);
        end

        function testCosineAmplitude(testCase)
            t = (0:99)/100;
            fc = dasw.signal.fouriercoeffs(cos(2*pi*5*t), 0.01);
            testCase.verifyEqual(real(fc(6)), 1, 'AbsTol', 1e-9);
            testCase.verifyEqual(imag(fc(6)), 0, 'AbsTol', 1e-9);
            testCase.verifyEqual(abs(fc(8)), 0, 'AbsTol', 1e-9);
        end

        function testSineIsImaginary(testCase)
            % A sine lands in the imaginary part (sign flipped relative to FFT).
            t = (0:99)/100;
            fc = dasw.signal.fouriercoeffs(sin(2*pi*5*t), 0.01);
            testCase.verifyEqual(fc(6), 1i, 'AbsTol', 1e-9);
        end
    end
end
