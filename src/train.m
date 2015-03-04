function [ x ] = train( D, b, method, varargin )
%train Used to initialize training under various techniques

%% Perform Training
if strcmp(method, 'soft_svm')
   x = train_soft_svm(D, b, varargin{:});
else
   error('Invalid training method.'); 
end

end