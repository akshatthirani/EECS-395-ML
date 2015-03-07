function [ error_statistics ] = generate_error_statistics( error_distribution )
%GENERATE_ERROR_DISTRIBUTINO Generate useful statistics on true positive
%and false positive rates

N = sum(error_distribution);
p_precision = error_distribution(1)/(error_distribution(1) + error_distribution(3));
p_recall = error_distribution(1)/(error_distribution(1) + error_distribution(4));
n_precision = error_distribution(2)/(error_distribution(2) + error_distribution(3));
n_recall = error_distribution(2)/(error_distribution(2) + error_distribution(4));
accuracy = (error_distribution(1) + error_distribution(2))/N;
error_rate = (error_distribution(3) + error_distribution(4))/N;

error_statistics = [ N, error_rate, p_precision, p_recall, n_precision, n_recall, accuracy ];

end

