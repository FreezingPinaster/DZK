function [small_binary_img, binary_img] = binary_image(histogram_num)
    % check if image is in RGB
    s = size(size(histogram_num)); %if s(2)==3, there is a RGB channel dimension
    if s(2) == 3
        histogram_num=rgb2gray(histogram_num);
    end

    level = basic_global_threshold(histogram_num, 0.001);
    
    % use the global threshold to binary the image
    [x_len, y_len] = size(histogram_num);
    binary_matrix = zeros(x_len, y_len);
    for x = 1:x_len
        for y = 1:y_len
            if histogram_num(x,y) > level
                binary_matrix(x,y) = 1;
            else
                binary_matrix(x,y) = 0;
            end
        end
    end
    small_binary_img = mat2gray(binary_matrix);
    binary_img = imresize(small_binary_img, 3);
end