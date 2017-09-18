% This software was developed using functions source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.

% load function files from subfolders aswell
addpath (genpath ('.'));

%% Envelope functions call
eigenfaces_train = @(X,y) eigenfaces(X,y,10);
fisherfaces_train = @(X,y) fisherfaces(X,y,10);
eigenfaces_test = @(model, Xtest) eigenfaces_predict(model, Xtest, 1);
fisherfaces_test = @(model, Xtest) fisherfaces_predict(model, Xtest, 1);

%% Set the amount of samples per subject progression
train_scale = [7, 35, 70, 150, 210];
angle_list = {'0', '-4', '-8', '-12', '-16', '-20', '-24'};

tpr_test = zeros(length(angle_list),10);
tpr2_test = zeros(length(angle_list),10);

avg_tpr = zeros(1,length(train_scale));
avg_tpr2 = zeros(length(angle_list),length(train_scale));

%% Begin instances to measure performance for different amounts of training data
for instance = 1:length(train_scale)
    n_images = train_scale(instance);
%     sprintf('Instance %d of %d ...',instance,length(train_scale))
    %% Run 10 tests with different train and test data, no repetition on the test set
    for t=1:10
        %% Load working directory and data folders
        sprintf('Run number %d...',t)
        path = 'C:\dev\facerec';
        gen_path = sprintf('%s\\%s',path,'MIT_frontalized_detected');
        folder_train = list_files(sprintf('%s\\%s',gen_path,'train'));
        folder_test = list_files(sprintf('%s\\%s',gen_path,'test'));
        % Path to training images for this 
        train_path = sprintf('%s\\%s\\%s', gen_path,'train', folder_train{t});
        % Path to testing images for this 
        test_path = sprintf('%s\\%s\\%s', gen_path,'test', folder_test{t});
        % load data
        [X , y, w, h, name] = read_images(train_path,n_images);

        %% train a model
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%
%         model = eigenfaces_train(X, y);
%         tpr = zeros(length(angle_list),10);

%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
        tpr2 = zeros(length(angle_list),10);  
        model2 = fisherfaces_train(X , y);

        'Model trained...'
        clearvars w h name ;
    
        %% Perform 10 equal runs of training and testing to obtain average measures
        for r=1:10
            % load data for testing
            sprintf('Beggining test %d...',r)
           
            % holds the cross validation result
            tp = zeros(length(angle_list),1);
            tp2 = zeros(length(angle_list),1);
            fp = zeros(length(angle_list),1);
            fp2 = zeros(length(angle_list),1);

        
            labels = list_files(train_path);
            subjects = list_files(test_path);
            for j=1:length(subjects)
                filename = subjects{j};
                %Find the angle of the test picture
                name_parts = strsplit(filename,'_');
                angle = name_parts(2);
                for a=1:length(angle_list)
                    loc(a) = strcmp(angle_list{a},angle);
                end
                i=find(loc);
                
                % extract name of the subject and load image
                file_path = sprintf('%s\\%s', test_path, filename);
                subj_name = filename(1:4);
                X2 = read_image(file_path);
                
            %   Evaluate model and return prediction structure
            %   Compute true positive rate by counting true positives if
            %   prediction and label coincide, and false positive if do not            
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%
%                 prediction = eigenfaces_predict(model, X2 ,1);         
%                 clearvars X2
%                 if strcmp(sprintf('%s',labels{prediction}),subj_name)
%                     tp(i) = tp(i) + 1;
%                 else
%                     fp(i) = fp(i) + 1;
%                 end
%             tpr(:,r) = 100 .* tp ./ (tp+fp);
            
%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
            prediction2 = fisherfaces_predict(model2, X2 ,1);
            clearvars X2
                if strcmp(sprintf('%s',labels{prediction2}),subj_name)
                    tp2(i) = tp2(i) + 1;
                else
                    fp2(i) = fp2(i) + 1;
                end
            tpr2(:,r) = 100 .* tp2 ./ (tp2+fp2);           
            end            
        end
        clearvars model model2
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%
%         tpr_test(:,t) = mean(tpr,2);
         
%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
        tpr2_test(:,t) = mean(tpr2,2);
        
    end
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%    
%     avg_tpr(:,instance) = mean(tpr_test,2);
    
%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
    avg_tpr2(:,instance) = mean(tpr2_test,2);

end
%% Print in screen
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%
%     sprintf('Eigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(1), avg_tpr(1,1),avg_tpr(2,1),avg_tpr(3,1),avg_tpr(4,1),avg_tpr(5,1),avg_tpr(6,1),avg_tpr(7,1))
% 
%     sprintf('Eigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(2), avg_tpr(1,2),avg_tpr(2,2),avg_tpr(3,2),avg_tpr(4,2),avg_tpr(5,2),avg_tpr(6,2),avg_tpr(7,2))
% 
%     sprintf('Eigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(3), avg_tpr(1,3),avg_tpr(2,3),avg_tpr(3,3),avg_tpr(4,3),avg_tpr(5,3),avg_tpr(6,3),avg_tpr(7,3))
%    
%     sprintf('Eigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(4), avg_tpr(1,4),avg_tpr(2,4),avg_tpr(3,4),avg_tpr(4,4),avg_tpr(5,4),avg_tpr(6,4),avg_tpr(7,4))
% 
%     sprintf('Eigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(5), avg_tpr(1,5),avg_tpr(2,5),avg_tpr(3,5),avg_tpr(4,5),avg_tpr(5,5),avg_tpr(6,5),avg_tpr(7,5))

   
%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
    sprintf('Fisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,1),avg_tpr2(2,1),avg_tpr2(3,1),avg_tpr2(4,1),avg_tpr2(5,1),avg_tpr2(6,1),avg_tpr2(7,1))

    sprintf('Fisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(2), avg_tpr2(1,2),avg_tpr2(2,2),avg_tpr2(3,2),avg_tpr2(4,2),avg_tpr2(5,2),avg_tpr2(6,2),avg_tpr2(7,2))

    sprintf('Fisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(3), avg_tpr2(1,3),avg_tpr2(2,3),avg_tpr2(3,3),avg_tpr2(4,3),avg_tpr2(5,3),avg_tpr2(6,3),avg_tpr2(7,3))

    sprintf('Fisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(4), avg_tpr2(1,4),avg_tpr2(2,4),avg_tpr2(3,4),avg_tpr2(4,4),avg_tpr2(5,4),avg_tpr2(6,4),avg_tpr2(7,4))
    
    sprintf('Fisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(5), avg_tpr2(1,5),avg_tpr2(2,5),avg_tpr2(3,5),avg_tpr2(4,5),avg_tpr2(5,5),avg_tpr2(6,5),avg_tpr2(7,5))

   
%% Print to file
    fileID = fopen('C:\dev\facerec\exp_results.txt','a+t');
    
% %%%%%%%%%%%%%% For Eigenfaces %%%%%%%%%%%%%    
%     fprintf(fileID, '\nEigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(1), avg_tpr(1,1),avg_tpr(2,1),avg_tpr(3,1),avg_tpr(4,1),avg_tpr(5,1),avg_tpr(6,1),avg_tpr(7,1));
%     fprintf(fileID, '\nEigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(2), avg_tpr(1,2),avg_tpr(2,2),avg_tpr(3,2),avg_tpr(4,2),avg_tpr(5,2),avg_tpr(6,2),avg_tpr(7,2));
%     fprintf(fileID, '\nEigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(3), avg_tpr(1,3),avg_tpr(2,3),avg_tpr(3,3),avg_tpr(4,3),avg_tpr(5,3),avg_tpr(6,3),avg_tpr(7,3));
%     fprintf(fileID, '\nEigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(4), avg_tpr(1,4),avg_tpr(2,4),avg_tpr(3,4),avg_tpr(4,4),avg_tpr(5,4),avg_tpr(6,4),avg_tpr(7,4));
%     fprintf(fileID, '\nEigenfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20deg: %.2f , tpr 24deg: %.2f'...
%        , length(folder_train), train_scale(5), avg_tpr(1,5),avg_tpr(2,5),avg_tpr(3,5),avg_tpr(4,5),avg_tpr(5,5),avg_tpr(6,5),avg_tpr(7,5));

%%%%%%%%%%%%% For Fisherfaces %%%%%%%%%%%%%
    fprintf(fileID, '\nFisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,1),avg_tpr2(2,1),avg_tpr2(3,1),avg_tpr2(4,1),avg_tpr2(5,1),avg_tpr2(6,1),avg_tpr2(7,1));
    fprintf(fileID, '\nFisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,2),avg_tpr2(2,2),avg_tpr2(3,2),avg_tpr2(4,2),avg_tpr2(5,2),avg_tpr2(6,2),avg_tpr2(7,2));
    fprintf(fileID, '\nFisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,3),avg_tpr2(2,3),avg_tpr2(3,3),avg_tpr2(4,3),avg_tpr2(5,3),avg_tpr2(6,3),avg_tpr2(7,3));
    fprintf(fileID, '\nFisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,4),avg_tpr2(2,4),avg_tpr2(3,4),avg_tpr2(4,4),avg_tpr2(5,4),avg_tpr2(6,4),avg_tpr2(7,4));
    fprintf(fileID, '\nFisherfaces %.d folds %.d images per subject tpr 0 deg: %.2f , tpr 4 deg: %.2f , tpr 8 deg: %.2f , tpr 12 deg: %.2f , tpr 16 deg: %.2f , tpr 20 deg: %.2f , tpr 24 deg: %.2f'...
       , length(folder_train), train_scale(1), avg_tpr2(1,5),avg_tpr2(2,5),avg_tpr2(3,5),avg_tpr2(4,5),avg_tpr2(5,5),avg_tpr2(6,5),avg_tpr2(7,5));
   
    fclose(fileID);

% save('C:\dev\facerec\performance analysis.m','train_scale', 'avg_tpr2'); %, 'avg_tpr'