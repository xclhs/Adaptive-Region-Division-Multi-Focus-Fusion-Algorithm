function [mapUpdate] = Postprocessing(updateMap1,updateMap2,guiedI,initialMaps)
%Extracting edge information and categorizing.
guiedI=imguidedfilter(guiedI);
if size(guiedI,3)==3
    guiedI=rgb2gray(guiedI);
else  size(guiedI,3)==1
    guiedI=guiedI;
end
edgeI=(edge(guiedI,'sobel')|edge(guiedI,'canny',0.2,0.2));
edgeImage=uint8(edgeI);
edgeImage(edgeImage&updateMap1==1&updateMap2==1)=1;
edgeImage(edgeImage&updateMap1==2&updateMap2==2)=2;
%Internal errors correction
for i=1:2
    logic=logical(false(size(updateMap1)));
    logic(updateMap1==i)=true;
    [L,n] = bwlabel(~logic);
    for j=1:n
        region=(L==j);
        region1=sum(initialMaps{1,1}(region));
        region2=sum(initialMaps{1,2}(region));
        if(any(edgeImage(region&edgeImage~=i))&&abs(region1-region2)/(region2+region1)>0.1)
            continue;
        else
            updateMap1(region)=i;
        end
    end
end
edgeImage(edgeImage&updateMap1==1&updateMap2==1)=1;
edgeImage(edgeImage&updateMap1==2&updateMap2==2)=2;
for i=1:2
    logic=logical(false(size(updateMap1)));
    logic(updateMap2==i)=true;
    [L,n] = bwlabel(~logic);
    for j=1:n
        region=(L==j);
        region1=sum(initialMaps{2,1}(region));
        region2=sum(initialMaps{2,2}(region));        
        if(any(edgeImage(region&edgeImage~=i))&&abs(region1-region2)/(region2+region1)>0.1)
            continue;
        else 
            updateMap2(region)=i;
        end
    end
end
result=double(updateMap2+updateMap1)/2;
result=imgaussfilt(result,2);
result=imguidedfilter(result,guiedI);
mapUpdate=result-1;
end