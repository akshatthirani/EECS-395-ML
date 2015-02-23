function [ x ] = train_soft_svm( x, D, b, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

lambda = 1;
if nargin == 4
   lambda = varargin{4};
elseif nargin > 4
   error('Too many inputs to function.'); 
end

dim = size(x,1);
N = size(b,1);
U = [zeros(dim+1,1) [zeros(1,dim); eye(dim)]];

% Define SVM cost function
soft_svm_cost_gradient = @(y)(-2.*D*diag(b)*max((ones(N,1)-diag(b)*D'*y),zeros(N,1)) + 2.*lambda.*U*y);
x = gradient_descent([1; x], soft_svm_cost_gradient);

end

