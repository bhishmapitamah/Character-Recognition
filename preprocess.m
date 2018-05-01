function IMG = preprocess(img)

redChannel = img(:, :, 1);
greenChannel = img(:, :, 2);
blueChannel = img(:, :, 3);
I =.2989*(redChannel) +  .587*(greenChannel) +   .114*(blueChannel);
Im = im2uint8(I(:));

counts = imhist(Im,256);
counts = double(counts(:));
K = counts / sum(counts);
cumSum = cumsum(K);
cu = cumsum(K .* (1:256)');
cu1 = cu(end);
sigmaSquared = (cu1 * cumSum - cu).^2 ./ (cumSum .* (1 - cumSum ));
maxval = max(sigmaSquared);
isfiniteMaxval = isfinite(maxval);

if isfiniteMaxval
    idx = mean(find(sigmaSquared == maxval));   
    t = (idx - 1) /255;
else
    t = 0.0;
end

IMG = (I > 255 *t);