classdef LabelRoisTest < matlab.unittest.TestCase
%LABELROISTEST Unit tests for dasw.roi.label_rois.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testAddsLabel(testCase)
            rois = struct('labels', {{'psd95'}, {}});
            rois = dasw.roi.label_rois(rois, 'GFP');
            testCase.verifyEqual(rois(1).labels, {'psd95', 'GFP'});
            testCase.verifyEqual(rois(2).labels, {'GFP'});
        end

        function testDoesNotDuplicate(testCase)
            rois = struct('labels', {{'GFP'}});
            rois = dasw.roi.label_rois(rois, 'GFP');
            testCase.verifyEqual(rois.labels, {'GFP'});
        end

        function testSeveralLabels(testCase)
            rois = struct('labels', {{'psd95'}});
            rois = dasw.roi.label_rois(rois, 'GFP', 'A', 'B');
            testCase.verifyEqual(rois.labels, {'psd95', 'GFP', 'A', 'B'});
        end
    end
end
