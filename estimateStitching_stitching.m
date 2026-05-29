function [savedOutputStichingNormal, savedOutputStichingTop] = estimateStitching_stitching(imgLeft, imgRight, ptsL_stitching, ptsR_stitching, ptsL_DLT, ptsR_DLT);


%--------------------------------------------------------------------------
%------------------Computer Stitching with camera angle view---------------
%--------------------------------------------------------------------------
%---Calculate homography
[hImg, wImg, ~] = size(imgLeft);
tformR2L = estgeotform2d(ptsR_stitching, ptsL_stitching, 'projective', 'MaxDistance', 3.0, 'MaxNumTrials', 5000);
H_r2l = tformR2L.A;  %3x3 projective matrix
%---

%---Apply center projection
H_cv = H_r2l';  %Now column-vector convention: p' = H_cv * p
H_cv = H_cv / H_cv(3,3);
H_half_cv = real(sqrtm(H_cv));
H_half_cv = H_half_cv / H_half_cv(3,3);

H_centerLeft_cv  = H_half_cv \ eye(3); %Center-left transform
H_centerRight_cv = H_half_cv; %Center-right transform
H_centerLeft_row  = H_centerLeft_cv'; %convert to row vector
H_centerRight_row = H_centerRight_cv'; %convert to row vector

tformLeft  = projtform2d(H_centerLeft_row); %get projection for left
tformRight = projtform2d(H_centerRight_row); %get projection for right
%---

%---Build canva
corners = [1, 1; wImg, 1; wImg, hImg; 1, hImg];

cornersL = transformPointsForward(tformLeft,  corners);
cornersR = transformPointsForward(tformRight, corners);

allCorners = [cornersL; cornersR];
xMin = floor(min(allCorners(:,1)));
xMax = ceil(max(allCorners(:,1)));
yMin = floor(min(allCorners(:,2)));
yMax = ceil(max(allCorners(:,2)));

canvasRef = imref2d([yMax - yMin + 1, xMax - xMin + 1], [xMin, xMax], [yMin, yMax]);
%---

%---Warp both images
warpedLeft  = imwarp(imgLeft,  tformLeft,  'OutputView', canvasRef, 'Interp', 'linear', 'FillValues', 0);
% figure; imshow(warpedLeft);
warpedRight = imwarp(imgRight, tformRight, 'OutputView', canvasRef, 'Interp', 'linear', 'FillValues', 0);
% figure; imshow(warpedRight);
%---

%---Create masks
onesImg = ones(hImg, wImg, 'uint8') * 255;
maskLeft  = imwarp(onesImg, tformLeft,  'OutputView', canvasRef, 'Interp', 'nearest', 'FillValues', 0) > 0; %create mask left
maskRight = imwarp(onesImg, tformRight, 'OutputView', canvasRef, 'Interp', 'nearest', 'FillValues', 0) > 0; %create mask right
% figure; imshow(maskLeft);
% figure; imshow(maskRight);
%---

%---Blending
overlapMask  = maskLeft & maskRight;
onlyLeftMask = maskLeft & ~maskRight;
onlyRightMask = ~maskLeft & maskRight;

distL = bwdist(~maskLeft); %Distance transforms for feathered blending
distR = bwdist(~maskRight); %Distance transforms for feathered blending
totalDist = distL + distR;
totalDist(totalDist == 0) = 1;  %Avoid division by zero

weightL = distL ./ totalDist;
weightR = distR ./ totalDist;

[canvasH, canvasW, ~] = size(warpedLeft); %Blend
result = zeros(canvasH, canvasW, 3, 'double'); %Blend

for c = 1:3;
    chL = double(warpedLeft(:,:,c));
    chR = double(warpedRight(:,:,c));
    blended = weightL .* chL + weightR .* chR;
    
    % Override: only-left and only-right regions
    ch = blended;
    ch(onlyLeftMask)  = chL(onlyLeftMask);
    ch(onlyRightMask) = chR(onlyRightMask);
    ch(~maskLeft & ~maskRight) = 0;
    
    result(:,:,c) = ch;
end;
result = uint8(min(max(result, 0), 255));
% figure;imshow(result);
%---

% %---Fit image to the largest valid rectangle
% combinedMask = maskLeft | maskRight;
% 
% %Find content bounding box
% rowsAny = any(combinedMask, 2);
% colsAny = any(combinedMask, 1);
% rMin = find(rowsAny, 1, 'first');
% rMax = find(rowsAny, 1, 'last');
% cMin = find(colsAny, 1, 'first');
% cMax = find(colsAny, 1, 'last');
% 
% %Search for best inscribed rectangle
% bestArea = 0;
% bestRect = [rMin, rMax, cMin, cMax];
% stepSize = 2;
% maxShrink = floor((rMax - rMin) / 4);
%     
% for topShrink = 0:stepSize:maxShrink;
%     for botShrink = 0:stepSize:maxShrink;
%         r0 = rMin + topShrink;
%         r1 = rMax - botShrink;
%         if r1 <= r0;
%             continue;
%         end;
%         
%         %Check which columns are fully filled in this row band
%         band = combinedMask(r0:r1, :);
%         colFilled = all(band, 1);
%         
%         if ~any(colFilled);
%             continue;
%         end;
%         
%         c0 = find(colFilled, 1, 'first');
%         c1 = find(colFilled, 1, 'last');
%         area = (r1 - r0) * (c1 - c0);
%         
%         if area > bestArea;
%             bestArea = area;
%             bestRect = [r0, r1, c0, c1];
%         end;
%     end;
% end;
% r0 = bestRect(1); r1 = bestRect(2);
% c0 = bestRect(3); c1 = bestRect(4);
% crop = result(r0:r1, c0:c1, :);

%---Resize to 4K and center
outW = 3840;
outH = 2160;
[cropH, cropW, ~] = size(result);
s = min(outW / cropW, outH / cropH);
newW = round(cropW * s);
newH = round(cropH * s);
resized = imresize(result, [newH, newW], 'lanczos3');

final = zeros(outH, outW, 3, 'uint8'); %Center on black canvas
yOff = floor((outH - newH) / 2) + 1;
xOff = floor((outW - newW) / 2) + 1;
final(yOff:yOff+newH-1, xOff:xOff+newW-1, :) = resized;

% figure; imshow(final)
%---

%---Save key elemets
savedOutputStichingNormal.tformLeft = tformLeft;
savedOutputStichingNormal.tformRight = tformRight;
savedOutputStichingNormal.canvasRef = canvasRef;

savedOutputStichingNormal.maskLeft = maskLeft;
savedOutputStichingNormal.maskRight = maskRight;
savedOutputStichingNormal.weightL = weightL;
savedOutputStichingNormal.weightR = weightR;
savedOutputStichingNormal.resultCanva = zeros(canvasH, canvasW, 3, 'double');

savedOutputStichingNormal.outH = outH;
savedOutputStichingNormal.outW = outW;
savedOutputStichingNormal.finalCanva = zeros(outH, outW, 3, 'uint8');
savedOutputStichingNormal.finalCrop = [yOff yOff+newH-1 xOff xOff+newW-1];
savedOutputStichingNormal.imgpanorama = final;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
%--------------------Computer Stitching with top-down view-----------------
%--------------------------------------------------------------------------
if isempty(ptsL_DLT) == 0;
    %need real world coordinates

    %---Calculate homography ... right image to left image space (using RANSAC)
    [h_img, w_img, ~] = size(imgLeft);

    [tform_R2L, inlierIdx] = estimateGeometricTransform2D( ...
    ptsR_stitching, ptsL_stitching, 'projective', ...
        'MaxDistance', 2.0, 'Confidence', 99.9);
    H_R2L = tform_R2L.T';
    %---

    %---Convert right control points into the left image space
    uv_L = ptsL_DLT(:,1:2);
    uv_R = ptsR_DLT(:,1:2);
    xy_L = ptsL_DLT(:,3:4);
    xy_R = ptsR_DLT(:,3:4);

    nR = size(uv_R, 1);
    uv_R_h = [uv_R, ones(nR, 1)];
    uv_R_in_L_h = (H_R2L * uv_R_h')';
    uv_R_in_L = uv_R_in_L_h(:,1:2) ./ uv_R_in_L_h(:,3);

    all_uv = [uv_L; uv_R_in_L]; 
    all_xy = [xy_L; xy_R]; 
    %---

    %---Compute homography from left image space to real world space
    tform_pix2world = fitgeotform2d(all_uv, all_xy, 'projective');
    H_pix2world = tform_pix2world.A;
    %---

    %---Convert World to 4K output view
    x_min_world = -5; %-5m
    x_max_world = 55; %+55m
    y_min_world = -5; %-5m
    y_max_world = 30; %+30m
    out_w = 3840;
    out_h = 2160;

    world_width  = x_max_world - x_min_world;
    world_height = y_max_world - y_min_world;
    scale = min(out_w / world_width, out_h / world_height);
    
    used_w = scale * world_width;
    used_h = scale * world_height;
    ox = (out_w - used_w) / 2;
    oy = (out_h - used_h) / 2;

    H_world2out = [scale  0     -scale*x_min_world + ox;
               0      scale -scale*y_min_world + oy;
               0      0      1];
    %---

    %---Composite last (composite) homographies
    H_L2out = H_world2out * H_pix2world;
    H_R2out = H_world2out * H_pix2world * H_R2L;

    tform_L2out = projective2d(H_L2out');
    tform_R2out = projective2d(H_R2out');
    %---

    %---Warp both images into the real world view
    outputRef = imref2d([out_h, out_w], [0.5, out_w+0.5], [0.5, out_h+0.5]); %output reference

    warpL = imwarp(imgLeft,  tform_L2out,  'OutputView', outputRef, 'InterpolationMethod', 'cubic');
    warpR = imwarp(imgRight, tform_R2out, 'OutputView', outputRef, 'InterpolationMethod', 'cubic');

%     figure; imshow(warpedLeft);
%     figure; imshow(warpedRight);

    maskL_bin = imwarp(ones(h_img, w_img, 'single'), tform_L2out, ...
                   'OutputView', outputRef, 'InterpolationMethod', 'nearest');
    maskR_bin = imwarp(ones(h_img, w_img, 'single'), tform_R2out, ...
                   'OutputView', outputRef, 'InterpolationMethod', 'nearest');
    %---

    %---Blending
    distL = bwdist(~(maskL_bin > 0));
    distR = bwdist(~(maskR_bin > 0));
    
    overlap = (maskL_bin > 0) & (maskR_bin > 0);
    total = single(distL) + single(distR) + 1e-8;

    weightL = zeros(out_h, out_w, 'single');
    weightR = zeros(out_h, out_w, 'single');
    
    onlyL = (maskL_bin > 0) & ~overlap;
    onlyR = (maskR_bin > 0) & ~overlap;
    weightL(onlyL) = 1;
    weightR(onlyR) = 1;
    
    weightL(overlap) = single(distL(overlap)) ./ total(overlap);
    weightR(overlap) = single(distR(overlap)) ./ total(overlap);
    
    output = uint8( single(warpL) .* weightL ...
              + single(warpR) .* weightR );

    %---Crop and resize
    grayOut = rgb2gray(output);
    rowMask = any(grayOut > 0, 2);
    colMask = any(grayOut > 0, 1);
    
    rMin = find(rowMask, 1, 'first');
    rMax = find(rowMask, 1, 'last');
    cMin = find(colMask, 1, 'first');
    cMax = find(colMask, 1, 'last');

    cropped = output(rMin:rMax, cMin:cMax, :);
    final = imresize(cropped, [2160, 3840], 'lanczos3');

%     figure;imshow(final)

    %---

    %---Save key elemets
    savedOutputStichingTop.outputRefCanva = outputRef;
    savedOutputStichingTop.tform_L2out = tform_L2out;
    savedOutputStichingTop.tform_R2out = tform_R2out;
    savedOutputStichingTop.distL = distL;
    savedOutputStichingTop.distR = distR;
    savedOutputStichingTop.weightL = weightL;
    savedOutputStichingTop.weightR = weightR;
    savedOutputStichingTop.crop = [rMin rMax cMin cMax];
    savedOutputStichingTop.imgpanorama = final;
    %---
else;
    
    savedOutputStichingTop = [];

end;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% end;



function ptsOut = transformPointsH(H, ptsIn)
    n = size(ptsIn, 1);
    ptsH = [ptsIn, ones(n, 1)]';   % 3×N
    proj = H * ptsH;                % 3×N
    ptsOut = (proj(1:2,:) ./ proj(3,:))';  % N×2
% end

function H = computeHomographyDLT(srcPts, dstPts);
    n = size(srcPts, 1);
    %---Normalise source points
    [srcNorm, Tsrc] = normalisePoints(srcPts);
    [dstNorm, Tdst] = normalisePoints(dstPts);
    %---

    %---Build the 2N × 9 matrix A
    A = zeros(2*n, 9);
    for i = 1:n
        x  = srcNorm(i,1);  y  = srcNorm(i,2);
        xp = dstNorm(i,1);  yp = dstNorm(i,2);
        A(2*i-1, :) = [-x -y -1  0  0  0  xp*x  xp*y  xp];
        A(2*i,   :) = [ 0  0  0 -x -y -1  yp*x  yp*y  yp];
    end
    %---

    %---Solve Ah = 0 via SVD
    [~, ~, V] = svd(A, 'econ');
    h = V(:, end);
    Hn = reshape(h, [3, 3])';
    %---

    %---De-normalise
    H = Tdst \ Hn * Tsrc;
    H = H / H(3,3);  % normalise so H(3,3) = 1
    %---
% end

function [ptsNorm, T] = normalisePoints(pts);
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
% end
