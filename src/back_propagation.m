function [ W ] = back_propagation( X, b, W )
%back_propagation The back propagation algorithm as described in the paper
%... (Hinton et. al, 1989)

L = size(W,1);
alpha = 10e0;
tolerance = 1e-2;
estimation = zeros(size(b));
error = Inf;
O = [];
delta = [];
b(b == -1) = 0;
while error > tolerance
    
    for i=1:size(X,2)
        % Compute output layer
        O = cell(L+1);
        I = cell(L+1);
        O{1} = X(:,i);
        I{1} = X(:,i);
        for j=2:(L+1)
            I{j} = W{j-1}'*O{j-1};
            O{j} = sigmoid(I{j});
        end

        delta = cell(size(W));
        delta{L} = sigmoid_gradient(I{L})*(O{L+1}-b(i));
        for k=(L-1):-1:1
           delta{k} = sigmoid_gradient(I{k}).*W{k+1}*delta{k+1};
           % delta{k}
        end

        for l=1:L
           W{l} = W{l} - alpha.*O{l}*delta{l}'; 
        end
        
        estimation(i) = O{L+1}(1);
    end
    
    error = 0.5*(norm(estimation-b)^2)
    % error = 0;
end

O
delta

end

