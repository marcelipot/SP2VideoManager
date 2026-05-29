function [map_x, map_y, pOpt, extraMappingParams] = optiUndistortPinHoleMap1(params, imsizein, imsizeout, viewType, ptDLTValid, doOptimisation, doTopDown, frame);
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



%Define parameters for top-down projection if needed
map_x = [];
map_y = [];
pOpt = [];
extraMappingParams = [];
H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);
margin_m = 0.1; % world-space margin around control region as pourcentage
fx0 = params.fx;
fy0 = params.fy;
cx0 = params.cx;
cy0 = params.cy;
k10 = params.k1;
k20 = params.k2;
k30 = params.k3;
k40 = params.k4;
k50 = params.k5;
k60 = params.k6;
p10 = params.p1;
p20 = params.p2;
s10 = params.s1;
s20 = params.s2;
s30 = params.s3;
s40 = params.s4;
KK0 = params.KK;


%--- Define lines
uPts = ptDLTValid(:,1);
vPts = ptDLTValid(:,2);
xPts = ptDLTValid(:,3);
yPts = ptDLTValid(:,4);

% Group indices: 5 vertical lines (constant x) and 5 horizontal lines (constant y)
xVals = unique(xPts);   % [0 15 25 35 50]
yVals = unique(yPts);   % [0 5 10 15 20]
 
vertGroups = cell(numel(xVals),1);
for i = 1:numel(xVals)
    vertGroups{i} = find(xPts == xVals(i));
end
horzGroups = cell(numel(yVals),1);
for j = 1:numel(yVals)
    horzGroups{j} = find(yPts == yVals(j));
end


%---OPTIMISATION
%Decision vector: p = [fx fy cx cy k1 k2]
p0 = [fx0 fy0 cx0 cy0 k10 k20];
 
% Light anchoring (acts as soft prior to keep solution physical)
sigma  = [50 50 30 30 1.0 1.0];
lambda = 0.05;
 
resFun = @(p) lineStraightnessResidual(p, uPts, vPts, ...
                                       vertGroups, horzGroups, ...
                                       p0, sigma, lambda);
 
opts = optimoptions('lsqnonlin', ...
    'Display','iter', ...
    'MaxFunctionEvaluations', 5000, ...
    'MaxIterations', 500, ...
    'FunctionTolerance', 1e-12, ...
    'StepTolerance', 1e-12, ...
    'OptimalityTolerance', 1e-10, ...
    'Display', 'off');
 
pNew = lsqnonlin(resFun, p0, [], [], opts);

fxN = pNew(1);
fyN = pNew(2);
cxN = pNew(3);
cyN = pNew(4);
k1N = pNew(5);
k2N = pNew(6);
KKN = [fxN 0 cxN; 0 fyN cyN; 0 0 1];


[rmseAll0, rmse0, max0] = straightnessStats(p0,  uPts, vPts, vertGroups, horzGroups);
[rmseAll1, rmse1, max1] = straightnessStats(pNew,uPts, vPts, vertGroups, horzGroups);
val_residual = [rmse1 max1];
% 
% %find outliers
% rmseAll1 = sort(rmseAll1,'descend');
% [indexOutliers, indexsort] = find(rmseAll1 >= 3.*rmse1);
% if length(indexOutliers) > 0.3*length(uPts);
%     indexOutliersReal = indexsort(1:ceil(0.1*length(uPts)));
% else;
%     indexOutliersReal = indexsort(indexOutliers);
% end;
% rmseAll1
% rmse1
% indexOutliers
% indexsort
% indexOutliersReal
% 
% eee=eee

%---Modify fx, fy and cx and cy
% Sample border pixels of the input image, undistort them analytically into
% the original-K's normalised plane, then map them to pixel coordinates.
% The bounding box of those projections defines the FOV; we then scale a
% new K so the bbox fits exactly inside Wout x Hout (with letterboxing).
Nb = 200;
edge1 = [linspace(1, W_in, Nb).' , ones(Nb,1)];
edge2 = [linspace(1, W_in, Nb).' , H_in*ones(Nb,1)];
edge3 = [ones(Nb,1)           , linspace(1, H_in, Nb).'];
edge4 = [W_in*ones(Nb,1)         , linspace(1, H_in, Nb).'];
border = [edge1; edge2; edge3; edge4];
 
% Undistort border points (iterative inverse of the distortion model)
xn_b = (border(:,1) - cxN) / fxN;
yn_b = (border(:,2) - cyN) / fyN;
xu = xn_b;  yu = yn_b;
for it = 1:30
    r2 = xu.^2 + yu.^2;
    f  = 1 + k1N.*r2 + k2N.*r2.^2;
    xu = xn_b ./ f;
    yu = yn_b ./ f;
end
% Project back through original K to get pixel coords in the undistorted frame
uUnd = fxN*xu + cxN;
vUnd = fyN*yu + cyN;
 
uMin = min(uUnd); uMax = max(uUnd);
vMin = min(vUnd); vMax = max(vUnd);
Wb = uMax - uMin;
Hb = vMax - vMin;
 
% Scale to fit the requested output size while preserving aspect (full FOV)
s = min(W_out / Wb, H_out / Hb);
fxF = fxN * s;
fyF = fyN * s;
% Centre the projected bbox inside the output canvas
cxF = s * (cxN - uMin) + (W_out - s*Wb)/2;
cyF = s * (cyN - vMin) + (H_out - s*Hb)/2;
KKN = [fxF 0 cxF; 0 fyF cyF; 0 0 1];
fxN = fxN;
fyN = fyN;
cxN = cxN;
cyN = cyN;

if doTopDown == 1;
    if doOptimisation == 1;
        pOpt.KK = KKN; %same KK
        pOpt.fx = fxN; %same fx
        pOpt.fy = fyN; %same fy
        pOpt.cx = cxN; %same cx
        pOpt.cy = cyN; %same cy
        pOpt.k1 = k1N; %Optimised k1
        pOpt.k2 = k2N; %Optimised k2
        pOpt.k3 = 0;
        pOpt.k4 = 0;
        pOpt.k5 = 0;
        pOpt.k6 = 0;
        pOpt.p1 = 0;
        pOpt.p2 = 0;
        pOpt.s1 = 0;
        pOpt.s2 = 0;
        pOpt.s3 = 0;
        pOpt.s4 = 0;
        [map_x, map_y] = topDownProjection(pOpt, ptDLTValid, imsizeout, margin_m, frame);
    else;
        pIni.KK = KK0;
        pIni.fx = fx0; %Native fx
        pIni.fy = fy0; %Native fy
        pIni.cx = cx0; %Native cx
        pIni.cy = cy0; %Native cy
        pIni.k1 = k10; %Native k1
        pIni.k2 = k20; %Native k2
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
        [map_x, map_y] = topDownProjection(pIni, ptDLTValid, imsizeout, margin_m, frame);
    end;
    extraMappingParams = [];
else
    if doOptimisation == 1;
        pOpt.KK = KKN; %same KK
        pOpt.fx = fxN; %same fx
        pOpt.fy = fyN; %same fy
        pOpt.cx = cxN; %same cx
        pOpt.cy = cyN; %same cy
        pOpt.k1 = k1N; %Optimised k1
        pOpt.k2 = k2N; %Optimised k2
        pOpt.k3 = 0;
        pOpt.k4 = 0;
        pOpt.k5 = 0;
        pOpt.k6 = 0;
        pOpt.p1 = 0;
        pOpt.p2 = 0;
        pOpt.s1 = 0;
        pOpt.s2 = 0;
        pOpt.s3 = 0;
        pOpt.s4 = 0;
        [map_x, map_y, extraMappingParams] = initUndistortPinHoleMap(pOpt, imsizein, imsizeout, viewType);
    end;
end;




% =====================================================================
function [Ud, Vd] = topDownProjection(pOpt, ptDLTValid, imResout, margin, frame)
% TOPDOWNPROJECTION  Build a top-down view of the world plane at the
% requested output resolution (Wout x Hout) and save it.
    %  1) Pick the homography-fitting subset of control points (topDownIdx).
    %  2) Undistort those points to normalised image coords.
    %  3) Solve homography H : (X,Y,1) ~ (xn,yn,1) by DLT.
    %     With 4 points the fit is exact; with more it is least-squares.
    %  4) For each output pixel, invert the affine output<->world mapping
    %     using topDownBBox, apply H, distort, and sample the source image.
    %  5) Mask output pixels that map behind the camera (sign flip in denom).
 
    uFit = ptDLTValid(:,1);
    vFit = ptDLTValid(:,2);
    xFit = ptDLTValid(:,3);
    yFit = ptDLTValid(:,4);
    H_out = imResout(1);
    W_out = imResout(2);
    [uo, vo] = meshgrid(1:W_out, 1:H_out);
    

    if abs(max(xFit) - 50) <= abs(max(xFit) - 25);
        %LCM
        limMinX = 0 - (50.*margin);
        limMaxX = 50 + (50.*margin);
        if abs(min(yFit) - 0) <= 5;
            limMinY = 0 - (25.*margin);
        else;
            limMinY = min(yFit) - (min(yFit).*margin);
        end;
        if abs(max(yFit) - 25) <= 5;
            limMaxY = 25 + (25.*margin);
        else;
            limMaxY = max(yFit) + (25.*margin);
        end;
    else;
        %SCM
        limMinX = 0 - (25.*margin);
        limMaxX = 25 + (25.*margin);;
        if abs(min(yFit) - 0) <= 5;
            limMin = 0 - (25.*margin);
        else;
            limMin = min(yFit) - (min(yFit).*margin);
        end;
        if abs(max(yFit) - 25) <= 5;
            limYMaxY = 25 + (25.*margin);
        else;
            limMaxY = max(yFit) + (25.*margin);
        end;
    end;
    topDownBBox = [limMinX limMaxX limMinY limMaxY];


    p(1) = pOpt.fx;
    p(2) = pOpt.fy;
    p(3) = pOpt.cx;
    p(4) = pOpt.cy;
    p(5) = pOpt.k1;
    p(6) = pOpt.k2;
    [Xn, Yn] = undistortPts(uFit, vFit, p);
    Hmat = computeHomography(xFit, yFit, Xn, Yn);
 
    pred = Hmat * [xFit.'; yFit.'; ones(1,numel(xFit))];
    rep = sqrt((pred(1,:)./pred(3,:) - Xn.').^2 + ...
                 (pred(2,:)./pred(3,:) - Yn.').^2);
 
%     other = setdiff((1:numel(uPts)).', [1:length(uFit(:,1))]);
%     if ~isempty(other)
%         [Xn_o, Yn_o] = undistortPts(uPts(other), vPts(other), pOpt);
%         pred_o = Hmat * [xPts(other).'; yPts(other).'; ones(1,numel(other))];
%         repO   = sqrt((pred_o(1,:)./pred_o(3,:) - Xn_o.').^2 + ...
%                       (pred_o(2,:)./pred_o(3,:) - Yn_o.').^2);
%     end
 
    % Explicit world bbox per topDownBBox = [Xmin Xmax Ymin Ymax]
    Xmin = topDownBBox(1);
    Xmax = topDownBBox(2);
    Ymin = topDownBBox(3);
    Ymax = topDownBBox(4);
    Wworld = Xmax - Xmin;
    Hworld = Ymax - Ymin;
 
    % Anisotropic px/m so the whole canvas is filled.
    sx = W_out / Wworld;
    sy = H_out / Hworld;
 
    % output pixel (1..W, 1..H) -> world (X,Y)
    Xw = (uo - 0.5)/sx + Xmin;
    Yw = (vo - 0.5)/sy + Ymin;
 
    denom = Hmat(3,1)*Xw + Hmat(3,2)*Yw + Hmat(3,3);
    xn = (Hmat(1,1)*Xw + Hmat(1,2)*Yw + Hmat(1,3)) ./ denom;
    yn = (Hmat(2,1)*Xw + Hmat(2,2)*Yw + Hmat(2,3)) ./ denom;
 
    % Mask points that fall behind the camera. The reference depth W_ref is
    % the median 3rd homogeneous coord of the control points after H^-1.
    Hinv = inv(Hmat);
    ctrlH = Hinv * [Xn.'; Yn.'; ones(1,numel(Xn))];
    sign_ref = sign(median(ctrlH(3,:)));
    behind = (denom * sign_ref) <= 0;
 
    r2 = xn.^2 + yn.^2;
    f = 1 + pOpt.k1.*r2 + pOpt.k2.*r2.^2;
    map_x = pOpt.fx*(xn .* f) + pOpt.cx;
    map_y = pOpt.fy*(yn .* f) + pOpt.cy;
    map_x(behind) = -1;     % force out-of-bounds for interp2 -> black
    map_y(behind) = -1;

    
    [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0); 
    figure;imshow(frame);
    eee=eee



% =============================================================================
% Local functions
% =============================================================================
function res = lineStraightnessResidual(p, u, v, vertGroups, horzGroups, ...
                                        p0, sigma, lambda)
    % Undistort all control points with the candidate intrinsics, then
    % measure the perpendicular distance of each point to the best-fit line
    % through its row / column. Append a soft anchor on the parameters.
    [Xu, Yu] = undistortPts(u, v, p);
 
    res = [];
    for i = 1:numel(vertGroups)
        idx = vertGroups{i};
        res = [res; perpDist(Xu(idx), Yu(idx))];        %#ok<AGROW>
    end
    for j = 1:numel(horzGroups)
        idx = horzGroups{j};
        res = [res; perpDist(Xu(idx), Yu(idx))];        %#ok<AGROW>
    end
 
    anchor = lambda * ((p - p0) ./ sigma).';
    res = [res; anchor];

 
function [rmseAll, rmse, mx] = straightnessStats(p, u, v, vertGroups, horzGroups)
    [Xu, Yu] = undistortPts(u, v, p);
    d = [];
    for i = 1:numel(vertGroups)
        d = [d; perpDist(Xu(vertGroups{i}), Yu(vertGroups{i}))]; %#ok<AGROW>
    end
    for j = 1:numel(horzGroups)
        d = [d; perpDist(Xu(horzGroups{j}), Yu(horzGroups{j}))]; %#ok<AGROW>
    end
    rmseAll = sqrt(d.^2);
    rmse = sqrt(mean(d.^2));
    mx   = max(abs(d));

 
function d = perpDist(x, y)
    % Perpendicular distance of points (x,y) to their best-fit line via SVD.
    x = x(:); y = y(:);
    cx = mean(x); cy = mean(y);
    A = [x - cx, y - cy];
    [~,~,V] = svd(A, 'econ');
    n = V(:,end);                  % unit normal of the best-fit line
    d = A * n;                     % signed perpendicular distances

 
function [Xu, Yu] = undistortPts(u, v, p)
    fx = p(1); fy = p(2); cx = p(3); cy = p(4);
    k1 = p(5); k2 = p(6);
    xn = (u - cx) / fx;
    yn = (v - cy) / fy;
    Xu = xn;  Yu = yn;
    for it = 1:30
        r2 = Xu.^2 + Yu.^2;
        f  = 1 + k1.*r2 + k2.*r2.^2;
        Xu = xn ./ f;
        Yu = yn ./ f;
    end


function H = computeHomography(X, Y, xn, yn)
    % DLT: solve for H s.t. [xn; yn; 1] ~ H * [X; Y; 1] over all correspondences.
    X = X(:); Y = Y(:); xn = xn(:); yn = yn(:);
    N = numel(X);
    A = zeros(2*N, 9);
    for i = 1:N
        Xi = X(i); Yi = Y(i); xi = xn(i); yi = yn(i);
        A(2*i-1,:) = [-Xi, -Yi, -1,   0,   0,  0,  xi*Xi,  xi*Yi,  xi];
        A(2*i  ,:) = [  0,   0,  0, -Xi, -Yi, -1,  yi*Xi,  yi*Yi,  yi];
    end
    [~,~,V] = svd(A, 'econ');
    h = V(:,end);
    H = reshape(h, 3, 3).';   % rows of H come from rows of h
    H = H / H(3,3);


function [pn, T] = normalizePts(pts)
% Hartley normalisation: shift to centroid, scale so mean distance = sqrt(2).
    c  = mean(pts, 1);
    d  = pts - c;
    s  = sqrt(2) / mean(sqrt(sum(d.^2, 2)));
    T  = [s 0 -s*c(1); 0 s -s*c(2); 0 0 1];
    ph = (T * [pts, ones(size(pts,1),1)].').';
    pn = ph(:, 1:2);

