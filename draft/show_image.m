function image_count = show_image(images, image_idx, img_type)
    GREY = 0;
    COLOR = 1;
    figure(image_idx);
    
    if img_type == GREY
        imshow(images);
    else
        image(images);
        axis image;
    end
        
    image_count = image_idx + 1;
end

