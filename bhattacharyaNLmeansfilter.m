function [output]=bhattacharyaNLmeansfilter(input,t,f,h)
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %  input: image to be filtered
 %  t: radio of search window
 %  f: radio of similarity window
 %  h: degree of filtering
 %
 %  Author: Jose Vicente Manjon Herrera & Antoni Buades
 %  Date: 09-03-2006
 %
 %  Implementation of the Non local filter proposed for A. Buades, B. Coll and J.M. Morel in
 %  "A non-local algorithm for image denoising"
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Size of the image
 [m n]=size(input);
 
 
 % Memory for the output
 Output=zeros(m,n);
 % Replicate the boundaries of the input image
 input2 = padarray(input,[f f],'symmetric');
 
 % Used kernel
 kernel = make_kernel(f);
 kernel = kernel / sum(sum(kernel));
 
 h=h*h;
 
 for i=1:m
 for j=1:n
                 
         i1 = i+ f;
         j1 = j+ f;
                
         W1= input2(i1-f:i1+f , j1-f:j1+f);
         
         wmax=0; 
         average=0;
         sweight=0;
         
         rmin = max(i1-t,f+1);
         rmax = min(i1+t,m+f);
         smin = max(j1-t,f+1);
         smax = min(j1+t,n+f);
         
         for r=rmin:1:rmax
         for s=smin:1:smax
                                               
                if(r==i1 && s==j1) continue; end;
                                
                W2= input2(r-f:r+f , s-f:s+f);                
                 
                d = bhattacharyya(W1,W2);
                                               
                w=exp(-d/h);
                
                                 
                if w>wmax                
                    wmax=w;                   
                end
                
                sweight = sweight + w;
                average = average + w*input2(r,s);                                  
         end 
         end
             
        average = average + wmax*input2(i1,j1);
        sweight = sweight + wmax;
                   
        if sweight > 0
            output(i,j) = average / sweight;
        else
            output(i,j) = input(i,j);
        end                
 end
 end
 

function d=bhattacharyya(X1,X2)
% BHATTACHARYYA  Bhattacharyya distance between two Gaussian classes
%
% d = bhattacharyya(X1,X2) returns the Bhattacharyya distance between X1 and X2.
%
% Inputs: X1 and X2 are n x m matrices represent two sets which have n
%         samples and m variables.
%
% Output: d is the Bhattacharyya distance between these two sets of data.
%
% Example:
%{
N=100;
M=10;
e1=2;
e2=5;
c1=3;
c2=7;
X1 = c1*randn(N,M)+e1;
X2 = c2*randn(N,M)+e2;
d = bhattacharyya(X1,X2);
%}
% Reference:
% Kailath, T., The Divergence and Bhattacharyya Distance Measures in Signal
% Selection, IEEE Trasnactions on Communication Technology, Vol. 15, No. 1,
% pp. 52-60, 1967
%
% By Yi Cao at Cranfield University on 8th Feb 2008.
%
%Check inputs and output
error(nargchk(2,2,nargin));
error(nargoutchk(0,1,nargout));
[n,m]=size(X1);
% check dimension 
% assert(isequal(size(X2),[n m]),'Dimension of X1 and X2 mismatch.');
assert(size(X2,2)==m,'Dimension of X1 and X2 mismatch.');
mu1=sum(sum(mean(X1)));
C1=sum(sum(cov(X1)));
mu2=sum(sum(mean(X2)));
C2=sum(sum(cov(X2)));
C=(C1+C2)/2;
dmu=(mu1-mu2)/chol(C);

try
    d=0.125*dmu*dmu'+0.5*log(det(C/chol(C1*C2)));
catch
    d=0.125*dmu*dmu'+0.5*log(abs(det(C/sqrtm(C1*C2))));
    warning('MATLAB:divideByZero','Data are almost linear dependent. The results may not be accurate.');
end
% d=0.125*dmu*dmu'+0.25*log(det((C1+C2)/2)^2/(det(C1)*det(C2)));