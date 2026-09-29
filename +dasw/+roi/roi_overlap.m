function overlaps = roi_overlap(rois, BI)
%ROI_OVERLAP - examines overlap between ROIs and binary image
%
%   OVERLAPS = dasw.roi.roi_overlap(ROIS, BI)
%
%  Inputs:  ROIS - An ROI structure list as returned from SPOTDETECTOR
%             BI - A binary image to examine
%
%  Outputs: ROI_OVERLAP - The fraction of overlapping pixels
%    
overlaps = [];
for i=1:numel(rois),
    numberpositivepixelsinBI = numel(find(BI(rois(i).pixelinds)));
    overlaps(i) = numberpositivepixelsinBI/numel(rois(i).pixelinds);
end;
