function [one_pixel_img, enlarged_one_pixel_img] = zhang_suen_thinning(binary_img, object_value)
    % Zhang-Suen method
    if object_value == 0
        one_pixel_img = 1 - binary_img; % convert object color to white (1) and background to black (0)
    else
        one_pixel_img = binary_img; % do not need to inverse since the object color is white (1)
    end
    int = 1;
    [row, col] = size(binary_img);
    img_del = ones(row, col);
    while int
        int = 0;
        for i = 2:row-1
            for j = 2:col-1
                p1=one_pixel_img(i,j);
                p2=one_pixel_img(i-1,j);
                p3=one_pixel_img(i-1,j+1);
                p4=one_pixel_img(i,j+1);
                p5=one_pixel_img(i+1,j+1);
                p6=one_pixel_img(i+1,j);
                p7=one_pixel_img(i+1,j-1);
                p8=one_pixel_img(i,j-1);
                p9=one_pixel_img(i-1,j-1);
    
                x = [p1 p2 p3 p4 p5 p6 p7 p8 p9 p2];
                % the three conditions
                if (p1 == 1 && sum(x(2:9)) <= 6 && sum(x(2:9)) >= 2 && ...
                                           p2*p4*p6 == 0 && p4*p6*p8 == 0)
                    A = 0;
                    % to count the number of transitions from 0 to 1
                    for k = 2:size(x, 2)-1
                        if x(k) == 0 && x(k+1) == 1
                            A = A+1;
                        end
                    end
                    if (A == 1)
                        img_del(i, j)=0;
                        int = 1;
                    end
                end
            end
        end
        one_pixel_img = one_pixel_img .* img_del; % the deletion must after all the pixels have been visited
        for i = 2:row-1
            for j = 2:col-1
                p1=one_pixel_img(i,j);
                p2=one_pixel_img(i-1,j);
                p3=one_pixel_img(i-1,j+1);
                p4=one_pixel_img(i,j+1);
                p5=one_pixel_img(i+1,j+1);
                p6=one_pixel_img(i+1,j);
                p7=one_pixel_img(i+1,j-1);
                p8=one_pixel_img(i,j-1);
                p9=one_pixel_img(i-1,j-1);
    
                x = [p1 p2 p3 p4 p5 p6 p7 p8 p9 p2];
    
                if (p1 == 1 && sum(x(2:9)) <= 6 && sum(x(2:9)) >= 2 && ...
                                          p2*p4*p8 == 0 && p2*p6*p8 == 0)
                    A = 0;
                    for k = 2:size(x, 2)-1
                        if x(k) == 0 && x(k+1) == 1
                            A = A+1;
                        end
                    end
                    if (A == 1)
                        img_del(i, j) = 0;
                        int = 1;
                    end
                end
            end
        end
        one_pixel_img = one_pixel_img .* img_del;
    end
    if object_value == 0
        one_pixel_img = 1 - one_pixel_img; % convert back to original color
    end
    one_pixel_img = mat2gray(one_pixel_img);
    enlarged_one_pixel_img = imresize(one_pixel_img, 3); % enlarge the image for display
end
