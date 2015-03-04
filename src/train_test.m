function train_test( test_mode, train_mode, varargin )
%train_test Test different training functions and allow for data reuse

%% Testing Initialization
D = [];
b = [];
if strcmp(test_mode, 'generate')
    % Comupte HOG Features for all train_test positive and negative examples
    l_positive = dir('../../data/train_test/1/*');
    l_negative = dir('../../data/train_test/-1/*');

    N = size(l_positive,1) + size(l_negative,1) - 4;
    b = [ones(size(l_positive,1)-2,1); -1.*ones(size(l_negative,1)-2,1)];

    k = 81;
    D = zeros(k+1,N);
    for i=3:size(l_positive,1)
        D(:,i-2) = [1; generate_hog_features(preprocess(imread(strcat('train_test/1/',l_positive(i).name))))];
    end

    for i=3:size(l_negative,1)
        D(:,size(l_positive,1)+i-4) = [1, generate_hog_features(preprocess(imread(strcat('train_test/-1/',l_negative(i).name))))'];
    end
    dlmwrite('D.dat',D);
    dlmwrite('b.dat',b);
else
    D = dlmread('D.dat');
    b = dlmread('b.dat');
end

%% Run Training
x = train(D, b, train_mode, varargin{:});

%% Store Learned Weights
dlmwrite('x.dat',x);

end