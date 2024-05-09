function [updateMap1,updateMap2] = computeDiffusion(initialMaps,enhanchedImages)
%extract the defocus spread effect near the boundaries
eq_img1=enhanchedImages{1};
eq_img2=enhanchedImages{2};
min_img=min(enhanchedImages{1},enhanchedImages{2});
max_img=max(enhanchedImages{1},enhanchedImages{2});

diff_img=max_img-min_img; % the variance of pixel
if size(diff_img,3)==3
  gray_img=rgb2gray(diff_img);
elseif size(diff_img,3)==1
  gray_img=diff_img;
end

if size(eq_img2,3)==3
    eq_img2_gray=rgb2gray(eq_img2);
elseif size(eq_img2,3)==1
    eq_img2_gray=eq_img2;
end

if size(eq_img1,3)==3
    eq_img1_gray=rgb2gray(eq_img1);
elseif size(eq_img1,3)==1
    eq_img1_gray = eq_img1;
end

ave_img=(double(eq_img2_gray)+double(eq_img1_gray))/2; % the distribution of pixel
a=0.01;
c=128;
transformI=1./(1+exp(a*abs(ave_img-c)));
img_normalized=double(gray_img)/255;
alpha=exp(1)-1;
logI=log(1+alpha*img_normalized);
diffuse=uint8(logI.*transformI*255);
binary=imbinarize(diffuse,"global");
se=strel('disk',3);
diffuse=imdilate(binary,se);

% Extracting edge information and categorizing.
ref=max(initialMaps{1,1},initialMaps{1,2});
map1=uint8(zeros(size(gray_img)));
map1(ref==initialMaps{1,2})=2;
map1(ref==initialMaps{1,1})=1;


ref=max(initialMaps{2,1},initialMaps{2,2});
map2=zeros(size(gray_img));
map2(ref==initialMaps{2,2})=2;
map2(ref==initialMaps{2,1})=1;
map2=medfilt2(map2,[8,8]);
map2=uint8(map2);

if size(min_img,3)==1
    min_img_gray=min_img;
elseif size(min_img,3)==3
    min_img_gray=rgb2gray(min_img);
end

edgeI =edge(min_img_gray,'sobel')|edge(min_img_gray,'canny',0.15);
edgeClass=uint8(zeros(size(edgeI)));
edgeClass(edgeI==1&map1==2&map2==2)=2;
edgeClass(edgeI==1&map1==1&map2==1)=1;

% update two initial maps
updateMap1=Knn(edgeClass,diffuse,map1,5,true);
updateMap2=Knn(edgeClass,diffuse,map2,5,true);
