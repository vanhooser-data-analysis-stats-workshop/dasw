classdef AutohistogramTest < matlab.unittest.TestCase
%AUTOHISTOGRAMTEST Unit tests for dasw.plot.autohistogram.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testKnownBins(testCase)
            % For 1:8, iqr is 6.5-2.5 = 4 and 8^(1/3) = 2, so the bin width is
            % 2*4/2 = 4. Edges run -3:4:12, i.e. [-3 1 5 9], giving bins
            % [-3,1) [1,5) [5,9] with centers -1, 3, 7.
            [counts, centers] = dasw.plot.autohistogram(1:8);
            testCase.verifyEqual(counts, [0 4 4]);
            testCase.verifyEqual(centers, [-1 3 7], 'AbsTol', 1e-12);
        end

        function testRowAndColumnAgree(testCase)
            % Row and column inputs give the same answer.
            data = [3 1 4 1 5 9 2 6 5 3 5];
            [c1, b1] = dasw.plot.autohistogram(data);
            [c2, b2] = dasw.plot.autohistogram(data(:));
            testCase.verifyEqual(c1, c2);
            testCase.verifyEqual(b1, b2);
        end

        function testCountsCoverAllData(testCase)
            % Every sample lands in some bin, and there is one center per bin.
            rng(0);
            data = randn(1,200);
            [counts, centers] = dasw.plot.autohistogram(data);
            testCase.verifyEqual(sum(counts), numel(data));
            testCase.verifyEqual(numel(centers), numel(counts));
        end

        function testCentersEvenlySpaced(testCase)
            % Bin centers are spaced by the Freedman-Diaconis width.
            rng(1);
            data = rand(1,125);
            [~, centers] = dasw.plot.autohistogram(data);
            width = 2*iqr(data)/125^(1/3);
            testCase.verifyEqual(diff(centers), width*ones(1,numel(centers)-1), ...
                'AbsTol', 1e-12);
        end
    end
end
