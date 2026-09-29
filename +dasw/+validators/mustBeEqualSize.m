function mustBeEqualSize(a, b)
%MUSTBEEQUALSIZE Validate that two inputs are the same size.
%
%   dasw.validators.mustBeEqualSize(A, B)
%
%   Throws an error if SIZE(A) and SIZE(B) differ; otherwise returns
%   nothing. MATLAB has no built-in validator that compares two
%   inputs, so this one is written in the style of the built-in
%   mustBe* functions and can be used in an arguments block:
%
%       arguments
%           x (:,1) double
%           y (:,1) double {dasw.validators.mustBeEqualSize(x, y)}
%       end
%
%   Size validation such as (:,1) runs first, so a row vector and a
%   column vector of the same length both become columns and pass.
%
%   INPUTS
%     A, B   Any MATLAB values. Only their sizes are compared.
%
%   ERRORS
%     dasw:validators:mustBeEqualSize   when SIZE(A) ~= SIZE(B).
%
%   EXAMPLE
%     dasw.validators.mustBeEqualSize(zeros(3,1), ones(3,1))  % passes
%     dasw.validators.mustBeEqualSize(zeros(3,1), ones(4,1))  % errors
%
%   See also mustBeFinite, mustBeVector,
%            dasw.demo.validators.mustBeEqualSize.showsWhichPairsPass.

    if ~isequal(size(a), size(b))
        error('dasw:validators:mustBeEqualSize', ...
            'Inputs must be the same size, but one is %s and the other is %s.', ...
            sizeString(a), sizeString(b));
    end

end

function s = sizeString(v)
    s = strjoin(string(size(v)), 'x');
end
