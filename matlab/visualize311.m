% 3.1.1 Visualization

% Load `pts1` and `pts2`.
load('../data/someCorresp.mat');

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');

M = max(size(img1, 1), size(img1, 2));    % The 2 images have the same size.

F = eightpoint(pts1, pts2, M);

disp('F:');
disp(F);

displayEpipolarF(img1, img2, F);
