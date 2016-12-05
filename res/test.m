a = X(:,1);

img = vec2mat(a, 56);
G = mat2gray(img);
imshow(G)
