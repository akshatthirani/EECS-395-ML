function [ patch_feature ] = generate_patch_features( image_in, varargin )
%GENERATE_PATCH_FEATURES Vectorizes patch with a given dimension

n_static_inputs = 1;
patch_height = 40;
patch_width = 40;
if nargin-n_static_inputs >= 1
    patch_height = varargin{1};
end
if nargin-n_static_inputs >= 2
    patch_width = varargin{2};
end

patch_feature = extract_patch(image_in, patch_height, patch_width);
patch_feature = patch_feature(:);

end

