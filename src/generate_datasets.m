function generate_datasets( varargin )
%GENERATE_DATASET Generate datasets for all the feature extraction
%mechanisms given by the array feature_extractors

%% Parse Inputs
n_static_inputs = 0;
feature_extractors = {@generate_hog_features; @generate_patch_features};
methods = {'hog','patch'};
if nargin-n_static_inputs >= 1
    feature_extractors = varargin{1};
end
base_dir = '../data/1/';
l = dir(base_dir);

for i=3:size(l,1)
    for j=1:size(feature_extractors,1)
        generate_class_data(strcat(base_dir, l(i).name,'/'), feature_extractors{j}, methods{j});
    end
end

end
