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
seed = 2.*rand(dim,1);
U = [zeros(dim+1,1) [zeros(1,dim); eye(dim)]];

if nargin-n_static_inputs >= 1
   lambda = varargin{1};
end
if nargin-n_static_inputs >= 2
   kernel = varargin{2};
end

%% Configure Kernel
H = zeros(size(D,2));
if strcmp(kernel, 'rbf')
    H = generate_kernel(D, 'rbf', varargin{3:end});     % RBF Kernel
elseif strcmp(kernel, 'poly')
    H = generate_kernel(D, 'poly', varargin{3:end});    % Polynomial Kernel
else
    % No kernel being used
    kernel = 'null';
end

%% Configure gradient
soft_svm_cost = @(y)(norm(max((ones(N,1)-diag(b)*[ones(1,N); D]'*y),zeros(N,1))) + lambda.*y'*U*y);
soft_svm_gradient = @(y)(-2.*[ones(1,N); D]*diag(b)*max((ones(N,1)-diag(b)*[ones(1,N); D]'*y),zeros(N,1)) + 2.*lambda.*U*y);
if ~strcmp(kernel,'null')
    seed = rand(N,1);
    soft_svm_cost = @(z)(norm(max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1))) + lambda.*z(2:end)'*H*z(2:end));
    soft_svm_gradient = @(z)([ -2.*b'*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)); -2*H*diag(b)*max(ones(N,1)-diag(b)*(H*z(2:end) + z(1).*ones(N,1)),zeros(N,1)) + lambda.*(H+H')*z(2:end) ]);
end

%% Perform Gradient Descent
x0 = [1; seed];
options = optimoptions(@fminunc,'Algorithm','quasi-newton');
soft_svm_cost(x0);
[x,fval,exitflag,output] = fminunc(soft_svm_cost,x0,options);
% x = gradient_descent(x0, soft_svm_gradient, soft_svm_cost, 1e-3, 10000000, 1, true);

disp('Final Error');
disp(soft_svm_cost(x));
end