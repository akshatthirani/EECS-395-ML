function [outI] = extract_patch( inI, height, width)
   
inW = size(inI, 2);
inH = size(inI, 1);
    
desiredWidth = width;
halfDesiredWidth = floor(width/2);

desiredHeight = height;
halfDesiredHeight = floor(height/2);
  
    if (height == width)        
     
        outI = imresize(inI, [height width]);
        
    else 
            
            if (height > width)
                imR = imresize(inI, [height NaN]);
            else
                imR = imresize(inI, [NaN width]);
            end
        
        newW = size(imR, 2);
        midWidth = floor(newW/2)+1;

        newH = size(imR, 1);
        midHeight = floor(newH/2)+1;
        
        outI = imcrop(imR, [midWidth-halfDesiredWidth midHeight-halfDesiredHeight desiredWidth desiredHeight]);
    
    end  
end