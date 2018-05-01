function [h] = sigmoid(z)
%% Calculate the sigmoid (activation function) of the given vector or matrix or scalar

h = 1.0 ./ (1.0 + exp(-z));

end

