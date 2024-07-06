function [outputArg] = resizeCrop(inputImage,position)
%RESIZECROP Resize and crop
%   Resize image and crop image

%Crop
position = floor(position);
x_0 = position(1); 
y_0 = position(2);
x_1 = position(1) +position(3); 
y_1 = position(2)+ position(4);
%position: A vector containing the position information [x, y, width, height] of the region to be cropped.
position
%The function extracts a region of interest from the input image based on the provided position.
%The position information specifies the coordinates (x, y) of the top-left corner and the width and height of the region to be cropped.
%The inputImage is cropped accordingly using array indexing.
imCroped = inputImage( y_0:y_1,x_0 : x_1);
% figure;imshow(imCroped);

% Resize
%After cropping, the resulting cropped image is resized to a fixed size of 50x27 pixels.
outputArg = imresize(imCroped,[50,27]);
end

