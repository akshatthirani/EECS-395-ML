function [ activation ] = sigmoid( x, w )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

activation = 1./(1+exp(-w'*x));

end

