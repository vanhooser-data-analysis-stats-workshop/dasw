classdef RoiOverlapTest < matlab.unittest.TestCase
%ROIOVERLAPTEST Unit tests for dasw.roi.roi_overlap.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testFractionOfPixels(testCase)
            rois = struct('pixelinds', {[1;2;3;4], [10;11], [1;2]});
            BI = false(5);
            BI([1 2]) = true;
            overlaps = dasw.roi.roi_overlap(rois, BI);
            testCase.verifyEqual(overlaps, [0.5 0 1]);
        end

        function testEmptyRois(testCase)
            rois = struct('pixelinds', {});
            testCase.verifyEmpty(dasw.roi.roi_overlap(rois, true(3)));
        end
    end
end
