%% Model Selection

clear;close all;clc;
fprintf('\n=============MODEL TESTING=============\n\n');
%% Load Dataset

fprintf('Loading Dataset ... ');

% Load dataset
load dataset.mat Xtrain ytrain Xcv ycv;

fprintf('done\n');

%% Hyperparameters

input_layer_size = 625;
hidden_layer_size = 600;
labels = 62;
iterations = 400;

%% Choosing Regularization

initial_Theta1 = randwt(hidden_layer_size, (input_layer_size + 1));
initial_Theta2 = randwt(labels, (hidden_layer_size + 1));
initial_Theta = [initial_Theta1(:); initial_Theta2(:)];
options = optimset('MaxIter', iterations,'Display','off'); 

lambda = [0.01 0.03 0.1 0.3 1 3 10 30];
Jtrain = zeros(1,length(lambda));
Jcv = zeros(1,length(lambda));
time = zeros(1,length(lambda));
minLambda = inf;
minCost = inf;

for k = 1:length(lambda)
    
    fprintf('Training for lambda = %f ... ',lambda(k));
    
    costFun = @(p) costfn(p, input_layer_size, hidden_layer_size, ...
                                   labels, Xtrain, ytrain, lambda(k));
    [thetaVec, cost] = fmincg(costFun, initial_Theta, options);
            
    Jtrain(k) = cost(end);
    [Jcv(k), ~] = costfn(thetaVec, input_layer_size, hidden_layer_size, ...
                                   labels, Xcv, ycv, lambda(k));
                               
    if Jcv(k) < minCost
        minCost = Jcv(k);
        minLambda = lambda(k);
    end
    fprintf('done\n');
end

%% Plot cuve

fprintf('\nPlotting Regularization Curve ... ');
plot(lambda,Jtrain,lambda,Jcv);
title('Regularization Curve');
xlabel('\lambda');
ylabel('Cost');
legend('Training Cost','Cross Validation Cost');
print('-dtiff','Plots/Regularization Curve.tiff');
fprintf('done\n');

fprintf('\nThe regularization parameter should be taken around %f\n',minLambda);

fprintf('\n\n==========REGULARIZATION SELECTED==========\n\n');
%%end