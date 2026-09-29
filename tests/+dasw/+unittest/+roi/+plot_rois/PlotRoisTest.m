classdef PlotRoisTest < matlab.unittest.TestCase
%PLOTROISTEST Unit tests for dasw.roi.plot_rois.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        Fig
    end

    methods (TestMethodSetup)

        function createFigure(testCase)
            testCase.Fig = figure('Visible', 'off');
            testCase.addTeardown(@close, testCase.Fig);
        end
    end

    methods (Test)

        function testOneLineAndLabelPerRoi(testCase)
            rois = struct('xi', {[1 2 2 1], [5 6 6 5]}, ...
                'yi', {[1 1 2 2], [5 5 6 6]}, 'index', {3, 4});
            [h_lines, h_text] = dasw.roi.plot_rois(rois, 9, [1 0 0]);
            testCase.verifyNumElements(h_lines, 2);
            testCase.verifyNumElements(h_text, 2);
            testCase.verifyEqual(get(h_lines(1), 'XData'), [1 2 2 1]);
            testCase.verifyEqual(get(h_lines(2), 'YData'), [5 5 6 6]);
            testCase.verifyEqual(get(h_lines(1), 'Color'), [1 0 0]);
            testCase.verifyEqual(get(h_text(2), 'String'), '4');
        end

        function testLabelAtCenter(testCase)
            rois = struct('xi', [0 4 4 0], 'yi', [0 0 2 2], 'index', 1);
            [~, h_text] = dasw.roi.plot_rois(rois, 9, [0 1 0]);
            pos = get(h_text, 'Position');
            testCase.verifyEqual(pos(1:2), [2 1]);
            testCase.verifyEqual(get(h_text, 'Color'), [0 1 0]);
        end

        function testHoldsPlot(testCase)
            plot(1:3);
            rois = struct('xi', [0 1 1 0], 'yi', [0 0 1 1], 'index', 1);
            dasw.roi.plot_rois(rois, 9, [0 0 1]);
            testCase.verifyNumElements(findobj(testCase.Fig, 'Type', 'line'), 2);
        end
    end
end
