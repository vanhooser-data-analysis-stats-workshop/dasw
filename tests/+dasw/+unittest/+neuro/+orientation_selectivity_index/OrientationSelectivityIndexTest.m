classdef OrientationSelectivityIndexTest < matlab.unittest.TestCase
%ORIENTATIONSELECTIVITYINDEXTEST Unit tests for dasw.neuro.orientation_selectivity_index.
%
%   Run with:
%     runtests("tests", IncludeSubfolders=true)

    methods (Test)

        function testPreferredPlusNinety(testCase)
            % Peak 10 at 90 deg; response at 180 deg is 2, so OSI = (10-2)/10.
            angles = 0:30:330;
            responses = [2 5 8 10 8 5 2 5 8 9 8 5];
            osi = dasw.neuro.orientation_selectivity_index(angles, responses);
            testCase.verifyEqual(osi, 0.8, 'AbsTol', 1e-12);
        end

        function testPreferredMinusNinety(testCase)
            % Peak at 270 deg: 360 is not sampled, so 180 deg is used instead.
            angles = 0:30:330;
            responses = [2 3 3 3 3 3 4 3 3 10 3 3];
            osi = dasw.neuro.orientation_selectivity_index(angles, responses);
            testCase.verifyEqual(osi, 0.6, 'AbsTol', 1e-12);
        end

        function testUntunedIsZero(testCase)
            osi = dasw.neuro.orientation_selectivity_index(0:45:315, 5*ones(1,8));
            testCase.verifyEqual(osi, 0);
        end
    end
end
