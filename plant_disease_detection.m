clear;
clc;
[filename, pathname] = uigetfile({'*.jpg';'*.png';'*.jpeg'},'File Selector'); 
% describe path for the test image
Completepath = strcat(pathname, filename); 
% Read image from the drive for testing
figure;
I  = imread(Completepath); 
I = im2double(I); 
newSize = [200, 300];
resizedImage = imresize(I, newSize);
I=resizedImage;

subplot(3,3,1);
imshow(I);
title('Orignal image')
I4 = imadjust(I,stretchlim(I));


subplot(3,3,2);
imshow(I4);
title(' Contrast Enhanced ');
I4 = I;
I5 = (I4);

subplot(3,3,3);
I6=rgb2gray(I);
imshow(I6);
title('Grayscale');

subplot(3,3,4);
imhist(I6);
impixelinfo;
title('histogram');

subplot(3,3,5);
I7 = im2bw(I6,graythresh(I6));
imshow(I7);
title('black and white image');

subplot(3,3,6)
I8=im2double(I7);
I9=1-I8;
imshow(I9);
title('inverted');

hsvImage = rgb2hsv(I4);
% Define color ranges for red and yellow in the HSV color space
redRange = [0, 0.1, 0.5, 1]; % Hue, Saturation, Value
% Create binary masks for red and yellow regions
redMask = (hsvImage(:, :, 1) >= redRange(1) & hsvImage(:, :, 1) <= redRange(2)) ...
    & (hsvImage(:, :, 2) >= redRange(3) & hsvImage(:, :, 2) <= redRange(4));
% Apply masks to the original image
redExtracted = I4;
redExtracted(repmat(~redMask, [1, 1, 3])) = 0;
% Display the extracted red region in images
subplot(3, 3, 7);
imshow(redExtracted);
title('Red Regions');

black = im2bw(redExtracted,graythresh(redExtracted));
subplot(3,3,8);
imshow(black);
title('Black & White Image affected');

m = size(redExtracted,1);
n = size(redExtracted,2);

zero_image = zeros(m,n); 
I_foreground = im2bw(redExtracted,graythresh(redExtracted));
SE = ones(2,2);
I_foreground = imerode(I_foreground,SE)

A1 = sum(sum(I_foreground));

    
I_black = im2bw(I,graythresh(I));
A2 = sum(sum(I_black)); 
if (A1/A2)*100<=0.1
    sprintf('The leaf is healthy')
else
    sprintf('the leaf is unhealthy')
end
sprintf('Area of the disease affected region is : %g%',(A1/A2)*100)
X = ['\color{red} Affected Area : ', num2str((A1/A2)*100)] ;
   
subplot(3,3,9);
imshow(redExtracted.*I_foreground);
title(X);
 


