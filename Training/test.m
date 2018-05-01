%% Test The Trained Neural Netowrk

clear;close all;clc;
fprintf('\n=========NEURAL NETWORK TESTING==========\n');

%% Load Neural Network

fprintf('\nLoading Trained Neural Network and dataset ... ');

%Load Parameters and dataset
load('NN.mat');

% Load dataset
load dataset.mat Xtrain ytrain Xtest ytest Xcv ycv
Xtrain = logical(Xtrain);
Xtrain = [Xtrain; logical(Xcv)];
ytrain = logical(ytrain);
ytrain = [ytrain; logical(ycv)];
Xtest = logical(Xtest);
ytest = logical(ytest);

% Use only small letters and numbers
% Xtrain = Xtrain([1:7110 25597:44082], :);
% ytrain = ytrain([1:7110 25597:44082], [1:10 37:62]);
% Xcv = Xcv([1:1520 5473:9424], :);
% ycv = ycv([1:1520 5473:9424], [1:10 37:62]);
% Xtest = Xtest([1:1520 5473:9424], :);
% ytest = ytest([1:1520 5473:9424], [1:10 37:62]);

fprintf('done\n');

%% Testing Neural Network

fprintf('\nChecking Neural Network Accuracy ...');
%Check accuracy on training set
pred = predict(Theta1, Theta2, Xtrain);
[~, Y] = max(ytrain,[],2);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Y)) * 100);

%Check accuracy on test set
pred = predict(Theta1, Theta2, Xtest);
[~, Y] = max(ytest,[],2);
fprintf('Test Set Accuracy: %f\n', mean(double(pred == Y)) * 100);

%% Test Neural Network on Random Test Inputs

LogicalStr = {'false','true'};
m = size(Xtest,1);
random = randperm(m);
meantime = 0;
for i = 1:m
    figure(1);
    imshow(imresize(reshape(Xtest(random(i),1:625),25,25),[300 NaN]));
    
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
meantime = meantime/i;

%% End 

fprintf('\nMean Prediction time : %fs\n',meantime);
fprintf('\n============TESTING COMPLETE============\n');