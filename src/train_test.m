function [ x ] = train_test( data_mode, train_mode, feature_extractor, varargin )
%train_test Test different training functions and allow for data reuse

%% Training Initialization
base_path = '../../data/';
c_t = datestr(datetime('now'));
c_t(12) = '_';
c_t(15) = '_';
c_t(18) = '_';

D = [];
b = [];
if strcmp(data_mode, 'generate')
    l_positive = dir(strcat(base_path, 'train/1/*'));
    l_negative = dir(strcat(base_path, 'train/-1/*'));

    N = size(l_positive,1) + size(l_negative,1) - 4;
    b = [ones(size(l_positive,1)-2,1); -1.*ones(size(l_negative,1)-2,1)];
    k = 0;
    D = [];
    if size(l_positive,1) >= 3
        F = feature_extractor(preprocess(imread((strcat(base_path,'train/1/',l_positive(3).name)))));
        k = size(F, 1);
        assert(size(F,2) == 1);
        D = zeros(k,N);
        D(1,:) = F;
    elseif size(l_negative,1) >= 3
        F = feature_extractor(preprocess(imread((strcat(base_path,'train/1/',l_negative(3).name)))));
        k = size(F, 1);
        assert(size(F,2) == 1);
        D = zeros(k,N);
        D(1,:) = F;
    end
    for i=4:size(l_positive,1)
        D(:,i-2) = feature_extractor(preprocess(imread(strcat(base_path,'train/1/',l_positive(i).name))));
    end

    for i=3:size(l_negative,1)
        D(:,size(l_positive,1)+i-4) = feature_extractor(preprocess(imread(strcat(base_path,'train/-1/',l_negative(i).name))));
    end
    
    dlmwrite(strcat('store/D_', c_t, '.dat'),D);
    dlmwrite(strcat('store/b_', c_t, '.dat'),b);
else
    D = dlmread('store/D.dat');
    b = dlmread('store/b.dat');
end

%% Run Training
x = train(D, b, train_mode, varargin{:});

%% Store Learned Weights
dlmwrite(strcat('store/x_',c_t,'.dat'),x);

end