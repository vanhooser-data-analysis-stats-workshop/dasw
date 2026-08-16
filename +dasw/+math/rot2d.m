function r = rot2d(theta)
% ROT2D(THETA) 2D rotation matrix
%
% R = dasw.math.rot2d(theta)
%
%  Returns the 2D rotation matrix:
%
%    R  = [cos(theta) -sin(theta) ; sin(theta) cos(theta) ]
%
r = [cos(theta) -sin(theta) ; sin(theta) cos(theta) ];
