% Copyright (c) Gonzalo Benito. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

function ordered_singles = reorder_cell(singles)
ordered_singles = cell(size(singles));
for i=1:length(singles)
    aux = strsplit(char(singles(i)),'_');
    disordered (i) = str2num(char(aux(2)));
end
A = sort(disordered, 'descend');

for j=1:length(singles)
    IndexC = strfind(singles, sprintf('_%d',A(j)));
    Index = find(not(cellfun('isempty', IndexC)));
    ordered_singles(j)= singles(Index);
end

end