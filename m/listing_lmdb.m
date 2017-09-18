% This software was developed using functions source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.
% load function files from subfolders aswell
addpath (genpath ('.'));
train_scale = [5, 10, 20, 30, 40, 50, 100, 150, 200];

for n=1:length(train_scale)
n_images = train_scale(n);

        %% Load working directory and data folders
for t=1:10
        sprintf('Run number %d...',t)
        path = 'C:\dev\facerec';
        gen_path = sprintf('%s\\%s',path,'MIT_img_prog');
        folder_train = list_files(sprintf('%s\\%s\\%d',gen_path,'train',n_images));
        folder_val = list_files(sprintf('%s\\%s',gen_path,'val'));
        folder_test = list_files(sprintf('%s\\%s',gen_path,'test'));
        % Path to training images for this 
        train_path = sprintf('%s\\%s\\%d\\%s', gen_path,'train',n_images, folder_train{t});
        val_path = sprintf('%s\\%s\\%s', gen_path,'val', folder_val{t});
        test_path = sprintf('%s\\%s\\%s', gen_path,'test', folder_test{t});
        
        mode = 'train'
        
        if strcmp(mode,'train') 
            list_file_name = sprintf('%s\\%d_%s_%d.txt',path, n_images, mode, t-1);
        else
            list_file_name = sprintf('%s\\%s_%d.txt',path, mode, t-1);
        end
        fileID = fopen(list_file_name,'a+t');
            
        if strcmp(mode,'train') 
%           List the files within each folder
            % load training data
            subjects = list_files(train_path);
            for j=1:length(subjects)
                foldername = subjects{j};
                folder_path = sprintf('%s\\%s', train_path, foldername);
                samples = list_files(folder_path);
                for i=1:length(samples)
                    filename = samples{i};
                    train_num = sprintf('train_%d',t-1);
                    subj_name = filename(1:4);
                    file_path = sprintf('%s/%s/%s', train_num, subj_name, filename);
                    fprintf(fileID, '%s %s\n', file_path, foldername);
                end
            end
        elseif strcmp(mode,'val')
            subjects = list_files(val_path);
            for j=1:length(subjects)
                foldername = subjects{j};
                folder_path = sprintf('%s\\%s', val_path, foldername);
                samples = list_files(folder_path);
                for i=1:length(samples)
                    filename = samples{i};
                    val_num = sprintf('val_%d',t-1);
                    subj_name = filename(1:4);
                    file_path = sprintf('%s/%s/%s', val_num, subj_name, filename);
                    fprintf(fileID, '%s %s\n', file_path, foldername);
                end
            end
        elseif strcmp(mode,'test')
        % load testing data
            subjects = list_files(test_path);
            for j=1:length(subjects)
                filename = subjects{j};
                test_num = sprintf('%d_%s_%s',n_images,'test',t-1);
                subj_name = filename(1:4);
                file_path = sprintf('%s/%s', test_num, filename);
                fprintf(fileID, '%s %s\n', file_path, subj_name);
            end
        end
        fclose(fileID);
end

end
