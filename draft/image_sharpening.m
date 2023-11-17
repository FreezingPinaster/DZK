function [sharpenedImage] = image_sharpening(originalImage)
    % Convert the image to double for processing
    originalImage = im2double(originalImage);
    
    % Define the amount of sharpening
    amount = 1.2; % You can adjust this value as needed
    
    % Create a blurred version of the original image
    blurryImage = imfilter(originalImage, fspecial('gaussian', 5, 2));
    
    % Create the sharpened image by subtracting the blurry image from the original
    sharpenedImage = originalImage + amount * (originalImage - blurryImage);
    
    % Clip values to ensure they are in the range [0, 1]
    sharpenedImage(sharpenedImage < 0) = 0;
    sharpenedImage(sharpenedImage > 1) = 1;
    
    % Display the original and sharpened images
    %figure;
    %subplot(1, 2, 1);
    %imshow(originalImage);
    %title('Original Image');
    
    %subplot(1, 2, 2);
    %imshow(sharpenedImage);
    %title('Sharpened Image');
    
    % Optionally, save the sharpened image to a file
    % imwrite(sharpenedImage, 'sharpened_image.jpg');
end

