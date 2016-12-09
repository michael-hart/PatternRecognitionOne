function [ ] = show_face( img_data )
%SHOW_FACE Convert vector to grayscale image and display

img = vec2mat(img_data, 56);
G = mat2gray(img);
imshow(G', 'Border', 'tight', 'InitialMagnification', 500);

end