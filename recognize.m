function [y] = recognize(Theta1, Theta2, X)
%RECOGNIZE is the prediction of the neural network
%   Recognize each input and return a string of the complete word

m = size(X,1);
a2 = sigmoid([ones(m,1) X] * Theta1');
h = sigmoid([ones(m,1) a2] * Theta2');
[~, y] = max(h ,[], 2);

end

