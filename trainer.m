% This function is used to train the NN to classify digital number in a
% image
tic;
digitDatasetPath = './SplitLabeledImage';

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

labelCount = countEachLabel(imds);
numTrainFiles = 650; 
%The script splits the dataset into training and validation sets using splitEachLabel.
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');
%The script defines the layers of the neural network using the Deep Learning Toolbox.
layers = [
    %It starts with an imageInputLayer that specifies the input size of the images.
    imageInputLayer([50 35 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    %Max pooling layers are used for downsampling.
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    %fully connected layer with a softmax output layer for classification.
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

%we specify the training options
%Stochastic gradient descent with momentum ('sgdm') is chosen as the optimization algorithm.
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

%After training, the script evaluates the performance of the trained network on the validation set.
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

%It computes the classification accuracy by comparing the predicted labels (YPred) with the true labels (YValidation).
accuracy = sum(YPred == YValidation)/numel(YValidation)
save net;
load net;
toc;
