function [ x ] = train( x, D, b, method, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if strcmp(method, 'soft_svm')
   x = train_soft_svm(x, D, b);
else
   error('Invalid training method.'); 
end

end

