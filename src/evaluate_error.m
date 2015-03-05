function varargout = evaluate_error( T, bt, model, w, varargin )
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
tp = 0;
tn = 0;
fp = 0;
fn = 0;
for i=1:N
    correct = -1;
    measure = sign([1 kernelize_feature(D, T(:,i), svm_kmap)]*w);
    if strcmp(model, 'soft_svm')
       correct = measure*bt(i); 
    end
    if correct > 0
       if bt(i) == 1
          tp = tp + 1; 
       else
          tn = tn + 1;
       end
    else
       if bt(i) == 1
          fp = fp + 1; 
       else
          fn = fn + 1;
       end
    end
end
error_rate = (fp+fn)/N;

if nargout >= 1
    varargout{1} = error_rate;
end
if nargout >= 2
    varargout{2} = [tp, tn, fp, fn];
end

end

