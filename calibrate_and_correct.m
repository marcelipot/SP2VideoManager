%% Camera calibration optimisation + rectilinear correction (+ optional top-down)
% ------------------------------------------------------------------------
% Loads a wide-angle image, optimises the intrinsic + radial-distortion
% parameters using a set of co-planar control points so that the corrected
% image becomes as rectilinear as possible, then produces a 2160x3840
% rectilinear image. If `condition == 1`, an additional top-down (bird's-eye)
% projection of the same scene is produced, also forced to 2160x3840.
% ------------------------------------------------------------------------

clear; clc; close all;

% ---- 0. USER OPTIONS ----------------------------------------------------
condition = 1;                        % 0 = rectilinear only, 1 = also top-down
imgPath   = 'ImUltrawide.png';        % input image

% ---- 1. LOAD IMAGE ------------------------------------------------------
img = imread(imgPath);
[Horig, Worig, ~] = size(img);
fprintf('Source image: %d x %d\n', Worig, Horig);

% ---- 2. INITIAL INTRINSICS ---------------------------------------------
fx0 = 1203.3;  fy0 = 1203.3;
cx0 = 1660.3;  cy0 =  833.9;
k1_0 = 0;       k2_0 = 0;

% ---- 3. CONTROL POINTS (u,v) <-> world (x,y, z=0) -----------------------
%        Columns: [u  v  X  Y]
ctrl = [ ...
     981.73   897.34    0    0;
     848.62   946.16    0    5;
     677.02  1009.11    0   10;
     455.89  1089.48    0   15;
     160.39  1193.07    0   20;
    1872.53   872.58   25    0;
    1855.05   923.09   25    5;
    1831.85   994.83   25   10;
    1795.88  1096.88   25   15;
    1736.87  1250.80   25   20;
    2820.98   884.73   50    0;
    2941.31   936.35   50    5;
    3099.81  1002.69   50   10;
    3613.30  1212.82   50   20];

u_obs = ctrl(:,1);  v_obs = ctrl(:,2);
Xw    = ctrl(:,3);  Yw    = ctrl(:,4);

% ---- 4. OPTIMISATION ----------------------------------------------------
% Cost: undistort observed points, fit a homography world->undist, then
% measure the reprojection error. This forces the undistorted points to
% obey a perspective projection of a planar grid (i.e. lines stay straight
% AND vanishing-point structure is respected).
p0 = [fx0, fy0, cx0, cy0, k1_0, k2_0];
lb = [ 400,  400,    0,    0, -2, -2];
ub = [3000, 3000, Worig, Horig,  2,  2];

opts = optimoptions('lsqnonlin', ...
    'Display','iter', ...
    'MaxIterations',2000, 'MaxFunctionEvaluations',20000, ...
    'FunctionTolerance',1e-12, 'StepTolerance',1e-12);

costFcn = @(p) reprojectionResiduals(p, u_obs, v_obs, Xw, Yw);
p_opt   = lsqnonlin(costFcn, p0, lb, ub, opts);

fx = p_opt(1);  fy = p_opt(2);
cx = p_opt(3);  cy = p_opt(4);
k1 = p_opt(5);  k2 = p_opt(6);

resOpt = costFcn(p_opt);
fprintf('\n--- Optimised intrinsics ---\n');
fprintf('fx = %.4f   fy = %.4f\n', fx, fy);
fprintf('cx = %.4f   cy = %.4f\n', cx, cy);
fprintf('k1 = %.6f   k2 = %.6f\n', k1, k2);
fprintf('RMS reprojection error: %.3f px\n', sqrt(mean(resOpt.^2)));

% ---- 5. RECTILINEAR (UNDISTORTED) IMAGE --------------------------------
Hout = 2160;  Wout = 3840;

% K of the source camera
K = [fx 0 cx; 0 fy cy; 0 0 1];

% Build K_new so that the ENTIRE field of view of the source image is
% preserved inside the Hout x Wout output frame.
% Step 1: sample the border of the source image and undistort each sample
% to normalised undistorted coordinates.
N = 500;
u_top    = linspace(0, Worig-1, N);    v_top    = zeros(1, N);
u_bot    = linspace(0, Worig-1, N);    v_bot    = (Horig-1) * ones(1, N);
v_lef    = linspace(0, Horig-1, N);    u_lef    = zeros(1, N);
v_rig    = linspace(0, Horig-1, N);    u_rig    = (Worig-1) * ones(1, N);
u_border = [u_top, u_bot, u_lef, u_rig].';
v_border = [v_top, v_bot, v_lef, v_rig].';

xd_b = (u_border - cx) / fx;
yd_b = (v_border - cy) / fy;
[xu_b, yu_b] = undistortNormalised(xd_b, yd_b, k1, k2);

xu_min = min(xu_b);  xu_max = max(xu_b);
yu_min = min(yu_b);  yu_max = max(yu_b);

% Step 2: pick a single scale that fits the FOV in both axes (preserves
% the natural aspect ratio of the rectilinear projection).  Then place
% the principal point so the FOV is centred in the output frame.
sx     = (Wout - 1) / (xu_max - xu_min);
sy     = (Hout - 1) / (yu_max - yu_min);
f_new  = min(sx, sy);
cx_new = (Wout - 1)/2 - f_new * (xu_min + xu_max)/2;
cy_new = (Hout - 1)/2 - f_new * (yu_min + yu_max)/2;

K_new = [f_new 0 cx_new; 0 f_new cy_new; 0 0 1];

fprintf('\n--- New camera matrix (full FOV preserved) ---\n');
fprintf('f_new  = %.4f\n', f_new);
fprintf('cx_new = %.4f   cy_new = %.4f\n', cx_new, cy_new);

[Uo, Vo] = meshgrid(1:Wout, 1:Hout);

% For each output pixel -> normalised coords -> apply forward distortion ->
% source pixel to sample.
xn =  (Uo - K_new(1,3)) / K_new(1,1);
yn =  (Vo - K_new(2,3)) / K_new(2,2);
r2 =  xn.^2 + yn.^2;
fac = 1 + k1*r2 + k2*r2.^2;
xd = xn .* fac;     yd = yn .* fac;
Usrc = K(1,1)*xd + K(1,3);
Vsrc = K(2,2)*yd + K(2,3);

img_rect = zeros(Hout, Wout, size(img,3), 'uint8');
for c = 1:size(img,3)
    img_rect(:,:,c) = uint8( interp2(double(img(:,:,c)), Usrc, Vsrc, 'linear', 0) );
end

figure('Name','Rectilinear corrected');
imshow(img_rect);
title(sprintf('Rectilinear  (k1=%.4f, k2=%.4f)', k1, k2));
imwrite(img_rect, 'corrected_rectilinear.png');

% ---- 6. OPTIONAL TOP-DOWN PROJECTION -----------------------------------
if condition == 1
    % World rectangle to render. The grid covers x:0..50, y:0..20.
    % A small margin is added so we get some context around the grid.
    x_min = -5;   x_max = 55;        % metres
    y_min = -2;   y_max = 25;

    % Forced output size 2160x3840 (height, width). The world box is
    % stretched independently in x and y to fill the output exactly.
    Htd = 2160;  Wtd = 3840;
    sx = Wtd / (x_max - x_min);      % px / m in u
    sy = Htd / (y_max - y_min);      % px / m in v

    % Undistorted-pixel coords of the control points  ->  homography
    [u_un, v_un] = applyUndistortToPixels(u_obs, v_obs, fx, fy, cx, cy, ...
                                          k1, k2, K_new);
    Hwu = computeHomography([Xw, Yw], [u_un, v_un]);  % world -> undist

    % For every top-down pixel, obtain its world coord, push through the
    % homography to get the undistorted pixel, then convert that back to
    % the distorted source pixel for sampling.
    [Utd, Vtd] = meshgrid(1:Wtd, 1:Htd);
    Xworld = x_min + (Utd - 1) / sx;
    Yworld = y_min + (Vtd - 1) / sy;

    Ptw  = [Xworld(:)'; Yworld(:)'; ones(1, numel(Xworld))];
    Pun  = Hwu * Ptw;
    Pun  = Pun ./ Pun(3,:);
    u_un_grid = reshape(Pun(1,:), Htd, Wtd);
    v_un_grid = reshape(Pun(2,:), Htd, Wtd);

    % Undistorted pixel -> normalised -> apply forward distortion -> source
    xn = (u_un_grid - K_new(1,3)) / K_new(1,1);
    yn = (v_un_grid - K_new(2,3)) / K_new(2,2);
    r2 = xn.^2 + yn.^2;
    fac = 1 + k1*r2 + k2*r2.^2;
    xd = xn .* fac;     yd = yn .* fac;
    Usrc = K(1,1)*xd + K(1,3);
    Vsrc = K(2,2)*yd + K(2,3);

    img_td = zeros(Htd, Wtd, size(img,3), 'uint8');
    for c = 1:size(img,3)
        img_td(:,:,c) = uint8( interp2(double(img(:,:,c)), Usrc, Vsrc, ...
                                       'linear', 0) );
    end

    figure('Name','Top-down projection');
    imshow(img_td);
    title('Top-down (bird''s-eye)  2160 x 3840');
    imwrite(img_td, 'corrected_topdown.png');
end


%% ======================================================================
%                              LOCAL FUNCTIONS
%  ======================================================================

function res = reprojectionResiduals(p, u_obs, v_obs, Xw, Yw)
    fx = p(1); fy = p(2); cx = p(3); cy = p(4);
    k1 = p(5); k2 = p(6);

    % Normalised distorted coords of the observed points
    xd = (u_obs - cx) / fx;
    yd = (v_obs - cy) / fy;

    % Iteratively undistort to get normalised undistorted coords
    [xu, yu] = undistortNormalised(xd, yd, k1, k2);

    % Convert to (undistorted) pixel coords using the same K
    u_un = fx*xu + cx;
    v_un = fy*yu + cy;

    % Best-fit homography from world to undistorted pixel
    H = computeHomography([Xw Yw], [u_un v_un]);

    % Reproject the world points and take the difference
    Pw   = [Xw'; Yw'; ones(1, numel(Xw))];
    Pp   = H * Pw;
    Pp   = Pp ./ Pp(3,:);
    res  = [Pp(1,:)' - u_un; Pp(2,:)' - v_un];
end


function [xu, yu] = undistortNormalised(xd, yd, k1, k2)
    % Fixed-point iteration to invert  xd = xu * (1 + k1 r^2 + k2 r^4)
    xu = xd;  yu = yd;
    for it = 1:30
        r2  = xu.^2 + yu.^2;
        fac = 1 + k1*r2 + k2*r2.^2;
        xu  = xd ./ fac;
        yu  = yd ./ fac;
    end
end


function [u_un, v_un] = applyUndistortToPixels(u, v, fx, fy, cx, cy, k1, k2, K_new)
    xd = (u - cx) / fx;
    yd = (v - cy) / fy;
    [xu, yu] = undistortNormalised(xd, yd, k1, k2);
    u_un = K_new(1,1)*xu + K_new(1,3);
    v_un = K_new(2,2)*yu + K_new(2,3);
end


function H = computeHomography(src, dst)
    % Direct Linear Transform: src(Nx2) -> dst(Nx2)
    N = size(src,1);
    A = zeros(2*N, 9);
    for i = 1:N
        x = src(i,1);  y = src(i,2);
        u = dst(i,1);  v = dst(i,2);
        A(2*i-1,:) = [-x -y -1  0  0  0  u*x  u*y  u];
        A(2*i  ,:) = [ 0  0  0 -x -y -1  v*x  v*y  v];
    end
    [~,~,V] = svd(A);
    h = V(:,end);
    H = reshape(h, 3, 3)';
    H = H / H(3,3);
end
