function [g] = siggrad(z)
%% Calculate the gradient of sigmoid function for a vector or matrix or scalar

h = sigmoid(z);
g = h .* (1 - h);

end

