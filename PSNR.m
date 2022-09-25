function f = PSNR(k,n)
    mx = max(k(:));
    SE = (k-n).^2;
    MSE = mean(SE(:));
    f = 20 * log10(mx/sqrt(MSE));
end