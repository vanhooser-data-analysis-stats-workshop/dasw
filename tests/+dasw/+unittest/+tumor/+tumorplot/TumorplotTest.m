classdef TumorplotTest < matlab.unittest.TestCase
%TUMORPLOTTEST Unit tests for dasw.tumor.tumorplot.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        Ax
    end

    methods (TestMethodSetup)

        function createFigure(testCase)
            fig = figure('Visible', 'off');
            testCase.addTeardown(@close, fig);
            testCase.Ax = axes(fig);
        end
    end

    methods (Test)

        function testDataAndFitLines(testCase)
            % Data [0 1 2; 10 20 40] with fit 0+10*exp(1*x.^1) = 10*exp(x).
            data = [0 1 2; 10 20 40];
            dasw.tumor.tumorplot(data, 0, 10, 1, 1);
            lines = findobj(testCase.Ax, 'Type', 'line');
            testCase.verifyNumElements(lines, 2);
            dataLine = findobj(lines, 'LineStyle', '-');
            fitLine = findobj(lines, 'LineStyle', '--');
            testCase.verifyEqual(dataLine.XData, [0 1 2]);
            testCase.verifyEqual(dataLine.YData, [10 20 40]);
            testCase.verifyEqual(fitLine.XData, [0 1 2]);
            testCase.verifyEqual(fitLine.YData, 10*exp([0 1 2]), 'AbsTol', 1e-12);
        end

        function testFitWithOffsetAndPower(testCase)
            % a + b*exp(c*x.^d) with a=5, b=2, c=-1, d=0.5 at x = [1 4 9]
            % is 5 + 2*exp(-[1 2 3]).
            data = [1 4 9; 7 6 5];
            dasw.tumor.tumorplot(data, 5, 2, -1, 0.5);
            fitLine = findobj(testCase.Ax, 'Type', 'line', 'LineStyle', '--');
            testCase.verifyEqual(fitLine.YData, 5 + 2*exp(-[1 2 3]), 'AbsTol', 1e-12);
        end

        function testAxesAndLabels(testCase)
            % The x axis spans the first to last day.
            data = [3 5 8; 1 2 3];
            dasw.tumor.tumorplot(data, 0, 1, 0.1, 1);
            testCase.verifyEqual(testCase.Ax.XLim, [3 8]);
            testCase.verifyEqual(testCase.Ax.XLabel.String, 'Day');
            testCase.verifyEqual(testCase.Ax.YLabel.String, 'Tumor size');
        end
    end
end
