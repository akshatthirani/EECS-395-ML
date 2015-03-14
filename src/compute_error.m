function [ error ] = compute_error( D, b, w, varargin  )
%ERROR Return the error rate, precisions, and recalls

%% Parse Inputs
n_static_inputs = 3;
svm_kmap = [];
H = [];
D_train = [];
if nargin-n_static_inputs >= 3
   H = varargin{1};
   svm_kmap = generate_kmap(varargin{2}, varargin{4:end});
   D_train = varargin{3};
end

%% Evaluate Error
N = size(D,2);
tp = 0;
tn = 0;
fp = 0;
fn = 0;
for i=1:N
    measure = 0;
    if ~isempty(svm_kmap)
        measure = sign([1 kernelize_feature(D_train, D(:,i), svm_kmap)]*w);
    else
        measure = sign([1 D(:,i)']*w);
    end
    correct = measure*b(i); 
    if correct > 0
       if b(i) == 1
          tp = tp + 1; 
       else
          tn = tn + 1;
       end
    else
       if b(i) == 1
          fp = fp + 1; 
       else
          fn = fn + 1;
       end
    end
end
error_rate = (fp+fn)/N;

error.error_rate = error_rate;
error.tp = tp;
error.tn = tn;
error.fp = fp;
error.fn = fn;

end

