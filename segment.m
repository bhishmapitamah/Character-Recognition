function [X, thintime] = segment(Img)

thintime = 0;
Img = [ones(size(Img,1),1) Img ones(size(Img,1),1)];
Hsum = sum(Img,2);
Hsum = max(Hsum) - Hsum;
Lregion = Hsum > (min(Hsum)+4);
dw = diff(Lregion);
Lstart = find(dw>0);
Lend = find(dw<0);
rw = size(Lstart, 1);
X = [];
seg = 0;

    seg = seg+1;
    segImg = Img(Lstart(1):Lend(end), :);
    Vsum = sum(segImg, 1);
    Vsum = max(Vsum) - Vsum;
    Cregion = Vsum > 0; 
    d = diff(Cregion); 
    Cstart = find(d>0);
    Cend = find(d<0);
    c = size(Cstart, 2);
   
    for i = 1:c     
        segChar = segImg(:, Cstart(i):Cend(i)); 
        segChar = [ones(uint8(0.15*size(segChar,1)),size(segChar,2));segChar;ones(uint8(0.20*size(segChar,1)),size(segChar,2))];
        %tstart = tic;segChar = Thinning(segChar);thintime = thintime + toc(tstart);
        [row, col] = size(segChar);
        whitespace = ones(row, 1);
        flag = true;
        while flag == true
              segChar = [whitespace segChar(:,1:end) whitespace];
              col = col + 2;
              if col > row
                 flag = false;
              end
        end
        segChar = imresize(segChar, [25,25]);
        X(seg, :) = segChar(:);
        seg = seg+1;     
    end

end