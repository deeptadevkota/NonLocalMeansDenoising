%I = imread('cameraman.tif');
%imtool(I,[]);

I = imread('lena_std.tif');
I=imresize(I,[256 256]);
I = rgb2gray(I);

I = double(I);
n=20*randn(size(I));
I1 = I + n;
%imtool(I1,[]);


I2 = NLmeansfilter(I1,2,1, 20);
ssimval2 = ssim(I2,I);
peaksnr2 = PSNR(I2,I);
%imtool(I2,[]);

I3 = improvedNLmeansfilter(I1,2,1, 20);
ssimval3 = ssim(I3,I);
peaksnr3 = PSNR(I3,I);
%imtool(I3,[]);

I4 = bhattacharyaNLmeansfilter(I1,2,1, 20);
ssimval4 = ssim(I4,I);
peaksnr4 = PSNR(I4,I);
%imtool(I4,[]);

I5 = NLmeansMedianfilter(I1,3,2,1, 20);
ssimval5 = ssim(I5,I);
peaksnr5 = PSNR(I5,I);
%imtool(I5,[]);




