function [map_x, map_y, pFishEyeOpt, extraMappingParams] = optiUndistortFishEyeMap1(pFishEye, imsizein, imsizeout, viewType, ptDLTValidMapped, doOptimisation, doTopDown, frame);
% References
% https://docs.opencv.org/4.x/d9/d0c/group__calib3d.html
% https://robots.stanford.edu/cs223b04/JeanYvesCalib/index.html#updates
% https://docs.opencv.org/3.4/da/d54/group__imgproc__transform.html#ga7dfb72c9cf9780a347fbe3d1c47e5d5a
% https://amroamroamro.github.io/mexopencv/matlab/cv.initUndistortRectifyMap.html
% https://kyamagu.github.io/mexopencv/matlab/initUndistortRectifyMap.html


% Creating mapping for pinhole model projection
% Input:
%   param: camera fisheye calibration
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
%
% Apply the following to map the image:
% [outputImage, XYHasNaNs] = imagesbuiltinImageInterpolation2D(Idistorted, map_x, map_y, 'nearest', 0);  




%---Define initial parameters
map_x = [];
map_y = [];
pFishEyeOpt = [];
extraMappingParams = [];

H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);
margin_m = 0.1; % world-space margin around control region as pourcentage
U = ptDLTValidMapped(:,1);
V = ptDLTValidMapped(:,2);
X = ptDLTValidMapped(:,3);
Y = ptDLTValidMapped(:,4);
N = numel(U);
a_init = pFishEye.MappingCoefficients';
center_init = pFishEye.DistortionCenter; %Distorsion center
stretchMatrix = [1 0; 0 1];

%---Initial pose from a planar homography
[rvec0, t0] = initialPose(U, V, X, Y, a_init, center_init);
params0 = [a_init(:); center_init(:); rvec0(:); t0(:)];   % 12x1

%Parameter scale.  Each scaled parameter is O(1). ---
SC = [1e3;  1e-4;  1e-7;  1e-11;        % a0  a2  a3  a4
      1e3;  1e3;                         % cx  cy
       1;    1;    1;                    % rvec
      30;   30;   30];                   % t


%---Robust optimisation with outlier rejection (residuals in WORLD m)
% use_reference = true;
% if use_reference
for iter = 1:2;
    if iter == 1;
        % Reference intrinsics (from multi-start fit, pixel RMS ~11)
        a_ref  = [1137.0110; 0; -1.0114e-4; -2.1338e-8; 1.3739e-11];
        cx_ref = 1914.6632;
        cy_ref = 1098.9738;
     
        % Override the initial polynomial / centre with the reference
        params0(1:4) = [a_ref(1); a_ref(3); a_ref(4); a_ref(5)];
        params0(5)   = cx_ref;
        params0(6)   = cy_ref;
     
        % Pose-only refinement: optimise rvec, t with intrinsics frozen
        opts = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', ...
            'Display', 'off', ...
            'MaxIterations', 2000, ...
            'MaxFunctionEvaluations', 1e5, ...
            'FunctionTolerance', 1e-14, ...
            'StepTolerance', 1e-14, ...
            'OptimalityTolerance', 1e-14, ...
            'FiniteDifferenceType', 'central');
     
        mask = true(N, 1);
        mask(1) = false;        % drop point 0 (the pool corner)
     
        pose_idx = 7:12;        % rvec(3) + t(3)
        fixed    = params0;
        f = @(sp_pose) reprojectionResiduals( ...
                buildParams(fixed, sp_pose, pose_idx, SC), ...
                U(mask), V(mask), X(mask), Y(mask));
        sp_pose0 = params0(pose_idx) ./ SC(pose_idx);
        sp_pose_opt = lsqnonlin(f, sp_pose0, [], [], opts);
        params0(pose_idx) = sp_pose_opt .* SC(pose_idx);
 
        xyRes   = worldXYResiduals(params0, U, V, X, Y);
        fullErr = sqrt(sum(xyRes.^2, 2));
        pixRes  = reprojectionResiduals(params0, U(mask), V(mask), X(mask), Y(mask));
        pixErr  = sqrt(sum(reshape(pixRes, [], 2).^2, 2));
        meanErr(1) = sqrt(mean(pixErr.^2));
        params0a = params0;
    else
        % Full optimisation (will diverge from Python reference, see notes above)
        opts = optimoptions('lsqnonlin', 'Algorithm', 'trust-region-reflective', ...
            'Display', 'off', ...
            'MaxIterations', 2000, 'MaxFunctionEvaluations', 5e5, ...
            'FunctionTolerance', 1e-14, 'StepTolerance', 1e-14, ...
            'OptimalityTolerance', 1e-14, 'FiniteDifferenceType', 'central');
        mask = true(N, 1); mask(1) = false;
        f = @(sp) reprojectionResiduals(sp .* SC, ...
                                        U(mask), V(mask), X(mask), Y(mask));
        sp0 = params0 ./ SC;
        sp_opt = lsqnonlin(f, sp0, [], [], opts);
        params0 = sp_opt .* SC;
        xyRes = worldXYResiduals(params0, U, V, X, Y);
        fullErr = sqrt(sum(xyRes.^2, 2));
        pixRes = reprojectionResiduals(params0, U(mask), V(mask), X(mask), Y(mask));
        pixErr = sqrt(sum(reshape(pixRes, [], 2).^2, 2));
        meanErr(2) = sqrt(mean(pixErr.^2));
        params0b = params0;
    end;
end;
if meanErr(1) > meanErr(2);
    params0 = params0b;
else;
    params0 = params0a;
end;


%---Extract & report
a4c = params0(1:4);
mappingCoeffs_opt = [a4c(1); 0; a4c(2); a4c(3); a4c(4)];   % [a0 a1 a2 a3 a4]
cx_opt = params0(5);
cy_opt = params0(6);
rvec = params0(7:9);
t = params0(10:12);
R = rodriguesRot(rvec);
% outliers = find(~mask);


%---Create maps depending on top-down or normal projection selection
if doTopDown == 1;
    if doOptimisation == 1;
        pFishEyeOpt.DistortionCenter = [cx_opt cy_opt]; %Distorsion center
        pFishEyeOpt.MappingCoefficients = mappingCoeffs_opt; %Fish Eye mapping coef
        pFishEyeOpt.StretchMatrix = stretchMatrix; %Stretch matrix
        pFishEyeOpt.ImageSize = [H_in W_in]; %Image size
        [map_x, map_y] = topDownProjectionOptim(pFishEyeOpt, ptDLTValidMapped, t, R, imsizeout, margin_m, frame);
    else;
        [map_x, map_y] = topDownProjection(pFishEye, ptDLTValid, imsizeout, margin_m, frame);
    end;
    extraMappingParams = [];
else
    if doOptimisation == 1;
        pFishEyeOpt.DistortionCenter = [cx_opt cy_opt]; %Distorsion center
        pFishEyeOpt.MappingCoefficients = mappingCoeffs_opt; %Fish Eye mapping coef
        pFishEyeOpt.StretchMatrix = stretchMatrix; %Stretch matrix
        pFishEyeOpt.ImageSize = [H_in W_in]; %Image size

%         [map_x, map_y, extraMappingParams] = initUndistortFishEyeMap(pFishEyeOpt, ...
%             imsizein, imsizeout, viewType, frame);   

        %---Choose output focal length so the WHOLE fisheye FOV fits
        % sample input-image perimeter
        offsetCols = 0;
        offsetRows = 0;
        distTop = 0;
        distLeft = 0;
        distBottom = imsizeout(2);
        distRight = imsizeout(1);
        scaleU = 1;
        scaleV = 1;

        us = [linspace(0,W_in-1,400) linspace(0,W_in-1,400) ...
              zeros(1,400) (W_in-1)*ones(1,400)].';
        vs = [zeros(1,400) (H_in-1)*ones(1,400) ...
              linspace(0,H_in-1,400) linspace(0,H_in-1,400)].';
        rays = backProject(us, vs, mappingCoeffs_opt, cx_opt, cy_opt);
        ok = rays(:,3) > 0;
        theta = atan2(sqrt(rays(ok,1).^2 + rays(ok,2).^2), rays(ok,3));
        theta_max = max(theta);
        
        diag_half = 0.5 * hypot(W_out, H_out);
        f_out = diag_half / tan(theta_max);
        cx_out = (W_out - 1) / 2;                 % should be 1419.5 for W_out=2840
        cy_out = (H_out - 1) / 2;                 % 1079.5
        
        %---Build map_x, map_y via 1-D theta-to-rho lookup
        rho_tab = linspace(0, 3000, 60000).';
        z_tab = mappingCoeffs_opt(1) + mappingCoeffs_opt(2)*rho_tab + mappingCoeffs_opt(3)*rho_tab.^2 + ...
                  mappingCoeffs_opt(4)*rho_tab.^3 + mappingCoeffs_opt(5)*rho_tab.^4;
        theta_tab = atan2(rho_tab, z_tab);
        % keep monotonic prefix
        nonmono = find(diff(theta_tab) <= 0, 1, 'first');
        if isempty(nonmono);
            nonmono = numel(theta_tab);
        end;
        rho_tab = rho_tab(1:nonmono);
        theta_tab = theta_tab(1:nonmono);
         
        proceed = 1;
        iter = 1;
        offsetCols = 0;
        offsetRows = 0;
        while proceed == 1; %main loop that recenter the image inside the canvas
            %---Output pixel map
            [uu, vv] = meshgrid(0:W_out, 0:H_out);
            Xd = uu - cx_out - offsetCols;
            Yd = vv - cy_out - offsetRows;

            theta_grid = atan2(hypot(Xd,Yd), f_out);
            phi_grid = atan2(Yd, Xd);
            rho_out = interp1(theta_tab, rho_tab, theta_grid(:), 'linear', NaN);
            rho_out = reshape(rho_out, size(theta_grid));

            map_x = rho_out .* cos(phi_grid) + cx_opt;
            map_y = rho_out .* sin(phi_grid) + cy_opt;

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
        [uu, vv] = meshgrid(0:W_out, 0:H_out);
        %3-D ray for every output pixel (pin-hole / perspective model)
        Xd = uu - cx_out - offsetCols;
        Yd = vv - cy_out - offsetRows;
        theta_grid = atan2(hypot(Xd,Yd), f_out);
        phi_grid = atan2(Yd, Xd);
        rho_out = interp1(theta_tab, rho_tab, theta_grid(:), 'linear', NaN);
        rho_out = reshape(rho_out, size(theta_grid));
        map_x = rho_out .* cos(phi_grid) + cx_opt;
        map_y = rho_out .* sin(phi_grid) + cy_opt;
        
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
        %---Create figure 4 for checks in ptmapping function
        % [frame4, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 
        
        [Hec, Wec] = size(map_x);
        map_x = roundn(imresize(map_x, [H_out W_out], 'bilinear'),0);
        map_y = roundn(imresize(map_y, [H_out W_out], 'bilinear'),0);
        %---Create figure 5 for checks in ptmapping function
        % [frame5, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 
        
        extraMappingParams.offsetCols = offsetCols;
        extraMappingParams.offsetRows = offsetRows;
        extraMappingParams.cropTop = distTop;
        extraMappingParams.cropLeft = distLeft;
        extraMappingParams.cropRight = distRight;
        extraMappingParams.cropBottom = distBottom;
        extraMappingParams.scaleU = Hec./H_out;
        extraMappingParams.scaleV = Wec./W_out;
        extraMappingParams.viewType = viewType;
    end;
end;



%% =======================================================================
%  ===========================  LOCAL HELPERS  ===========================
%  =======================================================================
function [map_x, map_y] = topDownProjectionOptim(pFishEye, ptDLT, t, R, imsizeout, margin_m, frame);

    %---Parameters
    cx_opt = pFishEye.DistortionCenter(1); %Distorsion center
    cy_opt = pFishEye.DistortionCenter(2); %Distorsion center
    mappingCoeffs = pFishEye.MappingCoefficients; %Fish Eye mapping coef
    stretchMatrix = pFishEye.StretchMatrix; %Stretch matrix
    H_in = pFishEye.ImageSize(1); %Image size
    W_in = pFishEye.ImageSize(2); %Image size
    H_out = imsizeout(1);
    W_out = imsizeout(2);

    xFit = ptDLT(:,3);
    yFit = ptDLT(:,4);
    if abs(max(xFit) - 50) <= abs(max(xFit) - 25);
        %LCM
        limMinX = 0 - (50.*margin_m);
        limMaxX = 50 + (50.*margin_m);
        if abs(min(yFit) - 0) <= 5;
            limMinY = 0 - (25.*margin_m);
        else;
            limMinY = min(yFit) - (min(yFit).*margin_m);
        end;
        if abs(max(yFit) - 25) <= 5;
            limMaxY = 25 + (25.*margin_m);
        else;
            limMaxY = max(yFit) + (25.*margin_m);
        end;
    else;
        %SCM
        limMinX = 0 - (25.*margin_m);
        limMaxX = 25 + (25.*margin_m);;
        if abs(min(yFit) - 0) <= 5;
            limMin = 0 - (25.*margin_m);
        else;
            limMin = min(yFit) - (min(yFit).*margin_m);
        end;
        if abs(max(yFit) - 25) <= 5;
            limYMaxY = 25 + (25.*margin_m);
        else;
            limMaxY = max(yFit) + (25.*margin_m);
        end;
    end;
    topDownBBox = [limMinX limMaxX limMinY limMaxY];
    td_x_range = [limMinX limMaxX];
    td_y_range = [limMinY limMaxY];


    % Build the same theta->rho lookup the rectilinear branch uses
    rho_tab = linspace(0, 3000, 60000).';
    z_tab = mappingCoeffs(1) + mappingCoeffs(2)*rho_tab + mappingCoeffs(3)*rho_tab.^2 + ...
              mappingCoeffs(4)*rho_tab.^3 + mappingCoeffs(5)*rho_tab.^4;
    theta_tab = atan2(rho_tab, z_tab);
    nonmono = find(diff(theta_tab) <= 0, 1, 'first');
    if isempty(nonmono);
        nonmono = numel(theta_tab);
    end;
    rho_tab = rho_tab(1:nonmono);
    theta_tab = theta_tab(1:nonmono);
    theta_max_table = max(theta_tab);
 

    %---Fit world rectangle inside the fixed [td_H td_W] frame ---
    world_W = diff(td_x_range);                 % metres
    world_H = diff(td_y_range);                 % metres
    px_per_m = min(W_out / world_W, H_out / world_H);
    inner_W = round(world_W * px_per_m);       % pixels of content
    inner_H = round(world_H * px_per_m);
    pad_x = floor((W_out - inner_W) / 2);     % left padding (black)
    pad_y = floor((H_out - inner_H) / 2);     % top  padding (black)
    

    %---Build the world (X,Y) grid for the full output ---
    % meshgrid: col varies along columns (matches output X), row along rows.
    [col, row] = meshgrid(double(1:W_out), double(1:H_out));
    Xw = td_x_range(1) + (col - pad_x) / px_per_m;
    Yw = td_y_range(1) + (row - pad_y) / px_per_m;
 
    % World -> camera frame: Pc = R * Pw + t  (Pw column vector)
    Xc = R(1,1)*Xw + R(1,2)*Yw + t(1);          % Zw = 0
    Yc = R(2,1)*Xw + R(2,2)*Yw + t(2);
    Zc = R(3,1)*Xw + R(3,2)*Yw + t(3);
    rxy = hypot(Xc, Yc);
    theta = atan2(rxy, Zc);                      % angle from optical axis
    phi = atan2(Yc, Xc);                       % azimuth in image plane


    %---Which output pixels are renderable? ---
    in_content = (col >= pad_x) & (col < pad_x + inner_W) & ...
                 (row >= pad_y) & (row < pad_y + inner_H);
    valid = in_content & (Zc > 0) & (theta < theta_max_table);
    n_valid = nnz(valid);
    

    %---Vector-only computation on the valid subset, then scatter back ---
    theta_v = theta(valid);
    phi_v = phi(valid);
    rho_v = interp1(theta_tab, rho_tab, theta_v, 'linear');
    map_x_td = -ones(H_out, W_out);
    map_y_td = -ones(H_out, W_out);
    map_x_td(valid) = rho_v .* cos(phi_v) + cx_opt;
    map_y_td(valid) = rho_v .* sin(phi_v) + cy_opt;
    map_x = map_x_td;
    map_y = map_y_td;


function rays = backProject(u, v, a, cx, cy);
    % Pixel -> camera-frame ray direction (un-normalised, identity stretch).
    du = u - cx;
    dv = v - cy;
    rho = hypot(du, dv);
    z = a(1) + a(2)*rho + a(3)*rho.^2 + a(4)*rho.^3 + a(5)*rho.^4;
    rays = [du(:), dv(:), z(:)];


function res = reprojectionResiduals(p, U, V, X, Y);
    % Reproject world points (X,Y,0) -> pixels; return [du; dv] residuals.
    a4c = p(1:4);
    a = [a4c(1); 0; a4c(2); a4c(3); a4c(4)];
    cx = p(5); cy = p(6);
    rvec = p(7:9);  t = p(10:12);
    R = rodriguesRot(rvec);
    
    N = numel(X);
    Pw = [X(:), Y(:), zeros(N,1)];
    Pc = Pw * R.' + t.';
    Xc = Pc(:,1); Yc = Pc(:,2); Zc = Pc(:,3);
    r = hypot(Xc,Yc);
    u_pred = zeros(N,1);  v_pred = zeros(N,1);
    for i = 1:N;
        if r(i) < 1e-9;
            up_i = 0;
            vp_i = 0;
        else;
            % poly:  a(5)*rho^4 + a(4)*rho^3 + a(3)*rho^2 + (a(2)-Zc/r)*rho + a(1) = 0
            coeffs = [a(5), a(4), a(3), a(2) - Zc(i)/r(i), a(1)];
            rt = roots(coeffs);
            cand = rt(abs(imag(rt)) < 1e-6 & real(rt) > 0);
            if isempty(cand);
                u_pred(i) = 1e6;
                v_pred(i) = 1e6;
                continue;
            end;
            rho = min(real(cand));
            up_i = rho * Xc(i)/r(i);
            vp_i = rho * Yc(i)/r(i);
        end;
        u_pred(i) = up_i + cx;
        v_pred(i) = vp_i + cy;
    end
    res = [U(:) - u_pred ; V(:) - v_pred];


function xy = worldXYResiduals(p, U, V, X, Y);
    % Back-project pixels through a plane and report world residuals.
    a4c = p(1:4);
    a = [a4c(1); 0; a4c(2); a4c(3); a4c(4)];
    cx = p(5);
    cy = p(6);
    rvec = p(7:9);
    t = p(10:12);
    R = rodriguesRot(rvec);
    rays_cam = backProject(U, V, a, cx, cy);
    rays_world = rays_cam * R;       % (R^T d)^T == d * R
    cam_pos = -R.' * t;
    s = -cam_pos(3) ./ rays_world(:,3);
    x_pred = cam_pos(1) + s .* rays_world(:,1);
    y_pred = cam_pos(2) + s .* rays_world(:,2);
    xy = [X(:) - x_pred, Y(:) - y_pred];


function [rvec, t] = initialPose(U, V, X, Y, a, center);
    % Use the back-projected normalised rays to fit a planar homography,
    % then decompose to (R, t) and return rvec via Rodrigues.
    a5 = [a(1); 0; a(2); a(3); a(4)];
    rays = backProject(U, V, a5, center(1), center(2));
    xn = rays(:,1) ./ rays(:,3);
    yn = rays(:,2) ./ rays(:,3);
    
    N = numel(X);
    A = zeros(2*N, 9);
    for i = 1:N
        A(2*i-1,:) = [-X(i), -Y(i), -1,  0, 0, 0,  xn(i)*X(i), xn(i)*Y(i), xn(i)];
        A(2*i,:) = [ 0, 0, 0,  -X(i), -Y(i), -1, yn(i)*X(i), yn(i)*Y(i), yn(i)];
    end
    [~,~,V_] = svd(A);
    H = reshape(V_(:,end), 3, 3).';
    lam = 1.0 / norm(H(:,1));
    H = H * lam;
    if H(3,3) < 0;
        H = -H;
    end;
    r1 = H(:,1);
    r2 = H(:,2);
    t = H(:,3);
    r1 = r1 / norm(r1);
    r2 = r2 - r1*(r1.'*r2);
    r2 = r2 / norm(r2);
    r3 = cross(r1, r2);
    R = [r1, r2, r3];
    [Uo,~,Vo] = svd(R);
    R = Uo*Vo.';
    if det(R) < 0;
        R(:,3) = -R(:,3);
    end;
    rvec = rotMatToVec(R);
    

function R = rodriguesRot(r);
    % Rotation vector -> rotation matrix (Rodrigues).
    theta = norm(r);
    if theta < 1e-12;
        R = eye(3);
        return;
    end;
    k = r(:)/theta;
    K =     [ 0   -k(3)  k(2);
          k(3) 0    -k(1);
         -k(2) k(1)  0 ];
    R = eye(3) + sin(theta)*K + (1-cos(theta))*(K*K);


function r = rotMatToVec(R);
    % Inverse Rodrigues.  Returns 3x1 rotation vector.
    theta = acos( max(-1,min(1,(trace(R)-1)/2)) );
    if theta < 1e-12;
        r = [0;0;0];
        return;
    end
    r = (theta/(2*sin(theta))) * [R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)];


function [u, v] = world_to_pixel_td(Xw, Yw, x_range, y_range, ...
                                     px_per_m, pad_x, pad_y)
    % Convert world-plane coordinates (metres) to top-down pixel coordinates
    % (1-based, matches insertShape's expectations).
    % pad_x, pad_y account for the black padding around the content rectangle.
    u = (Xw - x_range(1)) * px_per_m + pad_x + 1;
    v = (Yw - y_range(1)) * px_per_m + pad_y + 1;
 

function p = buildParams(fixed, sub_scaled, idx, SC)
    % Reconstruct the full parameter vector from a subset of (scaled) values.
    % Used for pose-only optimisation: intrinsics frozen, only rvec/t change.
    p = fixed;
    p(idx) = sub_scaled .* SC(idx);




