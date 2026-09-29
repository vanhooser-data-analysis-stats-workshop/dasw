classdef GenerateRandomDataTest < matlab.unittest.TestCase
%GENERATERANDOMDATATEST Unit tests for dasw.stats.generate_random_data.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testOutputSize(testCase)
            % N samples are returned as an N-by-1 column.
            rng(0);
            data = dasw.stats.generate_random_data(7, 'Normal', 0, 1);
            testCase.verifySize(data, [7 1]);
        end

        function testUniformMatchesInverseCdf(testCase)
            % The inverse CDF of Uniform(2,3) at u is 2+u, so with the same seed
            % the samples are exactly 2 plus the underlying rand draws.
            rng(1);
            u = rand(10,1);
            rng(1);
            data = dasw.stats.generate_random_data(10, 'Uniform', 2, 3);
            testCase.verifyEqual(data, 2+u, 'AbsTol', 1e-12);
        end

        function testNormalMatchesInverseCdf(testCase)
            % Normal samples are norminv applied to the rand draws.
            rng(2);
            u = rand(20,1);
            rng(2);
            data = dasw.stats.generate_random_data(20, 'Normal', 5, 2);
            testCase.verifyEqual(data, norminv(u, 5, 2), 'AbsTol', 1e-12);
        end

        function testNormalSampleMoments(testCase)
            % A large Normal(10,3) sample has mean near 10 and std near 3.
            rng(3);
            data = dasw.stats.generate_random_data(20000, 'Normal', 10, 3);
            testCase.verifyEqual(mean(data), 10, 'AbsTol', 0.1);
            testCase.verifyEqual(std(data), 3, 'AbsTol', 0.1);
        end
    end
end
