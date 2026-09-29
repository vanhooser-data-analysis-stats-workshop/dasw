function [h_lines,h_text] = plot_rois(rois, textsize, color)
% PLOT_ROIS - Plot regions of interest
%
%    [H_LINES, H_TEXT] = dasw.roi.plot_rois(ROIS, TEXTSIZE, COLOR)
%
%  Inputs:
%     ROIS - A structure array of ROIS returned by SPOTDETECTOR
%     TEXTSIZE - The size font that should be used to
%                label the numbers (0 for none)
%     COLOR - The color that should be used, in [R G B] format (0...1)
%
%  Outputs:
%     H_LINES - Handle array of line plots
%     H_TEXT - Handle array of text plots 
%                
h_lines = [];
h_text = [];
hold on; % make sure the plot is held
for i=1:numel(rois),
    h_lines(end+1) = plot(rois(i).xi,rois(i).yi,...
            'linewidth',2,'color',color);
    center_x = mean(rois(i).xi); % get x center
    center_y = mean(rois(i).yi); % get y center
    h_text(end+1) = text(center_x,center_y,int2str(rois(i).index),...
            'horizontalalignment','center','color',color);
end;
