classdef TumorfitTest < matlab.unittest.TestCase
%TUMORFITTEST Unit tests for dasw.tumor.tumorfit.
%
%   The data are generated from a known curve a+b*exp(c*x.^d) with no
%   noise, so the fit should recover it.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (TestMethodSetup)

        function seedRandom(testCase)
            % tumorfit picks random start points with randn.
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
            rng(0, 'twister');
        end
    end

    methods (Test)

        function testDecayChangeAndHalvingTime(testCase)
            % y = 200*2^(-x/5) halves every 5 days, so starting from y(1) it
            % reaches half of y(1) at x = 6. The raw change from x=1 to x=30
            % is 100*(2^(-6) - 2^(-0.2))/2^(-0.2) = 100*(2^(-5.8) - 1).
            x = 1:30;
            data = [x; 200*2.^(-x/5)];
            [change, rate] = dasw.tumor.tumorfit(data, 10);
            testCase.verifyEqual(change, 100*(2^(-5.8) - 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(rate, 6, 'RelTol', 0.02);
        end

        function testGrowthChangeAndDoublingTime(testCase)
            % y = 10*2^x doubles every day, so starting from y(1) = 20 it
            % reaches 40 at x = 2. Change from 20 to 10240 is 51100%.
            x = 1:10;
            data = [x; 10*2.^x];
            [change, rate] = dasw.tumor.tumorfit(data, 10);
            testCase.verifyEqual(change, 51100, 'AbsTol', 1e-9);
            testCase.verifyEqual(rate, 2, 'RelTol', 0.02);
        end

        function testRecoversCoefficients(testCase)
            % y = 5 + 100*exp(-0.1*x.^1)
            x = 1:40;
            y = 5 + 100*exp(-0.1*x);
            [~, ~, a, b, c, d] = dasw.tumor.tumorfit([x; y], 10);
            testCase.verifyEqual(a, 5, 'AbsTol', 0.5);
            testCase.verifyEqual(b, 100, 'RelTol', 0.02);
            testCase.verifyEqual(c, -0.1, 'RelTol', 0.02);
            testCase.verifyEqual(d, 1, 'RelTol', 0.02);
            testCase.verifyEqual(a + b*exp(c*x.^d), y, 'AbsTol', 0.5);
        end

        function testCoefficientsWithinBounds(testCase)
            % The fit is bounded: a in [-1e4,1e4], b in [0,1e4], c in [-10,10],
            % d in [0,1.2].
            x = 1:20;
            [~, ~, a, b, c, d] = dasw.tumor.tumorfit([x; 50 + 3*x], 5);
            testCase.verifyGreaterThanOrEqual([a b c d], [-10000 0 -10 0]);
            testCase.verifyLessThanOrEqual([a b c d], [10000 10000 10 1.2]);
        end

        function testRateInfWhenHalfIsUnreachable(testCase)
            % y = 80 + 20*exp(-0.2*x) never drops below 80, so it can never
            % reach half of y(1) (about 48): the rate is Inf.
            x = 1:30;
            data = [x; 80 + 20*exp(-0.2*x)];
            [change, rate] = dasw.tumor.tumorfit(data, 10);
            testCase.verifyEqual(rate, Inf);
            testCase.verifyLessThan(change, 0);
        end
    end
end
