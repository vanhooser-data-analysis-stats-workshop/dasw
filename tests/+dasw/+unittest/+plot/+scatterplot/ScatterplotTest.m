classdef ScatterplotTest < matlab.unittest.TestCase
%SCATTERPLOTTEST Unit tests for dasw.plot.scatterplot.
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

        function testOneLinePerClass(testCase)
            % Two classes give two lines, each holding that class's points.
            X = [0 0; 1 2; 2 1; 3 3];
            dasw.plot.scatterplot(X, 'class', [1; 1; 2; 2]);
            lines = findobj(testCase.Fig, 'Type', 'line');
            testCase.verifyNumElements(lines, 2);
            first = findobj(lines, 'XData', [0 1]);
            second = findobj(lines, 'XData', [2 3]);
            testCase.verifyEqual(first.YData, [0 2]);
            testCase.verifyEqual(second.YData, [1 3]);
            testCase.verifyEqual(first.LineStyle, 'none');
        end

        function testOptionsAreApplied(testCase)
            % Options passed as name/value pairs reach the plotted line.
            X = [0 0; 1 2; 2 1];
            dasw.plot.scatterplot(X, 'marker', 'o', 'markersize', 6, 'color', [1 0 0]);
            h = findobj(testCase.Fig, 'Type', 'line');
            testCase.verifyEqual(h.Marker, 'o');
            testCase.verifyEqual(h.MarkerSize, 6);
            testCase.verifyEqual(h.Color, [1 0 0]);
        end

        function testShrinkFitsAxesToData(testCase)
            X = [-1 2; 3 5; 1 4];
            dasw.plot.scatterplot(X);
            ax = gca;
            testCase.verifyEqual(ax.XLim, [-1 3]);
            testCase.verifyEqual(ax.YLim, [2 5]);
        end

        function testThreeDimensionsMakeTriangleOfSubplots(testCase)
            % Three columns give one subplot per pair of dimensions, so 3 axes
            % hold points.
            rng(0);
            dasw.plot.scatterplot(rand(10, 3));
            axs = findobj(testCase.Fig, 'Type', 'axes');
            hasPoints = arrayfun(@(a) ~isempty(findobj(a, 'Type', 'line')), axs);
            testCase.verifyEqual(nnz(hasPoints), 3);
        end
    end
end
