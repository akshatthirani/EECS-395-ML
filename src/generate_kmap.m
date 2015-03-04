function [ kmap ] = generate_kmap( mapping )
%generate_kmap Gives a function handle to the desired kernel mapping

if strcmp(mapping, 'rbf')
    gamma = 1;
    sigma = 1;
    kmap = @(x1, x2)(exp(-gamma*norm(x1-x2))/(2*sigma));
elseif strcmp(mapping, 'poly')
    n = 2;
    kmap = @(x1, x2)((1+x1'*x2)^n);
else
    error(fprintf('No kernel specified for %s',mapping));
end

end
