% 3.3.1 Estimate camera matrix P
% This script was originally in the `ec` dir.

function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

% disp(size(x));    % 2, 10
% disp(x);    % double, ~100
% disp(size(X));    % 3, 10
% disp(X);    % double, -2 ~ 2, some values are negative

A = zeros(2 * size(x, 2), 12);

for i = 1:size(x, 2)
    xi = x(1, i);
    yi = x(2, i);
    Xi = X(1, i);
    Yi = X(2, i);
    Zi = X(3, i);

    A(2 * i - 1, :) = [-Xi, -Yi, -Zi, -1, 0, 0, 0, 0, xi * Xi, xi * Yi, xi * Zi, xi];
    A(2 * i, :) = [0, 0, 0, 0, -Xi, -Yi, -Zi, -1, yi * Xi, yi * Yi, yi * Zi, yi];
end

[~, ~, V] = svd(A);
% disp(size(V));    % 12, 12

P = reshape(V(:, end), [4 3]);
P = P';
