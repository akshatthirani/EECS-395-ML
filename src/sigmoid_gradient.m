function [ gradient ] = sigmoid_gradient( x )
%sigmoid_gradient Gradient of the sigmoid activiation function in terms of
%the sigmoid function

gradient = sigmoid(x).*(1-sigmoid(x));

end

