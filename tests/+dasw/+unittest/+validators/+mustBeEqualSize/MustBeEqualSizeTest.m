classdef MustBeEqualSizeTest < matlab.unittest.TestCase
%MUSTBEEQUALSIZETEST Unit tests for dasw.validators.mustBeEqualSize.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testSameSizePasses(testCase)
            testCase.verifyWarningFree( ...
                @() dasw.validators.mustBeEqualSize(zeros(3,1), ones(3,1)));
            testCase.verifyWarningFree( ...
                @() dasw.validators.mustBeEqualSize(zeros(2,4), true(2,4)));
            testCase.verifyWarningFree( ...
                @() dasw.validators.mustBeEqualSize([], []));
        end

        function testDifferentLengthsFail(testCase)
            testCase.verifyError( ...
                @() dasw.validators.mustBeEqualSize(zeros(3,1), ones(4,1)), ...
                'dasw:validators:mustBeEqualSize');
        end

        function testRowVersusColumnFails(testCase)
            % Same number of elements, different shape: not equal size.
            testCase.verifyError( ...
                @() dasw.validators.mustBeEqualSize(zeros(1,3), ones(3,1)), ...
                'dasw:validators:mustBeEqualSize');
        end

        function testWorksInsideArgumentsBlock(testCase)
            % The way it is meant to be used: in an arguments block,
            % after (:,1) has turned both inputs into columns.
            z = addColumns(1:3, [10; 20; 30]);   % row and column, same length
            testCase.verifyEqual(z, [11; 22; 33]);
            testCase.verifyError(@() addColumns(1:3, 1:4), ?MException);
        end

    end
end

function z = addColumns(x, y)
% Tiny function that validates its inputs the way a dasw function would.
    arguments
        x (:,1) double
        y (:,1) double {dasw.validators.mustBeEqualSize(x, y)}
    end
    z = x + y;
end
