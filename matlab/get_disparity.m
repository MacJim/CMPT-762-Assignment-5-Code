% 3.2.2 Dense window matching to find per pixel density

function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity maxDisp and the window size windowSize.

mask = ones(windowSize, windowSize);

dispM = zeros(size(im1));
minDispM = ones(size(im1)) * inf;

% for y = 1:size(im1, 1)
%     for x = 1:size(im1, 2)
%         distances = zeros(1, maxDisp);
%         for d = 0:maxDisp
%         end
%     end
% end

% Will need to convert them to double.
im1 = double(im1);
im2 = double(im2);

% Use `conv2`.
for d = 0:maxDisp
    translatedIm2 = imtranslate(im2, [d, 0], 'FillValues', 255);
    currentDispM = conv2((im1 - translatedIm2) .^ 2, mask, 'same');
    dispM(currentDispM < minDispM) = d;
    minDispM = min(minDispM, currentDispM);
end

% disp(size(im1));    % 640, 480
% disp(size(im2));    % 640, 480
% disp(size(dispM));    % The same as the size of im1 and im2.
