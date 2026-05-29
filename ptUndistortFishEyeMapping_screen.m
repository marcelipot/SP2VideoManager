function [ptxMapped, ptyMapped] = ptUndistortFishEyeMapping_screen(ptx, pty, pFishEye, mappingDirection, imsizein, imsizeout, inputExtra);


%Inputs:
%   ptx: Column of x coordinates in the original image
%   pty: Column of y coordinates in the original image
%   params: Camera or fisheye parameters object
%   mappingDirection: 'forward' or 'inverse'
%   imSizeDist: Size of the orginal image
%   inputExtra:
%       For fisheye parameter Structure containing:
%           f_outNew: modified estimated equivalent focal length, including zoom in/out element
%           paramIntrinsic_out: Estimated equivalent internal parameter
%           update_distortion_center = factor on u and v to re-center the image;
%       For pinhole pameter structure containing:
%           viewType: full or valid view of the converted image
%           offsetCols: Offset to apply to u
%           offsetRows: Offset to apply to v
%           cropTop. cropBottom: Value to remove from u
%           cropLeft, cropRight: Value to remove from v
%           scaleU: scale factor on U
%           scaleV: scale factor on V
%
%Outputs:
%   ptxMapped: Column of x coordinates in the transforemd image
%   ptyMapped: Column of y coordinates in the transforemd image
%
%References:
% https://blogs.mathworks.com/steve/2006/05/05/spatial-transformations-inverse-mapping/


H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);

distLeft = inputExtra.cropLeft;
distRight = inputExtra.cropRight;
distTop = inputExtra.cropTop;
distBottom = inputExtra.cropBottom;
offsetRows = inputExtra.offsetRows;
offsetCols = inputExtra.offsetCols;
distCenter = pFishEye.DistortionCenter; %Distorsion center
mappingCoeffs = pFishEye.MappingCoefficients; %Fish Eye mapping coef
stretchMat = pFishEye.StretchMatrix; %Stretch matrix
a0 = mappingCoeffs(1);
a2 = mappingCoeffs(2);
a3 = mappingCoeffs(3);
a4 = mappingCoeffs(4);
cx = distCenter(1);
cy = distCenter(2);

if strcmpi(lower(mappingDirection), 'inverse');
    %input points in the corrected image, calculate points in the original image (distorted)
     
    % --- 0. Find the lens' max angle
    % Use the farthest input-image corner from the distortion centre.
    sz = size(ptx);
    cornersU = [1 1 W_in W_in] - cx;
    cornersV = [1 H_in 1 H_in] - cy;
    rhoMax = max(sqrt(cornersU.^2 + cornersV.^2));
    fAtMax = a0 + a2*rhoMax^2 + a3*rhoMax^3 + a4*rhoMax^4;
    thetaMax = atan2(rhoMax, fAtMax);          % half-FOV along the diagonal

    cx_out = (W_out + 1)/2;
    cy_out = (H_out + 1)/2;
    diagOut = sqrt((W_out/2)^2 + (H_out/2)^2);
    f_out = diagOut / tan(thetaMax);

    % --- 1. Undo imresize: final image -> cropped output position
    Wec = distRight - distLeft + 1;
    Hec = distBottom - distTop  + 1;
 
    xo_crop = (ptx - 0.5) .* (Wec / W_out) + 0.5;
    yo_crop = (pty - 0.5) .* (Hec / H_out) + 0.5;

    % --- 2. Undo crop: cropped position -> uncropped output position
    xo = xo_crop + distLeft - 1;
    yo = yo_crop + distTop - 1;

    % --- 3. 3-D ray (pin-hole / perspective model)
    X = xo - cx_out - offsetCols;
    Y = yo - cy_out - offsetRows;
    Z = f_out;
    R = sqrt(X.^2 + Y.^2);
    theta = atan2(R, Z);
    N_lut = 4096;
    rho_lut = linspace(0, rhoMax*1.05, N_lut).';
    f_lut = a0 + a2*rho_lut.^2 + a3*rho_lut.^3 + a4*rho_lut.^4;
    theta_lut = atan2(rho_lut, f_lut);

    % --- 4. Forward LUT: theta -> rho
    rho = interp1(theta_lut, rho_lut, theta, 'linear', NaN);

    % --- 5. Back to sensor-plane coordinates of the input fisheye
    Rsafe = R;
    Rsafe(R == 0) = 1;
    u_s = rho .* X ./ Rsafe;
    v_s = rho .* Y ./ Rsafe;
    u_s(R == 0) = 0;
    v_s(R == 0) = 0;

    % --- 6. Apply the stretch matrix and re-centre on (cx, cy)
    u_p = stretchMat(1,1).*u_s + stretchMat(1,2).*v_s;
    v_p = stretchMat(2,1).*u_s + stretchMat(2,2).*v_s;
 
    x_dist = u_p + cx;
    y_dist = v_p + cy;
 
    % --- 7. Propagate NaNs for points outside the LUT range
    bad = isnan(rho);
    x_dist(bad) = NaN;
    y_dist(bad) = NaN;
 
    % Restore the input shape
    ptxMapped = reshape(x_dist, sz);
    ptyMapped = reshape(y_dist, sz);

   
    
elseif strcmpi(lower(mappingDirection), 'forward');
    %input points in the original image (distorted), calculate points in the corrected image
    
    % --- 0. Find the lens' max angle
    % Use the farthest input-image corner from the distortion centre.
    sz = size(ptx);
    cornersU = [1 1 W_in W_in] - cx;
    cornersV = [1 H_in 1 H_in] - cy;
    rhoMax = max(sqrt(cornersU.^2 + cornersV.^2));
    fAtMax = a0 + a2*rhoMax^2 + a3*rhoMax^3 + a4*rhoMax^4;
    thetaMax = atan2(rhoMax, fAtMax);          % half-FOV along the diagonal

    cx_out = (W_out + 1)/2;
    cy_out = (H_out + 1)/2;
    diagOut = sqrt((W_out/2)^2 + (H_out/2)^2);
    f_out = diagOut / tan(thetaMax);

    % --- 1. Translate by the fisheye distortion centre
    u_p = ptx - cx;
    v_p = pty - cy;
 
    % --- 2. Invert the 2x2 stretch matrix
    invS = inv(stretchMat);
    u_s = invS(1,1).*u_p + invS(1,2).*v_p;
    v_s = invS(2,1).*u_p + invS(2,2).*v_p;
 
    % --- 3. Radial distance in the sensor plane of the input
    rho = sqrt(u_s.^2 + v_s.^2);
 
    % --- 4. Inverse LUT: rho -> theta
    %        (rho_lut must be monotonic in theta_lut.)
    N_lut = 4096;
    rho_lut = linspace(0, rhoMax*1.05, N_lut).';
    f_lut = a0 + a2*rho_lut.^2 + a3*rho_lut.^3 + a4*rho_lut.^4;
    theta_lut = atan2(rho_lut, f_lut);
    theta = interp1(rho_lut, theta_lut, rho, 'linear', NaN);
 
    % --- 5. Pinhole back-projection: R = f_out * tan(theta)
    R = f_out .* tan(theta);
 
    % Handle the optical centre (rho == 0) cleanly, exactly like the
    % forward code does for R == 0.
    rhoSafe = rho;
    rhoSafe(rho == 0) = 1;
    X = R .* u_s ./ rhoSafe;
    Y = R .* v_s ./ rhoSafe;
    X(rho == 0) = 0;
    Y(rho == 0) = 0;
 
    % --- 6. Pixel coordinates in the UNCROPPED output grid
    xo = X + cx_out + offsetCols;
    yo = Y + cy_out + offsetRows;
 
    % --- 7. Crop offset, then imresize scaling
    %        Forward:   map = map(distTop:distBottom, distLeft:distRight)
    %                   map = imresize(map, [H_out W_out], 'bilinear')
    %
    %        MATLAB's imresize uses the half-pixel centre convention:
    %           col_in_cropped = (xo_final - 0.5) * (Wec / W_out) + 0.5
    %        so the inverse is
    %           xo_final = (col_in_cropped - 0.5) * (W_out / Wec) + 0.5
    Wec = distRight  - distLeft + 1;
    Hec = distBottom - distTop  + 1;
 
    xo_crop = xo - distLeft + 1;
    yo_crop = yo - distTop  + 1;
 
    x_undist = (xo_crop - 0.5) .* (W_out / Wec) + 0.5;
    y_undist = (yo_crop - 0.5) .* (H_out / Hec) + 0.5;
 
    % --- 8. Propagate NaNs for points outside the LUT range
    bad = isnan(theta);
    x_undist(bad) = NaN;
    y_undist(bad) = NaN;
 
    % Restore the input shape
    ptxMapped = reshape(x_undist, sz);
    ptyMapped = reshape(y_undist, sz);
end;


