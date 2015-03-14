function [rank, scores] = classify(x, weights, labels, varargin)
	
	n_static_inputs = 3;
	svm_kmap = [];
	H = cell(0);
	D = cell(0);
    rank = cell(0);
    scores = cell(0);
    
	assert(size(weights,2) == size(labels,2));
	if nargin-n_static_inputs >= 2
	   D = varargin{1};
	   H = varargin{2};
	   svm_kmap = generate_kmap(varargin{3}, varargin{4:end});
	end
	
	outputs = zeros(size(weights));
	for i=1:size(weights,2)
		if ~isempty(svm_kmap)
		   outputs(i) = [1 kernelize_feature(D{i}, x, svm_kmap)]*weights{i};
		else
		   outputs(i) = [1 x']*weights{i};
		end
    end
	
    s_outputs = sort(outputs,'descend');
	valid = s_outputs(find(s_outputs > 0));
	for i=1:size(valid,2)
		rank{end+1} = find(outputs == valid(i));
        scores{end+1} = outputs(find(outputs == valid(i)));
	end
	
end