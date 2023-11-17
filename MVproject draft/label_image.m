function [matrix, set,labeled_matrix] = label_image(binary_img, object_value, connectivity)
    % ensure objects are 0 (black) and background is 1 (white)
    if object_value == 1
        binary_img = 1 - binary_img; 
    end

    [x_len, y_len] = size(binary_img);
    matrix = zeros(x_len,y_len);

    counter = 1;
    connect_pairs = [0 0;];
    pair_pointer = 1;
    pad_img = padarray(binary_img, [1 1], 1); %add padding around the image
    [x_len_p, y_len_p] = size(pad_img);

    for x = 2:x_len_p - 1
        for y = 2: y_len_p - 1
            if pad_img(x,y) ~= 1 % if pixel is part of an object
                if connectivity == 4 % left and bottom pixels
                    neighbour_list = [pad_img(x-1,y) pad_img(x,y-1)];
                    neighbour_label_list = [x-1 y; x y-1];
                else
                    neighbour_list = [pad_img(x,y-1) pad_img(x-1,y-1) pad_img(x-1,y) pad_img(x-1,y+1)];
                    neighbour_label_list = [x y-1; x-1 y-1; x-1 y; x-1 y+1];
                end
                sum_neighbour = sum(neighbour_list);
                % if all neihgboring pixels are part of the background
                % label the pixel as a segment = counter and increase counter
                if sum_neighbour == size(neighbour_list,2)
                    matrix(x-1,y-1) = counter;
                    counter = counter + 1;
                else
                    min_counter = counter;
                    max_counter = 0;

                    for i=1:size(neighbour_list,2)
                        if neighbour_label_list(i,1) - 1 > 0 && neighbour_label_list(i,2) - 1 > 0 && neighbour_label_list(i,1) - 1 <=x_len && neighbour_label_list(i,2) - 1 <= y_len
                            if neighbour_list(i) ~= 1 && matrix(neighbour_label_list(i,1)-1,neighbour_label_list(i,2)-1) < min_counter
                                min_counter = matrix(neighbour_label_list(i,1)-1,neighbour_label_list(i,2)-1);
                            end
                            if  matrix(neighbour_label_list(i,1)-1,neighbour_label_list(i,2)-1) > max_counter
                                max_counter = matrix(neighbour_label_list(i,1)-1,neighbour_label_list(i,2)-1);
                            end
                        end
                    end
                    matrix(x-1,y-1) = min_counter;
                    if ~ismember([min_counter max_counter], connect_pairs, 'rows')
                        connect_pairs(pair_pointer, 1) = min_counter;
                        connect_pairs(pair_pointer, 2) = max_counter;
                        pair_pointer = pair_pointer + 1;
                    end
                end
            end
        end
    end

    for x=2:x_len_p - 1
        for y=2:y_len_p - 1
            if connectivity == 4
                if pad_img(x-1, y) == 1 && pad_img(x,y-1) == 1 && pad_img(x+1,y) == 1 && pad_img(x,y+1) == 1 && pad_img(x,y) == 0
                    connect_pairs(end+1, 1) = matrix(x-1, y-1);
                    connect_pairs(end, 2) = matrix(x-1, y-1);
                end
            else
                if (pad_img(x-1,y) == 1 && pad_img(x-1,y-1) == 1 && pad_img(x-1,y+1) == 1 && ...
                        pad_img(x+1, y-1) == 1 && pad_img(x+1, y) == 1 && pad_img(x+1, y+1) == 1 && ...
                        pad_img(x,y-1) == 1 && pad_img(x,y+1) == 1 && pad_img(x,y) == 0)
                    connect_pairs(end+1, 1) = matrix(x-1, y-1);
                    connect_pairs(end, 2) = matrix(x-1, y-1);
                end
            end
        end
    end

    unique_pairs = unique(connect_pairs, 'rows', 'sorted');
    set_row_pointer = 1;
    dim = size(unique_pairs, 1);
    set = [0;0];
    for i = 1:dim
         if sum(sum(ismember(set, unique_pairs(i, 1)))) > 0
             [row, col] = find(set == unique_pairs(i, 1));
         else
             set(set_row_pointer, 1) = unique_pairs(i, 1);
             row = set_row_pointer;
             set_row_pointer = set_row_pointer + 1;
         end

        if ~ismember(set,unique_pairs(i, 2))
            for j = 1:size(set, 2)
                if set(row, j) == 0
                    set(row, j) = unique_pairs(i, 2);
                    break
                end
                if j == size(set, 2)
                    set(row, end + 1) = unique_pairs(i, 2);
                    break
                end
            end
        end
    end

    set = sort(set, 2);
    for i = 1:size(set, 1)
        zero_counter = 0;
        if set(i, 1) == 0
            zero_counter = zero_counter + 1;
            for j = 2:size(set, 2)
                set(i, j-zero_counter) = set(i, j);
                set(i, j) = 0;
            end
        else
            continue
        end
    end
    
    labeled_matrix = zeros(x_len,y_len);
    for x = 1:x_len
        for y = 1:y_len
            if matrix(x,y) ~= 0
                for i = 1:size(set, 1)
                    if ismember(matrix(x, y), set(i,:))
                        labeled_matrix(x,y) = i;
                    end
                end
            end
        end
    end

end
