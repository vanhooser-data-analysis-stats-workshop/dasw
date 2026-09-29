classdef AssignTest < matlab.unittest.TestCase
%ASSIGNTEST Unit tests for dasw.data.assign.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testNameValuePairs(testCase)
            [a, b] = callAssign('a', 1, 'b', 'x');
            testCase.verifyEqual(a, 1);
            testCase.verifyEqual(b, 'x');
        end

        function testUnlistedDefaultsKept(testCase)
            % Only the named variables change; the others keep their defaults.
            [a, b] = callAssign('b', [1 2 3]);
            testCase.verifyEqual(a, 0);
            testCase.verifyEqual(b, [1 2 3]);
        end

        function testLaterPairWins(testCase)
            % Assignments are made in order, so a repeated name takes the last value.
            a = callAssign('a', 1, 'a', 2);
            testCase.verifyEqual(a, 2);
        end

        function testStructInput(testCase)
            % A single struct is treated as field-name/value pairs.
            s = struct('a', 5, 'b', {{'p', 'q'}});
            [a, b] = callAssign(s);
            testCase.verifyEqual(a, 5);
            testCase.verifyEqual(b, {'p', 'q'});
        end

        function testEmptyStructAssignsNothing(testCase)
            [a, b] = callAssign(struct([]));
            testCase.verifyEqual(a, 0);
            testCase.verifyEqual(b, 0);
        end

        function testCellInput(testCase)
            % A single cell array is treated as the list of pairs.
            [a, b] = callAssign({'a', 3, 'b', 4});
            testCase.verifyEqual(a, 3);
            testCase.verifyEqual(b, 4);
        end

        function testOddArgumentCountIgnoresTrailingName(testCase)
            % A name with no value after it is ignored.
            [a, b] = callAssign('a', 7, 'b');
            testCase.verifyEqual(a, 7);
            testCase.verifyEqual(b, 0);
        end
    end
end

function [a, b] = callAssign(varargin)
% Mimics a function with default options overridden by dasw.data.assign.
a = 0;
b = 0;
dasw.data.assign(varargin{:});
end
