% Gamma tuning for RBF Soft-margin SVM

start_val = -5;
range = 10;
gamma_range = start_val:(start_val+range);

T = dlmread('T.dat');
D = dlmread('D.dat');
bt = dlmread('bt.dat');
b = dlmread('b.dat');

S = size(gamma_range,1);
testing_statistics = zeros(S, 7);
training_statistics = zeros(S, 7);
weights = [];

for i=1:range
    gamma = 10.^i;
    w = train(D, b, 'soft_svm', 1, 'rbf', gamma);
    weights = [weights; w];
    [test_error_d, train_error_d] = validate(T, bt, D, b, 'soft_svm', w, 'rbf', gamma);
    testing_statistics(i,:) = generate_error_statistics(test_error_d);
    training_statistics(i,:) = generate_error_statistics(train_error_d);
end

dlmwrite('gamma_weights.dat', weights);
dlmwrite('gamma_range.dat', 10.^gamma_range);
dlmwrite('gamma_test_stats.dat', testing_statistics);
dlmwrite('gamma_train_stats.dat', training_statistics);