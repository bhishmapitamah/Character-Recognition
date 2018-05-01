%% Train Neural Network for character classification

clear;close all;clc
fprintf('==========NEURAL NETWORK TRAINING==========\n');
%% Hyperparameters

input_layer_size = 625;
hidden_layer_size = 600;
labels = 62;
lambda = 0.01;
iterations = 2500;
 
%% Load Dataset

fprintf('\nLoading Saved Learning Data ... ');

% Load dataset
load dataset.mat Xtrain ytrain Xtest ytest Xcv ycv
Xtrain = logical(Xtrain);
Xtrain = [Xtrain; logical(Xcv)];
ytrain = logical(ytrain);
ytrain = [ytrain; logical(ycv)];
Xtest = logical(Xtest);
ytest = logical(ytest);

fprintf('done\n');

%% Initialize Neural Network

fprintf('\nInitializing Neural Netowrk Parameters with Random values ... ');

% Initialize NN parameters with random values to break symmetry
initial_Theta1 = randwt(hidden_layer_size, (input_layer_size + 1));
initial_Theta2 = randwt(labels, (hidden_layer_size + 1));

%Unroll the parameters for training
initial_Theta = [initial_Theta1(:); initial_Theta2(:)];

fprintf('done\n');

%% Train Neural Network

fprintf('\nTraining Neural Network... \n');

tic;
options = optimset('MaxIter', iterations,'Display','iter','GradObj','on');
costFun = @(p) costfn(p, input_layer_size, hidden_layer_size, ...
                                   labels, Xtrain, ytrain, lambda);
%[thetaVec, cost] = fmin_adam(costFun, initial_Theta, [], [], [], [], [], options);
[thetaVec, cost] = fmincg(costFun, initial_Theta,options);

Theta1 = reshape(thetaVec(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(thetaVec((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 labels, (hidden_layer_size + 1));

fprintf('Neural Network Trained. Training time : %0.1fs\n',toc);
  
%% Visualize Neural Netowrk

fprintf('\nVisualizing Neural Netowrk ... ');

displayData(Theta1(:, 2:end));
print('-dtiff','Plots/Hidden Layer.tiff');

fprintf('done\n');
fprintf('\nPaused. Press any key to test Neural Network accuracy.\n');
pause;

%% Testing Neural Network

%Check accuracy on training set
pred = predict(Theta1, Theta2, Xtrain);
[~, Y] = max(ytrain,[],2);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Y)) * 100);

%Check accuracy on test set
pred = predict(Theta1, Theta2, Xtest);
[~, Y] = max(ytest,[],2);
fprintf('Test Set Accuracy: %f\n', mean(double(pred == Y)) * 100);

%% Save Neural Network

fprintf('\nSave Neural Network or break\n');
pause;

%Save parameters
save NN.mat Theta1 Theta2

figure(1);
plot(1:iterations,cost');
title('Cost Function');
xlabel('Iterations');
ylabel('Cost');
print('-dtiff','Plots/Cost Function.tiff');
fprintf('\nPaused. Press any key to test Neural Network on random inputs.');
pause;

%% Test Neural Network on Random Test Inputs

meantime = 0;
LogicalStr = {'false','true'};
m = size(Xtest,1);
random = randperm(m);
for i = 1:m
    figure(1);
    imshow(imresize(reshape(Xtest(random(i),:),25,25),[300 NaN]));
    
    actual = find(ytest(random(i),:)==1);
    if actual < 27 
        fprintf('\nActual Character : %s\n',char(actual + 64));
    elseif actual < 53
        fprintf('\nActual Character : %s\n',char(actual + 70));
    else 
        fprintf('\nActual Character : %d\n',actual - 53);
    end
    
    tic;
    prediction = predict(Theta1, Theta2, Xtest(random(i),:));
    time = toc;
    meantime = meantime + time;
    if prediction < 27 
        fprintf('Neural Network Prediction : %s (%s)\n',char(prediction + 64), LogicalStr{(actual == prediction) +1});
    elseif prediction < 53
        fprintf('Neural Network Prediction : %s (%s)\n',char(prediction + 70), LogicalStr{(actual == prediction) +1});
    else 
        fprintf('Neural Network Prediction : %d (%s)\n',prediction - 53, LogicalStr{(actual == prediction) +1});
    end
    
    fprintf('Prediction time : %f\n',time);
    s = input('Press any key to continue or q to exit : ', 's');
    if s == 'q'
        break;
    end
end
meantime = meantime / i;

%% End

fprintf('\nMean Prediction time : %fs\n',meantime);
fprintf('\nTraining Complete. Press any key to exit.\n');
pause;
fprintf('\n==============TRAINING COMPLETE==============\n\n')