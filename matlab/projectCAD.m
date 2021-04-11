% 3.3.3 Project a CAD model to the image

close all;

% 1. Load an image, a CAD model cad, 2D points x and 3D points X from PnP.mat.
load('../data/PnP.mat');    % cad, image, x, X

% 2. Run estimate_pose and estimate_params to estimate camera matrix P, intrinsic matrix K, rotation matrix R, and translation t.
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);

% 3. Use your estimated camera matrix P to project the given 3D points X onto the image.
X = [
    X;
    ones(1, size(X, 2));
];
xEstimated = P * X;
xEstimated = xEstimated(1:2, :) ./ xEstimated(3, :);

% 4. Plot the given 2D points x and the projected 3D points on screen. An example is shown at the left below. Hint: use plot.
figure;
imshow(image);

hold on;

% Use different colors from the figure.
% https://www.mathworks.com/help/matlab/ref/linespec.html
plot(x(1, :), x(2, :), 'go', 'LineWidth', 1, 'MarkerSize', 15);    % Green circles.
p = plot(xEstimated(1, :), xEstimated(2, :), 'mo', 'LineWidth', 2, 'MarkerSize', 4, 'MarkerFaceColor', 'm');    % Magenta points.
% Somehow my Matlab has a bug that shows points '.' as squares 's'. I don't have a solution for that so I used circles 'o' instead.

hold off;

% 5. Draw the CAD model rotated by your estimated rotation R on screen. An example is shown at the middle below. Hint: use trimesh.
rotatedCad = cad;
rotatedCad.vertices = cad.vertices * R';

figure;
trimesh(rotatedCad.faces, rotatedCad.vertices(:, 1), rotatedCad.vertices(:, 2), rotatedCad.vertices(:, 3));
% axis equal;
% Matlab is a little funky here and results seem to be different at different window sizes due to axes scaling.

% 6. Project the CAD's all vertices onto the image and draw the projected CAD model overlapping with the 2D image. An example is shown at the right below. Hint: use patch.
vertices = [cad.vertices ones(size(cad.vertices, 1), 1)];
vertices = vertices * P';
vertices = vertices(:, 1:2) ./ vertices(:, 3);

figure;
ax = axes;
imshow(image);

hold on;

patch(ax, 'Faces', rotatedCad.faces, 'Vertices', vertices, 'FaceColor', 'red', 'FaceAlpha', 0.25, 'EdgeColor', 'none');    % Red projected CAD model overlapping on the image.

hold off;
