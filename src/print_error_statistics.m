function print_error_statistics( error_statistics )
%PRINT_ERROR_STATISTICS Print out some useful statistics based on the
%distribution

fprintf('Total Number of Samples: %d\n', error_statistics(1));
fprintf('Total Error Rate: %f\n', error_statistics(2));
fprintf('Positive Precision: %f\n', error_statistics(3));
fprintf('Positive Recall: %f\n', error_statistics(4));
fprintf('Negative Precision: %f\n', error_statistics(5));
fprintf('Negative Recall: %f\n', error_statistics(6));
fprintf('Accuracy: %f\n', error_statistics(7));

end

