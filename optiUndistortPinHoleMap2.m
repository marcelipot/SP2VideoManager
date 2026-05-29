function [map_x, map_y, pOpt, extraMappingParams] = optiUndistortPinHoleMap2(params, imsizein, imsizeout, viewType, ptDLTValid, doOptimisation, doTopDown, frame);
% References
% https://docs.opencv.org/4.x/d9/d0c/group__calib3d.html
% https://robots.stanford.edu/cs223b04/JeanYvesCalib/index.html#updates
% https://docs.opencv.org/3.4/da/d54/group__imgproc__transform.html#ga7dfb72c9cf9780a347fbe3d1c47e5d5a
% https://amroamroamro.github.io/mexopencv/matlab/cv.initUndistortRectifyMap.html
% https://kyamagu.github.io/mexopencv/matlab/initUndistortRectifyMap.html


% Creating mapping for pinhole model projection
% Input:
%   param: camera pinhole calibration
%   imRes: distorted image resolution [height width]
%           if 4K [2160 3840]
%   viewType: String
%       "full": keep the entire field of view
%       "valid": valid image only
%   ptDLTValid: image and real word coordinates of points for k optimisation n rows x 4 cols (U V X Y)
%
% Output:
%   mapX and mapY: Optimised mapping projection to create the undistorted image
%   KK: Optimised KK matrix
%   k: Optimised k1, and k2
%   val_residual: [mean RMS Max RMS]
%
% Apply the following to map the image:
% [outputImage, XYHasNaNs] = imagesbuiltinImageInterpolation2D(Idistorted, map_x, map_y, 'nearest', 0);  



%---Define parameters for top-down projection if needed
map_x = [];
map_y = [];
pOpt = [];
extraMappingParams = [];
H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);
S = max(W_out, H_out) / 2;     % radius-normalisation scale = 1920
margin_m = 0.1; % world-space margin around control region as pourcentage


%---Fit orders 4, 6, 8 and pick by parsimony
all_results = cell(3, 1);
for idx = 1:3;
    n_k = idx + 1;             % n_k = 2, 3, 4  ->  poly order 4, 6, 8
    [params, err] = fit(ptDLTValid, n_k, S);
    all_results{idx} = struct('n_k', n_k, 'params', params, 'err', err, ...
                              'rms', rms_(err));
end;
rmses = cellfun(@(r) r.rms, all_results);
[best_rms, ~] = min(rmses);
chosen = find(rmses <= 1.05 * best_rms, 1, 'first');
n_k = all_results{chosen}.n_k;
err = all_results{chosen}.err;


%---sigma outlier rejection
thr = mean(err) + 3 * std(err);
mask = err < thr;
n_dropped = sum(~mask);
if n_dropped > 0;
    idx = find(~mask);
    for k = 1:length(idx);
        i = idx(k);
    end;
end;
pts_clean = ptDLTValid(mask, :);
[params_final, err_final] = fit(pts_clean, n_k, S);


%---Optional 2.5-sigma pass
thr2 = mean(err_final) + 2.5 * std(err_final);
mask2 = err_final < thr2;
extra = sum(~mask2);
if extra > 0;
    pts_clean2 = pts_clean(mask2, :);
    [params2, err2] = fit(pts_clean2, n_k, S);
    if rms_(err2) < rms_(err_final);
        % Rebuild the global mask
        mask_orig  = false(size(ptDLTValid, 1), 1);
        clean_idx  = find(mask);
        for j = 1:length(mask2);
            if mask2(j);
                mask_orig(clean_idx(j)) = true;
            end;
        end;
        mask = mask_orig;
        pts_clean = pts_clean2;
        params_final = params2;
        err_final = err2;
    end;
end;


%---Final parameter unpack + report
[cx, cy, sy, ks, H] = unpack(params_final, n_k);
r = residuals(params_final, pts_clean, n_k, S);
N = size(pts_clean, 1);
rx = r(1:N);
ry = r(N+1:end);

if doTopDown == 1;
    if doOptimisation == 1;
        pOpt.fx = S; %same fx
        pOpt.fy = S; %same fy
        pOpt.cx = cx; %same cx
        pOpt.cy = cy; %same cy
        pOpt.KK = [S sy cx; 0 S cy; 0 0 1]; %same KK
        pOpt.k1 = ks(1); %Optimised k1
        pOpt.k2 = ks(2); %Optimised k2
        pOpt.k3 = 0; %Optimised k3
        pOpt.k4 = 0; %Optimised k4
        pOpt.k5 = 0;
        pOpt.k6 = 0;
        pOpt.p1 = 0; %Optimised p1
        pOpt.p2 = 0; %Optimised p2
        pOpt.s1 = 0;
        pOpt.s2 = 0;
        pOpt.s3 = 0;
        pOpt.s4 = 0;
        [map_x, map_y] = topDownProjectionOptim(pOpt, ptDLTValid, imsizeout, margin_m, frame);
    else;
        pIni.KK = params.KK;
        pIni.fx = params.fx; %Native fx
        pIni.fy = params.fy; %Native fy
        pIni.cx = params.cx; %Native cx
        pIni.cy = params.cy; %Native cy
        pIni.k1 = params.k1; %Native k1
        pIni.k2 = params.k2; %Native k2
        pIni.k3 = 0;
        pIni.k4 = 0;
        pIni.k5 = 0;
        pIni.k6 = 0;
        pIni.p1 = 0;
        pIni.p2 = 0;
        pIni.s1 = 0;
        pIni.s2 = 0;
        pIni.s3 = 0;
        pIni.s4 = 0;
        [map_x, map_y] = topDownProjectionNoOptim(pIni, ptDLTValid, imsizeout, margin_m, frame);
    end;
    extraMappingParams = [];
else
    if doOptimisation == 1;
        pOpt.fx = S; %same fx
        pOpt.fy = S; %same fy
        pOpt.cx = cx; %same cx
        pOpt.cy = cy; %same cy
        pOpt.KK = [S sy cx; 0 S cy; 0 0 1]; %same KK
        pOpt.k1 = ks(1); %Optimised k1
        pOpt.k2 = ks(2); %Optimised k2
        pOpt.k3 = 0; %Optimised k3
        pOpt.k4 = 0; %Optimised k4
        pOpt.k5 = 0;
        pOpt.k6 = 0;
        pOpt.p1 = 0;
        pOpt.p2 = 0;
        pOpt.s1 = 0;
        pOpt.s2 = 0;
        pOpt.s3 = 0;
        pOpt.s4 = 0;
        %---Build undistortion maps
        [map_x, map_y, extraMappingParams] = initUndistortPinHoleMap2(pOpt, imsizein, imsizeout, viewType, frame);
    end;
end;




% =====================================================================
function [map_x, map_y, extraMappingParams] = initUndistortPinHoleMap2(pOpt, imsizein, imsizeout, viewType, frame);


    %---Calibration parameters
    cx = pOpt.cx;          % principal point x (pixels)
    cy = pOpt.cy;          % principal point y (pixels)
    sy = pOpt.KK(1,2);     % pixel-stretch correction on the y axis
    S  = pOpt.fy;          % radius normalization (= max(W,H)/2)
    k1 = pOpt.k1;          % radial coefficient 1   (normalized)
    k2 = pOpt.k2;          % radial coefficient 2   (normalized)
    ks(1) = k1;
    ks(2) = k2;

    H_in = imsizeout(1);
    W_in = imsizeout(2);
    H_out = imsizeout(1);
    W_out = imsizeout(2);
    CONTENT_H = W_out * 9 / 16;            % 2160 -> preserve 16:9
    PAD_TOP   = (H_out - CONTENT_H) / 2;   % 10 px black bars
     
    % Undistorted bounding box: sweep the source border, undistort each sample.
    n = 400;
    ub = [linspace(0,W_in-1,n)'; (W_in-1)*ones(n,1); linspace(W_in-1,0,n)'; zeros(n,1)];
    vb = [zeros(n,1); linspace(0,H_in-1,n)'; (H_in-1)*ones(n,1); linspace(H_in-1,0,n)'];
    [xu_b, yu_b] = undistort(ub, vb, cx, cy, sy, ks, S);
    xu_min = min(xu_b);
    xu_max = max(xu_b);
    yu_min = min(yu_b);
    yu_max = max(yu_b);
     
    fit_scale = min(W_out/(xu_max-xu_min), CONTENT_H/(yu_max-yu_min));
    out_cx = W_out/2;  out_cy = PAD_TOP + CONTENT_H/2;
    ux_centre = (xu_min+xu_max)/2;  uy_centre = (yu_min+yu_max)/2;
     
    % For each output pixel -> undistorted coord -> invert radial -> source pixel
    proceed = 1;
    iter = 1;
    offsetCols = 0;
    offsetRows = 0;
    while proceed == 1; %main loop that recenter the image inside the canvas
        [i_grid, j_grid] = meshgrid(0:W_out-1, 0:H_out-1);
        xu = ux_centre + (i_grid - out_cx - offsetCols)/fit_scale;
        yu = uy_centre + (j_grid - out_cy - offsetRows)/fit_scale;
        [u_d, v_d] = rect_to_distorted(xu, yu, cx, cy, sy, ks, S);
         
        map_x = single(u_d + 1);     % +1 -> MATLAB 1-indexing for interp2
        map_y = single(v_d + 1);

        %---Recenter image in the canva
        %Find corners
        valid = (map_x >= 0) & (map_x <= W_in) & (map_y >= 0) & (map_y <= H_in);
        [ii, jj] = find(valid);
        if isempty(ii) == 0;
            %---Identify corner's positions
            top = min(ii)-1;
            bot = max(ii)-1;
            left = min(jj)-1;
            right = max(jj)-1;
            [~, k] = min(ii + jj);
            tl = [jj(k), ii(k)]; %top left
            [~, k] = min(ii - jj);
            tr = [jj(k), ii(k)]; %top right
            [~, k] = max(ii + jj);
            br = [jj(k), ii(k)]; %Bottom right
            [~, k] = max(ii - jj);
            bl = [jj(k), ii(k)]; %Bottom left        
            corners = [tl; tr; bl; br];
    
            %---Distance from the canvas edges
            distLeft = min(corners(:,1));
            distTop = min(corners(:,2));
            distRight = W_out - max(corners(:,1));
            distBottom = H_out - max(corners(:,2));
        
            if iter == 10;
                proceed = 0;
            else;
                %---Calculate offset to realign toward the center (applied in the next iteration of the loop when updating the maps)
                if abs(floor(distLeft) - floor(distRight)) <= 1 & abs(floor(distTop) - floor(distBottom)) <= 1;
                    proceed = 0;
                else;
                    if distLeft > distRight;
                        %move more to the left
                        offsetCols = offsetCols - ((distLeft - distRight)./2);
                    else;
                        %move more to the right
                        offsetCols = offsetCols + ((distRight - distLeft)./2);
                    end;
        
                    if distTop > distBottom;
                        %move more to the Top
                        offsetRows = offsetRows - ((distTop - distBottom)./2);
                    else;
                        %move more to the Bottom
                        offsetRows = offsetRows + ((distBottom - distTop)./2);
                    end;
        
                    iter = iter + 1;
                end;
            end;
        else;
            proceed = 0;
        end;
    end;
    %---Recompute maps a final time with current set of parameters
    [i_grid, j_grid] = meshgrid(0:W_out-1, 0:H_out-1);
    xu = ux_centre + (i_grid - out_cx - offsetCols)/fit_scale;
    yu = uy_centre + (j_grid - out_cy - offsetRows)/fit_scale;
    [u_d, v_d] = rect_to_distorted(xu, yu, cx, cy, sy, ks, S);
     
    map_x = single(u_d + 1);     % +1 -> MATLAB 1-indexing for interp2
    map_y = single(v_d + 1);

    %---Finalise ratio and crop
    %Find corners
    [H, W] = size(map_x);
    valid = (map_x >= 0) & (map_x <= W) & (map_y >= 0) & (map_y <= H);
    [ii, jj] = find(valid);
    if isempty(ii) == 0;
        %---Find again the corners for concave images
        top = min(ii)-1;
        bot = max(ii)-1;
        left = min(jj)-1;
        right = max(jj)-1;
        [~, k] = min(ii + jj);
        tl = [jj(k), ii(k)]; %top left
        [~, k] = min(ii - jj);
        tr = [jj(k), ii(k)]; %top right
        [~, k] = max(ii + jj);
        br = [jj(k), ii(k)]; %Bottom right
        [~, k] = max(ii - jj);
        bl = [jj(k), ii(k)]; %Bottom left            
        corners = [tl; tr; bl; br];
        %--Check again distance from the corners to the edges
        distLeft_op1 = min(corners(:,1));
        distTop_op1 = min(corners(:,2));
        distRight_op1 = max(corners(:,1));
        distBottom_op1 = max(corners(:,2));
        
        %---find the entire 4 edges
        sample = @(c) struct('mx', map_x(c(2), c(1)), 'my', map_y(c(2), c(1)));
        sTL = sample(tl);
        sTR = sample(tr);
        sBL = sample(bl);
        sBR = sample(br);
    
        %Infer source-image bounds from corner map values
        mx_min = min(sTL.mx, sBL.mx);    % left  side: smallest map_x
        mx_max = max(sTR.mx, sBR.mx);    % right side: largest  map_x
        my_min = min(sTL.my, sTR.my);    % top    side: smallest map_y
        my_max = max(sBL.my, sBR.my);    % bottom side: largest  map_y
    
        edges.bounds = struct('mx_min', mx_min, 'mx_max', mx_max, ...
             'my_min', my_min, 'my_max', my_max);
    
        %Strict validity using inferred bounds (with float tolerance)
        eps_tol = 1e-6;
        valid = (map_x >= mx_min - eps_tol) & (map_x <= mx_max + eps_tol) & ...
                (map_y >= my_min - eps_tol) & (map_y <= my_max + eps_tol);
        edges.valid = valid;
    
        %LEFT edge: leftmost valid col per row in [TL.row, BL.row]
        rL = (tl(2):bl(2)).';            % row indices, top -> bottom
        [~, cL] = max(valid(rL, :), [], 2);
        edges.left.rows = rL;
        edges.left.cols = cL;
    
        %RIGHT edge: rightmost valid col per row in [TR.row, BR.row]
        rR = (tr(2):br(2)).';
        [~, fromRight] = max(fliplr(valid(rR, :)), [], 2);
        edges.right.rows = rR;
        edges.right.cols = W + 1 - fromRight;
    
        %TOP edge: topmost valid row per col in [TL.col, TR.col]
        cT = (tl(1):tr(1)).';            % col indices, left -> right
        [~, rT] = max(valid(:, cT), [], 1);
        edges.top.cols = cT;
        edges.top.rows = rT(:);          % force column vec
    
        %BOTTOM edge: bottommost valid row per col in [BL.col, BR.col]
        cB = (bl(1):br(1)).';
        [~, fromBottom] = max(flipud(valid(:, cB)), [], 1);
        edges.bottom.cols = cB;
        edges.bottom.rows = (H + 1 - fromBottom(:));
    
        %Define limits based on crop selection
        if strcmpi(lower(viewType), "full");
            [leftCol, leftRow] = min(edges.left.cols);
            [rightCol, rightRow] = max(edges.right.cols);
            [topRow, topCol] = min(edges.top.rows);
            [bottomRow, bottomCol] = max(edges.bottom.rows);
        else;
            [leftCol, leftRow] = max(edges.left.cols);
            [rightCol, rightRow] = min(edges.right.cols);
            [topRow, topCol] = max(edges.top.rows);
            [bottomRow, bottomCol] = min(edges.bottom.rows);
        end;
        distLeft = leftCol;
        distRight = rightCol;
        distTop = topRow;
        distBottom = bottomRow;
    
    %         %  Figure to check image, corners amd edges
    %         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 
    %         figure;imshow(frame);
    %         hold on; plot(edges.left.cols, edges.left.rows, 'r.');
    %         hold on; plot(edges.right.cols, edges.right.rows, 'b.');
    %         hold on; plot(edges.top.cols, edges.top.rows, 'y.');
    %         hold on; plot(edges.bottom.cols, edges.bottom.rows, 'g.');
    %         
    %         hold on; plot(corners(1,1), corners(1,2), 'ro');
    %         hold on; plot(corners(2,1), corners(2,2), 'bo');
    %         hold on; plot(corners(3,1), corners(3,2), 'yo');
    %         hold on; plot(corners(4,1), corners(4,2), 'go');
    
    
        %---Finalise crop
        widthTarget = ((distRight - distLeft) + 1);
        heightTarget = ((distBottom - distTop) + 1);
        %Try 16/9 ratio to protect the width first
        heightNew = widthTarget ./ (W_out/H_out);
        if heightNew > heightTarget;
            %too high for targetted height
            %adjust width
            widthNew = heightTarget .* (W_out/H_out);
            heightNew = heightTarget;
        else;
            widthNew = widthTarget;
        end;
        diffWidth = abs(W_out - widthNew);
        distLeft = roundn((diffWidth./2), 0);
        distRight = W_out-roundn((diffWidth./2), 0);
        diffHeight = abs(H_out - heightNew);
        distTop = roundn((diffHeight./2), 0);
        distBottom = H_out - roundn((diffHeight./2), 0);
        
        if distTop <= 0;
            distTop = 1;
        end;
        if distLeft <= 0;
            distLeft = 1;
        end;
        if distBottom > H_out;
            distBottom = H_out;
        end;
        if distRight > W_out;
            distRight = W_out;
        end;
    else;
        distTop = 1;
        distLeft = 1;
        distBottom = H_out;
        distRight = W_out;
    end;
    
    map_x = map_x(distTop:distBottom, distLeft:distRight);
    map_y = map_y(distTop:distBottom, distLeft:distRight);
    
    [Hec, Wec] = size(map_x);
    map_x = roundn(imresize(map_x, [H_out W_out], 'bilinear'),0);
    map_y = roundn(imresize(map_y, [H_out W_out], 'bilinear'),0);
    
    extraMappingParams.offsetCols = offsetCols;
    extraMappingParams.offsetRows = offsetRows;
    extraMappingParams.cropTop = distTop;
    extraMappingParams.cropLeft = distLeft;
    extraMappingParams.cropRight = distRight;
    extraMappingParams.cropBottom = distBottom;
    extraMappingParams.scaleU = Hec./H_out;
    extraMappingParams.scaleV = Wec./W_out;
    extraMappingParams.viewType = viewType;


% =====================================================================
function [map_x, map_y] = topDownProjectionOptim(pOpt, ptDLTValid, imResout, margin, frame)
% TOPDOWNPROJECTION  Build a top-down view of the world plane at the
 
    % Set parameters
    cx = pOpt.cx;          % principal point x (pixels)
    cy = pOpt.cy;          % principal point y (pixels)
    sy = pOpt.KK(1,2);     % pixel-stretch correction on the y axis
    S  = pOpt.fy;          % radius normalization (= max(W,H)/2)
    k1 = pOpt.k1;          % radial coefficient 1   (normalized)
    k2 = pOpt.k2;          % radial coefficient 2   (normalized)
    ks(1) = k1;
    ks(2) = k2;
    H_out = imResout(1);
    W_out = imResout(2);

    Xmin = min(ptDLTValid(:,3));
    Xmax = max(ptDLTValid(:,3));
    Ymin = min(ptDLTValid(:,4));
    Ymax = max(ptDLTValid(:,4));
    mx = margin*(Xmax-Xmin);
    my = margin*(Ymax-Ymin);          % small margin
    % world_bounds = [Xmin-mx, Xmax+mx, Ymin-my, Ymax+my];
    W_world = Xmax - Xmin;
    H_world = Ymax - Ymin;
    
    % Uniform scale (square pixels) so the whole world region fits the canvas
    ppu = min(W_out / W_world, H_out / H_world);
    content_w = W_world * ppu;
    content_h = H_world * ppu;
    pad_x = (W_out - content_w) / 2;        % left/right black bars
    pad_y = (H_out - content_h) / 2;        % top/bottom black bars
    
    % Canvas pixel -> world (only the content area maps to a real world point)
    [ci, ri] = meshgrid(1:W_out, 1:H_out);
    X = Xmin + (ci + 0.5 - pad_x) / ppu;
    Y = Ymin + (ri + 0.5 - pad_y) / ppu;
    inside = (ci + 0.5 >= pad_x) & (ci + 0.5 <= pad_x + content_w) & ...
             (ri + 0.5 >= pad_y) & (ri + 0.5 <= pad_y + content_h);
    
    % world -> rectified pixel (inv H) -> distorted pixel (Newton)
    Hinv = inv(H);
    w  = Hinv(3,1)*X + Hinv(3,2)*Y + Hinv(3,3);
    xu = (Hinv(1,1)*X + Hinv(1,2)*Y + Hinv(1,3)) ./ w;
    yu = (Hinv(2,1)*X + Hinv(2,2)*Y + Hinv(2,3)) ./ w;
    [u_d, v_d] = rect_to_distorted(xu, yu, cx, cy, sy, ks, S);
    
    % Padding pixels: send them outside the source grid so interp2 returns the
    % fill value (0 -> black).
    u_d(~inside) = -10;  v_d(~inside) = -10;
    
    map_x = single(u_d + 1);     % +1 -> MATLAB 1-indexing for interp2
    map_y = single(v_d + 1);


       %         [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 
    %         figure;imshow(frame);


% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%     uFit = ptDLTValid(:,1);
%     vFit = ptDLTValid(:,2);
%     xFit = ptDLTValid(:,3);
%     yFit = ptDLTValid(:,4);
%     H_out = imResout(1);
%     W_out = imResout(2);
%     [uo, vo] = meshgrid(1:W_out, 1:H_out);
%     
%     if abs(max(xFit) - 50) <= abs(max(xFit) - 25);
%         %LCM
%         limMinX = 0 - (50.*margin);
%         limMaxX = 50 + (50.*margin);
%         if abs(min(yFit) - 0) <= 5;
%             limMinY = 0 - (25.*margin);
%         else;
%             limMinY = min(yFit) - (min(yFit).*margin);
%         end;
%         if abs(max(yFit) - 25) <= 5;
%             limMaxY = 25 + (25.*margin);
%         else;
%             limMaxY = max(yFit) + (25.*margin);
%         end;
%     else;
%         %SCM
%         limMinX = 0 - (25.*margin);
%         limMaxX = 25 + (25.*margin);;
%         if abs(min(yFit) - 0) <= 5;
%             limMin = 0 - (25.*margin);
%         else;
%             limMin = min(yFit) - (min(yFit).*margin);
%         end;
%         if abs(max(yFit) - 25) <= 5;
%             limYMaxY = 25 + (25.*margin);
%         else;
%             limMaxY = max(yFit) + (25.*margin);
%         end;
%     end;
%     topDownBBox = [limMinX limMaxX limMinY limMaxY];
% 
% 
%     % Explicit world bbox per topDownBBox = [Xmin Xmax Ymin Ymax]
%     Xmin = topDownBBox(1);
%     Xmax = topDownBBox(2);
%     Ymin = topDownBBox(3);
%     Ymax = topDownBBox(4);
%     Wworld = Xmax - Xmin;
%     Hworld = Ymax - Ymin;
%  
% 
%     % Anisotropic px/m so the whole canvas is filled.
%     X_world = W_out / Wworld;
%     Y_world = H_out / Hworld;
%  
% 
%     % Create maps
%     [Ug, Vg] = meshgrid(1:W_out, 1:H_out);
% 
% 
%     % World -> normalized undistorted image  via H_norm
%     Wmat = X_world*0;
%     xn_und = H_norm(1,1)*X_world + H_norm(1,2)*Y_world + H_norm(1,3);
%     yn_und = H_norm(2,1)*X_world + H_norm(2,2)*Y_world + H_norm(2,3);
%     Wmat = H_norm(3,1)*X_world + H_norm(3,2)*Y_world + H_norm(3,3);
%     xn_und = xn_und ./ Wmat;
%     yn_und = yn_und ./ Wmat;
% 
% 
%     % Apply forward distortion
%     [xd_in, yd_in] = forward_distort(xn_und, yn_und, k_tan,p_tan);
%     map_x = fx_use * xd_in + cx;
%     map_y = fy_use * yd_in + cy;



% ======================================================================
% Local functions
% ======================================================================
function [params, err] = fit(pts, n_k, S);
    % Fit by Levenberg-Marquardt / trust-region with parameter scaling.
    cx0 = (max(pts(:,1)) + min(pts(:,1))) / 2;   % loose seed at midpoint
    cy0 = (max(pts(:,2)) + min(pts(:,2))) / 2;
    sy0 = 1.0;
    ks0 = zeros(1, n_k);
    H0  = estimate_homography(pts(:,1:2), pts(:,3:4));
    p0  = [cx0; cy0; sy0; ks0(:); ...
           H0(1,1); H0(1,2); H0(1,3); ...
           H0(2,1); H0(2,2); H0(2,3); ...
           H0(3,1); H0(3,2)];
     
    % Per-parameter scales (similar to scipy's x_scale).  Must match the
    % shape of p0 (Octave is strict; MATLAB is lenient).
    x_scale = [1000; 1000; 0.1; 0.1*ones(n_k, 1); ...
               1e-2; 1e-2; 1.0; 1e-2; 1e-2; 1.0; 1e-5; 1e-5];
     
    % MATLAB / Octave compatible option struct.  optimset's option names work
    % in both: MATLAB also accepts 'StepTolerance' etc., but 'TolX', 'TolFun',
    % 'MaxIter' and 'TypicalX' are the historic names that both honour.
    opts = optimset('Algorithm',  'trust-region-reflective', ...
                    'TolX',       1e-12, ...
                    'TolFun',     1e-12, ...
                    'MaxIter',    5000, ...
                    'TypicalX',   x_scale, ...
                    'Display',    'off');
     
    [params, ~] = lsqnonlin(@(p) residuals(p, pts, n_k, S), p0, [], [], opts);
    err = err_per_pt(params, pts, n_k, S);


function r = residuals(params, pts, n_k, S);
    [cx, cy, sy, ks, H] = unpack(params, n_k);
    [xu, yu] = undistort(pts(:,1), pts(:,2), cx, cy, sy, ks, S);
    [Xp, Yp] = apply_homography(H, xu, yu);
    r = [Xp - pts(:,3); Yp - pts(:,4)];

 
function err = err_per_pt(params, pts, n_k, S);
    r = residuals(params, pts, n_k, S);
    N = size(pts, 1);
    err = hypot(r(1:N), r(N+1:end));
 

function [xu, yu] = undistort(u, v, cx, cy, sy, ks, S);
    x = u - cx;  y = v - cy;
    xn = x / S;  yn = y * sy / S;
    r2 = xn.^2 + yn.^2;
    sc = ones(size(r2));
    rp = r2;
    for i = 1:length(ks)
        sc = sc + ks(i) * rp;
        rp = rp .* r2;
    end
    xu = x .* sc + cx;
    yu = y .* sc + cy;

 
function [u_d, v_d] = rect_to_distorted(xu, yu, cx, cy, sy, ks, S)
    % rectified pixel -> distorted pixel  (invert radial gain via Newton)
    xun = (xu - cx)/S;  yun = (yu - cy)*sy/S;
    ru  = sqrt(xun.^2 + yun.^2);
    rd  = ru;
    for it = 1:40
        rd2 = rd.^2;
        sc  = ones(size(rd2));  dsc = zeros(size(rd));  rp = rd2;
        for i = 1:numel(ks)
            sc  = sc  + ks(i).*rp;
            dsc = dsc + ks(i)*2*i.*rd.^(2*i-1);
            rp  = rp .* rd2;
        end
        f  = rd.*sc - ru;
        fp = sc + rd.*dsc;  fp(abs(fp)<1e-12) = 1e-12;
        d  = f./fp;  rd = rd - d;
        if max(abs(d(:))) < 1e-10, break; end
    end
    ratio = rd./ru;  ratio(ru < 1e-12) = 1;
    xdn = xun.*ratio;  ydn = yun.*ratio;
    u_d = xdn*S + cx;
    v_d = ydn*S/sy + cy;

function [X, Y] = apply_homography(H, x, y);
    w = H(3,1)*x + H(3,2)*y + H(3,3);
    X = (H(1,1)*x + H(1,2)*y + H(1,3)) ./ w;
    Y = (H(2,1)*x + H(2,2)*y + H(2,3)) ./ w;

 
function H = estimate_homography(src, dst);
    % Direct Linear Transform: solves A * h = 0 for h = [H11..H33] (row-major).
    N = size(src, 1);
    A = zeros(2*N, 9);
    for i = 1:N
        x = src(i,1); y = src(i,2);
        X = dst(i,1); Y = dst(i,2);
        A(2*i-1, :) = [-x, -y, -1,  0,  0,  0, X*x, X*y, X];
        A(2*i,   :) = [ 0,  0,  0, -x, -y, -1, Y*x, Y*y, Y];
    end
    [~, ~, V] = svd(A, 0);
    h = V(:, end);                               % smallest right singular vector
    H = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) h(9)];
    H = H / H(3, 3);

 
function [cx, cy, sy, ks, H] = unpack(p, n_k);
    cx = p(1); cy = p(2); sy = p(3);
    ks = p(4 : 3 + n_k);
    h  = p(3 + n_k + 1 : end);
    H  = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) 1.0];


function v = rms_(x);
    v = sqrt(mean(x(:).^2));





