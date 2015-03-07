function [ kmap ] = generate_kmap( mapping, varargin )
%generate_kmap Gives a function handle to the desired kernel mapping

%% Parse Inputs
n_static_inputs = 1;

%% Define Kernel Function
if strcmp(mapping, 'rbf')
    gamma = 1;
    if nargin-n_static_inputs >= 1
       gamma = varargin{1}; 
    end
    kmap = @(x1, x2)(exp(-gamma*norm(x1-x2)));
elseif strcmp(mapping, 'poly')
    n = 2;
    if nargin-n_static_inputs >= 1
       n = varargin{1}; 
    end
    kmap = @(x1, x2)((1+x1'*x2)^n);
else
    error(fprintf('No kernel specified for %s\n',mapping));
end

end

