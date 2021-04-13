% 3.1.5 Write a test script that uses templeCoords

% A test script using templeCoords.mat
%
% Write your code here
%

% 1. Load the two images and the point correspondences from someCorresp.mat
im1 = imread('../data/im1.png');
im2 = imread('../data/im1.png');

load('../data/someCorresp.mat');

fprintf('The value of M is %d.\n', M);

% 2. Run eightpoint to compute the fundamental matrix F
F = eightpoint(pts1, pts2, M);

% 3. Load the points in image 1 contained in templeCoords.mat and run your epipolarCorrespondences on them to get the corresponding points in image 
load('../data/templeCoords.mat');    % Contains a different set of `pts1`. Don't load this above. Follow the handout.

pts2 = zeros(size(pts1));
for i = 1:size(pts1, 1)
    pts2(i, :) = epipolarCorrespondence(im1, im2, F, pts1(i, :));
end

% 4. Load intrinsics.mat and compute the essential matrix E
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);
disp('F:');
disp(F);
% disp(K1);
% disp(K2);
disp('E:');
disp(E);

% 5. Compute the first camera projection matrix P1 and use camera2.m to compute the four candidates for P2
P1 = K1 * [eye(3), zeros(3, 1)];    % Identity.

% 6. Run your triangulate function using the four sets of camera matrix candidates, the points from templeCoords.mat and their computed correspondences
% 7. Figure out the correct P2 and the corresponding 3D points
P2Candidates = camera2(E);    % Size: (3, 4, 4). So 4 candidates here.
minDistance = 1e10;
minDistance1 = 1e10;
minDistance2 = 1e10;
for i = 1:4
    if det(P2Candidates(1:3, 1:3, i)) ~= 1
        % Size changed.
        P2Candidates(:, :, i) = K2 * P2Candidates(:, :, i);

        pts3dCandidate = triangulate(P1, pts1, P2Candidates(:, :, i), pts2);

        x1 = P1 * (pts3dCandidate');
        x2 = P2Candidates(:, :, i) * (pts3dCandidate');
        x1 = x1 ./ x1(3, :);
        x2 = x2 ./ x2(3, :);
        x1 = x1';
        x2 = x2';

        if sum((pts3dCandidate(:, 3) > 0), 'all') == size(pts3dCandidate, 1)
            distance1 = norm(pts1 - x1(:, 1:2)) / size(pts3dCandidate, 1);
            distance2 = norm(pts2 - x2(:, 1:2)) / size(pts3dCandidate, 1);
            distance = distance1 + distance2;
            if distance < minDistance
                minDistance = distance;
                minDistance1 = distance1;
                minDistance2 = distance2;
                pts3d = pts3dCandidate;
                P2 = P2Candidates(:, :, i);
            end
        end
    end
end

% Print the re-projection errors for `pts1` and `pts2`.
fprintf('Min pts1 error: %f\n', minDistance1);
fprintf('Min pts2 error: %f\n', minDistance2);

% 8. Use matlab's plot3 function to plot these point correspondences on screen. Please type "axis equal" after "plot3" to scale axes to the same unit.
plot3(pts3d(:, 1), pts3d(:, 2), pts3d(:, 3), 'k.');
axis equal;
rotate3d on;

% 9. Save your computed rotation matrix (R1, R2) and translation (t1, t2) to the file ../data/extrinsics.mat. These extrinsic parameters will be used in the next section.
R1 = K1 \ P1(1:3, 1:3);
t1 = K1 \ P1(:, 4);
R2 = K2 \ P2(1:3, 1:3);
t2 = K2 \ P2(:, 4);
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
