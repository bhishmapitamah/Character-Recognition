function [ prediction ] = predict(Theta1, Theta2, X)
%% Predicts the class of the input based on trained Theta1 and Theta2

X = [ones(size(X,1),1) X];
a2 = sigmoid(X * Theta1');
h = sigmoid([ones(size(X,1),1) a2] * Theta2');
[~, prediction] = max(h ,[], 2);

end

