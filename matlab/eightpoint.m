% 3.1.1 Implement the eight point algorithm

function F = eightpoint(pts1, pts2, M)

% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates (4th quadrant coordinates was called (u, v) in CMPT 742)
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max(imwidth, imheight): scale parameter

% Q2.1 - TODO:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

% Left point to right line: FP = L
% P: (x, y, 1)^T representing point (x, y)
% L: (a, b, c)^T representing line ax + by + c = 0. Normalize L2 sum to 1 for (a, b).
% 
% Right point to left line:  PF = L
% P: (x, y, 1)
% L: (a, b, c)
%
% See page 106 of CMPT 742 slide "12. 3d reconstruction.pdf".

len = size(pts1, 1);

% disp(pts1);

% Append 1 to each element because the (x, y) -> (u, v) translation requires the third element to be 1.
% See page 106 of CMPT 742 slide "12. 3d reconstruction.pdf".
pts1 = [pts1 ones(len, 1)];
pts2 = [pts2 ones(len, 1)];

% MARK: Scale
T = [
    2 / M, 0, -1;
    0, 2 / M, -1;
    0, 0, 1;
];

% pts1 = (T * pts1')';
pts1 = pts1 * T';
pts2 = pts2 * T';

% MARK: 8-point algorithm
% Page 124 of CMPT 742 slide "12. 3d reconstruction.pdf".
A = zeros(len, 9);
for i = 1:3
    for j = 1:3
        col = ((i - 1) * 3) + j;
        A(:, col) = pts1(:, i, :) .* pts2(:, j, :);
    end
end

[U, D, V] = svd(A);

% Set the smallest singular value to 0 to enforce rank 2.
D(:, end) = 0;
A = U * D * V';

[~, ~, V] = svd(A);
F = V(:, 9);
F = reshape(F, [3, 3]);

% Refine the solution using local minimization.
% Call it before unscaling F.
% This function is provided by the handout.
F = refineF(F, pts1, pts2);

% Note that the fundamental matrix has transformation matrices on both sides (for 2 points).
F = T' * F * T;
