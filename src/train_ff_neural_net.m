function [ output_args ] = train_ff_neural_net( x, , b, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin > 4
   error('Too many inputs encountered.'); 
end

alpha = 0.01;
if nargin >= 4
    alpha = varargin{4};
end

end

