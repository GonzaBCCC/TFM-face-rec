% This software was developed using functions source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.

%% Testing script for face recognition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is made to perform model testing on both eigenfaces and
% fisherfaces methods for face recognition, being able to compute average
% training time and average True Positive Rate. The results are both
% displayed on command window and writen to results.txt file.
% The method involves performing several runs over the same data for both
% training and testing using a given amount of training samples in order 
% to compute an average performance, then switching to another pair of 
% training/testing data doing the same process. 
% The cycle is repeated over using different sizes of training data and in
% the end average performance for each train set size is computed.

% -------------------------------------------------------------------------
% Inputs:
%     train_scale   =   It represents the number of training images per
%                       subject that the dataset holds.
%                        
%     n_of_sets     =   Number of train/test pair of datasets to evaluate
%                       the algorithm over.
%                        
%     n_of_runs     =   Number of runs over the same dataset to ensure
%                       average performance metrics.
%
% Data paths highlighted as below need to be set according to data
% location (careful with Windows/Linux path notation):
%
%%%%% Important to set this %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path = 'directory/where/the/datasets/are';                              %                  %
% gen_path = sprintf('%s\\%s',path,'Dataset_with_train&test_subfolders'); % 
% folder_train = list_files(sprintf('%s\\%s',gen_path,'train_folder'));   %
% folder_test = list_files(sprintf('%s\\%s',gen_path,'test_folder'));     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Due to specific needs during development and validation phase, Dataset 
% predefined organization is as follows:
%
% global_path/
% |-- Dataset/
%     |-- train_set/
%     |   |-- train_0_set/
%     |   |   |-- person1
%     |   |   |   |-- 1.jpg
%     |   |   |   |-- 2.jpg
%     |   |   |   |-- 3.jpg
%     |   |   |   |-- 4.jpg
%     |   |   |-- person2
%     |   |   |   |-- 1.jpg
%     |   |   |   |-- 2.jpg
%     |   |   |   |-- 3.jpg
%     |   |   |   |-- 4.jpg 
%     |   |   [...]
%     |   |-- train_1_set
%     |   |-- [...]
%     |   |-- train_0_set
%     |   
%     |-- test_set/
%     |   |-- test_0_set/
%     |   |-- [...]
%
% You may change it as seen fit but at least structure with
% train_folder/person_x/image_files should remain for read_images script to
% work properly.
%
%% Note:
%       It is important to set all 'train_scale', 'n_of_sets' and 
% 'n_of_runs' variables correctly according to available data and desired
% runtime.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Begin of script:
% load function files from subfolders aswell
addpath (genpath ('.'));

% Set the amount of samples per subject of each testing instance. Set to 
% single value 'a' if you are only going to test with 'a' samples per
% subject.
train_scale = [5, 10, 20, 30, 40, 50, 100, 150, 200];

% Set the number of image sets to use (there must be a test set for each 
% train set):
n_of_sets = 10;

% Set number of runs per each image set:
n_of_runs = 10;

% Set time variables:
train_time = zeros(n_of_sets,n_of_runs);
average_time = 0;

% Learn Eigenfaces and/or Fisherfaces (comment as you see fit). By assigning
% eigenfaces(X,y,n) you may apply PCA with 'n' components to reduce
% dimensionality. Same case for fisherfaces, comment the method that is not
% to be used:
eigenfaces_train = @(X,y) eigenfaces(X,y);
fisherfaces_train = @(X,y) fisherfaces(X,y);
eigenfaces_test = @(model, Xtest) eigenfaces_predict(model, Xtest, 1);
fisherfaces_test = @(model, Xtest) fisherfaces_predict(model, Xtest, 1);

% Create True Positive Rate arrays: 
% For Eigenfaces:
% tpr_test = zeros(1,n_of_runs);
% For Fisherfaces:
tpr2_test = zeros(1,n_of_runs);

% For Eigenfaces:
% avg_tpr = zeros(1,length(train_scale));

% For Fisherfaces:
avg_tpr2 = zeros(1,length(train_scale));
%% Begin instances to measure performance for different amounts of training data
for instance = 1:length(train_scale)
    n_images = train_scale(instance);
    sprintf('Instance %d of %d ...',instance,length(train_scale))
    %% Run 'n_of_runs' tests with different train and test data, no repetition on the test set
    for t=1:n_of_sets
        %Load working directory and data folders
        sprintf('Run number %d...',t)
        
        %%%%% Important to set this %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        path = 'C:\dev\facerec';                                          %
        gen_path = sprintf('%s\\%s',path,'MIT_frontalized_detected');     % 
        folder_train = list_files(sprintf('%s\\%s',gen_path,'train'));    %
        folder_test = list_files(sprintf('%s\\%s',gen_path,'test'));      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Path to training images for this 
        train_path = sprintf('%s\\%s\\%s', gen_path,'train', folder_train{t});
    
        test_path = sprintf('%s\\%s\\%s', gen_path,'test', folder_test{t});

        % load data
        [X , y, w, h, name] = read_images(train_path, n_images);
        
        % For Eigenfaces:
%         tpr = zeros(1, n_of_runs);
        
        % For Fisherfaces:
        tpr2 = zeros(1, n_of_runs);
        
        %% Perform 'n_of_runs' equal runs of training and testing to obtain average measures
        for r=1:n_of_runs
    
            % train a model
            tic
            % For Eigenfaces:
%             model = eigenfaces_train(X, y);
            
            % For Fisherfaces:
            model2 = fisherfaces_train(X , y);
            
            train_time(t,r) = toc; 
            'Model trained...'
            % This variables are not used for this implementation:
            clearvars w h name ;
    
            % load data for testing
            sprintf('Beggining test %d...',r)
        
            % holds the cross validation result
            % For Eigenfaces:
%             tp=0; fp=0; tn=0; fn=0;
            % For Fisherfaces:
            tp2=0; fp2=0; tn2=0; fn2=0;
        
            labels = list_files(train_path);
            subjects = list_files(test_path);
            for j=1:length(subjects)
                filename = subjects{j};
                file_path = sprintf('%s\\%s', test_path, filename);
                subj_name = filename(1:4);

                X2 = read_image(file_path);
                % Evaluate model and return prediction structure:
                
                % For Eigenfaces:
%                 prediction = eigenfaces_predict(model, X2 ,1);
                
                % For Fisherfaces:
                prediction2 = fisherfaces_predict(model2, X2 ,1);
                clearvars X2

                % Compute true positive rate by counting true positives if
                % prediction and label coincide, and false positive if 
                % they do not:
                
                % For Eigenfaces:
%                 if strcmp(sprintf('%s',labels{prediction}),subj_name)
%                     tp = tp + 1;
%                 else
%                     fp = fp + 1;
%                 end

                % For Fisherfaces:
                if strcmp(sprintf('%s',labels{prediction2}),subj_name)
                    tp2 = tp2 + 1;
                else
                    fp2 = fp2 + 1;
                end
            end
            %% TPR count for this run
            % For Eigenfaces:
%             tpr(r) = 100 * tp / (tp+fp);
            
            % For Fisherfaces:
            tpr2(r) = 100 * tp2 / (tp2+fp2);
            
            clearvars model model2
        end
        %% Average TPR for this set 't'
        % For Eigenfaces:
%         tpr_test(t) = mean(tpr);

        % For Fisherfaces:
        tpr2_test(t) = mean(tpr2);
        
    end
    %% Compute mean values for training time and TPR given 'instance' 
    average_time = mean(train_time);
    % For Eigenfaces:
%     avg_tpr(instance) = mean(tpr_test);
    % For Fisherfaces:
    avg_tpr2(instance) = mean(tpr2_test);
    %% Display results and save them to results.txt file
    % For Eigenfaces:
%     sprintf('Eigenfaces for %.d folds of %.d runs and %d images per subject tpr: %.2f . Training time: %.4f'...
%         , length(folder_train), n_of_runs, n_images, avg_tpr(instance),average_time)
    
    % For Fisherfaces:
    sprintf('Fisherfaces for %.d folds of %.d runs and %d images per subject tpr: %.2f. Training time: %.4f'...
        , length(folder_train), n_of_runs, n_images, avg_tpr2(instance),average_time)

    fileID = fopen('C:\dev\facerec\exp_results.txt','a+t');
    % For Eigenfaces:
%     fprintf(fileID, '\nEigenfaces for %.d folds of %.d runs and %d images per subject tpr: %.2f . Training time: %.4f'...
%         , length(folder_train), n_of_runs, n_images, avg_tpr(instance),average_time);
    
    % For Fisherfaces:
    fprintf(fileID, '\nFisherfaces for %.d folds of %.d runs and %d images per subject tpr: %.2f. Training time: %.4f'...
        , length(folder_train), n_of_runs, n_images, avg_tpr2(instance),average_time);
    
    fclose(fileID);

end
%% Save environment variables if needed (for debug purposes, usually commented)
% save('C:\dev\facerec\performance analysis.m','train_scale', 'avg_tpr2'); %, 'avg_tpr'