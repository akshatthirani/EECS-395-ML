function validate( T, bt, D, b, model, w, varargin )
%VALIDATE Take training data D and testing data T and validates the model
% Typical ratios between |D| and |T| are p = 2-10

fprintf('Computing Testing Error\n*********************\n');
[testing_error, tee_stats] = evaluate_error(T, bt, model, w, D, varargin{:});
fprintf('Computing Testing Error\n*********************\n\n');
[training_error, tre_stats] = evaluate_error(D, b, model, w, D, varargin{:});

fprintf('Testing Error Statistics\n*****************\n');
print_error_statistics(tee_stats);
fprintf('\nTraining Error Statistics\n*****************\n');
print_error_statistics(tre_stats);

end