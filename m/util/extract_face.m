% Copyright (c) Gonzalo Benito. All rights reserved.
% Licensed under the BSD license. See LICENSE file in the project root for full license information.

function I2 = extract_face(I, BB)

side  = sqrt(1.5 *(BB(:,3).^2));

offset = round((side-BB(:,3))/2);

BB2 = [BB(:,1)-offset, BB(:,2)-offset, BB(:,3) + (offset*2), side + (offset*2)];

I2 = imcrop(I,BB2);
end