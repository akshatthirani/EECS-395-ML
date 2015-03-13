function [ x ] = gradient_descent( x, cost_gradient, varargin )
%Gradient Descent minimization function
%   Gradient Descent minimization using max iterations and an alpha-scaled
%   step size.

%% Parse Inputs
n_static_inputs = 2;
cost = [];
debug = 0;
alpha = 1e-3;
max_iterations = 1000000;
tolerance = 1e-3;
if nargin-n_static_inputs >= 1
   cost = varargin{1}; 
end
if nargin-n_static_inputs >= 2
    alpha = varargin{2};
end
if nargin-n_static_inputs >= 3
    max_iterations = varargin{3};
end
if nargin-n_static_inputs >= 4
    tolerance = varargin{4};
end
if nargin-n_static_inputs >= 5
   debug = varargin{5};
end


%% Gradient Descent Loop
iterations = double(0);
gradient = cost_gradient(x);
strides = 500;
alpha_step = 0;
prev_cost = cost(x);
while iterations < max_iterations && sum(abs(gradient) > tolerance) > 0
   if cost(x) > prev_cost 
       alpha = alpha - alpha_step;
   else
       alpha = alpha + alpha_step;
   end
   prev_cost = cost(x);
   x = x - alpha*gradient;
   
   gradient = cost_gradient(x);
   iterations = iterations + 1;
   it_buffer = iterations;
   cost_buffer = cost(x);
   
   if debug
       if mod(iterations, strides) == 0
        disp(strcat(num2str(it_buffer), ': Cost is [', num2str(cost_buffer),']'));
        disp(sum(abs(gradient) > tolerance));
        disp(alpha);
       end
   end
end

end

