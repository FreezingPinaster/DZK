function [small_one_pixel_img,one_pixel_img] = one_pixel_letter(binary_img)
    % Zhang-Suen method without inversing
    small_one_pixel_img = binary_img; % do not need to inverse since the characters are in white (1)
    [x_len_1, y_len_1] = size(small_one_pixel_img);

    small_one_pixel_img = padarray(small_one_pixel_img, [1 1], 0);

    [x_len, y_len] = size(small_one_pixel_img);
    flag = 0;
    while flag ~= 1
        pre_img = small_one_pixel_img;
        % Step 1
        for x = 2:x_len-1
            for y = 2:y_len-1
                kernel = zeros(1,10);
                kernel(1) = small_one_pixel_img(x, y);
                kernel(2) = small_one_pixel_img(x-1, y);
                kernel(3) = small_one_pixel_img(x-1, y+1);
                kernel(4) = small_one_pixel_img(x, y+1);
                kernel(5) = small_one_pixel_img(x+1, y+1);
                kernel(6) = small_one_pixel_img(x+1, y);
                kernel(7) = small_one_pixel_img(x+1, y-1);
                kernel(8) = small_one_pixel_img(x, y-1);
                kernel(9) = small_one_pixel_img(x-1, y-1);
                kernel(10) = kernel(2);
                circle_rise = 0; % to count the transitions from 0 to 1
                circle_count = 0; % to count the number of non-zero neighbor pixels (sum of neighbors)
                for k = 3:10
                    if kernel(k) > kernel(k-1)
                        circle_rise = circle_rise + 1;
                    end
                    circle_count = circle_count + kernel(k);
                end
                if (kernel(1) == 1)&&...
                       (circle_rise == 1)&&...
                       (2 < circle_count)&&(circle_count < 6)&&...
                       (kernel(2) * kernel(4) * kernel(6) == 0)&&...
                       (kernel(4) * kernel(6) * kernel(8) == 0)
                   small_one_pixel_img(x, y) = 0;
                end
            end
        end

        for x = 2:x_len-1
            for y = 2:y_len-1
                kernel = zeros(1,10);
                kernel(1) = small_one_pixel_img(x, y);
                kernel(2) = small_one_pixel_img(x-1, y);
                kernel(3) = small_one_pixel_img(x-1, y+1);
                kernel(4) = small_one_pixel_img(x, y+1);
                kernel(5) = small_one_pixel_img(x+1, y+1);
                kernel(6) = small_one_pixel_img(x+1, y);
                kernel(7) = small_one_pixel_img(x+1, y-1);
                kernel(8) = small_one_pixel_img(x, y-1);
                kernel(9) = small_one_pixel_img(x-1, y-1);
                kernel(10) = kernel(2);
                circle_rise = 0;
                circle_count = 0;
                for k = 3:10
                    if kernel(k) > kernel(k-1)
                        circle_rise = circle_rise + 1;
                    end
                    circle_count = circle_count + kernel(k);
                end
                if (kernel(1) == 1)&&...
                       (circle_rise == 1)&&...
                       (2 < circle_count)&&(circle_count < 6)&&...
                       (kernel(2) * kernel(4) * kernel(8) == 0)&&...
                       (kernel(2) * kernel(6) * kernel(8) == 0)
                   small_one_pixel_img(x, y) = 0;
                end
            end
        end

        flag = isequal(pre_img,small_one_pixel_img);
    end

    % small_one_pixel_img = 1 - small_one_pixel_img;
    r_small_one_pixel_img = zeros(x_len_1,y_len_1);
    
    for x = 2:x_len
        for y = 2: y_len
            r_small_one_pixel_img(x-1,y-1) = small_one_pixel_img(x,y);
        end
    end

    small_one_pixel_img = mat2gray(r_small_one_pixel_img);
    one_pixel_img = imresize(small_one_pixel_img, 3);
end
