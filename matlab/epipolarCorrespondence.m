% 3.1.2 Find epipolar correspondences

function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1, Nx2: in my tests N = 1
%   Returns:
%       pts2:   coordinates of points in image 2, Nx2
%

minDistance = 1e10;

% I think converting them to grayscale can help the matching process.
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

% disp(pts1);
% disp(size(pts1));    % 1x2

len = size(pts1, 1);
pts1 = [pts1 ones(len, 1)];
pts1 = pts1';

% disp(pts1);    % (x, y, 1)^T in 4th quadrant.
% disp(size(pts1));    % 3x1

% Calculate lines.
l = F * pts1;
l = l / -l(2);    % Simplify calculation of point 2.

% Crop patch 1.
% Note that we need integers for indices.
% And by default the points are float.
pts1 = round(pts1);    % Convert to integer.
patches1 = im1((pts1(2) - 3):(pts1(2) + 3), (pts1(1) - 3):(pts1(1) + 3), :);
% disp(size(patches1));    % 7x7

% Find matching patch 2 on the line.
% Search within a range relative to the original x value (to prevent selecting similar features).
% Note that x can be negative when clicking the edge.
startX = max(0, pts1(1) - 10);
endX = min(size(im1, 2), pts1(1) + 10);

% disp(sprintf('Selecting a similar point from x range (%d, %d)', startX, endX));

pts2 = [pts1(1), l(1) * pts1(1) + l(3)];

for x = startX:endX
    % disp(x);
    pt2 = round([x, l(1) * x + l(3), 1]);
    
    try
        patches2 = im2((pt2(2) - 3):(pt2(2) + 3), (pt2(1) - 3):(pt2(1) + 3));
        distance = sqrt(sum((patches2 - patches1) .^ 2, 'all'));
        if distance < minDistance
            minDistance = distance;
            pts2 = [pt2(1), pt2(2)];
        end
    catch
    end
end
