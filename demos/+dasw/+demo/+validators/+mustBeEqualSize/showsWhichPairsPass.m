function showsWhichPairsPass()
%SHOWSWHICHPAIRSPASS Demo: which pairs of inputs dasw.validators.mustBeEqualSize accepts.
%
%   dasw.demo.validators.mustBeEqualSize.showsWhichPairsPass()
%
%   Opens a figure with four panels. Each panel draws two inputs, A
%   (blue) and B (orange), as grids with one square per element, then
%   calls dasw.validators.mustBeEqualSize(A, B) and reports what
%   happened: PASS if it returned quietly, FAIL plus the error message
%   if it threw an error. It then shows the validator at work inside
%   an arguments block, in the Command Window.
%
%   WHAT YOU SHOULD SEE
%     - Top left, 3x1 and 3x1: PASS. The grids are the same shape.
%     - Top right, 3x1 and 4x1: FAIL. B has an extra square, and the
%       message names both sizes.
%     - Bottom left, 1x3 and 3x1: FAIL, even though both have three
%       elements. "Same size" means same shape, not same count.
%     - Bottom right, 2x4 and 2x4: PASS. It works on matrices, not
%       just vectors.
%     - In the Command Window: a small function that validates its
%       inputs this way ACCEPTS a row X with a column Y of the same
%       length. Its arguments block turns both into columns with
%       (:,1) BEFORE the validator runs, so the validator sees 5x1 and
%       5x1. It REJECTS X and Y of different lengths, before its body
%       ever runs.
%
%   Why validate at all? A function that checks its inputs fails
%   loudly, at the line that made the mistake, with a message that
%   says what was wrong -- instead of returning a plausible but wrong
%   answer, or failing later somewhere confusing.
%
%   See also dasw.validators.mustBeEqualSize.

    %% The four pairs to check: {title, A, B}
    cases = { ...
        'Same shape',               zeros(3,1), zeros(3,1); ...
        'Different lengths',        zeros(3,1), zeros(4,1); ...
        'Same count, different shape', zeros(1,3), zeros(3,1); ...
        'Matrices, same shape',     zeros(2,4), zeros(2,4)};

    blue   = [0.25 0.45 0.80];
    orange = [0.90 0.55 0.15];
    green  = [0.10 0.55 0.25];
    red    = [0.80 0.15 0.15];

    figure('Name', 'dasw.validators.mustBeEqualSize: which pairs pass?');
    tiledlayout(2, 2, 'TileSpacing', 'compact');

    %% For each pair: draw A and B, call the validator, report
    for k = 1:size(cases, 1)
        [name, A, B] = cases{k, :};

        try
            dasw.validators.mustBeEqualSize(A, B);
            passed  = true;
            message = 'Returned quietly: the inputs are accepted.';
        catch err
            passed  = false;
            message = err.message;
        end

        ax = nexttile;
        hold(ax, 'on');
        drawGrid(ax, size(A), 0, blue);  % A starts at x = 0
        xB = size(A, 2) + 2;             % leave a gap between A and B
        drawGrid(ax, size(B), xB, orange);
        text(ax, size(A,2)/2, -0.5, sprintf('A: %s', sizeStr(A)), ...
            'HorizontalAlignment', 'center', 'Color', blue, 'FontWeight', 'bold');
        text(ax, xB + size(B,2)/2, -0.5, sprintf('B: %s', sizeStr(B)), ...
            'HorizontalAlignment', 'center', 'Color', orange, 'FontWeight', 'bold');
        text(ax, 0, 5.2, strrep(message, ', but ', sprintf(',\nbut ')), ...
            'VerticalAlignment', 'top', 'FontSize', 9, 'Interpreter', 'none');
        hold(ax, 'off');

        set(ax, 'YDir', 'reverse');
        axis(ax, 'equal', 'off');
        xlim(ax, [-0.5, 10]);
        ylim(ax, [-1.2, 7]);

        if passed
            verdict = 'PASS';  color = green;
        else
            verdict = 'FAIL';  color = red;
        end
        title(ax, {name, verdict}, 'Color', color);
    end

    %% Inside an arguments block: how the validator is meant to be used
    fprintf(['\naddColumns (at the bottom of this file) validates Y with\n' ...
             'dasw.validators.mustBeEqualSize(x, y) in its arguments block.\n\n']);

    z = addColumns(1:5, (10:10:50).');   % a ROW with a COLUMN, same length
    fprintf('  Row X (1x5) with column Y (5x1): ACCEPTED, X + Y = [%s].\n', ...
        num2str(z.'));
    fprintf(['    (the (:,1) size check turns both into 5x1 columns ' ...
             'before the validator runs)\n\n']);

    try
        addColumns((1:10).', (1:9).');
    catch err
        fprintf('  X of length 10 with Y of length 9: REJECTED before the body runs:\n');
        fprintf('    %s\n\n', err.message);
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

function drawGrid(ax, sz, x0, color)
% Draw an array of size SZ as one square per element, left edge at X0.
    for r = 1:sz(1)
        for c = 1:sz(2)
            rectangle(ax, 'Position', [x0 + c - 1, r - 1, 0.9, 0.9], ...
                'FaceColor', color, 'EdgeColor', 'none');
        end
    end
end

function s = sizeStr(v)
    s = strjoin(string(size(v)), 'x');
end
