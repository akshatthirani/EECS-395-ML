% 
% EECS 395: Machine Learning
% 
% Class Project: Computer Vision
% 
% Akshat Thirani
% Tigist Diriba
% 
% 16th Feb
% ____________________________________________________

% Pre-processing

rows = 1024;
cols = 1280;

folder = '/Users/Akshat/Desktop/EECS 395 ML/Project/Matlab Code/Pre-processing/';
i1 = 'sample.jpg';

ji1 = imread([folder i1]);

I = zeros(rows,cols);
I = rgb2gray(ji1);

%% Histogram Eq.

n = 500;
J = zeros(rows,cols);
J = histeq(I,n);

% imshow(J)

% Note:

% J = histeq(I,n) transforms the intensity image I, returning in J an 
% intensity image with n discrete gray levels. A roughly equal number 
% of pixels is mapped to each of the n levels in J, so that the histogram 
% of J is approximately flat. (The histogram of J is flatter when n is 
% much smaller than the number of discrete levels in I.) The default 
% value for n is 64.

%% Gaussian Low-Pass Filter

h = zeros(rows,cols);
hsize = 10;
sigma = 4;

h = fspecial('gaussian', hsize, sigma)








