function [map_x, map_y, pOpt, extraMappingParams] = optiUndistortPinHoleMap(params, imsizein, imsizeout, viewType, ptDLTValid, doOptimisation, doTopDown, frame);
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
u = ptDLTValid(:,1);
v = ptDLTValid(:,2);
X = ptDLTValid(:,3);
Y = ptDLTValid(:,4);
N = size(ptDLTValid,1);


%% ---------- fit ----------
model = polyCalibrate(ptDLTValid, 'Degree', 5, 'MadThresh', 3.0, 'Verbose', true);

% Show which control points were flagged
outIdx = find(~model.keep);
% fprintf('\nRejected outliers:\n');
xyHat = polyApply(model, CP(:,1:2), 'forward');
% for k = 1:numel(outIdx)
%     i = outIdx(k);
%     fprintf('  row %2d: (u,v)=(%7.1f,%7.1f)  given=(%4.1f,%4.1f)  fit=(%6.2f,%6.2f)\n', ...
%         i, CP(i,1), CP(i,2), CP(i,3), CP(i,4), xyHat(i,1), xyHat(i,2));
% end

%% ---------- visualise residuals ----------
figure;
subplot(1,2,1);
hold on; axis equal; grid on;
scatter(ptDLTValid(model.keep,3),  ptDLTValid(model.keep,4),  40, 'g',  'filled');
scatter(ptDLTValid(~model.keep,3), ptDLTValid(~model.keep,4), 100, 'r', 'x', 'LineWidth',2);
scatter(xyHat(model.keep,1), xyHat(model.keep,2), 60, 'b');
for i = 1:size(CP,1)
    plot([ptDLTValid(i,3) xyHat(i,1)], [ptDLTValid(i,4) xyHat(i,2)], 'k-');
end
xlabel('x [m]'); ylabel('y [m]');
title(sprintf('World residuals (RMS = %.3f m)', model.rmsWorld));
legend({'inliers','outliers','reprojected'}, 'Location','best');
 
subplot(1,2,2);
hold on; grid on;
scatter(ptDLTValid(model.keep,1),  ptDLTValid(model.keep,2),  40, 'g',  'filled');
scatter(ptDLTValid(~model.keep,1), ptDLTValid(~model.keep,2), 100, 'r', 'x', 'LineWidth',2);
xlabel('u [px]'); ylabel('v [px]'); set(gca,'YDir','reverse');
title('Control points in distorted image');
legend({'inliers','outliers'}, 'Location','best');


%% ---------- warp the image to a metric top-down view ----------
pxPerMetre = 30;
xs = 0 : 1/pxPerMetre : 50;
ys = 0 : 1/pxPerMetre : 25;
[XX, YY] = meshgrid(xs, ys);

UV = polyApply(model, [XX(:) YY(:)], 'inverse');
U  = reshape(UV(:,1), size(XX));
V  = reshape(UV(:,2), size(XX));

% Out-of-image samples -> NaN so they appear black
bad = U<1 | U>W | V<1 | V>H;
U(bad) = NaN; V(bad) = NaN;



[frameOut, ~] = imagesbuiltinImageInterpolation2D(frame, map_x, map_y, 'nearest', 0);
figure;imshow(frameOut);

eee=eee


if doTopDown == 1;
    if doOptimisation == 1;
        pOpt.fx = fx; %Optimised fx
        pOpt.fy = fy; %Optimised fy
        pOpt.cx = cx; %Optimised cx
        pOpt.cy = cy; %Optimised cy
        pOpt.k1 = k1; %Optimised k1
        pOpt.k2 = k2; %Optimised k2
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
        pOpt.KK = [fx 0 cx; 0 fy cy; 0 0 1]; %Optimised KK
        [map_x, map_y] = topDownProjection(pOpt, ptDLTValid, imsizeout, margin_m, frame);
    else;
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
        pIni.KK = [fx0 0 cx0; 0 fy0 cy0; 0 0 1];
        [map_x, map_y] = topDownProjection(pIni, ptDLTValid, imsizeout, margin_m, frame);
    end;
    extraMappingParams = [];
else
    if doOptimisation == 1;
        pOpt.fx = fx; %Optimised fx
        pOpt.fy = fy; %Optimised fy
        pOpt.cx = cx; %Optimised cx
        pOpt.cy = cy; %Optimised cy
        pOpt.k1 = k1; %Optimised k1
        pOpt.k2 = k2; %Optimised k2
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
        pOpt.KK = [fx 0 cx; 0 fy cy; 0 0 1]; %Optimised KK
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



%% =====================================================================
%% Helpers
%% =====================================================================
function F = polyFeat(a, b, deg, centre, scale)
    an = (a - centre(1)) / scale;
    bn = (b - centre(2)) / scale;
    cols = (deg+1)*(deg+2)/2;
    F = zeros(numel(a), cols);
    k = 1;
    for total = 0:deg
        for i = 0:total
            j = total - i;
            F(:,k) = (an.^i) .* (bn.^j);
            k = k + 1;
        end
    end


function [xn, yn] = brown_undistort(u, v, p, fx, fy, cx, cy)
    k1 = p(1); k2 = p(2); k3 = p(3); pp1 = p(4); pp2 = p(5);
    xd = (u - cx)/fx;
    yd = (v - cy)/fy;
    xn = xd;  yn = yd;
    for it = 1:25
        r2  = xn.^2 + yn.^2;
        rad = 1 + k1*r2 + k2*r2.^2 + k3*r2.^3;
        dxT = 2*pp1*xn.*yn + pp2*(r2 + 2*xn.^2);
        dyT = pp1*(r2 + 2*yn.^2) + 2*pp2*xn.*yn;
        xn  = (xd - dxT) ./ rad;
        yn  = (yd - dyT) ./ rad;
    end


function H = fit_homography(xn, yn, X, Y)
    n = numel(xn);
    A = zeros(2*n, 9);
    for i = 1:n
        A(2*i-1,:) = [-xn(i), -yn(i), -1,  0,     0,    0, X(i)*xn(i), X(i)*yn(i), X(i)];
        A(2*i,  :) = [ 0,      0,     0, -xn(i),-yn(i),-1, Y(i)*xn(i), Y(i)*yn(i), Y(i)];
    end
    [~,~,V] = svd(A, 'econ');
    H = reshape(V(:,end), 3, 3).';


function res = brown_world_res(p, u, v, X, Y, fx, fy, cx, cy)
    [xn, yn] = brown_undistort(u, v, p, fx, fy, cx, cy);
    H = fit_homography(xn, yn, X, Y);
    w_ = H(3,1)*xn + H(3,2)*yn + H(3,3);
    Xp = (H(1,1)*xn + H(1,2)*yn + H(1,3)) ./ w_;
    Yp = (H(2,1)*xn + H(2,2)*yn + H(2,3)) ./ w_;
    res = [X - Xp; Y - Yp];


