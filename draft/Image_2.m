clear
close all

% Add paths
addpath(genpath('.\basic_process'));
addpath(genpath('.\thresholding'));
addpath(genpath('.\one_pixel_thinning'));
addpath(genpath('.\outlining'));
addpath(genpath('.\segmentation'));
addpath(genpath('.\SVM_classify'));


% Hyperparameters
filepath='hello_world.jpg';

% init_parameters
img_count = 1;
GREY = 0;
COLOR = 1;

% Q1 Display the original image on screen.
original_img=imread(filepath);


% Q2 Create an image which is a sub-image of the original image comprising the middle line – HELLO, WORLD.
sub_img = cut_textline_image(filepath);
sub_img = image_sharpening(sub_img);


% Q3 Create a binary image from Step 2 using thresholding.
[binary_img, large_binary_img] = binary_image(sub_img);


% Q4 determine a one-pixel thin image of characters
[border_img, enlarged_border_img] = zhang_suen_thinning(binary_img, 1);
%[border_img] = zhang_suen_thinning(binary_img, 1);


% Q5 determine outlines of characters of the image
[outline_img, outline_enlarged] = outline_image(binary_img);

% Q5 determine outlines of characters of the image
[outline_img, outline_enlarged] = outline_image(binary_img);


% Q6 segment image to seperate and label the different characters
[matrix, set, labeled_matrix] = label_image(binary_img, 1, 8);
[coloured] = color_image(labeled_matrix, set);


% Q7 recognize different characters
% SVM
% mode=1 to train a new SVM model (cost about 10 minutes, not recommend)
% mode=0 to use a trained SVM model
mode=0;
[accuracy, resultImg] = classify_svm(labeled_matrix, mode);
img_count = show_image(resultImg,img_count,GREY);

