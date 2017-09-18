% load function files from subfolders aswell
addpath (genpath ('.'));

% holds the cross validation result
tp=0; fp=0; tn=0; fn=0;
tp2=0; fp2=0; tn2=0; fn2=0;

train_time = 0;
average_time = 0;

% Learn Eigenfaces with 100 components
%eigenfaces_train = @(X,y) eigenfaces(X,y,10);
fisherfaces_train = @(X,y) fisherfaces(X,y);
%eigenfaces_test = @(model, Xtest) eigenfaces_predict(model, Xtest, 1);
fisherfaces_test = @(model, Xtest) fisherfaces_predict(model, Xtest, 1);

for t=1:10
    
    path = 'C:\dev\facerec';
    gen_path = sprintf('%s\\%s',path,'MIT_frontalized_detected');
    folder_train = list_files(sprintf('%s\\%s',gen_path,'train'));
    folder_test = list_files(sprintf('%s\\%s',gen_path,'test'));
    
    train_path = sprintf('%s\\%s\\%s', gen_path,'train', folder_train{t});
        
    test_path = sprintf('%s\\%s\\%s', gen_path,'test', folder_test{t});
    'Load training data'
    % load data
    [X , y, w, h, name] = read_images(train_path);
    %/home/gonzalo/dev/facerec/train_data'); %att_faces'); %
    'Begin trainin...'
    % train a model
%     model = eigenfaces_train(X, y);
    model = fisherfaces(X , y, 10);
    'Model trained...'
    clearvars X y w h name ;
    
    % load data for testing
    'Beggining test...'
    
    labels = list_files(train_path);
    subjects = list_files(test_path);
    for j=1:length(subjects)
        filename = subjects{j};
        file_path = sprintf('%s\\%s', test_path, filename);
        subj_name = filename(1:4);

        X2 = read_image(file_path);
    %   evaluate model and return prediction structure
%         prediction = eigenfaces_predict(model, X2 ,1);
        prediction2 = fisherfaces_predict(model, X2 ,1);
        clearvars X2

        % Compute true positive rate by counting true positives if
        % prediction and label coincide, and false positive if do not
%         if strcmp(sprintf('%s',labels{prediction}),subj_name)
%             tp = tp + 1;
%         else
%             fp = fp + 1;
%         end
        if strcmp(sprintf('%s',labels{prediction2}),subj_name)
            tp2 = tp2 + 1;
        else
            fp2 = fp2 + 1;
        end
    end
end

% tpr = 100 * tp / (tp+fp);
tpr2 = 100 * tp2 / (tp2+fp2);

sprintf('Eigenfaces for %.f folds and %.f images per subject tpr: %.2f'...
    , length(folder_train), length(list_files('C:\dev\facerec\MIT_frontalized_detected\step0\0000')), tpr2)

fileID = fopen('C:\dev\facerec\exp_results.txt','a+t');
fprintf(fileID, '\nEigenfaces for %.f folds and %.f images per subject tpr: %.2f'...
    , length(folder_train), length(list_files('C:\dev\facerec\MIT_frontalized_detected\step0\0000')), tpr2);
% fprintf(fileID, ' Fisherfaces tpr: %.2f', tpr2 ); % %
fclose(fileID);

