% Copyright (c) Philipp Wagner. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

function [X y width height names] = read_images(path, n_images)
	%% Read images from a given path and return the Imagematrix X.
	%%
	%% Returns:
	%%  X [numDim x numSamples] Array with images given in columns -- [X1,X2,...,Xn]
	%%  y [1 x numSamples] Classes corresponding to images of X. -- [y1,y2,...,yn]
	%%  width [int] width of the images
	%%  height [int] height of the images
	%%  names [cell array] folder name of each class, so names{1} is the name of class 1
	%%
	%% Example:
	%% 	[X y width height names] = read_images("./data/yalefaces")
	%%
	folder = list_files(path);
	X = [];
	y = [];
	names = {};
	n = 1;
    %modification for intaking different quantities of images per sample
    if nargin == 2
        images = cell(1,n_images);
    end
%     img = cell(7,33);
	for i=1:length(folder)
		subject = folder{i};
		images_pre = list_files([path, filesep, subject]);
		if(length(images_pre) == 0)
			continue; %% dismiss files or empty folder
        end
        %% Load a fixed set of samples noticing rotation angles
        if nargin == 2
            images = ditributeimg(images_pre,n_images);
        else
            % Or load all images in directory as in original function
            images = images_pre;
        end
%         %% Load a random set of samples regardless of rotation angle
%         if nargin == 2
%            r = randi(227,n_images,1);
%            for index=1:length(r)
%             images{index} = images_pre{r(index)}; 
%            end
%         else
%             % Or load all images in directory as in original function
%             images = images_pre;
%         end
        clearvars images_pre

        added = 0;
		names{n} = subject;
		%% build image matrix and class vector
		for j=1:length(images)
			%% absolute path
			filename = [path, filesep, subject, filesep, images{j}]; 

			%% Octave crashes on reading non image files (uncomment this to be a bit more robust)
			%extension = strsplit(images{j}, "."){end};
			%if(~any(strcmpi(extension, {"bmp", "gif", "jpg", "jpeg", "png", "tiff"})))
			%	continue;
			%endif
      
			% Quite a pythonic way to handle failure.... May blow you up just like the above.
			try
				T = double(imread(filename));
			catch
				lerr = lasterror;
				fprintf(1,'Cannot read image %s', filename)
			end
			
			[height width channels] = size(T);
      
			% greyscale the image if we have 3 channels
			if(channels == 3)
				T = (T(:,:,1) + T(:,:,2) + T(:,:,3)) / 3;
			end
      
			%% finally try to append data
			try
				%% Add image as a column vector:
				X = [X, reshape(T,width*height,1)];
				y = [y, n];
				added = added + 1;
			catch
				lerr = lasterror;
				fprintf(1,'Image cannot be added to the Array. Wrong image size?\n')
			end
		end
		% only increment class if images were actually added!
		if ~(added == 0)
			n = n + 1;
		end
	end
end
