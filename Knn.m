function [updateDecisionMap] = Knn(edgeMap,diffusionMap,decisionMap,step,boxCheck)
%knn clustering algorithm
edgeMap(edgeMap==0&diffusionMap==1)=3;
for i=1:step
    mask1=false(size(edgeMap));
    mask2=false(size(edgeMap));
    mask1(edgeMap==1)=true;
    mask2(edgeMap==2)=true;
    mask2=imdilate(mask2,strel('disk',step));
    mask1=imdilate(mask1,strel('disk',step));
    union=mask2&mask1;
    edgeMap(mask1==1&~union&edgeMap==3)=1;
    edgeMap(mask2==1&~union&edgeMap==3)=2;
end
decisionMap(edgeMap==1)=1;
decisionMap(edgeMap==2)=2;
[height,width] = size(edgeMap);
region_size=4;
if boxCheck==true
for i=1:height
    for j=1:width
        if edgeMap(i,j)==3
                region = decisionMap(max(1, j-region_size):min(height, j+region_size),max(1, j-region_size):min(width, j+region_size));
                num_ones=sum(region(:)==1);
                num_twos=sum(region(:)==2);
                if(num_ones>=num_twos*2)
                    decisionMap(i,j)=1;
                elseif(num_ones*2<=num_twos)
                    decisionMap(i,j)=2;
                end
        end
    end
end
decisionMap=imclose(decisionMap-1,strel('disk',2))+1;
updateDecisionMap=decisionMap;
else
decisionMap(edgeMap==3)=3;
updateDecisionMap=decisionMap;
end
end