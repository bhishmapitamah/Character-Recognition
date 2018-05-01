%% Plot Learning Curves for Bias and Variance Check

clear;close all;clc;
fprintf('\n==============LEARNING CURVES==============\n\n');
%% Load Dataset

fprintf('Loading Dataset ... ');

% Load dataset
load dataset.mat Xtrain ytrain Xcv ycv Xtest ytest;

fprintf('done\n\n');

%% Hyperparameters

input_layer_size = 625;
hidden_layer_size = 600;
labels = 62;
lambda = 0.01;
iterations = 400;

%% Train for different dataset sizes

initial_Theta1 = randwt(hidden_layer_size, (input_layer_size + 1));
initial_Theta2 = randwt(labels, (hidden_layer_size + 1));
initial_Theta = [initial_Theta1(:); initial_Theta2(:)];
options = optimset('MaxIter', iterations,'Display','off');  

datasize = 4000:4000:length(Xtrain);
trainings = length(datasize);
Jtrain = zeros(1, trainings);
Jcv = zeros(1,trainings);
time = zeros(1,trainings);

for k = 1:trainings
    
    fprintf('Traning for m = %d .... ',datasize(k));
    
    tic;
    r = randperm(datasize(k));
    Xt = Xtrain(r,:);
    yt = ytrain(r,:);

    costFun = @(p) costfn(p, input_layer_size, hidden_layer_size, ...
                                   labels, Xt, yt, lambda);
    [thetaVec, cost] = fmincg(costFun, initial_Theta, options);
    
    Jtrain(k) = cost(end);
    [Jcv(k), ~] = costfn(thetaVec, input_layer_size, hidden_layer_size, ...
                                   labels, Xcv, ycv, lambda);
    
    time(k) = toc;
    fprintf('done   %0.1fs\n',time(k));
    
end

fprintf('Total time taken to train : %0.1f\n',sum(time));

%% Plot cuve

fprintf('\nPlotting Learning Curve ... ');
figure(1);
plot(datasize,Jtrain,datasize,Jcv);
title('Learning Curve');
xlabel('Number of traning examples(m)');
ylabel('Cost');
legend('Traning Cost','Cross Validation Cost');
print('-dtiff','Plots/Learning Curve.tiff');
fprintf('done\n');

fprintf('Plotting Time vs Dataset Size Curve ... ');
figure(2);
plot(datasize,time);
title('Traning Time');
xlabel('Number of traning examples(m)');
ylabel('Time taken for traning(s)')
print('-dtiff','Plots/Traning time.tiff');
fprintf('done\n');

fprintf('\n\n==========LEARNING CURVE PLOTTED==========\n\n');
%%end