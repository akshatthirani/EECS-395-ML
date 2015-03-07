function [test_error_distribution, train_error_distribution] = validate( T, bt, D, b, model, w, varargin )
%VALIDATE Take training data D and testing data T and validates the model
% Typical ratios between |D| and |T| are p = 2-10

fprintf('\nComputing Testing Error\n*********************\n');
[testing_error, test_error_distribution] = evaluate_error(T, bt, model, w, D, varargin{:});
fprintf('Computing Testing Error\n*********************\n\n');
[training_error, train_error_distribution] = evaluate_error(D, b, model, w, D, varargin{:});

fprintf('Testing Error Statistics\n*****************\n');
print_error_statistics(generate_error_statistics(test_error_distribution));
fprintf('\nTraining Error Statistics\n*****************\n');
print_error_statistics(generate_error_statistics(train_error_distribution));

end