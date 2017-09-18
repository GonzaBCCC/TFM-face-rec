function ordered_imgs = ditributeimg(images_pre,n_images)

% List how many rotation angles there are
for i=1:length(images_pre)
    img_name = images_pre{i};
    cell_name{i} = img_name(1:8);
end
singles = unique(cell_name);
ordered_singles = reorder_cell(singles);
% Round the required number of images per angle given the number of samples
% requested (minimum 1 image per angle)
images_per_angle = round((n_images/length(ordered_singles)));
% Array of samples distributed over angles
% ordered_imgs = cell(length(singles),images_per_angle);
ordered_imgs={};
% Fill the cell array
for j=1:length(ordered_singles)
    % Find the filenames that belong to a same rotation angle and fill the
    % array.
    indexes = find(strncmp(ordered_singles{j},images_pre,8),images_per_angle);
    for k=1:length(indexes)
        ordered_imgs{end + 1} = images_pre{indexes(k)};
    end
end 
%counter for underfill cases
p = 1;
%check for dimensions mismatch
while(length(ordered_imgs)) < n_images
    indexes = find(strncmp(ordered_singles{p},images_pre,8),images_per_angle + p);
    ordered_imgs{end + 1} = images_pre{indexes(end)};
    p = p+1;
end    
% If images per angle is over the limit of n_images, then cut down samples
% to match n_images.
if n_images < length(ordered_imgs)
    dropout = length(ordered_imgs) - n_images;
    ordered_imgs (end +1-dropout :end) = [];
end

end