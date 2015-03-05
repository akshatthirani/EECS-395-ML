function [ error_rate ] = evaluate_error( T, bt, model, w, varargin )
%evaluate_error Evaluate the error over dataset based on a model

%% Parse Inputs
n_static_inputs = 4;
svm_kmap = [];
if strcmp(model, 'soft_svm')
    if nargin-n_static_inputs >= 1
       D = varargin{1};
    end
    if nargin-n_static_inputs >= 2
       svm_kmap = generate_kmap(varargin{2}); 
    end
end

%% Evaluate Error
N = size(T,2);
total_error = 0;
for i=1:N
    correct = -1;
    if strcmp(model, 'soft_svm')
       correct = sign([1 kernelize_feature(D, T(:,i), svm_kmap)]*w)*bt(i); 
    end
    if correct < 0
       total_error = total_error + 1; 
    end
end
error_rate = total_error/N;

end

