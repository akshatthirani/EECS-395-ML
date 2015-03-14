function generate_class_data( data_path, feature_extractor, varargin )
%GENERATE_CLASS_DATA Iterate over the data_dir and produce
%the class training and testing data matrices for the feature extraction function
%including negative samples from a preset batch


%% Parse Inputs
n_static_inputs = 2;
method_str = '';
class_str = strsplit(data_path,'/');
class_str = char(class_str(end-1));
if nargin-n_static_inputs >= 1
    method_str = char(strcat('_',varargin{1}));
end

%% Data matrix generation
disp(strcat('Generating training and testing data matrices for: ',data_path));

neg_data_path = '../data/-1/BACKGROUND_Google/';
l_positive = dir(data_path);
l_negative = dir(neg_data_path);

N_p = size(l_positive,1)-2;
N_n = size(l_negative,1)-2;
N = N_p + N_n;

positive_perm = randperm(N_p)+2;
negative_perm = randperm(N_n)+2;

training_ratio = 0.60;
testing_ratio = 1-training_ratio;

training_count = floor(training_ratio*N_p);
testing_count = N_p-training_count;

positve_negative_ratio = 0.5;
training_positive = floor(positve_negative_ratio*training_count);
training_negative = training_count-training_positive;

testing_positive = floor(positve_negative_ratio*testing_count);
testing_negative = testing_count-testing_positive;

b_train = [ones(training_positive,1); -1.*ones(training_negative,1)];
b_test = [ones(testing_positive,1); -1*ones(testing_negative,1)];

k = 0;
D_train = [];
D_test = [];
b_train = [];
b_test = [];

%% Generate Training Data
if training_positive >= 1
    F = feature_extractor(preprocess(imread((strcat(data_path,l_positive(positive_perm(1)).name)))));
    k = size(F, 1);
    assert(size(F,2) == 1);
    D_train = zeros(k,training_count);
    D_train(:,1) = F; 
    b_train(1,1) = 1;
elseif training_negative >= 1
    F = feature_extractor(preprocess(imread((strcat(data_path,l_negative(negative_perm(1)).name)))));
    k = size(F, 1);
    assert(size(F,2) == 1);
    D_train = zeros(k,training_count);
    D_train(:,1) = F; 
    b_train(1,1) = -1;
end
for i=2:training_positive
    D_train(:,i) = feature_extractor(preprocess(imread(strcat(data_path,l_positive(positive_perm(i)).name))));
    b_train(i,1) = 1;
    % i
end
for i=(training_positive+1):(training_positive+training_negative)
    D_train(:,i) = feature_extractor(preprocess(imread(strcat(neg_data_path,l_negative(negative_perm(i-training_positive)).name))));
    b_train(i,1) = -1;
    % i
end

%% Generate Test Data
if testing_positive >= 1
    F = feature_extractor(preprocess(imread((strcat(data_path,l_positive(positive_perm(training_positive+1)).name)))));
    k = size(F, 1);
    assert(size(F,2) == 1);
    D_test = zeros(k,testing_count);
    D_test(:,1) = F; 
    b_test(1,1) = 1;
elseif testing_negative >= 1
    F = feature_extractor(preprocess(imread((strcat(data_path,l_negative(negative_perm(training_negative+1)).name)))));
    k = size(F, 1);
    assert(size(F,2) == 1);
    D_test = zeros(k,testing_count);
    D_test(:,1) = F; 
    b_test(1,1) = -1;
end
for i=2:testing_positive
    D_test(:,i) = feature_extractor(preprocess(imread(strcat(data_path,l_positive(positive_perm(training_positive+i)).name))));
    b_test(i,1) = 1;
    % i
end
for i=(testing_positive+1):(testing_positive+testing_negative)
    D_test(:,i) = feature_extractor(preprocess(imread(strcat(neg_data_path,l_negative(negative_perm(i-testing_positive)).name))));
    b_test(i,1) = -1;
    % i
end

%% Write Out Data
dlmwrite(strcat('store/D_train_', class_str, method_str, '.dat'), D_train);
dlmwrite(strcat('store/b_train_', class_str, method_str, '.dat'), b_train);
dlmwrite(strcat('store/D_test_', class_str, method_str, '.dat'), D_test);
dlmwrite(strcat('store/b_test_', class_str, method_str, '.dat'), b_test);

end

