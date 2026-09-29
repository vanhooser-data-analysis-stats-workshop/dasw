classdef AnalyzeTumorsPlotTest < matlab.unittest.TestCase
%ANALYZETUMORSPLOTTEST Unit tests for dasw.tumor.analyze_tumors_plot.
%
%   Each test builds a temporary folder of per-animal subfolders holding
%   tumor_data.txt files generated from known a+b*exp(c*x.^d) curves.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        Folder
        FiguresBefore
    end

    methods (TestMethodSetup)

        function setup(testCase)
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
            rng(0, 'twister');

            % analyze_tumors_plot calls figure itself, so hide new figures by
            % default and close any it made.
            oldVisible = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@set, groot, 'DefaultFigureVisible', oldVisible);
            testCase.FiguresBefore = findall(groot, 'Type', 'figure');
            testCase.addTeardown(@() closeFigures(newFigures(testCase.FiguresBefore)));

            fixture = testCase.applyFixture( ...
                matlab.unittest.fixtures.TemporaryFolderFixture);
            testCase.Folder = char(fixture.Folder);

            % mouseA: 200*2^(-x/5) on days 1..30 (halving time 6 from day 1).
            % mouseB: 10*2^x on days 1..10 (doubling time 2 from day 1).
            x = 1:30;
            writeTumorData(testCase.Folder, 'mouseA', [x; 200*2.^(-x/5)]);
            x = 1:10;
            writeTumorData(testCase.Folder, 'mouseB', [x; 10*2.^x]);
            mkdir(fullfile(testCase.Folder, 'nodata'));
        end
    end

    methods (Test)

        function testTableWithoutPlotting(testCase)
            folder = testCase.Folder;
            [out, t] = runQuietly(@() dasw.tumor.analyze_tumors_plot(folder, 'drugA', 0));

            testCase.verifyEmpty(newFigures(testCase.FiguresBefore));
            testCase.verifyEqual(t.Properties.VariableNames, ...
                {'Change', 'Rate', 'a', 'b', 'c', 'd', 'Condition', 'File'});
            testCase.verifyEqual(height(t), 2);
            testCase.verifyEqual(t.Condition, ["drugA"; "drugA"]);

            fileA = [folder filesep 'mouseA' filesep 'tumor_data.txt'];
            fileB = [folder filesep 'mouseB' filesep 'tumor_data.txt'];
            testCase.verifySubstring(out, ['Analyzing file ' fileA '.']);
            rowA = t(t.File == fileA, :);
            rowB = t(t.File == fileB, :);
            testCase.verifyEqual(rowA.Change, 100*(2^(-5.8) - 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(rowB.Change, 51100, 'AbsTol', 1e-9);
            testCase.verifyEqual(rowA.Rate, 6, 'RelTol', 0.02);
            testCase.verifyEqual(rowB.Rate, 2, 'RelTol', 0.02);
        end

        function testPlotsOneAxesPerAnimal(testCase)
            folder = testCase.Folder;
            [~, t] = runQuietly(@() dasw.tumor.analyze_tumors_plot(folder, 'drugA', 1));
            testCase.verifyEqual(height(t), 2);

            figs = newFigures(testCase.FiguresBefore);
            testCase.verifyNumElements(figs, 1);
            ax = findobj(figs, 'Type', 'axes');
            testCase.verifyNumElements(ax, 2);

            % Titles are '<subfolder>, C%=<change>, R=<rate>'; change for
            % mouseA is -98% and for mouseB is 51100%.
            titles = axesTitles(ax);
            testCase.verifyTrue(any(startsWith(titles, "mouseA, C%=-98, R=")), ...
                strjoin(titles, ' | '));
            testCase.verifyTrue(any(startsWith(titles, "mouseB, C%=51100, R=")), ...
                strjoin(titles, ' | '));

            % Each axes holds the data line and the fitted curve.
            for k = 1:numel(ax)
                testCase.verifyNumElements(findobj(ax(k), 'Type', 'line'), 2);
            end
        end

        function testPlotsDataOfEachAnimal(testCase)
            folder = testCase.Folder;
            runQuietly(@() dasw.tumor.analyze_tumors_plot(folder, 'drugA', 1));
            ax = findobj(newFigures(testCase.FiguresBefore), 'Type', 'axes');
            titles = axesTitles(ax);
            axB = ax(startsWith(titles, "mouseB"));
            dataLine = findobj(axB, 'Type', 'line', 'LineStyle', '-');
            fitLine = findobj(axB, 'Type', 'line', 'LineStyle', '--');
            testCase.verifyEqual(dataLine.XData, 1:10);
            testCase.verifyEqual(dataLine.YData, 10*2.^(1:10), 'AbsTol', 1e-9);
            testCase.verifyEqual(fitLine.YData, 10*2.^(1:10), 'RelTol', 0.01);
        end
    end
end

function writeTumorData(folder, subfolder, data)
% Write DATA (2 x N: days; sizes) as ASCII to FOLDER/SUBFOLDER/tumor_data.txt.
d = fullfile(folder, subfolder);
if ~isfolder(d), mkdir(d); end
save(fullfile(d, 'tumor_data.txt'), 'data', '-ascii', '-double');
end

function [out, t] = runQuietly(fh)
% Call FH, returning its first output T and the text it printed in OUT.
t = [];
out = evalc('t = fh();');
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

function titles = axesTitles(ax)
% The title of each axes in AX, as a string array.
titles = strings(size(ax));
for k = 1:numel(ax)
    titles(k) = string(ax(k).Title.String);
end
end
