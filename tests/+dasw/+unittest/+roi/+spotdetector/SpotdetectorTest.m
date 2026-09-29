classdef SpotdetectorTest < matlab.unittest.TestCase
%SPOTDETECTORTEST Unit tests for dasw.roi.spotdetector.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testFindsSpots(testCase)
            % A 2x2 block and a single pixel are two separate spots.
            BI = false(10);
            BI(2:3, 2:3) = true;
            BI(7, 7) = true;
            [rois, L] = dasw.roi.spotdetector(BI, 4, 'CELL10', 1, {'psd95'});
            testCase.verifyNumElements(rois, 2);
            testCase.verifySize(L, [10 10]);
            testCase.verifyEqual([rois.index], [1 2]);
            testCase.verifyEqual(rois(1).name, 'CELL10');
            testCase.verifyEqual(rois(1).labels, {'psd95'});
            testCase.verifyEqual(sort(rois(1).pixelinds), sort(find(L == 1)));
            testCase.verifyNumElements(rois(1).pixelinds, 4);
            testCase.verifyEqual(rois(2).pixelinds, sub2ind([10 10], 7, 7));
            testCase.verifyEqual(rois(1).stats.Area, 4);
        end

        function testFirstIndexOffsetsNumbering(testCase)
            BI = false(10);
            BI(2, 2) = true;
            BI(8, 8) = true;
            rois = dasw.roi.spotdetector(BI, 4, 'img', 0, {});
            testCase.verifyEqual([rois.index], [0 1]);
        end

        function testSinglePixelContourIsFlared(testCase)
            % A one-pixel spot is drawn as a small square around the pixel.
            BI = false(5);
            BI(3, 4) = true;
            rois = dasw.roi.spotdetector(BI, 4, 'img', 1, {});
            testCase.verifyEqual(rois.xi, 4 + [-0.5 -0.5 0.5 0.5]');
            testCase.verifyEqual(rois.yi, 3 + [-0.5 -0.5 0.5 0.5]');
        end

        function testConnectivity(testCase)
            % Diagonal neighbors are one spot with 8-connectivity, two with 4.
            BI = logical(eye(3));
            testCase.verifyNumElements(dasw.roi.spotdetector(BI, 4, 'img', 1, {}), 3);
            testCase.verifyNumElements(dasw.roi.spotdetector(BI, 8, 'img', 1, {}), 1);
        end

        function testEmptyImage(testCase)
            rois = dasw.roi.spotdetector(false(5), 4, 'img', 1, {});
            testCase.verifyEmpty(rois);
        end
    end
end
