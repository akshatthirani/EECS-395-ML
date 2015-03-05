function train_test( data_mode, train_mode, varargin )
%train_test Test different training functions and allow for data reuse

%% Training Initialization
base_path = '../../data/';
D = [];
b = [];
if strcmp(data_mode, 'generate')
    l_positive = dir(strcat(base_path, 'train/1/*'));
    l_negative = dir(strcat(base_path, 'train/-1/*'));

    N = size(l_positive,1) + size(l_negative,1) - 4;
    b = [ones(size(l_positive,1)-2,1); -1.*ones(size(l_negative,1)-2,1)];
    k = 81;
    D = zeros(k,N);
    for i=3:size(l_positive,1)
        D(:,i-2) = generate_hog_features(preprocess(imread(strcat(base_path,'train/1/',l_positive(i).name))));
    end

    for i=3:size(l_negative,1)
        D(:,size(l_positive,1)+i-4) = generate_hog_features(preprocess(imread(strcat(base_path,'train/-1/',l_negative(i).name))));
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