function train_all( )
%TRAIN_ALL Soft SVM with using HoG and Patches

% methods = cell(1);
% methods{1} = cell(2);
% methods{1}{1} = @(D,b)(train_soft_svm(D,b,1));
% % methods{1}{1} = @train_lin
% methods{1}{2} = 'lin~svm';

methods = cell(1);
% 
% gammas = -3;
t_count = 1;
% 
% for g=gammas
%     methods{t_count} = cell(2);
%     methods{t_count}{1} = @(D,b)(train_soft_svm(D,b,1,'rbf',(10.^g)));
%     % methods{t_count}{1} = @train_rbf;
%     methods{t_count}{2} = strcat('rbf~svm~g~',num2str(g));
%     t_count = t_count + 1;
% end

p_n=2;
for n=p_n
    methods{t_count} = cell(2);
    methods{t_count}{1} = @(D,b)(train_soft_svm(D,b,1,'poly',n));
    % methods{t_count}{1} = @train_poly;
    methods{t_count}{2} = strcat('poly~svm~p~',num2str(n));
    t_count = t_count + 1;
end

initiate_training(methods);

end