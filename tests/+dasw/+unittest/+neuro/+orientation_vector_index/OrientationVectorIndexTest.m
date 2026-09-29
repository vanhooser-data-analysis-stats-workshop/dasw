classdef OrientationVectorIndexTest < matlab.unittest.TestCase
%ORIENTATIONVECTORINDEXTEST Unit tests for dasw.neuro.orientation_vector_index.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testUntunedIsZero(testCase)
            ovi = dasw.neuro.orientation_vector_index(0:30:330, ones(1,12));
            testCase.verifyEqual(ovi, 0, 'AbsTol', 1e-12);
        end

        function testSingleOrientationIsOne(testCase)
            responses = zeros(1,12);
            responses(4) = 5;
            ovi = dasw.neuro.orientation_vector_index(0:30:330, responses);
            testCase.verifyEqual(ovi, 1, 'AbsTol', 1e-12);
        end

        function testOppositeDirectionsAreSameOrientation(testCase)
            % 0 and 180 deg are the same orientation, so they add, not cancel.
            responses = zeros(1,12);
            responses([1 7]) = 5;
            ovi = dasw.neuro.orientation_vector_index(0:30:330, responses);
            testCase.verifyEqual(ovi, 1, 'AbsTol', 1e-12);
        end

        function testOrthogonalOrientationsCancel(testCase)
            responses = zeros(1,12);
            responses([1 4]) = 5;
            ovi = dasw.neuro.orientation_vector_index(0:30:330, responses);
            testCase.verifyEqual(ovi, 0, 'AbsTol', 1e-12);
        end
    end
end
