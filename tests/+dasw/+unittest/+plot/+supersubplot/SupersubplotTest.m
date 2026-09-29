classdef SupersubplotTest < matlab.unittest.TestCase
%SUPERSUBPLOTTEST Unit tests for dasw.plot.supersubplot.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testFirstFigure(testCase)
            % Plot numbers up to M*N stay on the first figure.
            fig = testCase.newFigure();
            ax = dasw.plot.supersubplot(fig, 2, 2, 4);
            testCase.verifyClass(ax, 'matlab.graphics.axis.Axes');
            testCase.verifyEqual(ax.Parent, fig);
        end

        function testSpillsToNextFigure(testCase)
            % Plot number M*N+1 starts a second figure, which is remembered.
            fig = testCase.newFigure();
            ax = dasw.plot.supersubplot(fig, 2, 2, 5);
            ud = get(fig, 'userdata');
            testCase.addTeardown(@() close(ud(2)));
            testCase.verifyNumElements(ud, 2);
            testCase.verifyEqual(ud(1), fig);
            testCase.verifyEqual(ax.Parent, ud(2));
            testCase.verifyNotEqual(ax.Parent, fig);
        end

        function testReusesSecondFigure(testCase)
            % Later plots on the second figure do not create a third one.
            fig = testCase.newFigure();
            ax1 = dasw.plot.supersubplot(fig, 2, 2, 5);
            ud = get(fig, 'userdata');
            testCase.addTeardown(@() close(ud(2)));
            ax2 = dasw.plot.supersubplot(fig, 2, 2, 8);
            testCase.verifyNumElements(get(fig, 'userdata'), 2);
            testCase.verifyEqual(ax2.Parent, ax1.Parent);
        end
    end

    methods (Access = private)

        function fig = newFigure(testCase)
            fig = figure('Visible', 'off');
            testCase.addTeardown(@() close(fig));
        end
    end
end
