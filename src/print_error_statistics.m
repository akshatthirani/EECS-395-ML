function print_error_statistics( error_distribution )
%PRINT_ERROR_STATISTICS Print out some useful statistics based on the
%distribution

N = sum(error_distribution);
p_precision = error_distribution(1)/(error_distribution(1) + error_distribution(3));
p_recall = error_distribution(1)/(error_distribution(1) + error_distribution(4));
n_precision = error_distribution(2)/(error_distribution(2) + error_distribution(3));
n_recall = error_distribution(2)/(error_distribution(2) + error_distribution(4));
accuracy = (error_distribution(1) + error_distribution(2))/N;
error_rate = (error_distribution(3) + error_distribution(4))/N;

fprintf('Total Number of Samples: %d\n', N);
fprintf('Total Error Rate: %f\n', error_rate);
fprintf('Positive Precision: %f\n', p_precision);
fprintf('Positive Recall: %f\n', p_recall);
fprintf('Negative Precision: %f\n', n_precision);
fprintf('Negative Recall: %f\n', n_recall);
fprintf('Accuracy: %f\n', accuracy);

end

