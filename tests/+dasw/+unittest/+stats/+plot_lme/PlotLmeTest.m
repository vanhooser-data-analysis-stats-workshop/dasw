classdef PlotLmeTest < matlab.unittest.TestCase
%PLOTLMETEST Unit tests for dasw.stats.plot_lme.
%
%   The data are balanced (every subject has the same number of
%   observations in every condition), so for y ~ 1 + drug + (1|subject)
%   the fixed-effect means equal the raw condition means, and the
%   subjects' random intercepts sum to zero.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties
        Ax
        Tbl
        Lme
    end

    methods (TestMethodSetup)

        function setup(testCase)
            oldState = rng;
            testCase.addTeardown(@rng, oldState);
            rng(1, 'twister');

            % 4 subjects x 2 conditions x 3 repeats.
            nSubj = 4; nRep = 3;
            offsets = [-3 -1 1 4];
            subject = strings(0, 1); drug = strings(0, 1); y = zeros(0, 1);
            for s = 1:nSubj
                for cond = ["drug" "placebo"]
                    effect = 2*(cond == "drug");
                    subject(end+1:end+nRep, 1) = "s" + s;
                    drug(end+1:end+nRep, 1) = cond;
                    y(end+1:end+nRep, 1) = 10 + offsets(s) + effect + randn(nRep, 1);
                end
            end
            testCase.Tbl = table(y, categorical(drug), categorical(subject), ...
                'VariableNames', {'y', 'drug', 'subject'});
            testCase.Lme = fitlme(testCase.Tbl, 'y ~ 1 + drug + (1|subject)');

            fig = figure('Visible', 'off');
            testCase.addTeardown(@close, fig);
            testCase.Ax = axes(fig);
        end
    end

    methods (Test)

        function testHandleCount(testCase)
            % 8 subject/condition point groups + 8 subject bars + 2 mean bars.
            h = dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            testCase.verifyNumElements(h, 18);
        end

        function testFixedEffectBarsAreConditionMeans(testCase)
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            thick = findobj(testCase.Ax, 'Type', 'line', 'LineWidth', 3);
            testCase.verifyNumElements(thick, 2);
            [x, order] = sort(arrayfun(@(l) l.XData(1), thick));
            thick = thick(order);
            testCase.verifyEqual(x, [1 - 0.35; 2 - 0.35], 'AbsTol', 1e-12);

            tbl = testCase.Tbl;
            means = [mean(tbl.y(tbl.drug == 'drug')); mean(tbl.y(tbl.drug == 'placebo'))];
            for k = 1:2
                testCase.verifyEqual(thick(k).XData, k + [-0.35 0.35], 'AbsTol', 1e-12);
                testCase.verifyEqual(thick(k).YData, means(k)*[1 1], 'AbsTol', 1e-8);
                testCase.verifyEqual(thick(k).Color, [0 0 0]);
            end
        end

        function testSubjectBars(testCase)
            % Per-subject bars are fixed mean + random intercept: they average
            % to the fixed mean in each condition, and every subject's
            % drug-placebo difference equals the fixed-effect difference.
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            thin = findobj(testCase.Ax, 'Type', 'line', 'LineWidth', 1, 'Marker', 'none');
            testCase.verifyNumElements(thin, 8);

            tbl = testCase.Tbl;
            means = [mean(tbl.y(tbl.drug == 'drug')); mean(tbl.y(tbl.drug == 'placebo'))];
            level = zeros(4, 2);
            colors = zeros(4, 3);
            for c = 1:2
                bars = thin(arrayfun(@(l) abs(l.XData(1) - (c - 0.25)) < 1e-12, thin));
                testCase.verifyNumElements(bars, 4);
                [~, order] = sortrows(vertcat(bars.Color));
                bars = bars(order);
                for s = 1:4
                    testCase.verifyEqual(bars(s).XData, c + [-0.25 0.25], 'AbsTol', 1e-12);
                    level(s, c) = bars(s).YData(1);
                    colors(s, :) = bars(s).Color;
                end
                testCase.verifyEqual(mean(level(:, c)), means(c), 'AbsTol', 1e-8);
            end
            testCase.verifyEqual(level(:, 1) - level(:, 2), ...
                (means(1) - means(2))*ones(4, 1), 'AbsTol', 1e-8);
            % One distinct color per subject by default.
            testCase.verifyEqual(size(unique(colors, 'rows'), 1), 4);
        end

        function testDataPoints(testCase)
            % Every observation is drawn once, within jitter/2 of its column.
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            pts = findobj(testCase.Ax, 'Type', 'line', 'Marker', 'o');
            testCase.verifyNumElements(pts, 8);
            testCase.verifyEqual(sort([pts.YData]'), sort(testCase.Tbl.y));
            for k = 1:numel(pts)
                col = round(mean(pts(k).XData));
                testCase.verifyLessThanOrEqual(abs(pts(k).XData - col), 0.15/2);
            end
        end

        function testZeroJitter(testCase)
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject', ...
                'jitter', 0);
            pts = findobj(testCase.Ax, 'Type', 'line', 'Marker', 'o');
            x = [pts.XData];
            testCase.verifyEqual(sort(unique(x)), [1 2]);
            testCase.verifyEqual(sum(x == 1), 12);
        end

        function testStyleOptions(testCase)
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject', ...
                'thick_width', 5, 'thick_color', [1 0 0], 'thin_width', 2, ...
                'thin_color', [0 0.5 0], 'point_size', 8);
            thick = findobj(testCase.Ax, 'Type', 'line', 'LineWidth', 5);
            testCase.verifyNumElements(thick, 2);
            testCase.verifyEqual(vertcat(thick.Color), repmat([1 0 0], 2, 1));
            thin = findobj(testCase.Ax, 'Type', 'line', 'LineWidth', 2);
            testCase.verifyNumElements(thin, 8);
            testCase.verifyEqual(vertcat(thin.Color), repmat([0 0.5 0], 8, 1));
            pts = findobj(testCase.Ax, 'Type', 'line', 'Marker', 'o');
            testCase.verifyEqual(unique([pts.MarkerSize]), 8);
            testCase.verifyEqual(vertcat(pts.MarkerFaceColor), repmat([0 0.5 0], 8, 1));
        end

        function testAxesTicksAndLimits(testCase)
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            testCase.verifyEqual(testCase.Ax.XTick, [1 2]);
            testCase.verifyEqual(string(testCase.Ax.XTickLabel(:)), ["drug"; "placebo"]);
            testCase.verifyEqual(testCase.Ax.XLim, [0.5 2.5]);
        end

        function testRestoresHoldState(testCase)
            % Hold is released afterwards unless it was already on.
            hold(testCase.Ax, 'off');
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            testCase.verifyFalse(ishold(testCase.Ax));

            cla(testCase.Ax);
            hold(testCase.Ax, 'on');
            dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, 'drug', 'y', 'subject');
            testCase.verifyTrue(ishold(testCase.Ax));
        end

        function testUnknownOptionErrors(testCase)
            testCase.verifyError(@() dasw.stats.plot_lme(testCase.Lme, testCase.Tbl, ...
                'drug', 'y', 'subject', 'colour', [1 0 0]), ?MException);
        end
    end
end
