% This software was developed using functions source code provided by:
% https://github.com/bytefish/facerec
% under the following BSD license:

% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

% Gonzalo Benito, Universitat Autonoma de Barcelona, 2017.

function [images] = gather_img(path, folder, n_images) 
if nargin == 3
%     images = cell(1,n_images);
    images = {};
end
names = {};
n = 1;

for i=1:length(folder)
    subject = folder{i};
    %index = i + (length(folder)*(i-1));
	images_pre = list_files([path, filesep, subject]);
	if isempty(images_pre)
		continue; %% dismiss files or empty folder
    end
    %% Load a fixed set of samples noticing rotation angles
    if nargin == 3
        aux = ditributeimg(images_pre,n_images);
        for index=1:length(aux)
            images{end+1} = aux{index};
        end
    else
    % Or load all images in directory as in original function
        images = images_pre;
    end
    clearvars images_pre

    added = 0;
    names{n} = subject;
end

% only increment class if images were actually added!
if ~(added == 0)
    n = n + 1;
end