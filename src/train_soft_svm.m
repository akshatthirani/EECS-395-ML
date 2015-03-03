function [ x ] = train_soft_svm( x, D, b, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if nargin > 6
   error('Too many inputs to function.'); 
end

lambda = 1;
sigma = 1;
kernel = [];
dim = size(D,1)-1;
N = size(b,1);
U = [zeros(dim+1,1) [zeros(1,dim); eye(dim)]];
if nargin >= 4
   lambda = varargin{4};
end
if nargin >= 5
   sigma = varargin{5}; 
end
if nargin >= 6
   kernel = varargin{6}; 
end
if isempty(x)
   x = rand(N,1); 
end

%% RBF Kernel Matrix
% H = zeros(N);
% for i=1:N
%    for j=i:N
%       H(i,j) = exp(-(norm(D(2:end,i)-D(2:end,j)).^2)/(2*sigma));
%       H(j,i) = H(i,j);
%    end
% end

%% Polynomial Kernel Matrix
H = zeros(N);
for i=1:N
   for j=i:N
      H(i,j) = (1+D(2:end,i)'*D(2:end,j))^3;
      H(j,i) = H(i,j);
   end
end

% Kernelized RBF Gaussian
% k_soft_svm_gradient = @(z)([ 2.*sum(H*z(2:end) + z(1).*ones(N,1)-b); 2.*max(ones(N,1)-b.*(H*z(2:end)+z(1).*ones(N,1)),zeros(N,1)).*(H*b) + lambda.*(H+H')*z(2:end) ]);
k_soft_svm_gradient = @(z)([ -2.*b'*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)); -2*H*diag(b)*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)) + lambda.*(H+H')*z(2:end) ]);
% k_soft_svm_gradient = @(z)([ 2.*sum(b'*max(zeros(N,1),ones(N,1) - b.*(H*z(2:end) + z(1).*ones(N,1)))); H*(H*z(2:end) + z(1).*ones(N,1) - b) + lambda.*(H+H')*z(2:end) ]);

% Define SVM cost function
soft_svm_cost_gradient = @(y)(-2.*D*diag(b)*max((ones(N,1)-diag(b)*D'*y),zeros(N,1)) + 2.*lambda.*U*y);
x = gradient_descent([1; x], k_soft_svm_gradient);

end