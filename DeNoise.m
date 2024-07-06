% Set the total number of images
N = 1200;

% Loop through each image
for k = 1:N
    % Read the image
    I = imread(sprintf('imagedata/train_%04d.png', k));
    
    % Convert the image to binary using Otsu's thresholding
    Ibinary = im2bw(I, graythresh(I));
    
    % Apply averaging filter to smoothen the binary image
    Ibinaryf = imfilter(Ibinary, fspecial('average', 5), 'replicate');
    
    % Define a disk-shaped structuring element for morphological closing
    se1 = strel('disk', 1);
    
    % Perform morphological closing to fill gaps in the binary image
    IbinaryAfterClosing = imclose(Ibinaryf, se1);
    
    % Write the processed image to the labeledImage directory
    imwrite(IbinaryAfterClosing, sprintf('labeledImage/labeled_train_%04d.png', k));
end
