function [ x ] = gradient_descent( x, cost_gradient, varargin )
%Gradient Descent minimization function
%   Gradient Descent minimization using max iterations and an alpha-scaled
%   step size.

if nargin > 5
    error('Invalid inputs detected.');
end

alpha = 1e-3;
max_iterations = 1000000;
tolerance = 10^-3;
if nargin >= 3
    alpha = varargin{1};
end
if nargin >= 4
    max_iterations = varargin{2};
end
if nargin >= 5
    tolerance = varargin{3}; 
end

iterations = 0;
gradient = cost_gradient(x);
while iterations < max_iterations && sum(gradient(gradient > tolerance)) > 0
   x = x - alpha*gradient;
   gradient = cost_gradient(x);
   iterations = iterations + 1;
   iterations
   x
end

end

