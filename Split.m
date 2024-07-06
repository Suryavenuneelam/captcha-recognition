% This script is used to split numbers from images and generate multiple
% small images in the './SplitLabeledImage' directory.

% Load true labels from 'labels.txt' file
true_labels = importdata('labels.txt');

% Initialize variables
my_labels = zeros(size(true_labels));
N = size(true_labels, 1);
i_p = 0;

% Iterate over each image
for k = 1:N
    % Read the labeled image
    im = imread(sprintf('labeledImage/labeled_train_%04d.png', k));
    [w, h] = size(im);
    
    % Find vertical image peaks
    vertical_sum = sum(im);
    change_point = [];
    start_index = 0;
    for i = 1:h
        % Find the start of a vertical peak
        if vertical_sum(i) == w && i < h && vertical_sum(i+1) < w
            change_point = [change_point, i];
            start_index = i;
        % Find the end of a vertical peak
        elseif vertical_sum(i) < w && i < h && vertical_sum(i+1) == w
            % Check if the peak width is at least 40 pixels
            if i+1 - start_index >= 40
                mid_point = floor((i+1 - start_index) / 2) + start_index;
                change_point = [change_point, mid_point];
                change_point = [change_point, mid_point+1];
                start_index = mid_point+1;
            end
            if i+1 - start_index >= 10
                change_point = [change_point, i+1];
            else
                change_point(size(change_point, 2)) = [];
            end
        end
    end
    
    % Calculate the number of detected digits
    n_number = size(change_point, 2) / 2;
    
    % Skip images with less than 3 digits
    if n_number < 3
        disp("We just recognize no more than 3");
        disp(k);
        continue;
    end
    
    % Find horizontal image peaks
    horizontal_change_point = [];
    for i = 1:n_number
        % Extract the region of interest (ROI)
        j_im = im(:, change_point(2*(i-1)+1):change_point(2*i));
        gap = change_point(2*i) - change_point(2*(i-1)+1) + 1;
        horizontal_sum = sum(j_im, 2);
        points = [];
        for m = 1:w
            % Find horizontal peaks
            if horizontal_sum(m) == gap && m < w && horizontal_sum(m+1) < gap
                points = [points, m];
            elseif horizontal_sum(m) < gap && m < w && horizontal_sum(m+1) == gap
                points = [points, m];
            end
        end
        % Determine the boundaries of the digits
        minp = min(points);
        maxp = max(points);
        points = [minp, maxp];
        horizontal_change_point = [horizontal_change_point, points];
    end
    
    % Iterate over detected digits
    for i = 1:n_number
        true_label = true_labels(k,:,:);
        % Crop and resize each digit
        cropped_image = im(horizontal_change_point(2*(i-1)+1):horizontal_change_point(2*i), ...
                           change_point(2*(i-1)+1):change_point(2*i));
        resized_image = imresize(cropped_image, [50, 35]);
        % Save the cropped and resized digit image
        imwrite(resized_image, sprintf('./SplitLabeledImage/%01d/%01d.tif', true_label(i), i_p));
        % Update image counter
        i_p = i_p + 1;
    end
end
