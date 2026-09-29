classdef DisplayFourierFrequenciesTest < matlab.unittest.TestCase
%DISPLAYFOURIERFREQUENCIESTEST Unit tests for dasw.signal.display_fourier_frequencies.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (TestMethodSetup)

        function hideAndCloseFigures(testCase)
            % display_fourier_frequencies opens its own figure and pauses
            % between frames, so hide new figures, turn pausing off, and close
            % any figure it creates once the test is done.
            origVisible = get(groot, 'DefaultFigureVisible');
            set(groot, 'DefaultFigureVisible', 'off');
            testCase.addTeardown(@set, groot, 'DefaultFigureVisible', origVisible);
            origPause = pause('query');
            pause('off');
            testCase.addTeardown(@pause, origPause);
            before = findall(groot, 'Type', 'figure');
            testCase.addTeardown(@() closeNewFigures(before));
        end
    end

    methods (Test)

        function testFrequencies(testCase)
            % N samples at rate SR give frequencies SR*(0:N-1)/N.
            t = (0:7)/8;
            fn = dasw.signal.display_fourier_frequencies(t);
            testCase.verifyEqual(fn, 0:7, 'AbsTol', 1e-9);
        end

        function testShowsLastFrequency(testCase)
            t = (0:3)/4;
            dasw.signal.display_fourier_frequencies(t);
            ax = gca;
            testCase.verifyEqual(ax.Title.String, 'Frequency fn, n=4.');
            testCase.verifyEqual(ax.XLabel.String, 'Time(s)');
            line = findobj(ax, 'Type', 'line');
            testCase.verifyEqual(line.YData, sin(2*pi*t*3), 'AbsTol', 1e-12);
        end
    end
end

function closeNewFigures(before)
figs = findall(groot, 'Type', 'figure');
delete(figs(~ismember(figs, before)));
end
