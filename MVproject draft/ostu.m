function binary_image = ostu(filepath)
A=imread(filepath);
A=rgb2gray(A);
level = graythresh(A);
BW = imbinarize(A,level);
binary_image=BW;
imshow(binary_image);
end

