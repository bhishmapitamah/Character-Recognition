function [ J, gradient] = costfn(thetaVec, input_layer_size ...
                                    , hidden_layer_size ...
                                    , labels, X, y, lambda)
%% costfn calculates the current cost and gradient   

%% Prerequisits
m = size(X,1);
Theta1 = reshape(thetaVec(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
Theta2 = reshape(thetaVec((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 labels, (hidden_layer_size + 1));

%% Feedforward
a1 = [ones(m,1) X];
z2 = a1 * Theta1'; a2 = [ones(m,1) sigmoid(z2)];
z3 = a2 * Theta2'; h = sigmoid(z3);

%% Cost or error of parameters
temp1 = Theta1; temp1(1:end,1) = 0;
temp2 = Theta2; temp2(1:end,1) = 0;
J = -sum(sum(y .* log(h) + (1 - y) .* log(1 - h)))/m + lambda * (sum(sum(temp1.^2)) + sum(sum(temp2.^2)))./(2.0*m);

%% Gradient of parameters
delta3 = h - y;
delta2 = delta3 * Theta2; delta2 = delta2(:, 2:end);
delta2 = delta2 .* siggrad(z2);
Theta1_grad = (delta2' * a1) / m + lambda * temp1 / m; 
Theta2_grad = (delta3' * a2) / m + lambda * temp2 / m;
gradient = [Theta1_grad(:); Theta2_grad(:)];

end

