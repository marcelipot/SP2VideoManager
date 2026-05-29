function [map_x, map_y, extraMappingParams] = initUndistortPinHoleMap(p, imsizein, imsizeout, viewType);
% References
% https://docs.opencv.org/4.x/d9/d0c/group__calib3d.html
% https://robots.stanford.edu/cs223b04/JeanYvesCalib/index.html#updates
% https://docs.opencv.org/3.4/da/d54/group__imgproc__transform.html#ga7dfb72c9cf9780a347fbe3d1c47e5d5a
% https://amroamroamro.github.io/mexopencv/matlab/cv.initUndistortRectifyMap.html
% https://kyamagu.github.io/mexopencv/matlab/initUndistortRectifyMap.html


% Creating mapping for pinhole model projection
% Input:
%   p: camera pinhole calibration (reformatted structure, not matlab object)
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
offsetCols = 0;
offsetRows = 0;
distTop = 0;
distLeft = 0;
distBottom = imsizeout(2);
distRight = imsizeout(1);
scaleU = 1;
scaleV = 1;
H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);
Hec = H_out;
Wec = W_out;

KK = p.KK; %Internal param matrix
fx = p.fx; %Focal length x
fy = p.fy; %Focal length y
cx = p.cx; %Principal point x
cy = p.cy; %Principal point y
k1 = p.k1; %Radial distortion coef 1
k2 = p.k2; %Radial distortion coef 2
k3 = p.k3; %Radial distortion coef 3
k4 = p.k4; %Radial distortion coef 4
k5 = p.k5; %Radial distortion coef 5
k6 = p.k6; %Radial distortion coef 6
p1 = p.p1; %tangential distortion coef 1
p2 = p.p2; %tangential distortion coef 2
s1 = p.s1; %prism distortion coef 1
s2 = p.s2; %prism distortion coef 2
s3 = p.s3; %prism distortion coef 3
s4 = p.s4; %prism distortion coef 4


%---Prepare mapping points based on viewType option
%get undistoroted real full size and position of the new principal point
[imSizeUndistFull, imSizeUndistValid, newPPFull, newPPValid] = ImSizeUndistort_screen(p, [H_in W_in]);
newOrigin = [cx-newPPFull(1) cy-newPPFull(2)] + 1;
nrowUndist = imSizeUndistFull(1);
ncolUndist = imSizeUndistFull(2);

proceed = 1;
iter = 1;
offsetCols = 0;
offsetRows = 0;
while proceed == 1; %main loop that recenter the image inside the canvas
    %---create map
    [u, v] = meshgrid(1:ncolUndist, 1:nrowUndist); %prepare a meshgrid
    if roundn(ncolUndist/nrowUndist,-3) < roundn(W_out/H_out,-3);
        rowsIdeal = roundn(ncolUndist ./ (W_out/H_out),0);
        if rowsIdeal > 1;
            diffH = abs(rowsIdeal - nrowUndist);
            u = u(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
            v = v(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
        end;
    end;
    
    u = (u + newOrigin(1)) - offsetCols; %offset the new origin u
    v = (v + newOrigin(2)) - offsetRows; %offset the new origin v
    u = roundn(imresize(u, [H_out W_out], 'bilinear'),0); %resize map a first time in case rows have been removed (DJI case)
    v = roundn(imresize(v, [H_out W_out], 'bilinear'),0);
    u = reshape(u, H_out*W_out, 1); %reshape as a column vector
    v = reshape(v, H_out*W_out, 1); %reshape as a column vector

    %Normalize to camera coordinates to real world space
    Xp = (u' - cx) / fx;
    Yp = (v' - cy) / fy;
    
    %---Apply distortion correction
    r2 = Xp(1,:).^2 + Yp(1,:).^2;
    x = Xp(1,:);
    y = Yp(1,:);
    
    xpp = x.*(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + 2*p1.*x.*y + p2*(r2 + 2.*x.^2) + s1.*r2 + s2.*r2.^2;
    ypp = y.*(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + p1.*(r2 + 2.*y.^2) + 2*p2.*x.*y + s3.*r2 + s4.*r2.^2;

    %---Reconvert back to pixels
    map_x = fx*xpp + cx;
    map_y = fy*ypp + cy;

    %---Reshape back to output size (from column vector)
    map_x = reshape(map_x, [H_out W_out]);
    map_y = reshape(map_y, [H_out W_out]); 

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
[u, v] = meshgrid(1:ncolUndist, 1:nrowUndist); %prepare a meshgrid
if roundn(ncolUndist/nrowUndist,-3) < roundn(W_out/H_out,-3);
    %remove some rows (case of DJI Osmo 6)
    rowsIdeal = roundn(ncolUndist ./ (W_out/H_out),0);
    if rowsIdeal > 1;
        diffH = abs(rowsIdeal - nrowUndist);
        u = u(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
        v = v(floor(diffH./2):ceil(nrowUndist-ceil(diffH./2)), :);
    end;
end;
u = (u + newOrigin(1)) - offsetCols; %offset the new origin u
v = (v + newOrigin(2)) - offsetRows; %offset the new origin v
%---Create figure 1 for checks in ptmapping function
% [frame1, ~] = imagesbuiltinImageInterpolation2D(frame, u, v, 'nearest', 0); 

u = roundn(imresize(u, [H_out W_out], 'bilinear'),0);
v = roundn(imresize(v, [H_out W_out], 'bilinear'),0);
%---Create figure 2 for checks in ptmapping function
% [frame2, ~] = imagesbuiltinImageInterpolation2D(frame, u, v, 'nearest', 0); 
u = reshape(u, H_out*W_out, 1); %reshape as a column vector
v = reshape(v, H_out*W_out, 1); %reshape as a column vector

%Normalize to camera coordinates
Xp = (u' - cx) / fx;
Yp = (v' - cy) / fy;

%---Apply distortion
r2 = Xp(1,:).^2 + Yp(1,:).^2;
x = Xp(1,:);
y = Yp(1,:);

xpp = x.*(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + 2*p1.*x.*y + p2*(r2 + 2.*x.^2) + s1.*r2 + s2.*r2.^2;
ypp = y.*(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + p1.*(r2 + 2.*y.^2) + 2*p2.*x.*y + s3.*r2 + s4.*r2.^2;

%---Reconvert back to pixels
map_x = fx*xpp + cx;
map_y = fy*ypp + cy;

map_x = reshape(map_x, [H_out W_out]);
map_y = reshape(map_y, [H_out W_out]);
%---Create figure 3 for checks in ptmapping function
% [frame3, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 

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

