clc;
close all;
% Clear command window and close all open figure windows.


total_time = 0;
% Timing initialization

 currentPath = pwd;
 imageFolderPath = fullfile(currentPath,"MFFW\MFFW2_image\1");
 [images,enhancedImages,guiedI]=readImages(imageFolderPath, '*.tif');
% Load images


   settings.MaxScale =4;
   [initialMaps] = InitialFocusMeasure(images,settings,guiedI);
   % compute the activity level of images
    
   [updateMap1,updateMap2]=computeDiffusion(initialMaps,enhancedImages);
   % extract the defocus spread effect near the focus boundaries
    
    Map=Postprocessing(updateMap1,updateMap2,guiedI,initialMaps);
    % internal errors correction
    result=smoothImage(Map,images);

    file_name = sprintf('result.tif');
    % smoothing
    imwrite(result,file_name);





