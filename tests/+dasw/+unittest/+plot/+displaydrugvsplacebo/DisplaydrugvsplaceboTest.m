classdef DisplaydrugvsplaceboTest < matlab.unittest.TestCase
%DISPLAYDRUGVSPLACEBOTEST Unit tests for dasw.plot.displaydrugvsplacebo.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        FiguresBefore
    end

    methods (TestMethodSetup)

        function hideAndTrackFigures(testCase)
            % displaydrugvsplacebo calls figure itself, so hide new figures
            % by default and close any it made.
            oldVisible = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@set, groot, 'DefaultFigureVisible', oldVisible);
            testCase.FiguresBefore = findall(groot, 'Type', 'figure');
            testCase.addTeardown(@() closeFigures(newFigures(testCase.FiguresBefore)));
        end
    end

    methods (Test)

        function testMean(testCase)
            % mean([1 2 3 4]) = 2.5, mean([10 20 30]) = 20; no figure.
            [out, f] = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'mean', [1; 2; 3; 4], [10; 20; 30]));
            testCase.verifyEmpty(f);
            testCase.verifyEmpty(newFigures(testCase.FiguresBefore));
            testCase.verifySubstring(out, '   Drug group mean: 2.5, N=4.');
            testCase.verifySubstring(out, 'Placebo group mean: 20, N=3.');
        end

        function testModeIsCaseInsensitive(testCase)
            out = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'MEAN', [1; 2; 3; 4], [10; 20; 30]));
            testCase.verifySubstring(out, 'Drug group mean: 2.5, N=4.');
        end

        function testMedian(testCase)
            % median([4 1 3 2]) = 2.5 with N=4; median([30 10 20]) = 20, N=3.
            [out, f] = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'median', [4; 1; 3; 2], [30; 10; 20]));
            testCase.verifyEmpty(f);
            testCase.verifySubstring(out, '   Drug group median: 2.5, N=4.');
            testCase.verifySubstring(out, 'Placebo group median: 20, N=3.');
        end

        function testPercentileRange(testCase)
            % For 1..10, MATLAB's prctile puts value k at percentile
            % 100*(k-0.5)/10, so the 20th percentile is 2.5 and the 80th is
            % 8.5; scaling the data by 10 scales them to 25 and 85.
            [out, f] = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'percentilerange', (1:10)', 10*(1:10)'));
            testCase.verifyEmpty(f);
            testCase.verifySubstring(out, ...
                '   Drug group: 20%-tile is 2.5, 80%-tile is 8.5, N=10.');
            testCase.verifySubstring(out, ...
                'Placebo group: 20%-tile is 25, 80%-tile is 85, N=10.');
        end

        function testNumbers(testCase)
            % Two tables of the sorted data in a new figure.
            [out, f] = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'numbers', [3; 1; 2], [9; 7; 8; 6]));
            testCase.verifyClass(f, 'matlab.ui.Figure');
            tables = findall(f, 'Type', 'uitable');
            testCase.verifyNumElements(tables, 2);
            names = strings(size(tables));
            for k = 1:numel(tables)
                names(k) = string(tables(k).ColumnName);
            end
            drug = tables(names == "Drug group");
            placebo = tables(names == "Placebo group");
            testCase.verifyEqual(drug.Data, [1; 2; 3]);
            testCase.verifyEqual(placebo.Data, [6; 7; 8; 9]);
            testCase.verifySubstring(out, '   Drug group: ');
            testCase.verifySubstring(out, 'Placebo group: ');
        end

        function testBarGraphRange(testCase)
            % Bars at the group means (3 and 7) with every observation drawn
            % as a point over its bar.
            data1 = [1; 2; 3; 6];
            data2 = [4; 8; 9];
            f = dasw.plot.displaydrugvsplacebo('bargraphrange', data1, data2);
            testCase.verifyClass(f, 'matlab.ui.Figure');
            ax = findobj(f, 'Type', 'axes');
            testCase.verifyNumElements(ax, 1);

            bars = findobj(ax, 'Type', 'bar');
            testCase.verifyNumElements(bars, 2);
            [x, order] = sort([bars.XData]);
            y = [bars.YData];
            testCase.verifyEqual(x, [1 2]);
            testCase.verifyEqual(y(order), [3 7], 'AbsTol', 1e-12);

            drugPoints = findobj(ax, 'Type', 'line', 'Marker', 'o');
            placeboPoints = findobj(ax, 'Type', 'line', 'Marker', 'x');
            testCase.verifyEqual(unique([drugPoints.XData]), 1);
            testCase.verifyEqual(unique([placeboPoints.XData]), 2);
            testCase.verifyEqual(sort([drugPoints.YData]), sort(data1)');
            testCase.verifyEqual(sort([placeboPoints.YData]), sort(data2)');

            testCase.verifyEqual(string(ax.XTickLabel(:)), ...
                ["Drug N=4"; "Placebo N=3"]);
            testCase.verifyEqual(ax.YLabel.String, 'Years of life');
            testCase.verifyLessThanOrEqual(ax.YLim(1), 1);
            testCase.verifyGreaterThanOrEqual(ax.YLim(2), 9);
        end

        function testHistogram(testCase)
            % One axes per group, sharing bins; the counts add up to N.
            data1 = (1:8)';
            data2 = [2; 4; 6; 8];
            f = dasw.plot.displaydrugvsplacebo('histogram', data1, data2);
            ax = findobj(f, 'Type', 'axes');
            testCase.verifyNumElements(ax, 2);

            drugBars = findobj(f, 'Type', 'bar', 'FaceColor', [0 0 1]);
            placeboBars = findobj(f, 'Type', 'bar', 'FaceColor', [0 1 0]);
            testCase.verifyNumElements(drugBars, 1);
            testCase.verifyNumElements(placeboBars, 1);
            testCase.verifyEqual(sum(drugBars.YData), 8);
            testCase.verifyEqual(sum(placeboBars.YData), 4);
            testCase.verifyEqual(drugBars.XData, placeboBars.XData);
            widths = diff(drugBars.XData);
            testCase.verifyEqual(widths, widths(1)*ones(size(widths)), 'RelTol', 1e-9);

            drugAx = ancestor(drugBars, 'axes');
            testCase.verifyEqual(string(drugAx.YLabel.String(:)), ...
                ["Drug group: # of observations"; "N=8"]);
            placeboAx = ancestor(placeboBars, 'axes');
            testCase.verifyEqual(string(placeboAx.YLabel.String(:)), ...
                ["Placebo group: # of observations"; "N=4"]);
            testCase.verifyEqual(placeboAx.XLabel.String, 'Years of life');
        end

        function testCumulativeHistogram(testCase)
            % Each curve runs from 0% to 100% through the 0th..100th
            % percentiles of its group, padded one bin width on each side.
            data1 = (1:10)';
            data2 = (11:20)';
            f = dasw.plot.displaydrugvsplacebo('cumulativehistogram', data1, data2);
            ax = findobj(f, 'Type', 'axes');
            testCase.verifyNumElements(ax, 1);

            drug = findobj(ax, 'Type', 'line', 'Color', [0 0 1]);
            placebo = findobj(ax, 'Type', 'line', 'Color', [0 1 0]);
            testCase.verifyNumElements(drug, 1);
            testCase.verifyNumElements(placebo, 1);
            testCase.verifyEqual(drug.YData, [0 0:100 100]);
            testCase.verifyEqual(placebo.YData, [0 0:100 100]);
            testCase.verifyEqual(drug.XData([2 end-1]), [1 10], 'AbsTol', 1e-12);
            testCase.verifyEqual(placebo.XData([2 end-1]), [11 20], 'AbsTol', 1e-12);
            testCase.verifyEqual(drug.XData(1), placebo.XData(1));
            testCase.verifyLessThan(drug.XData(1), 1);
            testCase.verifyGreaterThan(placebo.XData(end), 20);
            testCase.verifyGreaterThanOrEqual(diff(drug.XData), 0);

            lgd = findobj(f, 'Type', 'legend');
            testCase.verifyEqual(string(lgd.String(:)), ...
                ["Drug group, N=10"; "Placebo group, N=10"]);
        end

        function testUnknownModeDoesNothing(testCase)
            [out, f] = runQuietly(@() dasw.plot.displaydrugvsplacebo( ...
                'nonsense', [1; 2], [3; 4]));
            testCase.verifyEmpty(f);
            testCase.verifyEmpty(out);
            testCase.verifyEmpty(newFigures(testCase.FiguresBefore));
        end
    end
end

function [out, f] = runQuietly(fh)
% Call FH, returning its first output F and the text it printed in OUT.
f = [];
out = evalc('f = fh();');
end

function figs = newFigures(before)
% Figures that exist now but were not in BEFORE.
figs = findall(groot, 'Type', 'figure');
keep = true(size(figs));
for k = 1:numel(figs)
    for j = 1:numel(before)
        if figs(k) == before(j), keep(k) = false; end
    end
end
figs = figs(keep);
end

function closeFigures(figs)
for k = 1:numel(figs)
    if isvalid(figs(k)), close(figs(k)); end
end
end
