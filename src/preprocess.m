function [ O ] = preprocess( I, varargin )
%PREPROCESS Using the Tan and Triggs proposed preprocessing pipeline '07

%% Parse Inputs
n_static_inputs = 1;
gamma = 0.5;
tau = 10;
a = 0.1;
g_sigma_0 = 1;
g_sigma_1 = 2;
if nargin-n_static_inputs >= 1
   gamma = varargin{1}; 
end
if nargin-n_static_inputs >= 2
   tau = varargin{2}; 
end
if nargin-n_static_inputs >= 3
   a = varargin{3}; 
end
if nargin-n_static_inputs >= 3
   g_sigma_0 = varargin{4}; 
end
if nargin-n_static_inputs >= 3
   g_sigma_1 = varargin{5}; 
end

if numel(size(I)) == 3
   I = rgb2gray(I); 
end

if numel(size(I)) ~= 2
   error('Invalid image size.');
end

O =  I;

%% Gamma COrrection
if gamma > 0
    O = double(O).^gamma;
else
    O = log(O); 
end

%% DoG
g_kernel_0 = fspecial('gaussian', 3, g_sigma_0);
g_kernel_1 = fspecial('gaussian', 3, g_sigma_1);
O = conv2(double(O), double(g_kernel_0)) - conv2(double(O), double(g_kernel_1));

%% Contrast Equalization
N = numel(O);
O_transform_0 = abs(O);
O_transform_1 = max(abs(O).^a, tau);
O = O./(((sum(sum(abs(O_transform_0).^a)))/N)^(1/a));
O = O./(((sum(sum(abs(O_transform_1).^a)))/N)^(1/a));
O_min = min(min(O));
O_max = max(max(O));
O = (O-O_min)/(O_max-O_min);

end