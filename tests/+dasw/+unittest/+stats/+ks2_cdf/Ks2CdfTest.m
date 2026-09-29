classdef Ks2CdfTest < matlab.unittest.TestCase
%KS2CDFTEST Unit tests for dasw.stats.ks2_cdf.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testZeroDifference(testCase)
            % A K-S statistic of 0 is the smallest possible, so the CDF is 0.
            testCase.verifyEqual(dasw.stats.ks2_cdf(100, 100, 0), 0, 'AbsTol', 1e-12);
        end

        function testLargeDifference(testCase)
            % A maximal difference between the empirical CDFs gives a CDF of 1.
            testCase.verifyEqual(dasw.stats.ks2_cdf(100, 100, 1), 1, 'AbsTol', 1e-12);
        end

        function testCriticalValue(testCase)
            % The asymptotic Kolmogorov distribution reaches 0.95 at
            % lambda = 1.3581, where lambda = (sqrt(n)+0.12+0.11/sqrt(n))*D
            % and n = n1*n2/(n1+n2).
            n = 100*100/(100+100);
            D = 1.3581/(sqrt(n) + 0.12 + 0.11/sqrt(n));
            testCase.verifyEqual(dasw.stats.ks2_cdf(100, 100, D), 0.95, 'AbsTol', 1e-4);
        end

        function testOutputShapeAndMonotonic(testCase)
            D = linspace(0, 0.5, 26)';
            c = dasw.stats.ks2_cdf(40, 60, D);
            testCase.verifySize(c, size(D));
            testCase.verifyGreaterThanOrEqual(c, 0);
            testCase.verifyLessThanOrEqual(c, 1);
            testCase.verifyGreaterThanOrEqual(diff(c), -1e-12);
        end

        function testLargerSamplesAreMoreSensitive(testCase)
            % The same K-S statistic is more extreme for larger samples.
            testCase.verifyGreaterThan(dasw.stats.ks2_cdf(200, 200, 0.1), ...
                dasw.stats.ks2_cdf(20, 20, 0.1));
        end
    end
end
