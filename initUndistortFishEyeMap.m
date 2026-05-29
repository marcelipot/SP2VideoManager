% function [map_x, map_y, bbox] = initUndistortFishEyeMap(pFishEye, viewType);
function [map_x, map_y, extraMappingParams] = initUndistortFishEyeMap(pFishEye, imsizein, imsizeout, viewType, frame);
% References
% https://docs.opencv.org/3.4/db/d58/group__calib3d__fisheye.html
% https://au.mathworks.com/help/vision/ug/fisheye-calibration-basics.html
% https://au.mathworks.com/matlabcentral/fileexchange/118195-scaramuzza-fisheye-model-implemention/files/computeApproxImageProjection.m


% Creating mapping for fisheye model projection
% Input:
%   pFishEye: camera pinhole calibration (reformatted structure, not matlab object)
%   imsizein: input distorted image resolution [height width]
%           if 4K [2160 3840]
%   imsizeout: output corrected image resolution [height width]
%   viewType: String
%       "full": keep the entire field of view
%       "valid": valid image only
%
% Output:
%   mapX and mapY: Mapping projection to create the undistorted image
%   extraMappingParams: Structure with recentering params
%       offsetCols, offsetRows, cropTop, cropLeft, cropRight, cropBottom, scaleU and scaleV
%
% Apply the following to map the image:
% [outputImage, XYHasNaNs] = imagesbuiltinImageInterpolation2D(Idistorted, map_x, map_y, 'nearest', 0);  



%---Define parameters
extraMappingParams.f_outNew = [];
extraMappingParams.distortion_centerNew = [];
extraMappingParams.update_distortion_center = [];

offsetCols = 0;
offsetRows = 0;
distTop = 0;
distLeft = 0;
distBottom = imsizeout(2);
distRight = imsizeout(1);
scaleU = 1;
scaleV = 1;
H_in = pFishEye.ImageSize(1); %input size
W_in = pFishEye.ImageSize(2); %input size
H_out = imsizeout(1); %output size
W_out = imsizeout(2); %output size
distCenter = pFishEye.DistortionCenter; %Distorsion center
mappingCoeffs = pFishEye.MappingCoefficients; %Fish Eye mapping coef
stretchMat = pFishEye.StretchMatrix; %Stretch matrix
%Unpack
a0 = mappingCoeffs(1);
a2 = mappingCoeffs(2);
a3 = mappingCoeffs(3);
a4 = mappingCoeffs(4);
cx = distCenter(1);
cy = distCenter(2);
 
 
%---Find the lens' max angle
% Use the farthest input-image corner from the distortion centre.
cornersU = [1 1 W_in W_in] - cx;
cornersV = [1 H_in 1 H_in] - cy;
rhoMax = max(sqrt(cornersU.^2 + cornersV.^2));
fAtMax = a0 + a2*rhoMax^2 + a3*rhoMax^3 + a4*rhoMax^4;
thetaMax = atan2(rhoMax, fAtMax);          % half-FOV along the diagonal

%---Virtual perspective camera
% Pick the output focal length so the output diagonal = thetaMax.
% That is the largest f_out that still shows the full input FOV.
cx_out = (W_out + 1)/2;
cy_out = (H_out + 1)/2;
diagOut = sqrt((W_out/2)^2 + (H_out/2)^2);
f_out = diagOut / tan(thetaMax);

%---LUT  theta  ->  rho
N_lut = 4096;
rho_lut = linspace(0, rhoMax*1.05, N_lut).';
f_lut = a0 + a2*rho_lut.^2 + a3*rho_lut.^3 + a4*rho_lut.^4;
theta_lut = atan2(rho_lut, f_lut);
 

% %---Prepare mapping points based on viewType option
% %get undistoroted real full size and position of the new principal point
% [imSizeUndistFull, imSizeUndistValid, newPPFull, newPPValid] = ImSizeUndistort_screen(p, [H_in W_in]);
% newOrigin = [cx-newPPFull(1) cy-newPPFull(2)] + 1;
% nrowUndist = imSizeUndistFull(1);
% ncolUndist = imSizeUndistFull(2);


proceed = 1;
iter = 1;
offsetCols = 0;
offsetRows = 0;
while proceed == 1; %main loop that recenter the image inside the canvas
    %---Output pixel map
    [xo, yo] = meshgrid(1:W_out, 1:H_out);
%     if W_out/nrowUndist < W_out/H_out;
%         %remove some rows (case of DJI Osmo 6) ... DJI has 2176 ish rows instead of 2160
%         rowsIdeal = roundn(ncolUndist ./ (W_out/H_out),0);
%         diffH = abs(rowsIdeal - nrowUndist);
%         xo = xo(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
%         yo = yo(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
%     end;

    %3-D ray for every output pixel (pin-hole / perspective model)
    X = xo - cx_out - offsetCols;
    Y = yo - cy_out - offsetRows;
    Z = f_out;
    R = sqrt(X.^2 + Y.^2);
    theta = atan2(R, Z);
     
    %---Look-up rho on the input
    rho = interp1(theta_lut, rho_lut, theta, 'linear', NaN);
    
    %---Back to sensor-plane coordinates
    Rsafe = R;
    Rsafe(R == 0) = 1;
    u_s = rho .* X ./ Rsafe;
    v_s = rho .* Y ./ Rsafe;
    u_s(R == 0) = 0;
    v_s(R == 0) = 0;
    
    %---Stretch + distortion centre
    u_p = stretchMat(1,1)*u_s + stretchMat(1,2)*v_s;
    v_p = stretchMat(2,1)*u_s + stretchMat(2,2)*v_s;
    map_x = u_p + cx;        % column coordinate in the input fisheye
    map_y = v_p + cy;        % row coordinate in the input fisheye

%     [outputImage, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0);  
%     figure; imshow(outputImage);

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
[xo, yo] = meshgrid(1:W_out, 1:H_out);
% if ncolUndist/nrowUndist < W_out/H_out;
%     %remove some rows (case of DJI Osmo 6) ... DJI has 2176 ish rows instead of 2160
%     rowsIdeal = roundn(ncolUndist ./ (W_out/H_out),0);
%     diffH = abs(rowsIdeal - nrowUndist);
%     xo = xo(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
%     yo = yo(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
% end;

%3-D ray for every output pixel (pin-hole / perspective model)
X = xo - cx_out - offsetCols;
Y = yo - cy_out - offsetRows;
Z = f_out;
R = sqrt(X.^2 + Y.^2);
theta = atan2(R, Z);
 
%---Look-up rho on the input
rho = interp1(theta_lut, rho_lut, theta, 'linear', NaN);

%---Back to sensor-plane coordinates
Rsafe = R;
Rsafe(R == 0) = 1;
u_s = rho .* X ./ Rsafe;
v_s = rho .* Y ./ Rsafe;
u_s(R == 0) = 0;
v_s(R == 0) = 0;

%---Stretch + distortion centre
u_p = stretchMat(1,1)*u_s + stretchMat(1,2)*v_s;
v_p = stretchMat(2,1)*u_s + stretchMat(2,2)*v_s;
map_x = u_p + cx;        % column coordinate in the input fisheye
map_y = v_p + cy;        % row coordinate in the input fisheye


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

% figure;imshow(frame5);
% title('f5:resized again')
% figure;imshow(frame4);
% title('f4:cropped')
% figure;imshow(frame3);
% title('f3:Distortion applied')
% figure;imshow(frame2);
% title('f2:resized to 4K')
% figure;imshow(frame1);
% title('f1:origined and offseted')

