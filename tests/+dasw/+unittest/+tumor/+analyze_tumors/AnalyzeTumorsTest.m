classdef AnalyzeTumorsTest < matlab.unittest.TestCase
%ANALYZETUMORSTEST Unit tests for dasw.tumor.analyze_tumors.
%
%   Each test builds a temporary folder of per-animal subfolders holding
%   tumor_data.txt files generated from known a+b*exp(c*x.^d) curves.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        Folder
    end

    methods (TestMethodSetup)

        function setup(testCase)
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
            rng(0, 'twister');
            fixture = testCase.applyFixture( ...
                matlab.unittest.fixtures.TemporaryFolderFixture);
            testCase.Folder = char(fixture.Folder);
        end
    end

    methods (Test)

        function testTableFromTwoAnimals(testCase)
            % mouseA: 200*2^(-x/5) on days 1..30 (halving time 6 from day 1).
            % mouseB: 10*2^x on days 1..10 (doubling time 2 from day 1).
            % A subfolder with no data file and a loose file are ignored.
            x = 1:30;
            writeTumorData(testCase.Folder, 'mouseA', [x; 200*2.^(-x/5)]);
            x = 1:10;
            writeTumorData(testCase.Folder, 'mouseB', [x; 10*2.^x]);
            mkdir(fullfile(testCase.Folder, 'nodata'));
            writelines("not tumor data", fullfile(testCase.Folder, 'notes.txt'));

            folder = testCase.Folder;
            [out, t] = runQuietly(@() dasw.tumor.analyze_tumors(folder, 'drugA'));

            testCase.verifyClass(t, 'table');
            testCase.verifyEqual(t.Properties.VariableNames, ...
                {'Change', 'Rate', 'a', 'b', 'c', 'd', 'Condition', 'File'});
            testCase.verifyEqual(height(t), 2);
            testCase.verifyEqual(t.Condition, ["drugA"; "drugA"]);

            fileA = [folder filesep 'mouseA' filesep 'tumor_data.txt'];
            fileB = [folder filesep 'mouseB' filesep 'tumor_data.txt'];
            testCase.verifyEqual(sort(t.File), sort(string({fileA; fileB})));
            testCase.verifySubstring(out, ['Analyzing file ' fileA '.']);
            testCase.verifySubstring(out, ['Analyzing file ' fileB '.']);

            rowA = t(t.File == fileA, :);
            rowB = t(t.File == fileB, :);
            testCase.verifyEqual(rowA.Change, 100*(2^(-5.8) - 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(rowB.Change, 51100, 'AbsTol', 1e-9);
            testCase.verifyEqual(rowA.Rate, 6, 'RelTol', 0.02);
            testCase.verifyEqual(rowB.Rate, 2, 'RelTol', 0.02);
        end

        function testFitCoefficientsReproduceData(testCase)
            % The a, b, c, d columns describe the fitted curve for each file.
            x = 1:40;
            y = 5 + 100*exp(-0.1*x);
            writeTumorData(testCase.Folder, 'rat1', [x; y]);
            folder = testCase.Folder;
            [~, t] = runQuietly(@() dasw.tumor.analyze_tumors(folder, "control"));
            testCase.verifyEqual(height(t), 1);
            testCase.verifyEqual(t.Condition, "control");
            yfit = t.a + t.b*exp(t.c*x.^t.d);
            testCase.verifyEqual(yfit, y, 'AbsTol', 0.5);
        end

        function testEmptyFolderGivesEmpty(testCase)
            % No subfolders with tumor_data.txt: the result is empty.
            mkdir(fullfile(testCase.Folder, 'nodata'));
            folder = testCase.Folder;
            [out, t] = runQuietly(@() dasw.tumor.analyze_tumors(folder, 'drugA'));
            testCase.verifyEmpty(t);
            testCase.verifyEmpty(strtrim(out));
        end

        function testOnlyOneLevelDeep(testCase)
            % Data files nested two levels down, or directly in the folder,
            % are not analyzed.
            x = 1:10;
            data = [x; 10*2.^x];
            writeTumorData(fullfile(testCase.Folder, 'outer'), 'inner', data);
            writeTumorData(testCase.Folder, '', data);
            folder = testCase.Folder;
            [~, t] = runQuietly(@() dasw.tumor.analyze_tumors(folder, 'drugA'));
            testCase.verifyEmpty(t);
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
