% This software was developed using functions source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.

% load function files from subfolders aswell
addpath (genpath ('.'));

% holds the cross validation result
tp=0; fp=0; tn=0; fn=0;
tp2=0; fp2=0; tn2=0; fn2=0;

train_time = 0;
average_time = 0;

% Learn Eigenfaces with 100 components
eigenfaces_train = @(X,y) eigenfaces(X,y,10);
%fisherfaces_train = @(X,y) fisherfaces(X,y);
eigenfaces_test = @(model, Xtest) eigenfaces_predict(model, Xtest, 1);


for t=1:10
    
    path = 'C:\dev\facerec';
    gen_path = sprintf('%s\\%s',path,'MIT_frontalized_detected');
    folder = list_files(sprintf('%s\\%s',gen_path,'train'));
    
    train_path = sprintf('%s\\%s\\%s', gen_path,'train', folder{t});
        
    test_path = sprintf('%s\\%s\\%s', gen_path,'test', folder{t});
    % load data
    [X , y, w, h, name] = read_images(train_path);
    %/home/gonzalo/dev/facerec/train_data'); %att_faces'); %
    
    % train a model
    model = eigenfaces_train(X, y);
    % model = fisherfaces(X , y, 100);
    'Model trained...'
    clearvars X y ;
    
    % load data for testing
    'Loading test data'
    [X2, y2,~,~,~] = read_images(test_path);
    

    for i=1:length(folder)
        subjname = folder{i};
        subjects = list_files(sprintf('%s\\%s', path, subjname));
        for j=1:length(subjects)
            filename = subjects{j};
            file_path = sprintf('%s\\%s\\%s', path, subjname, filename);
            subj_name = filename(1:4);

            X2 = read_image(file_path);
    %       evaluate model and return prediction structure
    %       tic
%           prediction = eigenfaces_predict(model, X2 ,1);
            prediction2 = fisherfaces_predict(model, X2 ,1);
    %       average_time = (average_time + toc)/idx;
            clearvars X2
    %       if you want to count [tn, fn] please add your code here
%           if strcmp(sprintf('%s',folder{prediction}),subj_name)
%               tp = tp + 1;
%           else
%               fp = fp + 1;
%           end
            if strcmp(sprintf('%s',folder{prediction2}),subj_name)
                tp2 = tp2 + 1;
            else
                fp2 = fp2 + 1;
            end
        end
    end

end
% tpr = 100 * tp / (tp+fp);
tpr2 = 100 * tp2 / (tp2+fp2);

sprintf('Fisherfaces for %.f subjects and %.f images per subject tpr: %.2f'...
    , length(folder), length(list_files('C:\dev\facerec\MIT-front\0000')), tpr2)
% sprintf('Fisherfaces tpr: %.2f', tpr2)


fileID = fopen('C:\dev\facerec\exp_results.txt','a+t');
fprintf(fileID, 'Fisherfaces for %s subjects and %s images per subject tpr: %.2f'...
    , length(folder), length(list_files('C:\dev\facerec\MIT-front\0000')), tpr2);
% fprintf(fileID, ' Fisherfaces tpr: %.2f', tpr2 ); % %
fclose(fileID);

