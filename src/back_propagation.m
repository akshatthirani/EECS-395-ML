function [ W ] = back_propagation( X, b, W )
%back_propagation The back propagation algorithm as described in the paper
%... (Hinton et. al, 1989)

L = size(W,1)+1;
n = zeros(L,1);
for i=1:size(W)
    n(i) = size(W{i},1);
end
n(L) = size(W{L-1},2);

alpha = 100e0;
tolerance = 1e-2;
estimation = zeros(size(b));
error = Inf;
b(b == -1) = 0;

%% Matrix BP
% while error > tolerance
%     
%     for i=1:size(X,2)
%         % Compute output layer
%         O = cell(L+1);
%         I = cell(L+1);
%         O{1} = X(:,i);
%         I{1} = X(:,i);
%         for j=2:(L+1)
%             I{j} = W{j-1}'*O{j-1};
%             O{j} = sigmoid(I{j});
%         end
% 
%         delta = cell(size(W));
%         delta{L} = sigmoid_gradient(I{L})*(O{L+1}-b(i));
%         for k=(L-1):-1:1
%            size(I{k})
%            size(delta{k+1}')
%            size(W{k+1}')
%            delta{k} = sigmoid_gradient(I{k}).*delta{k+1}'*W{k+1};
%            % delta{k}
%         end
% 
%         for l=1:L
%            W{l} = W{l} - alpha.*delta{l}'*O{l+1}; 
%         end
%         
%         estimation(i) = O{L+1}(1);
%     end
%     
%     error = 0.5*(norm(estimation-b)^2);
%     
% end

%% Scalar BP
while error > tolerance
    
    for d=1:size(X,2)
        % Compute output layer
        O = cell(L);
        I = cell(L);
        O{1} = X(:,d);
        I{1} = X(:,d);
        
        for j=2:L
            for k=1:n(j)
               I{j}(k) = 0;
               for i=1:n(j-1)
                  I{j}(k) = I{j}(k) + W{j-1}(i,k)*O{j-1}(i);
                  O{j}(k) = sigmoid(I{j}(k));
               end
            end
        end
        
        % Compute initial delta
        delta = cell(L-1,1);
        dEdW = cell(L-1,1);
        delta{L-1} = zeros(n(L-1),n(L));
        dEdW{L-1} = zeros(n(L-1),n(L));
        for k=1:n(L)
           for h=1:n(L-1)
               delta{L-1}(h,k) = (O{L}(k)-b(k))*sigmoid_gradient(I{L}(k));
               dEdW{L-1}(h,k) = delta{L-1}(h,k)*O{L-1}(h);
           end
        end
        
        % Compute remaining deltas
        for j=(L-2):1
           delta{j} = zeros(n(j),n(j+1));
           dEdW{j} = zeros(n(j),n(j+1));
           for k=1:n(j+1)
              for h=1:n(j)
                delta{j}(h,k) = (O{j+1}(k)-b(k))*sigmoid_gradient(I{j+1}(k))*O{j}(h);
                dEdW{j}(h,k) = delta{j}(h,k)*O{j}(h);
              end
           end
        end
        
        % Update the weights
        for j=1:(L-1)
           for k=1:n(j+1)
              for h=1:n(j)
                 W{j}(h,k) = W{j}(h,k) + alpha*dEdW{j}(h,k); 
              end
           end
        end
        
        error = 0.5*(norm(O{L}-b)^2)
        
%         for j=2:(L+1)
%             I{j} = W{j-1}'*O{j-1};
%             O{j} = sigmoid(I{j});
%         end
% 
%         delta = cell(size(W));
%         delta{L} = sigmoid_gradient(I{L})*(O{L+1}-b(d));
%         for k=(L-1):-1:1
%            size(I{k})
%            size(delta{k+1}')
%            size(W{k+1}')
%            delta{k} = sigmoid_gradient(I{k}).*delta{k+1}'*W{k+1};
%            % delta{k}
%         end
% 
%         for l=1:L
%            W{l} = W{l} - alpha.*delta{l}'*O{l+1}; 
%         end

    end
    
end

end

