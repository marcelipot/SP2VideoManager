function [ptxMapped, ptyMapped] = ptUndistortPinHoleMapping_screen(ptx, pty, params, mappingDirection, imsizein, imsizeout, inputExtra);


%Inputs:
%   ptx: Column of x coordinates in the original image
%   pty: Column of y coordinates in the original image
%   params: Camera or fisheye parameters object
%   mappingDirection: 'forward' or 'inverse'
%   imSizeDist: Size of the orginal image
%   inputExtra:
%       For pinhole pameter structure containing:
%           viewType: full or valid view of the converted image
%           offsetCols: Offset to apply to u
%           offsetRows: Offset to apply to v
%           cropTop: Value to remove from u
%           cropLeft: Value to remove from v
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
if strcmpi(lower(mappingDirection), 'inverse');

    %---input points in the corrected image, calculate points in the original image (distorted)
    K = params.KK; %Internal param matrix
    fx = params.fx; %Focal length x
    fy = params.fy; %Focal length y
    cx = params.cx; %Principal point x
    cy = params.cy; %Principal point y
    k1 = params.k1; %Radial distortion coef 1
    k2 = params.k2; %Radial distortion coef 2
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
    viewType = inputExtra.viewType; %View type
    offsetCols = inputExtra.offsetCols;
    offsetRows = inputExtra.offsetRows;
    cropTop = inputExtra.cropTop;
    cropBottom = inputExtra.cropBottom;
    cropLeft = inputExtra.cropLeft;
    cropRight = inputExtra.cropRight;
    scaleU = inputExtra.scaleU;
    scaleV = inputExtra.scaleV;

    [imSizeUndistFull, imSizeUndistValid, newPPFull, newPPValid] = ImSizeUndistort_screen(params, [H_in W_in]);
    newOrigin = [cx-newPPFull(1) cy-newPPFull(2)] + 1;
    nrowUndist = imSizeUndistFull(1);
    ncolUndist = imSizeUndistFull(2);

    %---Reverse the final crop+resize (only if crop bounds known)
    Wec = cropRight - cropLeft + 1;
    Hec = cropBottom - cropTop + 1;
%     j_c = (ptx - 0.5) * ncolUndist/W_out + 0.5;
%     i_c = (pty - 0.5) * nrowUndist/H_out + 0.5;
    j_c = (ptx - 0.5) * Wec/W_out + 0.5;
    i_c = (pty - 0.5) * Hec/H_out + 0.5;
    j_pre = j_c + cropLeft - 1;
    i_pre = i_c + cropTop - 1;

    %---Aspect-ratio row crop of the original meshgrid
    if ncolUndist/nrowUndist < W_out/H_out;
        rowsIdeal = round(ncolUndist / (W_out/H_out));
        diffH = abs(rowsIdeal - nrowUndist);
        rowTop = floor(diffH/2);                 % first kept row
        rowBot = ceil(nrowUndist - ceil(diffH/2));       % last  kept row
        Heff = rowBot - rowTop + 1;
    else
        rowTop = 1;
        Heff = nrowUndist;
    end
    Weff = ncolUndist;
 
    u_mg_local = (j_pre - 0.5) * Heff/H_out + 0.5;
    v_mg_local = (i_pre - 0.5) * Weff/W_out + 0.5;

    %---Reverse the row crop (column crop is not applied in the script)
    u_mg = u_mg_local + newOrigin(1) - offsetCols;
    v_mg = (v_mg_local + rowTop - 1) + newOrigin(2) - offsetRows;

    %---Normalised undistorted coords
    X = (u_mg - cx) / fx;
    Y = (v_mg - cy) / fy;
 
    %---Forward distortion model
    r2 = X.^2 + Y.^2;
    num = 1 + k1*r2 + k2*r2.^2 + k3*r2.^3;
    den = 1 + k4*r2 + k5*r2.^2 + k6*r2.^3;
    R = num ./ den;
    xpp = X.*R + 2*p1.*X.*Y + p2*(r2 + 2*X.^2) + s1*r2 + s2*r2.^2;
    ypp = Y.*R + p1.*(r2 + 2*Y.^2) + 2*p2.*X.*Y + s3*r2 + s4*r2.^2;
 
    %---Reconvert to pixels in the DISTORTED source
    ptxMapped = fx .* xpp + cx;
    ptyMapped = fy .* ypp + cy;

    
elseif strcmpi(lower(mappingDirection), 'forward');
    %input points in the original image (distorted), calculate points in the corrected image
    K = params.KK; %Internal param matrix
    fx = params.fx; %Focal length x
    fy = params.fy; %Focal length y
    cx = params.cx; %Principal point x
    cy = params.cy; %Principal point y
    k1 = params.k1; %Radial distortion coef 1
    k2 = params.k2; %Radial distortion coef 2
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
    viewType = inputExtra.viewType; %View type
    offsetCols = inputExtra.offsetCols;
    offsetRows = inputExtra.offsetRows;
    cropTop = inputExtra.cropTop;
    cropBottom = inputExtra.cropBottom;
    cropLeft = inputExtra.cropLeft;
    cropRight = inputExtra.cropRight;
    scaleU = inputExtra.scaleU;
    scaleV = inputExtra.scaleV;

    %---Recenter points using the principal position
    [imSizeUndistFull, imSizeUndistValid, newPPFull, newPPValid] = ImSizeUndistort_screen(params, [H_in W_in]);        
    newOrigin = [cx-newPPFull(1) cy-newPPFull(2)] + 1;
    nrowUndist = imSizeUndistFull(1);
    ncolUndist = imSizeUndistFull(2);

    %---Normalised distorted coordinates
    xpp = (ptx - cx) / fx;
    ypp = (pty - cy) / fy;

    %---Iteratively invert the distortion model
    X = xpp;
    Y = ypp;
    maxIter = 20;
    tol = 1e-10;
    itUsed = maxIter;
    err = NaN;
 
    for it = 1:maxIter;
        r2  = X.^2 + Y.^2;
        num = 1 + k1*r2 + k2*r2.^2 + k3*r2.^3;
        den = 1 + k4*r2 + k5*r2.^2 + k6*r2.^3;
        R   = num ./ den;
 
        dx = 2*p1.*X.*Y + p2*(r2 + 2*X.^2) + s1*r2 + s2*r2.^2;
        dy = p1.*(r2 + 2*Y.^2) + 2*p2.*X.*Y + s3*r2 + s4*r2.^2;
 
        Xn = (xpp - dx) ./ R;
        Yn = (ypp - dy) ./ R;
 
        err = max([abs(Xn - X); abs(Yn - Y)]);
        X = Xn;  Y = Yn;
        if err < tol
            itUsed = it;
            break;
        end;
    end;

    %---Back to pixels in the ideal undistorted frame
    xu = X*fx + cx;
    yu = Y*fy + cy;

    %---Walk the rest of the pipeline forward
    if ncolUndist/nrowUndist < W_out/H_out;
        rowsIdeal = round(ncolUndist / (W_out/H_out));
        diffH = abs(rowsIdeal - nrowUndist);
        rowStart = floor(diffH/2);
        rowEnd = ceil(nrowUndist - ceil(diffH/2));
        Heff = rowEnd - rowStart + 1;
%         v_mg_local = yu - rowStart + 1;
    else;
        rowStart = 1;
        H_pre = nrowUndist;
%         v_mg_local = yu;
    end;
    Weff = ncolUndist;

    v_mg = xu - newOrigin(1) + offsetCols;
    u_mg = yu - newOrigin(2) + offsetRows - (rowStart - 1);
    
    i_pre = (v_mg - 0.5) * W_out/Weff + 0.5;
    j_pre = (u_mg - 0.5) * H_out/Heff + 0.5;
    
    Wec = cropRight - cropLeft + 1;
    Hec = cropBottom - cropTop + 1;
    i_c = i_pre - cropLeft + 1;
    j_c = j_pre - cropTop + 1;
    ptxMapped = (i_c - 0.5) * W_out/Wec + 0.5;
    ptyMapped = (j_c - 0.5) * H_out/Hec + 0.5;

end;


