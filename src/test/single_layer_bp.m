function [ W ] = single_layer_bp( X, b )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Construct hidden layer of 3 units
W = cell(2,1);
W{1} = [1 2 3; 4 5 6]; % rand(2,3);   % Make room for a bias term
W{2} = [1; 2; 3; 4]; % rand(4,1);   % Make room for a bias term
N = size(X,2);

for n=1:N
   % Forward Propagation
   I = cell(3,1);
   O = cell(3,1);
   I{1} = [X(:,n); 1];
   O{1} = I{1};
   for l=2:3
        I{l} = W{l-1}'*O{l-1};
        if l ~= 3
            O{l} = [sigmoid(I{l}); 1];
        else
            O{l} = sigmoid(I{l});
        end
   end
   
   % Back Propagation
   delta = cell(size(W));
   delta{size(W,1),1} = zeros(size(W{end,1},2));
   delta{size(W,1),1} = (O{l}-b(n,:)).*O{l}.*(1-O{l});
   for wl=(size(W,1)-1):-1:1
       size(W{wl}'*[delta{wl+1}; 1])
       size(O{wl})
       delta{wl} = O{wl}.*(1-O{wl}); %.*();
   end
end

end

