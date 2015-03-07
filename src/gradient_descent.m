function [ x ] = gradient_descent( x, cost_gradient, varargin )
%Gradient Descent minimization function
%   Gradient Descent minimization using max iterations and an alpha-scaled
%   step size.

%% Parse Inputs
n_static_inputs = 2;
if nargin > 6
    error('Invalid inputs detected.');
end

debug = 0;
alpha = 1e-3;
max_iterations = 1000000;
tolerance = 10^-3;
if nargin-n_static_inputs >= 1
    alpha = varargin{1};
end
if nargin-n_static_inputs >= 2
    max_iterations = varargin{2};
end
if nargin-n_static_inputs >= 3
    tolerance = varargin{3};
end
if nargin-n_static_inputs >= 4
   debug = varargin{4};
end


%% Gradient Descent Loop
iterations = 0;
gradient = cost_gradient(x);
while iterations < max_iterations && sum(abs(gradient) > tolerance) > 0
   x = x - alpha*gradient;
   gradient = cost_gradient(x);
   iterations = iterations + 1;
   if debug
      disp(gradient);
      disp(iterations);
   end
end

end

