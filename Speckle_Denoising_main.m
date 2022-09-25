I = imread('pout.tif');
%I=imresize(I,[256 256]);
%I = rgb2gray(I);

%I = double(I);
imtool(I,[]);

I1 = imnoise(I,'speckle',0.02);
I1 = double(I1);
I = double(I);
imtool(I1,[]);


I2 = NLmeansfilter(I1,2,1, 20);
imtool(I2,[]);
ssimval2 = ssim(I2,I);
peaksnr2 = PSNR(I2,I);

I3 = improvedNLmeansfilter(I1,2,1, 20);
imtool(I3,[]);
ssimval3 = ssim(I3,I);
peaksnr3 = PSNR(I3,I);

I4 = bhattacharyaNLmeansfilter(I1,2,1, 20);
imtool(I4,[]);
ssimval4 = ssim(I4,I);
peaksnr4 = PSNR(I4,I);

I5 = NLmeansMedianfilter(I1,3,2,1, 20);
imtool(I5,[]);
ssimval5 = ssim(I5,I);
peaksnr5 = PSNR(I5,I);

I6 = NLmeansfilterPCC(I1,2,1, 20);
imtool(I6,[]);
ssimval6 = ssim(I6,I);
peaksnr6 = PSNR(I6,I);





