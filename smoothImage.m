function [result] = smoothImage(decisionMap,datas)
%smoothing the focus boundaries
if size(datas{1},3)==3
    grayI1=rgb2gray(datas{1});
elseif size(datas{1},3)==1
    grayI1=datas{1};
end

if size(datas{2},3)==3
    grayI2=rgb2gray(datas{2});
elseif size(datas{1},3)==1
    grayI2=datas{2};
end

minI=min(grayI1,grayI2);
result=double(datas{2}).*decisionMap+double(datas{1}).*(1-decisionMap);
result=uint8(result);
edge1=edge(grayI1-minI,'canny');
edge2=edge(grayI2-minI,'canny');
edge3=edge2|edge1;
edge3=imdilate(edge3,strel('disk',2));
if size(result,3)==3
    result_gray=rgb2gray(result);
elseif size(result,3)==1
    result_gray=result;
end

edgeI=edge(result_gray-minI,'canny',0.2);
focus=edgeI&~edge3;
i=0;
while 1
    if ~any(focus(:))||i==20
        break
    end
    focus=imdilate(focus,strel("disk",2));
    filterI=imgaussfilt(decisionMap,6);
    decisionMap(focus)=filterI(focus);
    result=double(datas{2}).*decisionMap+double(datas{1}).*(1-decisionMap);
    result=uint8(result);

    if size(result,3)==3
        result_gray=rgb2gray(result);
    elseif size(result,3)==1
        result_gray=result;
    end
    edgeI=edge(result_gray-minI,'canny',0.2);
    focus=edgeI&~edge3;
    i=i+1;
end
result=uint8(result);
figure;imshow(result);
end