% 3.3.2 Estimate intrinsic/extrinsic parameters

function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

% disp(P);    % Changes with each call.
% disp(size(P));    % 3, 4

% 1. Compute the camera center c by using SVD
[~, ~, V] = svd(P);
c = V(:, end);
% disp(c);
c = c(1:3) ./ c(4);

% 2. Compute the intrinsic K and rotation R by using QR decomposition
% Source: https://math.stackexchange.com/questions/1640695/rq-decomposition
reversePermutation = [
    0, 0, 1;
    0, 1, 0;
    1, 0, 0;
];
reverseP = reversePermutation * P(:, 1:3);
reverseP = reverseP';
[Q, R] = qr(reverseP);

Q = reversePermutation * Q';
R = reversePermutation * R' * reversePermutation;

neg = -any((R < 0) & (abs(R) > 1e-4));
neg(neg == 0) = 1;
% disp(neg);

% K is a right upper triangle matrix.
K = R * diag(neg);

% R is an orthonormal matrix.
R = diag(neg) * Q;
if (abs(det(R) + 1) < 1e-4)
    R = -R;
end

% 3. Compute the translation by t = −Rc
t = -R * c;
