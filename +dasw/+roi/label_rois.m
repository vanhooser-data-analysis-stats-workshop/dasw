function rois_new = label_rois(rois, label, varargin)

% LABEL_ROIS - Add a label to the ROIS
%
%  ROIS = dasw.roi.label_rois(ROIS, LABEL1, ... LABELN)
%
%  Inputs: ROIS - an ROI structure as from SPOTDETECTOR
%          LABEL1 - A label to add to the 'label' field
%          LABELN - A label to add to the 'label' field
%
%  OUTPUS: ROIS - The modified ROI structure

rois_new = rois;

for i=1:length(rois_new),
	if isempty(intersect(rois_new(i).labels,label)),
		rois_new(i).labels{end+1} = label;
	end;
end;

if ~isempty(varargin), % add more if provided
	rois_new = dasw.roi.label_rois(rois_new, varargin{1}, varargin{2:end});
end;
