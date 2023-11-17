function sub_image = cut_textline_image(filepath)
    A=imread(filepath);
    sub_image = A(100:150, :, :);
end

