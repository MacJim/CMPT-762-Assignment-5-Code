% 3.1.2 Visualization

% Load `pts1` and `pts2`.
load('../data/someCorresp.mat');

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');

M = max(size(img1, 1), size(img1, 2));    % The 2 images have the same size.
fprintf('The value of M is %d.\n', M);

F = eightpoint(pts1, pts2, M);

epipolarMatchGUI(img1, img2, F);