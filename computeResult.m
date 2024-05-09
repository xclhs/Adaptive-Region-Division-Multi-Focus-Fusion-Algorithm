function [result] = computeResult(Map,images)
%UNTITLED Summary of this function goes here
figure;imshow(1-Map);
result=double(images{2}).*Map+double(images{1}).*(1-Map);
result=uint8(result);
figure;imshow(result);
end
