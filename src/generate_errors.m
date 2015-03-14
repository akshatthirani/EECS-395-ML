function [test_errors, train_errors] = generate_errors()
    base_name = 'store/';
    dir_files = dir(base_name);

    fileset = {};

    test_errors = [];
    train_errors = [];

    train_error_count = 0;
    test_error_count = 0;
    
    f_parse = cell(0);
    test_train_hash = [];
    
    for i=1:size(dir_files,1)
        s = strsplit(dir_files(i).name,'_');
        if strcmp(s(1),'D')
            fileset{size(fileset,1)+1,1} = dir_files(i);
            f_parse{size(fileset,1),1} = dir_files(i).name;
        end
    end
    
    for i=1:size(fileset,1)
       s = strsplit(f_parse{i},'_');
       if strcmp(s(2),'train') == 1
           found = false;
           c = 'D_test';
           for k=3:size(s,2)
              c = strcat(c,'_',s(k));
           end
           for j=i:size(fileset,1)
               if strcmp(fileset{j}.name, c) == 1
                   test_train_hash(j) = i;
                   found = true;
                   break;
               end
               if found
                  break; 
               end
           end
       elseif strcmp(s(2),'test') == 1
            found = false;
            c = 'D_train';
            for k=3:size(s,2)
               c = strcat(c,'_',s(k));
            end
            for j=i:size(fileset,1)
               if strcmp(fileset{j}.name, c) == 1
                   test_train_hash(i) = j;
                   found = true;
                   break;
               end
               if found
                  break; 
               end
            end
       end
    end
    
    for i=1:size(fileset,1)
        s = strsplit(fileset{i}.name,'_');
        b_name = fileset{i}.name;
        b_name(1) = 'b';
        class_name = s(3);

        lin_svm = 0;
        g_range = 3;
        p_range = [];

        w_base_name = strcat('w_',class_name,'_');

        feature_type = strsplit(char(s(end)),'.');
        feature_type = feature_type(1);

        lin_base_name = 'lin~svm';
        poly_base_name = 'poly~svm~p~';
        rbf_base_name = 'rbf~svm~g~';

        if lin_svm == 1
            D = dlmread(char(strcat(base_name, fileset{i}.name)));
            b = dlmread(char(strcat(base_name, b_name)));
            w = dlmread(char(strcat(base_name, w_base_name, lin_base_name,'_',feature_type,'.dat')));
            error = compute_error(D, b, w); 

            if strcmp(s(2),'train') == 1
               train_error_count = train_error_count + 1; 
               train_errors(train_error_count).error_rate = error.error_rate;
               train_errors(train_error_count).tp = error.tp;
               train_errors(train_error_count).tn = error.tn;
               train_errors(train_error_count).fp = error.fp;
               train_errors(train_error_count).fn = error.fn;
            else
                test_error_count = test_error_count + 1;
                test_errors(test_error_count).error_rate = error.error_rate;
                test_errors(test_error_count).tp = error.tp;
                test_errors(test_error_count).tn = error.tn;
                test_errors(test_error_count).fp = error.fp;
                test_errors(test_error_count).fn = error.fn;
            end
        end

        for k=g_range
            b = dlmread(char(strcat(base_name, b_name)));
            H = dlmread(char(strcat(base_name, 'H_', class_name, '_', rbf_base_name, num2str(k),'_',feature_type,'.dat')));
            w = dlmread(char(strcat(base_name, w_base_name, rbf_base_name, num2str(k),'_',feature_type,'.dat')));
            
            if strcmp(s(2),'train') == 1
               D = dlmread(char(strcat(base_name, fileset{i}.name)));
               error = compute_error(D, b, w, H, 'rbf', D, 10^k);
               train_error_count = train_error_count + 1; 
               train_errors(train_error_count).error_rate = error.error_rate;
               train_errors(train_error_count).tp = error.tp;
               train_errors(train_error_count).tn = error.tn;
               train_errors(train_error_count).fp = error.fp;
               train_errors(train_error_count).fn = error.fn;
            else
               D = dlmread(char(strcat(base_name, fileset{i}.name)));
               D_train = dlmread(char(strcat(base_name, fileset{test_train_hash(i)}.name)));
               error = compute_error(D, b, w, H, 'rbf', D_train, 10^k);
               test_error_count = test_error_count + 1;
               test_errors(test_error_count).error_rate = error.error_rate;
               test_errors(test_error_count).tp = error.tp;
               test_errors(test_error_count).tn = error.tn;
               test_errors(test_error_count).fp = error.fp;
               test_errors(test_error_count).fn = error.fn;
            end
        end

        for k=p_range
            D = dlmread(char(strcat(base_name, fileset{i}.name)));
            b = dlmread(char(strcat(base_name, b_name)));
            H = dmread(char(strcat(base_name, H_name, '_', class_name, '_', poly_base_name, num2str(k),'_',feature_type,'.dat')));
            w = dlmread(char(strcat(base_name, w_base_name, poly_base_name, numstr(k),'_',feature_type,'.dat')));
            error = compute_error(D, b, w, H, 'poly', 10^k);
            
            if strcmp(s(2),'train') == 1
               train_error_count = train_error_count + 1; 
               train_errors(train_error_count).error_rate = error.error_rate;
               train_errors(train_error_count).error_rate = error.tp;
               train_errors(train_error_count).error_rate = error.tn;
               train_errors(train_error_count).error_rate = error.fp;
               train_errors(train_error_count).error_rate = error.fn;
            else
               test_error_count = test_error_count + 1;
               test_errors(test_error_count).error_rate = error.error_rate;
               test_errors(test_error_count).tp = error.tp;
               test_errors(test_error_count).tn = error.tn;
               test_errors(test_error_count).fp = error.fp;
               test_errors(test_error_count).fn = error.fn;
            end
        end
    end
end