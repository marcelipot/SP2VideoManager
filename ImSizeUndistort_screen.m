function [imSizeUndistFull, imSizeUndistValid, imCenterUndistFull, imCenterUndistValid] = ImSizeUndistort_screen(params, imSizeDist);


%Inputs:
%   param: Camera parameter (cameraParam or FishEyeParam)
%   imSizeDist: Size of the original image with distortion [nrows ncols]
%
%Outputs:
%   imSizeUndist: full image size without distortion (full FOV)
%   imCenterUndist: new cx and cy


% if strcmpi(class(params), 'cameraParameters');

fx = params.fx;
fy = params.fy;
cx = params.cx;
cy = params.cy;
k1 = params.k1;
k2 = params.k2;
k3 = params.k3;
k4 = params.k4;
k5 = params.k5;
k6 = params.k6;
p1 = params.p1;
p2 = params.p2;
s1 = params.s1;
s2 = params.s2;
s3 = params.s3;
s4 = params.s4;
K = [fx 0 cx;
    0 fy cy;
    0 0 1];
img_h = imSizeDist(1); %Height
img_w = imSizeDist(2); %Width

%Sample all border pixels of the distorted image
num_pts = 100;
top    = [0:img_w-1;  zeros(1,img_w)];
bottom = [0:img_w-1;  (img_h-1)*ones(1,img_w)];
left   = [zeros(1,img_h);  0:img_h-1];
right  = [(img_w-1)*ones(1,img_h);  0:img_h-1];
border = [top, bottom, left, right];   % 2 x N
u_d = border(1,:);
v_d = border(2,:);

rowINI = 1;
rowEND = length(top(1,:))-1;
rowBordersTop = rowINI:rowEND;
rowINI = rowEND+1;
rowEND = rowINI + length(bottom(1,:))-1;
rowBordersBottom = rowINI+1:rowEND;
rowINI = rowEND+1;
rowEND = rowINI + length(left(1,:))-1;
rowBordersLeft = rowINI+1:rowEND;
rowINI = rowEND+1;
rowEND = rowINI + length(right(1,:));
rowBordersRight = rowINI+1:rowEND;

%Normalize distorted points
x_d = (u_d - cx) / fx;
y_d = (v_d - cy) / fy;

%Iteratively invert distortion: distorted -> undistorted
% Model: xd = xu * (1 + k1*r^2 + k2*r^4)
x_u = x_d;
y_u = y_d;

% for i = 1:30
%     r2     = x_u.^2 + y_u.^2;
%     factor = 1 + k1.*r2 + k2.*r2.^2;
%     x_u = x_d ./ factor;
%     y_u = y_d ./ factor;
% end

for iter = 1:20;
    r2 = x_u.^2 + y_u.^2;
    x_u = x_d./(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + 2*p1.*x_d.*y_d + p2*(r2 + 2.*x_d.^2) + s1.*r2 + s2.*r2.^2;
    y_u = y_d./(1 + k1*r2 + k2*r2.^2 + k3*r2.^3)./(1 + k4*r2 + k5*r2.^2 + k6*r2.^3) + p1.*(r2 + 2.*y_d.^2) + 2*p2.*x_d.*y_d + s3.*r2 + s4.*r2.^2;
end;

%Convert back to pixel coordinates
u_u = x_u * fx + cx;
v_u = y_u * fy + cy;

%Bounding box of undistorted border
u_min = floor(min(u_u));
u_max = ceil(max(u_u));
v_min = floor(min(v_u));
v_max = ceil(max(v_u));

v_min2 = max(v_u(rowBordersTop));
v_max2 = min(v_u(rowBordersBottom));
u_min2 = max(u_u(rowBordersLeft));
u_max2 = min(u_u(rowBordersRight));

% max(u_u(rowBordersLeft))
% min(u_u(rowBordersLeft))


%Full FOV size
imSizeUndistFull(2) = u_max - u_min; %new ncol (width)
imSizeUndistFull(1) = v_max - v_min; %new nrows (height)

%Valid FOV size
imSizeUndistValid(2) = u_max2 - u_min2; %new ncol (width)
imSizeUndistValid(1) = v_max2 - v_min2; %new nrows (height)


%New principal point (relative to new image origin)
imCenterUndistFull(1) = cx - u_min;
imCenterUndistFull(2) = cy - v_min;

imCenterUndistValid(1) = cx - u_min;
imCenterUndistValid(2) = cy - v_min;
    
% elseif strcmpi(class(params), 'fisheyeParameters');
%     
% 
% % 
% %     %Calculate undistorted image size using pinhole projection
% %     imSizeUndist(2) = ceil(f_new * tan(theta_left) + f_new * tan(theta_right));
% %     imSizeUndist(1) = ceil(f_new * tan(theta_top)  + f_new * tan(theta_bottom));
% % 
% %     %Undistorted principal point
% %     imCenterUndist(1) = f_new * tan(theta_left);
% %     imCenterUndist(2) = f_new * tan(theta_top);    
% 
% 
%     %Scaramuzza Fisheye Parameters
%     imgSize = imSizeDist; % [height, width]
%     a = params.Intrinsics.MappingCoefficients; %Scaramuzza polynomial model
%     cc = params.Intrinsics.DistortionCenter; % distortion center [cx, cy]
%     
%     %Sample all border pixels of the distorted image
%     % Top & bottom rows
%     u_top = 1:imgSize(2);
%     v_top = ones(1, imgSize(2));
%     u_bot = 1:imgSize(2);
%     v_bot = imgSize(1) * ones(1, imgSize(2));
%     % Left & right columns
%     v_left = 1:imgSize(1);
%     u_left = ones(1, imgSize(1));
%     v_right = 1:imgSize(1);
%     u_right = imgSize(2) * ones(1, imgSize(1));
%     
%     u_border = [u_top, u_bot, u_left, u_right];
%     v_border = [v_top, v_bot, v_left, v_right];
%     
%     %Map border pixels to 3D rays via Scaramuzza model
%     % Subtract distortion center (cx corresponds to column, cy to row)
%     xp = u_border - cc(1);
%     yp = v_border - cc(2);
%     
%     % Apply inverse stretch matrix
%     invStretch = inv(stretchMatrixNew);
%     coords = invStretch * [xp; yp];
%     xp = coords(1, :);
%     yp = coords(2, :);
%     
%     % Radial distance
%     rho = sqrt(xp.^2 + yp.^2);
%     
%     % Polynomial: z = a0 + a1*rho + a2*rho^2 + a3*rho^3
%     z = a(1) + a(2).*rho + a(3).*rho.^2 + a(4).*rho.^3;
%     
%     %Project rays onto pinhole plane
%     % Use |a(1)| as the focal length for the undistorted image
%     f = abs(a(1));
%     
%     u_undist = f .* xp ./ z;
%     v_undist = f .* yp ./ z;
%     
%     %Calculate undistorted image size
%     u_min = min(u_undist);  u_max = max(u_undist);
%     v_min = min(v_undist);  v_max = max(v_undist);
%     
%     imSizeUndist(2)  = ceil(u_max - u_min) + 1;
%     imSizeUndist(1) = ceil(v_max - v_min) + 1;
% 
%     imCenterUndist = [];
% end;


