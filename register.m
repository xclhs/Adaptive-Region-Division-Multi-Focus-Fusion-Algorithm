% 读取需要配准的两幅图像
dirpath='/media/student/DATA/program/三维重建/dataset/samples/';
suffix='*.bmp';
images = readImages2(dirpath,suffix);
originalImage = images{1};
num=length(images);
for i=2:num
matchedImage = images{i};
% 将图像转换为灰度图像
grayOriginal = rgb2gray(originalImage);
grayMatched = rgb2gray(matchedImage);

% 检测图像中的 SURF 特征点
keypointsOriginal = detectSURFFeatures(grayOriginal);
keypointsMatched = detectSURFFeatures(grayMatched);

% 提取图像中的 SURF 特征描述子
[featuresOriginal, validKeypointsOriginal] = extractFeatures(grayOriginal, keypointsOriginal);
[featuresMatched, validKeypointsMatched] = extractFeatures(grayMatched, keypointsMatched);

% 对图像中的 SURF 特征点进行匹配
indexPairs = matchFeatures(featuresOriginal, featuresMatched);

% 获取匹配点对的坐标
matchedPointsOriginal = validKeypointsOriginal(indexPairs(:,1)).Location;
matchedPointsMatched  = validKeypointsMatched(indexPairs(:,2)).Location;

% 创建 imref2d 对象
imageSize = size(grayOriginal);
refOriginal  = imref2d(imageSize);
refMatched = imref2d(imageSize);

% 估计两幅图像之间的几何变换关系
tform = estimateGeometricTransform(matchedPointsMatched, matchedPointsOriginal, 'similarity');

% 使用估计的变换关系对待匹配图像进行变换
outputImage = imwarp(matchedImage, tform, 'OutputView', refOriginal);

% 显示配准后的图像
figure;
imshowpair(originalImage, outputImage, 'montage');
title('配准后的图像');
newName = sprintf('image_%d.bmp',i);
imwrite(outputImage,newName);
end