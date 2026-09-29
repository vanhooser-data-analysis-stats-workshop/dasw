classdef FiltertransferTest < matlab.unittest.TestCase
%FILTERTRANSFERTEST Unit tests for dasw.signal.filtertransfer.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testFrequencyGrid(testCase)
            % 200 log-spaced frequencies from SR/N up to just under Nyquist.
            f = dasw.signal.filtertransfer(1, 1, 1000, 1000, 'filter');
            testCase.verifyNumElements(f, 200);
            testCase.verifyEqual(f(1), 1, 'AbsTol', 1e-9);
            testCase.verifyEqual(f(end), 499.5, 'AbsTol', 1e-9);
            testCase.verifyTrue(all(diff(f) > 0));
        end

        function testIdentityFilterPassesEverything(testCase)
            % Non-integer numbers of cycles leak a little, so the tolerance is loose.
            [~, output, phaseshift] = dasw.signal.filtertransfer(1, 1, 1000, 1000, 'filter');
            testCase.verifyEqual(output, ones(1,200), 'AbsTol', 0.1);
            testCase.verifyEqual(phaseshift, zeros(1,200), 'AbsTol', 0.15);
        end

        function testMovingAverageIsLowPass(testCase)
            [~, output] = dasw.signal.filtertransfer(ones(1,5)/5, 1, 1000, 1000, 'filter');
            testCase.verifyGreaterThan(output(1), 0.95);
            testCase.verifyLessThan(output(end), 0.3);
        end
    end
end
