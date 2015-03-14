function initiate_training( varargin )
%INITIATE_TRAINING Read through all available dataset input output pairs
%and produce a corresponding weight vector for the different models that
%we've tried
% training_methods{1} <- training_method
% training_methods{2} <- training_method_str

%% Parse Inputs
n_static_inputs = 0;
training_methods = {@train_soft_svm};
if nargin-n_static_inputs >= 1
    training_methods = varargin{1};
end

dataset_path = 'store/';
dataset_dir = dir(dataset_path);
fileset = 3:size(dataset_dir,1);

for i=3:size(dataset_dir,1)
    s = strsplit(dataset_dir(i).name, '_');
    % Find corresponding D and b matches
    if size(s,2) > 2
        % Check  if D or b
        D = [];
        b = [];
        class_str = '';
        w_str = '';
        found = false;
        if strcmp(s(1),'D') == 1 && strcmp(s(2),'train') == 1
            % Find corresponding b
            D = dlmread(strcat(dataset_path, dataset_dir(i).name));
            class_str = s(3);
            b_name = 'b';
            for j=2:size(s,2)
                b_name = strcat(b_name, '_', s(j));
            end
            for j=1:size(fileset,2)
               if strcmp(dataset_dir(fileset(j)).name, b_name) == 1
                   b = dlmread(char(strcat(dataset_path, b_name)));
                   fileset(j) = [];
                   found = true;
                   break;
               end
            end
        elseif strcmp(s(1),'b') == 1 && strcmp(s(2),'train') == 1
            % Find corresponding D
            b = dlmread(strcat(dataset_path, dataset_dir(i).name));
            class_str = s(3);
            D_name = 'D';
            found = false;
            for j=2:size(s,2)
                D_name = strcat(D_name, '_', s(j));
            end
            for j=1:size(fileset,2)
               if strcmp(dataset_dir(fileset(j)).name, D_name)
                   D = dlmread(strcat(dataset_path, D_name));
                   fileset(j) = [];
                   found = true;
                   break;
               end
            end
        end
        
        n = find(fileset == (i-2));
        if ~isempty(n)
           fileset(n) = []; 
        end
       
        % Call all the training methods and store corresponding results
        if found
            for k=1:size(training_methods,1)
                [w, H] = training_methods{k}{1}(D, b);
                method_str = strcat('_',training_methods{k}{2});
                dlmwrite(char(strcat(dataset_path,'w_',class_str,method_str,'_',s(end))),w);
                dlmwrite(char(strcat(dataset_path,'H_',class_str,method_str,'_',s(end))),H);
            end
            disp('Trained dataset...');
        end
    end
end

end

