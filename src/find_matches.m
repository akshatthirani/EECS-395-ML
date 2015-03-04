function [ locations, classes ] = find_matches( image_in, window_size, model )
%find_matches Find matches of a set number classes and return locations

assert(numel(window_size) == 2);

left_end = floor(window_size(1)/2);
right_end = window_size(1)-left_end;
bottom_end = floor(window_size(2)/2);
top_end = window_size(2)-bottom_end;

pyr_depth = floor(log(min(size(image_in)))/log(2)+1);
pyramid = cell(pyr_depth,1);
pyramid{1} = image_in;

locations = [];
classes = [];

for d=2:pyr_depth
   pyramid{d} = impyramid(pyramid{d-1},'reduce'); 
end

for d=1:pyr_depth
    for i=(left_end):(size(pyramid{d},1)-right_end)
       for j=(bottom_end):(size(pyramid{d},2)-top_end)
           [class] = match(image_in((i-left_end+1):(i+right_end),(j-bottom_end+1):(j+bottom_end)), model);
           if ~strcmp(class, 'null')
               locations = [locations; d*[i, j]];
               classes = [classes; class];
           end
       end
    end
end

