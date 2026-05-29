function [ptsNorm, T] = normalisePoints(pts)
% NORMALISEPOINTS  Translate & scale so centroid is at origin, mean dist = sqrt(2).
    mu = mean(pts, 1);
    pts0 = pts - mu;
    meanDist = mean(sqrt(sum(pts0.^2, 2)));
    if meanDist < eps
        s = 1;
    else
        s = sqrt(2) / meanDist;
    end
    T = [s  0  -s*mu(1);
         0  s  -s*mu(2);
         0  0   1];
    n = size(pts, 1);
    ptsH = [pts, ones(n,1)]';
    ptsNormH = T * ptsH;
    ptsNorm = ptsNormH(1:2,:)';
end