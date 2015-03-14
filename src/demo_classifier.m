function demo_classifier( image_in, varargin )
%DEMO_CLASSIFIER Compute HoG and patch feature of input image and generate
%output class ranking

%% Parse Inputs
show = 0;
if nargin-1 >= 1
   show = vararg{1}; 
end

%% Preprocessing
preprocessed = preprocess(image_in);

%% HOG Features
hog_features = generate_hog_features(image_in);
rescaled_hog_features = imresize(hog_features', 10);

%% Scaled Normalized Image Patch Features
patch_features = generate_patch_features(preprocessed);

%% Image Display
if show == 1
    figure('Name','Original Image');
    imshow(image_in);

    figure('Name','Preprocessed Image');
    imshow(preprocessed);

    figure('Name','HOG Feature Vector Scaled 50 Times');
    imshow(rescaled_hog_features);

    figure('Name','40x40 Patch');
    imshow(reshape(patch_features,[40,40]));
end

%% Read Weights
lin_dir = 'weights/lin/cv/';
rbf_dir = 'weights/rbf/cv/';
% poly_dir = 'weights/poly/cv';

%% Weights and Labels
% Linear SVM using HOG and Patch Features
lin_hog_weights = cell(0);
lin_hog_labels = cell(0);
lin_patch_weights = cell(0);
lin_patch_labels = cell(0);

% RBF SVM using HOG and Patch Features
rbf_hog_weights = cell(0);
rbf_hog_labels = cell(0);
rbf_hog_dtrain = cell(0);
rbf_hog_H = cell(0);
rbf_patch_weights = cell(0);
rbf_patch_labels = cell(0);
rbf_patch_dtrain = cell(0);
rbf_patch_H = cell(0);

% % Polynomial SVM using HOG and Patch Features
% poly_hog_weights = cell(0);
% poly_hog_labels = cell(0);
% poly_patch_weights = cell(0);
% poly_patch_labels = cell(0);

% Relative Weight Directories
lin_list = dir(lin_dir);
rbf_list = dir(rbf_dir);
% poly_list = dir(poly_dir);

for i=3:size(lin_list,1)
    s = strsplit(lin_list(i).name,'_');
    feature_type = strsplit(char(s(end)),'.');
    feature_type = feature_type(end-1);
    if strcmp(feature_type, 'hog')
        lin_hog_weights{end+1} = dlmread(char(strcat(lin_dir, lin_list(i).name)));
        lin_hog_labels{end+1} = s(2);
    elseif strcmp(feature_type, 'patch')
        lin_patch_weights{end+1} = dlmread(char(strcat(lin_dir, lin_list(i).name)));
        lin_patch_labels{end+1} = s(2);
    end
end

for i=3:size(rbf_list,1)
    s = strsplit(rbf_list(i).name,'_');
    feature_type = strsplit(char(s(end)),'.');
    feature_type = feature_type(end-1);
    if strcmp(feature_type, 'hog')
        rbf_hog_weights{end+1} = dlmread(char(strcat(rbf_dir, rbf_list(i).name)));
        rbf_hog_labels{end+1} = s(2);
        rbf_hog_dtrain{end+1} = dlmread(char(strcat('store/D_train_',s(2),'_hog.dat')));
        rbf_hog_H{end+1} = dlmread(char(strcat('kernels/rbf/cv/H_',s(2),'_',s(end-1),'_',s(end))));
    elseif strcmp(feature_type, 'patch')
        rbf_patch_weights{end+1} = dlmread(char(strcat(rbf_dir, rbf_list(i).name)));
        rbf_patch_labels{end+1} = s(2);
        rbf_patch_dtrain{end+1} = dlmread(char(strcat('store/D_train_',s(2),'_patch.dat')));
        rbf_patch_H{end+1} = dlmread(char(strcat('kernels/rbf/cv/H_',s(2),'_',s(end-1),'_',s(end))));
    end
end

% No Polynomial
% for i=3:size(poly_list,2)
%     s = strsplit(poly_list(i).name);
%     feature_type = strsplit(s(end),'.');
%     feature_type = s(end);
%     
%     if strcmp(feature_type, 'hog')
%         poly_hog_weights{end+1} = dlmread(strcat(lin_dir, lin_list(i).name));
%         poly_hog_labels{end+1} = s(2);
%     elseif strcmp(feature_type, 'patch')
%         poly_patch_weights{end+1} = dlmread(strcat(lin_dir, lin_list(i).name));
%         poly_patch_labels{end+1} = s(2);
%     end
% end

%% HOG Classification
[lin_hog_rank, lin_hog_scores] = classify(hog_features, lin_hog_weights, lin_hog_labels);
[rbf_hog_rank, rbf_hog_scores] = classify(hog_features, rbf_hog_weights, rbf_hog_labels, rbf_hog_dtrain, rbf_hog_H, 'rbf', 0);
% poly_hog_rank = classify(hog_feautre, poly_hog_weights, poly_hog_labels);

%% Patch Classification
[lin_patch_rank, lin_patch_scores] = classify(patch_features, lin_patch_weights, lin_patch_labels);
[rbf_patch_rank, rbf_patch_scores] = classify(patch_features, rbf_patch_weights, rbf_patch_labels, rbf_patch_dtrain, rbf_patch_H, 'rbf', 0);
% [poly_patch_rank, poly_patch_scores] = classify(patch_feautres, poly_patch_weights, poly_patch_labels);

%% Pretty Printing Ranks
fprintf('*****************************************************\n\n');
fprintf('Linear SVM using HOG Features Rank\n');
for i=1:size(lin_hog_rank,2)
   fprintf('%d: %s (%f)\n',i, char(lin_hog_labels{lin_hog_rank{i}}),double(lin_hog_scores{i}));
end

fprintf('*****************************************************\n\n');
fprintf('RBF SVM using HOG Features Rank\n');
for i=1:size(rbf_hog_rank,2)
   fprintf('%d: %s (%f)\n',i,char(rbf_hog_labels{rbf_hog_rank{i}}),double(rbf_hog_scores{i}));
end

% fprintf('*****************************************************\nn');
% fprintf('Polynomial SVM using HOG Features Rank\n');
% for i=1:size(poly_hog_rank,2)
%    fprintf('%d: %s (%f)\n',i,poly_hog_rank{i},poly_hog_labels{poly_hog_rank{i}});
% end

fprintf('*****************************************************\n\n');
fprintf('Linear SVM using Patch Features Rank\n');
for i=1:size(lin_patch_rank,2)
   fprintf('%d: %s (%f)\n',i,char(lin_patch_labels{lin_patch_rank{i}}),double(lin_patch_scores{i}));
end

fprintf('*****************************************************\n\n');
fprintf('RBF SVM using Patch Features Rank\n');
for i=1:size(rbf_patch_rank,2)
   fprintf('%d: %s (%f)\n',i,char(rbf_patch_labels{rbf_patch_rank{i}}),double(rbf_patch_scores{i}));
end

% fprintf('*****************************************************\n\n');
% fprintf('Polynomial SVM using Patch Features Rank\n');
% for i=1:size(poy_patch_rank,2)
%    fprintf('%d: %s (%f)\n',i,poly_patch_rank{i},poly_patch_labels{poly_patch_rank{i}});
% end

end