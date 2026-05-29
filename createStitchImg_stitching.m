function imgPanorama = createStitchImg_stitching(imgLeft, imgRight, savedOutputStichingNormal, savedOutputStichingTop, viewAngle);


if strcmpi(viewAngle, 'NormalView') == 1;
%Camera angle view

    %---Warp both images
    warpedLeft  = imwarp(imgLeft,  savedOutputStichingNormal.tformLeft,  'OutputView', savedOutputStichingNormal.canvasRef, 'Interp', 'linear', 'FillValues', 0);
    % figure; imshow(warpedLeft);
    warpedRight = imwarp(imgRight, savedOutputStichingNormal.tformRight, 'OutputView', savedOutputStichingNormal.canvasRef, 'Interp', 'linear', 'FillValues', 0);
    % figure; imshow(warpedRight);
    %---
    
    
    %---Blending
    overlapMask = savedOutputStichingNormal.maskLeft & savedOutputStichingNormal.maskRight;
    onlyLeftMask = savedOutputStichingNormal.maskLeft & ~savedOutputStichingNormal.maskRight;
    onlyRightMask = ~savedOutputStichingNormal.maskLeft & savedOutputStichingNormal.maskRight;
    result = savedOutputStichingNormal.resultCanva;
    for c = 1:3;
        chL = double(warpedLeft(:,:,c));
        chR = double(warpedRight(:,:,c));
        blended = savedOutputStichingNormal.weightL .* chL +savedOutputStichingNormal.weightR .* chR;
        
        % Override: only-left and only-right regions
        ch = blended;
        ch(onlyLeftMask)  = chL(onlyLeftMask);
        ch(onlyRightMask) = chR(onlyRightMask);
        ch(~savedOutputStichingNormal.maskLeft & ~savedOutputStichingNormal.maskRight) = 0;
        
        result(:,:,c) = ch;
    end;
    result = uint8(min(max(result, 0), 255));
    %---
    
    
    %---Crop and resize
    [cropH, cropW, ~] = size(result);
    s = min(savedOutputStichingNormal.outW / cropW, savedOutputStichingNormal.outH / cropH);
    newW = round(cropW * s);
    newH = round(cropH * s);
    resized = imresize(result, [newH, newW], 'lanczos3');
    imgPanorama = savedOutputStichingNormal.finalCanva;
    imgPanorama(savedOutputStichingNormal.finalCrop(1) : savedOutputStichingNormal.finalCrop(2), savedOutputStichingNormal.finalCrop(3) : savedOutputStichingNormal.finalCrop(4), :) = resized;

else;
%Top down view

    [h_img, w_img, ~] = size(imgLeft);
    %---Warp both images
    warpL = imwarp(imgLeft,  savedOutputStichingTop.tform_L2out,  'OutputView', savedOutputStichingTop.outputRefCanva, 'InterpolationMethod', 'nearest');
    % figure; imshow(warpedLeft);
    warpR = imwarp(imgRight, savedOutputStichingTop.tform_R2out, 'OutputView', savedOutputStichingTop.outputRefCanva, 'InterpolationMethod', 'nearest');
    % figure; imshow(warpedRight);

    maskL_bin = imwarp(ones(h_img, w_img, 'single'), savedOutputStichingTop.tform_L2out, ...
                   'OutputView', savedOutputStichingTop.outputRefCanva, 'InterpolationMethod', 'nearest');
    maskR_bin = imwarp(ones(h_img, w_img, 'single'), savedOutputStichingTop.tform_R2out, ...
                   'OutputView', savedOutputStichingTop.outputRefCanva, 'InterpolationMethod', 'nearest');
    %---

    %---Blending
    output = uint8( single(warpL) .* savedOutputStichingTop.weightL ...
              + single(warpR) .* savedOutputStichingTop.weightR );
    %---

    %---Crop and resize
    grayOut = rgb2gray(output);
    rowMask = any(grayOut > 0, 2);
    colMask = any(grayOut > 0, 1);
    
    rMin = find(rowMask, 1, 'first');
    rMax = find(rowMask, 1, 'last');
    cMin = find(colMask, 1, 'first');
    cMax = find(colMask, 1, 'last');

    cropped = output(rMin:rMax, cMin:cMax, :);
    imgPanorama = imresize(cropped, [2160, 3840], 'lanczos3');
    %---
end;