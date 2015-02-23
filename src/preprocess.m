function [ O ] = preprocess( I, varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

if nargin > 2
   error('Too many inputs to the function.'); 
end

MAX_LENGTH = 400;
if nargin == 2
   MAX_LENGTH = varargin{2};
end

if numel(size(I)) == 3
   I = rgb2gray(I); 
end

if numel(size(I)) ~= 2
   error('Invalid image size.');
end

O = histeq(I);
K = fspecial('gaussian');
O = uint8(conv2(double(O),double(K)));

M = max(size(O));
if M > MAX_LENGTH
   scale = MAX_LENGTH/M;
   O = imresize(O, scale);
end

end

