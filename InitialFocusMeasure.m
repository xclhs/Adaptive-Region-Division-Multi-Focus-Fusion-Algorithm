function [InitialMaps] = InitialFocusMeasure(Images,Settings,guiedI)
%compute the activity level of images
if nargin<1
    % check the number of Parameter
    Images=cell(1,1);
    Images{1}=[1,2,3,4;5,6,7,8;9,10,11,12;13,14,15,16];
    Settings.MaxScale=2;
end
nums = numel(Images);
if nums==0
    disp('There is no image to process!\n');
    return;
end

InitialMaps=cell(2,nums);

sobelX=[-1 0 1;-2 0 2;-1 0 1];
sobelY=[-1 -2 -1;0 0 0;1 2 1];
paddingSize=1;
for i=1:nums
    img=Images{i};
    if size(img,3)==3
        img = rgb2gray(img);
    end
    img=double(img);
    Iguided = imguidedfilter(img,guiedI);
    se=strel('disk',1);
    if  isfield(Settings,'MaxScale')
        paddedImg = padarray(Iguided,[paddingSize,paddingSize],"symmetric");
        gradX = conv2(paddedImg,sobelX,'valid');
        gradY = conv2(paddedImg,sobelY,'valid');
        Ivar = gradX.^2+gradY.^2;

        InitialMaps{1,i}=imgaussfilt(Ivar,Settings.MaxScale);
        % Tenengrad

        db=Iguided-imopen(Iguided,se);
        dd=imclose(Iguided,se)-Iguided;
        InitialMaps{2,i}=imguidedfilter(imgaussfilt(max(db,dd),7),guiedI);
        % Morphological filtering
    end
end
end