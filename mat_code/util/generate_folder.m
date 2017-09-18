% This software was developed using source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.

function generate_folder()
addpath (genpath ('.'));
for n=0:9
    stage = n;
    train_stage = sprintf('train_%d', stage);
    path = sprintf('%s\\%s', 'C:\dev\facerec\MIT\train', train_stage);
    folder = list_files(path);
    n_images = 150;
    
    % FDetect = vision.CascadeObjectDetector;
    
    images = gather_img(path, folder, n_images);
    
    % for i=1:length(folder)
    %     filename = folder{i};
    for i=1:length(images)
        filename = images{i};
        subj_name = filename(1:4);
    %     file_path = sprintf('%s\\%s', path, filename);
        file_path = sprintf('%s\\%s\\%s', path, subj_name, filename);
        newSubFolder = sprintf('%s\\%d\\%s\\%s', 'C:\dev\facerec\MIT_img_prog\train', n_images, train_stage, subj_name);
        % Finally, create the folder if it doesn't exist already.
        if ~exist(newSubFolder, 'dir')
            mkdir(newSubFolder);
        end
        fname = [filename(1:end-4),'.jpg'];
        output_file = sprintf('%s\\%s', newSubFolder, fname);
        if exist(output_file, 'file')
            sprintf('File already exists...')
        else
    %     if (strncmp(filename,strcat(subj_name,'_L2'),6) || strncmp(filename,strcat(subj_name,'_L3'),6) ||...
    %         strncmp(filename,strcat(subj_name,'_L4'),6) || strncmp(filename,strcat(subj_name,'_R2'),6) ||...
    %         strncmp(filename,strcat(subj_name,'_R3'),6) || strncmp(filename,strcat(subj_name,'_R4'),6))
    %         
    %         sprintf('Not good profile pic...')
    %     else 
        I = imread(file_path);
    %         Iout = imresize(I,[320 320]);
    %         I = imresize(I,0.25);
    %         BB = step(FDetect,I);
    %         if isempty(BB)
    %             sprintf('No face detected')
    %         elseif size(BB,1)==1
    % %             I2 = extract_face(I,BB(1,:));
    %             I2 = imcrop(I,BB(1,:));
    %             Iout = imresize(I2,[160 160]);
    %             imwrite(Iout, output_file);
    %         else
    %             Area = BB(:,3).*BB(:,4);
    %             [M,index] = max(Area);
    % %             I2 = extract_face(I,BB(index,:));
    %             I2 = imcrop(I,BB(index,:));
    %             clearvars M;
    %             Iout = imresize(I2,[160 160]);
    %             imwrite(Iout, output_file);
    %         end
            imwrite(I, output_file);
        end
    end
    sprintf('Face detection finished')
%    copyfile(file_path,newSubFolder);
end
end