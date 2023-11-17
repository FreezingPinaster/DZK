function [outline_img, outline_enlarged] = outline_image(binary_img)
    [x_len,y_len] = size(binary_img);
    outline_img = zeros(64);
    % Row
    for x = 1:x_len
        for y = 2:y_len - 1
            if binary_img(x, y) > binary_img(x, y+1)
                outline_img(x, y) = 1;
            end
            if binary_img(x, y) > binary_img(x, y-1)
                outline_img(x, y-1) = 1;
            end
        end
    end

    % Column
    for x = 2:x_len - 1
        for y = 1:y_len
            if binary_img(x, y) > binary_img(x+1, y)
                outline_img(x, y) = 1;
            end
            if binary_img(x, y) > binary_img(x-1, y)
                outline_img(x-1, y) = 1;
            end
        end
    end
    
    outline_enlarged = imresize(outline_img, 3);
end