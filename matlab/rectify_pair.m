% 3.2.1 Image rectification
% Computes the rectification matrices.

function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and 
% returns left and right rectification matrices (M1, M2) and updated camera parameters.
%
% You can test your function using the provided script ~~q4rectify.m~~ testRectify.m

% 1. Compute the optical center c1 and c2 of each camera
c1 = -inv(K1 * R1) * (K1 * t1);
c2 = -inv(K2 * R2) * (K2 * t2);

% disp(c1);
% disp(size(c1));    % 3, 1 (vertical)
% disp(c2);
% disp(size(c2));    % 3, 1 (vertical)

% 2. Compute the new rotation matrix Rtilde
r1 = abs(c1 - c2) / norm(c1 - c2);    % Euclidean norm

% I think I should also normalize r2 and r3 so that the rotation matrix is orthorgonal.
r21 = cross(R1(3, :), r1);
r21 = r21 / norm(r21);
r31 = cross(r1, r21);
r31 = r31 / norm(r31);
% Rtilde = [r1'; r21; r31];
R1n = [r1'; r21; r31];

r22 = cross(R2(3, :), r1);
r32 = cross(r1, r22);
R2n = [r1'; r22; r32];

% 3. ~~Compute the new intrinsic parameter Ktilde~~ Simply set them to K2
K1n = K2;
K2n = K2;

% 4. Compute the new translations
t1n = -R1n * c1;
t2n = -R2n * c2;

% 5. Compute the rectification matrix
M1 = (K1n * R1n) * inv(K1 * R1);
M2 = (K2n * R2n) * inv(K2 * R2);
