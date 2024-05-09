function [images,enhanchedImage,guiedI] = readImages(path,suffix)
% read images in the folder
 folder=path;
 files = dir(fullfile(folder,suffix));
 dataset = cell(1,length(files));
 enhanchedImage=cell(1,length(files));
 for i=1:length(files)
     filename=fullfile(folder,files(i).name);
     img=imread(filename);
     figure;imshow(img);
     dataset{i}=img;
     enhanchedImage{i}=histeq(img);
 end
 guiedI=min(enhanchedImage{1},enhanchedImage{2});
 images=dataset;
 fprintf('There are %d images.\n',numel(dataset));
end
