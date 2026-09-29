function [rois, L] = spotdetector(BI, connectivity, roiname, firstindex, labels)
% SPOTDETECTOR - identifies spots in a binary image
%
%   [ROIS, L] = dasw.roi.spotdetector(BI, CONNECTIVITY, ROINAME, ...
%               FIRSTINDEX, LABELS)
%
%  Inputs: BI - binary image in which to detect spots
%          CONNECTIVITY - 4 or 8; should pixels only be considered
%               connected if they are immediately adjacent in x and y (4)
%               or should diagonals be considered adjacent (8)?
%          ROINAME - Name for the ROI series...maybe the same as a filename?
%          FIRSTINDEX - Index number to start with for labeling (maybe 0 or 1?)
%          LABELS - Any labels you might want to include (string or cell list)
%
%  Ouputs: ROIS a structure array with the following fields:
%          ROIS(i).name       The name of the roi (same as ROINAME)
%          ROIS(i).index      The index number
%          ROIS(i).xi         The xi coordinates of the contour
%          ROIS(i).yi         The yi coordinates of the contour
%          ROIS(i).pixelinds  Pixel index values (in image BI) of the ROI
%          ROIS(i).labels     Any labels for this ROI
%          ROIS(i).stats      All stats from matlab's regionprops func
%          L - the labeled BW image
%          
[BW, L] = bwboundaries(BI, connectivity);
stats = regionprops(L,'all');
  % create an empty structure and then fill it in
rois=struct('name','','index','','xi','','yi','',...
        'pixelinds','','labels','','stats','');
rois = rois([]); % make an empty structure
for i=1:numel(BW),
    newroi.name = roiname;
    newroi.index = firstindex -1 + i; % first entry will be firstindex
    if numel(BW{i}(:,2))==1, % if contour is a single point, flare it out
        newroi.xi = BW{i}(:,2) + [ -0.5 -0.5 0.5 0.5]';
        newroi.yi = BW{i}(:,1) + [ -0.5 -0.5 0.5 0.5]';
    else,
        newroi.xi = BW{i}(:,2);
        newroi.yi = BW{i}(:,1);
    end;
    newroi.pixelinds = stats(i).PixelIdxList;
    newroi.labels = labels;
    newroi.stats = stats(i); % same stats
    rois(end+1) = newroi;
end;
