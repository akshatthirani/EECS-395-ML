function [ x ] = train_soft_svm( D, b, varargin )
%train_soft_svm Soft-margin SVM Classifier with Kernel support

%% Parse Inputs
n_static_inputs = 2;
dim = size(D,1);
N = size(b,1);

lambda = 1;
gamma = 1;
n = 2;
kernel = 'null';
seed = rand(dim,1);
U = [zeros(dim+1,1) [zeros(1,dim); eye(dim)]];

if nargin-n_static_inputs >= 1
   lambda = varargin{1};
end
if nargin-n_static_inputs >= 2
   kernel = varargin{2};
   seed = rand(N,1);
end

%% Configure Kernel
H = zeros(size(D,2));
if strcmp(kernel, 'rbf')
    H = generate_kernel(D, 'rbf', varargin{6:end});     % RBF Kernel
elseif strcmp(kernel, 'poly')
    H = generate_kernel(D, 'poly', varargin{6:end});    % Polynomial Kernel
else
    % No kernel being used
    kernel = 'null';
end

%% Configure gradient
soft_svm_gradient = @(y)(-2.*[ones(1,N); D]*diag(b)*max((ones(N,1)-diag(b)*[ones(N,1); D]'*y),zeros(N,1)) + 2.*lambda.*U*y);
if ~strcmp(kernel,'null')
    soft_svm_gradient = @(z)([ -2.*b'*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)); -2*H*diag(b)*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)) + lambda.*(H+H')*z(2:end) ]);
end

%% Perform Gradient Descent
x = gradient_descent([1; seed], soft_svm_gradient, 1e-5, 1000000, 1, 1);

end