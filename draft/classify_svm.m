function [accuracy, resultImg] = classify_svm(labeled_matrix, mode)  
    % Train_model(Only valid when 'mode' is 1,it cost more time)
    if mode==1
        rootDir = './p_dataset_26'; % Training set location
        folders = {'SampleD', 'SampleE', 'SampleH', 'SampleL', 'SampleO', 'SampleR', 'SampleW'};
        labels = {'D', 'E', 'H', 'L', 'O', 'R', 'W'}; % Label of Training set
        
        %% 1. Retrieve Data
        allImages = [];
        allLabels = [];
        
        for i = 1:length(folders)
            folderPath = fullfile(rootDir, folders{i});
            imgFiles = dir(fullfile(folderPath, '*.png')); 
            for j = 1:length(imgFiles)
                img = imread(fullfile(folderPath, imgFiles(j).name));
                allImages{end+1} = img;
                allLabels{end+1} = labels{i};
            end
        end
        
        %% Disorder Data
        % Ensure the training and validation datasets have similar data distributions.
        randOrder = randperm(length(allImages));
        allImages = allImages(randOrder);
        allLabels = allLabels(randOrder);
        
        %% 2. Data Preprocess
        % Image is uint8, convert to double
        for i = 1:length(allImages)
            % Convert to double
            allImages{i} = double(allImages{i}) / 255;
            % Convert to grayscale
            if size(allImages{i}, 3) == 3
                img = rgb2gray(allImages{i});
            else
                img = allImages{i};
            end
        end
        
        %% 3. Feature Extraction
        features = [];
        for i = 1:length(allImages)
            % Extracting HOG features
            feature = extractHOGFeatures(allImages{i});
            features = [features; feature];
        end
        
        %% 4. Training the SVM model
        
        % Data Segmentation
        trainingPercentage = 0.75;
        splitPoint = floor(length(allImages) * trainingPercentage);
        
        % Training Data
        trainingFeatures = features(1:splitPoint, :);
        trainingLabels = allLabels(1:splitPoint);
        
        % Validation Data
        validationFeatures = features(splitPoint+1:end, :);
        validationLabels = allLabels(splitPoint+1:end);

        % train SVM
        t = templateSVM('Standardize', true, 'KernelFunction', 'linear');
        SVMModel = fitcecoc(trainingFeatures, trainingLabels, 'Learners', t);
    else
        % Using a trained model
        load('.\SVMModel.mat');
    end
    
    %% 5. Validating model classification effects
    if mode==1
        predictedLabels = predict(SVMModel, validationFeatures);
  
        % Make sure both are column vectors
        predictedLabels = predictedLabels(:);
        validationLabels = validationLabels(:);
        
        % Calculate accuracy
        accuracy = sum(strcmp(predictedLabels, validationLabels)) / length(validationLabels);
        % Calculate the confusion matrix
        [C, order] = confusionmat(validationLabels, predictedLabels);
    else
        load('./accuracy.mat');
        load('./Order.mat');
        load('./C.mat');
    end
    
    disp(['Accuracy: ', num2str(accuracy * 100), '%']);


    
    % Display Confusion Matrix
    figure;
    confusionchart(C, order);
    title('Confusion Matrix');
    
    %% Prediction 

    %number of extraction(customizable)
    numRegions=13;
    % Copy the original image for overlaying the recognition results
    resultImg = labeled_matrix;  
    for k = 1:numRegions
        % Get the bounding rectangle of the current area
        [row, col] = find(labeled_matrix == k);
        top = min(row); bottom = max(row);
        left = min(col); right = max(col);
        
        % Checking the dimensional constraints of a rectangle(customizable)
        if (bottom - top + 1) >= 35 && (right - left + 1) >= 20
            % Extracting letters in an image
            letterImg = labeled_matrix(top:bottom, left:right);

            %Expand by 20%, then zoom in.(For higher accuracy)
            [rows, cols] = size(letterImg);
            paddingRows = round(0.2 * rows);
            paddingCols = round(0.2 * cols);
            
            paddedImg = padarray(letterImg, [paddingRows, paddingCols], 0, 'both');
            
            % Resizing the image to 128x128(The same as train set)
            resizedImg = imresize(paddedImg, [128, 128]);
            
            % Convert to binary image
            threshold = graythresh(resizedImg);
            bwImg = im2bw(resizedImg, threshold); 
            
            % Reverse color processing(Be the same as training data)
            invertedImg = ~bwImg;
            
            %(optional,show Extracted letters)
            % figure()
            % imshow(invertedImg);
            
            % Extracting features and predicting them with SVM models
            letter_feature = extractHOGFeatures(invertedImg);
    
            label = predict(SVMModel, letter_feature);
            
            % Overlay the recognition results onto the original image
            position = [left, top]; % Position of inserted text
            resultImg = insertText(resultImg, position, label{1,1}, 'FontSize', 18, 'BoxColor', 'white');
           
        end
    end

 end
    

