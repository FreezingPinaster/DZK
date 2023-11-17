function [histogram_num, small_gray_img, gray_img] = original_image(filepath)
    fileID = fopen(filepath,'r');
    Image = fscanf(fileID,'%s',[64 1]);
    % Matrix transpose
    Image = Image';
    x_len = size(Image,1);
    y_len = size(Image,2);
    for x = 1:x_len
        for y = 1:y_len
            asc = abs(Image(x,y));
            if (asc >= 65 && asc <= 86)
                num2img(x,y) = asc - 54;
            else
                num2img(x,y) = asc - 48;
            end
        end
    end
    
    histogram_num = num2img;
    small_gray_img = mat2gray(num2img);
    gray_img = imresize(small_gray_img, 3);
end

