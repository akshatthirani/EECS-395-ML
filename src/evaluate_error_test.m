function [ output_args ] = evaluate_error_test( test_data_mode, train_data_mode, test_mode, varargin )
%evaluate_error_test Test error evaluation suite

%% Parse Inputs
n_static_inputs = 2;

%% Testing Initialization
base_path = '../../data/';
D = [];
T = [];
bt = [];
if strcmp(test_data_mode, 'generate')
    l_positive = dir(strcat(base_path,'test/1/*'));
    l_negative = dir(strcat(base_path,'test/-1/*'));

    N = size(l_positive,1) + size(l_negative,1) - 4;
    bt = [ones(size(l_positive,1)-2,1); -1.*ones(size(l_negative,1)-2,1)];
    k = 81;
    T = zeros(k,N);
    for i=3:size(l_positive,1)
        T(:,i-2) = generate_hog_features(preprocess(imread(strcat(base_path,'test/1/',l_positive(i).name))));
    end
    
    for i=3:size(l_negative,1)
        T(:,size(l_positive,1)+i-4) = generate_hog_features(preprocess(imread(strcat(base_path,'test/-1/',l_negative(i).name))));
    end
    dlmwrite('T.dat',T);
    dlmwrite('bt.dat',bt);
else
    T = dlmread('T.dat');
    bt = dlmread('bt.dat');
end
S = size(T,2);

if strcmp(train_data_mode, 'generate')
    l_positive = dir(strcat(base_path, 'train/1/*'));
    l_negative = dir(strcat(base_path, 'train/-1/*'));

    N = size(l_positive,1) + size(l_negative,1) - 4;
    k = 81;
    D = zeros(k,N);
    for i=3:size(l_positive,1)
        D(:,i-2) = generate_hog_features(preprocess(imread(strcat(base_path,'train/1/',l_positive(i).name))));
    end

    for i=3:size(l_negative,1)
        D(:,size(l_positive,1)+i-4) = generate_hog_features(preprocess(imread(strcat(base_path,'train/-1/',l_negative(i).name))));
    end
    dlmwrite('D.dat',D);
else
    D = dlmread('D.dat');
end

x = dlmread('x.dat');

%% Run Testing
error_rate = evaluate_error(T, bt, test_mode, x, D, varargin{:});
fprintf('Total Number of Samples: %d\nTesting Error Rate: %f\n', S, error_rate);

end

