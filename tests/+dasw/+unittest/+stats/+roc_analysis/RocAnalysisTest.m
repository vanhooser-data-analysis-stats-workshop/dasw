classdef RocAnalysisTest < matlab.unittest.TestCase
%ROCANALYSISTEST Unit tests for dasw.stats.roc_analysis.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testSeparableSamples(testCase)
            % Samples that do not overlap can be perfectly discriminated.
            [discrim, TPR, FPR, Xvalues, ~, s1cum, s2cum] = ...
                dasw.stats.roc_analysis([1 2], [3 4]);
            testCase.verifyEqual(Xvalues, [0; 1; 2; 3; 4]);
            testCase.verifyEqual(s1cum, [0; 1; 2; 2; 2]);
            testCase.verifyEqual(s2cum, [0; 0; 0; 1; 2]);
            testCase.verifyEqual(TPR, [1; 1; 1; 0.5; 0], 'AbsTol', 1e-12);
            testCase.verifyEqual(FPR, [1; 0.5; 0; 0; 0], 'AbsTol', 1e-12);
            testCase.verifyEqual(discrim, [0.5; 0.75; 1; 0.75; 0.5], 'AbsTol', 1e-12);
            testCase.verifyEqual(max(discrim), 1, 'AbsTol', 1e-12);
        end

        function testIdenticalSamples(testCase)
            % Identical samples cannot be told apart: accuracy is chance.
            discrim = dasw.stats.roc_analysis([1 2 3], [1 2 3]);
            testCase.verifyEqual(discrim, 0.5*ones(size(discrim)), 'AbsTol', 1e-12);
        end

        function testConfusionSumsToOne(testCase)
            % At every threshold, the 4 confusion entries partition the data.
            rng(1);
            [~, ~, ~, Xvalues, confusion] = ...
                dasw.stats.roc_analysis(randn(30,1), randn(40,1)+1);
            total = confusion.TP_x + confusion.FN_x + confusion.FP_x + confusion.TN_x;
            testCase.verifyEqual(total, ones(size(Xvalues)), 'AbsTol', 1e-12);
        end

        function testRatesAreBoundedAndMonotonic(testCase)
            rng(2);
            [~, TPR, FPR] = dasw.stats.roc_analysis(randn(25,1), randn(25,1)+0.5);
            testCase.verifyEqual(TPR(1), 1, 'AbsTol', 1e-12);
            testCase.verifyEqual(FPR(1), 1, 'AbsTol', 1e-12);
            testCase.verifyEqual(TPR(end), 0, 'AbsTol', 1e-12);
            testCase.verifyEqual(FPR(end), 0, 'AbsTol', 1e-12);
            testCase.verifyLessThanOrEqual(diff(TPR), 1e-12);
            testCase.verifyLessThanOrEqual(diff(FPR), 1e-12);
        end
    end
end
