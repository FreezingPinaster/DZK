clear
close all

% Add paths
addpath(genpath('.\basic_process'));
addpath(genpath('.\thresholding'));
addpath(genpath('.\one_pixel_thinning'));
addpath(genpath('.\outlining'));
addpath(genpath('.\segmentation'));
addpath(genpath('.\rotation'));

% Hyperparameters
filepath = 'chromo.txt';

% init_parameters
img_count = 1;
GREY = 0;
COLOR = 1;

% Q1 Display the original image on screen.
[histogram_num, original, enlarged] = original_image(filepath);
img_count = show_image(enlarged,img_count,GREY);

% Q2 Threshold the image and convert it into binary image.
[binary_img,binary_img_enlarged] = binary_image(histogram_num);
img_count = show_image(binary_img_enlarged,img_count,GREY);

% Q3 Determine an one-pixel thin image of the objects.
[border_img, enlarged_border_img] = zhang_suen_thinning(binary_img, 0);
img_count = show_image(enlarged_border_img,img_count,GREY);

% Q4 Determine the outline(s)
[outline_img, outline_enlarged] = outline_image(binary_img);
img_count = show_image(outline_enlarged,img_count,GREY);

% Q5 Label the different objects
[matrix, set, labeled_matrix] = label_image(binary_img, 0, 4);
[coloured] = color_image(labeled_matrix, set);
img_count = show_image(coloured,img_count,COLOR);

% Q6 Rotate image by 30, 60 and 90 degrees
[rotated_30, rotated_30_enlarged] = rotation(original, 30);
img_count = show_image(rotated_30_enlarged,img_count,GREY);

[rotated_60, rotated_60_enlarged] = rotation(original, 60);
img_count = show_image(rotated_60_enlarged,img_count,GREY);

[rotated_90, rotated_90_enlarged] = rotation(original, 90);
img_count = show_image(rotated_90_enlarged,img_count,GREY);