function h = plot_lme(lme, tbl, condition_name, y_name, subject_name, varargin)
% PLOT_LME - Plot data, fixed-effect means, and per-subject random effects
%
%   H = dasw.stats.plot_lme(LME, TBL, CONDITION_NAME, Y_NAME, SUBJECT_NAME)
%
%  Plot (in the current axes) the data behind a fitted LinearMixedModel LME.
%  This is a teaching-focused simplification of vlt.stats.plot_lme_category.
%
%  The plot has three layers:
%    - Individual observations of TBL.(Y_NAME) are drawn as circles, one
%      column per level of TBL.(CONDITION_NAME). A small amount of random
%      horizontal noise is added so points at similar values do not overlap.
%    - A thick horizontal bar in each column shows the fixed-effect
%      (population) mean of that condition, obtained from LME with all
%      random effects set to zero.
%    - A thin horizontal bar per subject in each column shows that
%      subject's predicted mean under the condition (fixed-effect mean
%      plus that subject's random intercept). Because the random effect
%      is shared across a subject's columns, the thin bars make the
%      subject-to-subject baseline differences visible at a glance.
%
%  H is a vector of the graphics handles produced.
%
%  Optional name/value arguments:
%    'jitter'       (0.15)     horizontal width of the point jitter
%    'thick_width'  (3)        linewidth of the fixed-effect mean bars
%    'thin_width'   (1)        linewidth of the per-subject bars
%    'thick_color'  ([0 0 0])  color of the fixed-effect mean bars
%    'thin_color'   ([])       color of the per-subject bars; default is
%                              one color per subject (from lines())
%    'point_size'   (5)        marker size for the data points
%
%  Example (from Lab 2.6):
%     lme = fitlme(tbl,'y ~ 1 + drug + (1|subject)');
%     figure;
%     dasw.stats.plot_lme(lme, tbl, 'drug','y','subject');
%     xlabel('drug'); ylabel('y'); box off;

jitter       = 0.15;
thick_width  = 3;
thin_width   = 1;
thick_color  = [0 0 0];
thin_color   = [];
point_size   = 5;

for i = 1:2:numel(varargin),
    switch lower(varargin{i}),
        case 'jitter',      jitter      = varargin{i+1};
        case 'thick_width', thick_width = varargin{i+1};
        case 'thin_width',  thin_width  = varargin{i+1};
        case 'thick_color', thick_color = varargin{i+1};
        case 'thin_color',  thin_color  = varargin{i+1};
        case 'point_size',  point_size  = varargin{i+1};
        otherwise, error(['Unknown option: ' varargin{i}]);
    end;
end;

cond_column = tbl.(condition_name);
subj_column = tbl.(subject_name);

cond_values = unique(cond_column);
subj_values = unique(subj_column);

n_cond = numel(cond_values);
n_subj = numel(subj_values);

if isempty(thin_color),
    subj_colors = lines(n_subj);
else
    subj_colors = repmat(thin_color, n_subj, 1);
end;

h = [];
was_held = ishold;
hold on;

% --- Layer 1: individual data points, jittered horizontally ---
for ci = 1:n_cond,
    cv = cond_values(ci);
    for si = 1:n_subj,
        sv = subj_values(si);
        mask = (cond_column == cv) & (subj_column == sv);
        yi = tbl.(y_name)(mask);
        if isempty(yi), continue; end;
        xj = ci + jitter*(rand(size(yi)) - 0.5);
        h(end+1) = plot(xj, yi, 'o', ...
            'MarkerSize', point_size, ...
            'MarkerFaceColor', subj_colors(si,:), ...
            'MarkerEdgeColor', subj_colors(si,:));
    end;
end;

% --- Layer 2: per-subject thin bars (fixed mean + subject random effect) ---
% Build a template row from tbl(1,:) and vary only the columns we control,
% so predict() sees the same variable types it was fit on.
template = tbl(1,:);
for si = 1:n_subj,
    per_subj_tbl = repmat(template, n_cond, 1);
    for ci = 1:n_cond,
        per_subj_tbl.(condition_name)(ci) = cond_values(ci);
        per_subj_tbl.(subject_name)(ci)   = subj_values(si);
    end;
    subj_pred = predict(lme, per_subj_tbl);   % includes random effects
    for ci = 1:n_cond,
        h(end+1) = plot(ci + [-0.25 0.25], subj_pred(ci)*[1 1], '-', ...
            'Color', subj_colors(si,:), 'LineWidth', thin_width);
    end;
end;

% --- Layer 3: thick bars at the fixed-effect means ---
fixed_tbl = repmat(template, n_cond, 1);
for ci = 1:n_cond,
    fixed_tbl.(condition_name)(ci) = cond_values(ci);
end;
fixed_pred = predict(lme, fixed_tbl, 'Conditional', false);
for ci = 1:n_cond,
    h(end+1) = plot(ci + [-0.35 0.35], fixed_pred(ci)*[1 1], '-', ...
        'Color', thick_color, 'LineWidth', thick_width);
end;

set(gca, 'XTick', 1:n_cond, 'XTickLabel', cellstr(string(cond_values)));
xlim([0.5 n_cond+0.5]);

if ~was_held,
    hold off;
end;
