clear
close all

%% Set Parameters

Iorig = imread('lotr.jpg');
Iorig = rgb2gray(Iorig);

% Parameters of the image
[h,w] = size(Iorig);

% Noise
In = imnoise(Iorig,'gaussian',0,0.05);

% Show
figure(1)
clf
subplot(1,2,1)
imshow(Iorig);
title('Original image')
subplot(1,2,2)
imshow(In);
title('Noisy image')
box off

%% Your turn
