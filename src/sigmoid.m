function [ activation ] = sigmoid( x )
%sigmoid Sigmoid activation function defined by 1/(1+exp(-x)

activation = 1./(1+exp(-x));

end

