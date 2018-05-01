%% Create a dataset from the available large dataset
% The fonts.hdf5 is a 13G file downloaded from erik's blog
% Link of the file is in the readme file

info = h5info('fonts.hdf5');
num_fonts = info.Datasets.Dataspace.Size(4);

X = [];
y = [];
indexes = [];

for i = 1:num_fonts
    figure(1);
    data = h5read('fonts.hdf5','/fonts',[1 1 1 i],[64,64,62,1]);
    data = permute(data,[2 1 3]);
    data1 = false(25,25,62);
    for j = 1:62
        data1(:,:,j) = ~imresize(imbinarize(data(:,:,j)),[25,25]);
    end
    data = data1;
    data = reshape(data,[625 62]);
    data = data';
    displayData(data);
    choice = input('Choose? : ','s');
    if choice == 'y'
        indexes = [indexes;i];
        X = [X;data];
        y = [y;eye(62)];
    end
    fprintf('%d\n',size(X,1)/62);
    if length(indexes)==1500
        break;
    end
end

%% Split Dataset into Train, Test and Cross Validataion Sets

Xtrain= X(1:62000,:);
ytrain = y(1:62000,:);
Xcv = X(62001:77500,:);
ycv = y(62001:77500,:);
Xtest = X(77500:end,:);
ytest = y(77500:end,:);

%% Save Dataset

fprintf('Saving ... ');
save dataset.mat Xtrain ytrain Xcv ycv Xtest ytest indexes;
fprintf('done');

fprintf('\n\n===========DATASET CREATED==========\n');