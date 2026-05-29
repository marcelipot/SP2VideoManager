function [map_x, map_y, pFishEyeOpt, extraMappingParams] = optiUndistortFishEyeMap2(pFishEye, imsizein, imsizeout, viewType, ptDLTValidMapped, doOptimisation, doTopDown, frame);
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
%
% Apply the following to map the image:
% [outputImage, XYHasNaNs] = imagesbuiltinImageInterpolation2D(Idistorted, map_x, map_y, 'nearest', 0);  




%Define parameters for top-down projection if needed
map_x = [];
map_y = [];
pFishEyeOpt = [];
extraMappingParams = [];

H_in = imsizein(1);
W_in = imsizein(2);
H_out = imsizeout(1);
W_out = imsizeout(2);
margin_m = 0.1; % world-space margin around control region as pourcentage

distCenter = pFishEye.DistortionCenter; %Distorsion center
            % mappingCoeffs0 = pFishEye.MappingCoefficients; %Fish Eye mapping coef
mappingCoeffs0 = [pFishEye.MappingCoefficients' ; 0]; %Fish Eye mapping coef
stretchMatrix = pFishEye.StretchMatrix; %Stretch matrix
cx = distCenter(1);
cy = distCenter(2);

% ss0  = [ 1.1441e+03 ; -3.6854e-05 ; -5.4689e-08 ;  1.3894e-11 ];  % a0,a2,a3,a4
% xc0 = 1887.7;            % distortion centre, u (column)
% yc0 = 1091.8;            % distortion centre, v (row)
% stretchMatrix = [1 0; 0 1]; % stretch matrix (identity, not optimised)


%--- Define points
uv = ptDLTValidMapped(:,1:2);
XY = ptDLTValidMapped(:,3:4);
N = size(ptDLTValidMapped, 1);





% %---Create maps depending on top-down or normal projection selection
if doTopDown == 1;
    if doOptimisation == 1;
        pFishEyeOpt.DistortionCenter = [cx_opt cy_opt]; %Distorsion center
        pFishEyeOpt.MappingCoefficients = mappingCoeffs_opt; %Fish Eye mapping coef
        pFishEyeOpt.StretchMatrix = stretchMatrix; %Stretch matrix
        pFishEyeOpt.ImageSize = [H_in W_in]; %Stretch matrix

%         [map_x, map_y] = topDownProjection(pOpt, ptDLTValid, imsizeout, margin_m, frame);
    else;

%         [map_x, map_y] = topDownProjection(pFishEye, ptDLTValid, imsizeout, margin_m, frame);
    end;
    extraMappingParams = [];
else
    if doOptimisation == 1;
        pFishEyeOpt.DistortionCenter = [cx_opt cy_opt]; %Distorsion center
        pFishEyeOpt.MappingCoefficients = mappingCoeffs_opt; %Fish Eye mapping coef
        pFishEyeOpt.StretchMatrix = stretchMatrix; %Stretch matrix
        pFishEyeOpt.ImageSize = [H_in W_in]; %Stretch matrix

        [map_x, map_y, extraMappingParams] = initUndistortFishEyeMap(pFishEyeOpt, ...
            imsizein, imsizeout, viewType);
        
    end;
end;




%% =======================================================================
%  ===========================  LOCAL HELPERS  ===========================
%  =======================================================================
 

