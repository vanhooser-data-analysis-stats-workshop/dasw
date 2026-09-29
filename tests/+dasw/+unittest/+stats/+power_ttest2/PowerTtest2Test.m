classdef PowerTtest2Test < matlab.unittest.TestCase
%POWERTTEST2TEST Unit tests for dasw.stats.power_ttest2.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testHugeEffectAlwaysDetected(testCase)
            % A difference of 100 standard deviations is detected every time,
            % so the power is 1 and its standard error is 0.
            rng(0);
            [p, se] = dasw.stats.power_ttest2(10, 100, 1, 0.05, 50);
            testCase.verifyEqual(p, 1);
            testCase.verifyEqual(se, 0);
        end

        function testNoEffectGivesTypeIErrorRate(testCase)
            % With no true difference, the rejection rate is near ALPHA.
            rng(1);
            [p, se] = dasw.stats.power_ttest2(10, 0, 1, 0.05, 2000);
            testCase.verifyEqual(p, 0.05, 'AbsTol', 0.02);
            testCase.verifyLessThan(se, 0.01);
        end

        function testStandardErrorFormula(testCase)
            % SE is sqrt(P*(1-P)/NUM_EXPERIMENTS), and P is a multiple of
            % 1/NUM_EXPERIMENTS.
            rng(2);
            num = 400;
            [p, se] = dasw.stats.power_ttest2(10, 1, 1, 0.05, num);
            testCase.verifyEqual(se, sqrt(p*(1-p)/num), 'AbsTol', 1e-12);
            testCase.verifyEqual(p*num, round(p*num), 'AbsTol', 1e-9);
            testCase.verifyGreaterThanOrEqual(p, 0);
            testCase.verifyLessThanOrEqual(p, 1);
        end

        function testLargerEffectHasMorePower(testCase)
            % Power grows with effect size; for n=17 and d=1 it is about 0.8.
            rng(3);
            pSmall = dasw.stats.power_ttest2(17, 0.3, 1, 0.05, 1000);
            pLarge = dasw.stats.power_ttest2(17, 1, 1, 0.05, 1000);
            testCase.verifyGreaterThan(pLarge, pSmall);
            testCase.verifyEqual(pLarge, 0.8, 'AbsTol', 0.06);
        end
    end
end
