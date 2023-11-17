function [coloured] = color_image(labeled_matrix, set)
    [rows, columns] = size(labeled_matrix);
    coloured = zeros(rows, columns);
    dim = size(set,1);
    for x = 1:rows
        for y = 1:columns
            coloured(x,y) = floor(labeled_matrix(x,y) * 255 / dim);
        end
    end
end
