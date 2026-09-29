function osi = orientation_selectivity_index( angles, responses )
% ORIENTATION_SELECTIVITY_INDEX
%   OSI=dasw.neuro.orientation_selectivity_index(ANGLES, RESPONSES)
% Takes ANGLES in degrees
% Returns (R(pref)-R(pref+90))/R(pref)
[mx,ind]=max(responses);
ang=angles(ind); 
ang1 = find(angles==ang+90);
ang2 = find(angles==ang-90);
if isempty(ang1), opposite = ang2;
else, opposite = ang1;
end;
osi = (mx-responses(opposite))/mx;
