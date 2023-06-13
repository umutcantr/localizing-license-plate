% When plate region and surrounding have high contrast this algorithm
% localize license plate. But sobel threshold value not dynamic. 
% Select "plaka.jpg"(sobel_thres1 = 0.1) and "plaka6.jpg"(sobel_thres1 = 0.25) to see result.

sobel_thres1 = 0.1;

%% Read image
img = imread('plaka.jpg');
subplot(3,3,1);
imshow(img);
title('Original image')


%% Convert rgb to grayscale
gray_img = rgb2gray(img);
subplot(3,3,2);
imshow(gray_img);
title('Gray level')


%% Apply vertical sobel filter with sobel_thres1 value
sobel_img = edge(gray_img, "sobel", "vertical",sobel_thres1);  % Laplacian of gaussian may be better alternative edge detection method.
subplot(3,3,3);
imshow(sobel_img);
title('Sobel applied')

%% Remove unwanted noise 
sobel_img = bwareaopen(sobel_img, 70);
subplot(3,3,4);
imshow(sobel_img);
title('Remove small objects-opening')

%% Dilate image to see results clearly 
se = strel('line',11,90);
sobel_img = imdilate(sobel_img, se);
subplot(3,3,5);
imshow(sobel_img);
title('Dilate image')

%% Find bounding boxes
s = regionprops(sobel_img,'BoundingBox');
centroids = cat(1,s.BoundingBox);
dist = centroids(3,1) - centroids(1,1);   % Assuming there will be 3 bounding box in image and 1. coordinate refers to start of plate region 3. coordinate refers to finish of plate region in x axis

%% Display sobel image that has two sharp vertical edges
subplot(3,3,6);
imshow(sobel_img);
title("Show vertical edges")
hold on
plot(centroids(:,1),centroids(:,2),'b*')
hold off

%% Display cropped image
subplot(3,3,7);
img = imcrop(img, [centroids(1,1), centroids(1,2), dist, dist/4])
imshow(img);
title("Cropped image")

