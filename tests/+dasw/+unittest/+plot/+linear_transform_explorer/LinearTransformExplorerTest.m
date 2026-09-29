classdef LinearTransformExplorerTest < matlab.unittest.TestCase
%LINEARTRANSFORMEXPLORERTEST Unit tests for dasw.plot.linear_transform_explorer.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    properties (Constant)
        UnitTitle = 'The unit circle';
        TransformTitle = 'The linear transformation';
        EigTitle = 'Eigenvectors of the transform (+/-)';
        EigTransformTitle = 'Transformed eigenvectors of the transform (+/-)';
    end

    methods (TestMethodSetup)

        function hideFigures(testCase)
            % The function opens its own figure; keep it off screen.
            old = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@() set(groot, 'DefaultFigureVisible', old));
        end
    end

    methods (Test)

        function testFourPanels(testCase)
            fig = testCase.explore([2 0; 0 0.5], 8);
            ax = findobj(fig, 'Type', 'axes');
            testCase.verifyNumElements(ax, 4);
            titles = sort(arrayfun(@(a) string(a.Title.String), ax));
            testCase.verifyEqual(titles, sort(string({testCase.UnitTitle; ...
                testCase.TransformTitle; testCase.EigTitle; testCase.EigTransformTitle})));
        end

        function testOneVectorPerStep(testCase)
            % Each of STEPS angles gets one vector on the circle and one
            % transformed vector; 2 eigenvectors (+/-) give 4 on each lower panel.
            fig = testCase.explore([2 0; 0 0.5], 12);
            testCase.verifySize(testCase.endpoints(fig, testCase.UnitTitle), [12 2]);
            testCase.verifySize(testCase.endpoints(fig, testCase.TransformTitle), [12 2]);
            testCase.verifySize(testCase.endpoints(fig, testCase.EigTitle), [4 2]);
            testCase.verifySize(testCase.endpoints(fig, testCase.EigTransformTitle), [4 2]);
        end

        function testUnitCircleVectors(testCase)
            % 4 steps sample the unit circle at 0, 90, 180 and 270 degrees.
            fig = testCase.explore([2 0; 0 0.5], 4);
            testCase.verifyEqual(testCase.endpoints(fig, testCase.UnitTitle), ...
                sortrows([1 0; 0 1; -1 0; 0 -1]), 'AbsTol', 1e-12);
        end

        function testTransformedVectors(testCase)
            % Row vectors are transformed as P*LT, so x is scaled by 2 and y by 0.5.
            fig = testCase.explore([2 0; 0 0.5], 4);
            testCase.verifyEqual(testCase.endpoints(fig, testCase.TransformTitle), ...
                sortrows([2 0; 0 0.5; -2 0; 0 -0.5]), 'AbsTol', 1e-12);
        end

        function testGeneralTransform(testCase)
            % Every transformed vector is the matching unit vector times LT.
            LT = [1 0.5; 0.5 2];
            fig = testCase.explore(LT, 16);
            angles = (0:15)' * 2*pi/16;
            expected = sortrows(round([cos(angles) sin(angles)] * LT, 12));
            testCase.verifyEqual(testCase.endpoints(fig, testCase.TransformTitle), ...
                expected, 'AbsTol', 1e-12);
        end

        function testEigenvectors(testCase)
            % A diagonal transform has the axes as eigenvectors, which it
            % stretches by the eigenvalues 2 and 0.5.
            fig = testCase.explore([2 0; 0 0.5], 4);
            % Both signs of each eigenvector are drawn, so the set is sign-free.
            testCase.verifyEqual(testCase.endpoints(fig, testCase.EigTitle), ...
                sortrows([1 0; -1 0; 0 1; 0 -1]), 'AbsTol', 1e-12);
            testCase.verifyEqual(testCase.endpoints(fig, testCase.EigTransformTitle), ...
                sortrows([2 0; -2 0; 0 0.5; 0 -0.5]), 'AbsTol', 1e-12);
        end
    end

    methods (Access = private)

        function fig = explore(testCase, LT, steps)
            dasw.plot.linear_transform_explorer(LT, steps, 0, 0);
            fig = gcf;
            testCase.addTeardown(@() close(fig));
        end

        function pts = endpoints(testCase, fig, titleStr)
            % Tip of every vector drawn on the panel titled TITLESTR, sorted.
            ax = findobj(fig, 'Type', 'axes');
            ax = ax(arrayfun(@(a) strcmp(a.Title.String, titleStr), ax));
            testCase.assertNumElements(ax, 1);
            lines = findobj(ax, 'Type', 'line');
            pts = zeros(numel(lines), 2);
            for k = 1:numel(lines)
                x = lines(k).XData;
                y = lines(k).YData;
                testCase.verifyEqual([x(1) y(1)], [0 0], 'AbsTol', 1e-12);
                pts(k,:) = [x(end) y(end)];
            end
            pts = sortrows(round(pts, 12));
        end
    end
end
