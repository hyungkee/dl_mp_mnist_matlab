function [model, mse] = mlp(X, Y, h)
% Multilayer perceptron
% Input:
%   X: d x n data matrix
%   Y: p x n response matrix
%   h: L x 1 vector specify number of hidden nodes in each layer l
% Ouput:
%   model: model structure
%   mse: mean square error
% Written by Mo Chen (sth4nth@gmail.com).
h = [size(X,1);h(:);size(Y,1)];
L = numel(h);
W = cell(L-1);
epsilon_init = 0.4;
for l = 1:L-1
    W{l} = rand(h(l),h(l+1)) * epsilon_init * 2 - epsilon_init;
end

Z = cell(L);
Z{1} = X;

eta = 2/size(X,2);
% dGp = 0.001/size(X,2);
% dGm = 0.001/size(X,2);

    
maxiter = 50;
mse = zeros(1,maxiter);

G = W;
V = Z;

for iter = 1:maxiter
    fprintf('%d iterations..', iter)
    
%     forward
    for l = 2:L
%        Z{l} = sigmoid(W{l-1}'*Z{l-1});
        V{l} = sigmoid(G{l-1}'*V{l-1});
    end
%     backward
    E = V{L}-Y;
    mse(iter) = mean(dot(E(:),E(:)));

%    delta = V{L}-Y;
    GxD = V{L}-Y;
    for l = L-1:-1:1
%        delta_p = delta;
%        delta_p(delta<0) = dGp;
%        delta_p(delta>=0) = 0;

%        delta_m = delta;
%        delta_m(delta>0) = -dGm;
%        delta_m(delta<=0) = 0;
        
%        delta_sum = sum(delta_p,2) + sum(delta_m,2);
        
%        dG = repmat(delta_sum,1,size(G{l},1))';
        df = V{l+1}.*(1-V{l+1});
        D = df.*(GxD);

        dG = V{l}*D';
        G{l} = G{l} - eta*dG;
        
        GxD = G{l}*D;
                
%        delta = G{l}*V{l+1};
    end
    
%    for l = L-1:-1:1
%        df = Z{l+1}.*(1-Z{l+1});
%        dG = df.*E;
%        dW = Z{l}*dG';
%        W{l} = W{l}-eta*dW;
%        E = W{l}*dG;
%    end
    
    fprintf('mse : %d\n', mse(iter))
end
mse = mse(1:iter);
model.W = W;