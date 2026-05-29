function [map_xNew, map_yNew] = undistortMappingRefine_screen(map_x, map_y, k, distModel, outputView);

%Inputs:
%   map_x: original map x
%   map_y: Original map y
%       if no original maps, create mew maps with:
%          [nrows, ncols] = size(I(:,:,1));
%          [xi, yi] = meshgrid(1:ncols,1:nrows);
%   k: Distorion model factor [must be between -1 and 1]
%   distModel: 1 to 4 to select the distortion model to apply
%   outputView: 'full' or 'crop'
%        'full': preserve the entire field of view
%        'crop': keep only valid image
%
%Outputs:
%   map_xNew: New map x
%   map_yNew: New map y
%
%To generate an image, use:
% [Iundist, ~] = imagesbuiltinImageInterpolation2D(I, map_xNew, map_yNew, 'nearest', 0);
%
%References:
% https://au.mathworks.com/help/images/creating-a-gallery-of-transformed-images.html
% https://blogs.mathworks.com/steve/2006/05/05/spatial-transformations-inverse-mapping/
% https://au.mathworks.com/matlabcentral/fileexchange/37980-barrel-and-pincushion-lens-distortion-correction?s_tid=prof_contriblnk


%---Find size and center of the image
[nrows, ncols] = size(map_x);
center = [round(ncols/2) round(nrows/2)];


%---Apply correction model
xt = map_x - ncols/2; % offset center x
yt = map_y - nrows/2; % offset center y
[theta, r] = cart2pol(xt, yt); % Convert to polar coordinates
R = sqrt(center(1)^2 + center(2)^2); %normalised data
rN = r/R;
if distModel == 1;
    s1 = rN.*(1./(1+k.*rN)); % Apply model 1
elseif distModel == 2;
    s1 = rN.*(1./(1+k.*(rN.^2))); % Apply model 2
elseif distModel == 3;
    s1 = rN.*(1+k.*rN); % Apply model 3
elseif distModel == 4;
    s1 = rN.*(1+k.*(rN.^2)); % Apply model 4
end;
s2 = s1 * R; %Remove normalisation
s2b = s2*1; %Apply scale factor of 1 (do nothing just for test)
[ut,vt] = pol2cart(theta,s2b); % Convert back to catesian coordinates
ui = ut + ncols/2; % Re-offset center x
vi = vt + nrows/2; % Re-offset center y

%---Define scaling factor
if strcmpi(lower(outputView), 'full') == 1; %Full fov

    %Define image boundaries
    limLeft = max(max(ui(:,1)));
    limRight = ncols - min(min(ui(:,end)));
    limTop = max(max(vi(1,:)));
    limBottom = nrows - min(min(vi(end,:)));

    %find the closest boundary
    [~, locmin] = min(abs([limLeft limRight limTop limBottom]));
    if locmin == 1;
        closestBoundary = limLeft;
    elseif locmin == 2;
        closestBoundary = limRight;
    elseif locmin == 3;
        closestBoundary = limTop;
    elseif locmin == 4;
        closestBoundary = limBottom;
    end;

    %determine the direction of the scaling factor
    if closestBoundary < 0;
        scaleDirection = -1;
    elseif closestBoundary > 0;
        scaleDirection = 1;
    end;

    %Main loop optimising the scale factor
    scaleFactor = 1;
    for roundEC = 1:3;
        proceed = 1;
        nTimes = 1;
        while proceed == 1;
            %increment for the scaling factor
            if roundEC == 1;
                %Round 1 for the 0.1 iteration
                currentInc = 0.1;
            elseif roundEC == 2;
                %Round 2 for the 0.01 iteration
                currentInc = 0.01;
            elseif roundEC == 3;
                %Round 3 for the 0.001 iteration 
                currentInc = 0.001;
            end;

            %direction: postive to zoom in and negative to zoom out
            if scaleDirection < 0;
                scaleFactorInc = scaleFactor - (nTimes.*currentInc);
            elseif scaleDirection > 0;
                scaleFactorInc = scaleFactor + (nTimes.*currentInc);
            end;
    
%             if scaleFactorInc < 2.5;
                %Apply scaling factor and update the maps
                s2b = s2*scaleFactorInc;
                [ut,vt] = pol2cart(theta,s2b); % Convert back to catesian coordinates
                ui = ut + ncols/2; % Re-offset center x
                vi = vt + nrows/2; % Re-offset center y
    
                %Check new image boundaries
                limLeft = max(max(ui(:,1)));
                limRight = ncols - min(min(ui(:,end)));
                limTop = max(max(vi(1,:)));
                limBottom = nrows - min(min(vi(end,:)));
                [~, locmin] = min(abs([limLeft limRight limTop limBottom]));
                if locmin == 1;
                    closestBoundary = limLeft;
                elseif locmin == 2;
                    closestBoundary = limRight;
                elseif locmin == 3;
                    closestBoundary = limTop;
                elseif locmin == 4;
                    closestBoundary = limBottom;
                end;    
    
                %Determine if the image has reached its targed
                if scaleDirection < 0;
                    if closestBoundary >= 0;
                        proceed = 0;
                        scaleFactor = scaleFactorInc+currentInc;
                    else;
                        nTimes = nTimes + 1;
                    end;
                elseif scaleDirection > 0;
                    if closestBoundary <= 0;
                        proceed = 0;
                        scaleFactor = scaleFactorInc-currentInc;
                    else;
                        nTimes = nTimes + 1;
                    end;
                end;
%             else;
%                 proceed = 0;
%                 scaleFactor = scaleFactorInc-currentInc;
%             end;
        end;
    end;

else; %Crop fov

    %Define image boundaries
    limLeft = find(all(ui >= 1, 1), 1, 'first');
    limRight =  find(all(vi >= 1, 2), 1, 'first');
    limTop = ncols - find(all(ui <= ncols, 1), 1, 'last');
    limBottom =  nrows - find(all(vi <+ nrows, 2), 1, 'last');
    
    %find the closest boundary
    [~, locmin] = max(abs([limLeft limRight limTop limBottom]));
    if locmin == 1;
        closestBoundary = limLeft;
    elseif locmin == 2;
        closestBoundary = limRight;
    elseif locmin == 3;
        closestBoundary = limTop;
    elseif locmin == 4;
        closestBoundary = limBottom;
    end;

    %determine the direction of the scaling factor
    if closestBoundary <= 1;
        scaleDirection = 1;
    elseif closestBoundary > 1;
        scaleDirection = -1;
    end;

    %Main loop optimising the scale factor
    scaleFactor = 1;
    for roundEC = 1:3;
        proceed = 1;
        nTimes = 1;
        while proceed == 1;
            %increment for the scaling factor
            if roundEC == 1;
                %Round 1 for the 0.1 iteration
                currentInc = 0.1;
            elseif roundEC == 2;
                %Round 2 for the 0.01 iteration
                currentInc = 0.01;
            elseif roundEC == 3;
                %Round 3 for the 0.001 iteration 
                currentInc = 0.001;
            end;

            %direction: postive to zoom in and negative to zoom out
            if scaleDirection < 0;
                scaleFactorInc = scaleFactor - (nTimes.*currentInc);
            elseif scaleDirection > 0;
                scaleFactorInc = scaleFactor + (nTimes.*currentInc);
            end;
   
            %Apply scaling factor and update the maps
            s2b = s2*scaleFactorInc;
            [ut,vt] = pol2cart(theta,s2b); % Convert back to catesian coordinates
            ui = ut + ncols/2; % Re-offset center x
            vi = vt + nrows/2; % Re-offset center y
    
            %Check new image boundaries
            limLeft = find(all(ui >= 1, 1), 1, 'first');
            limRight =  find(all(vi >= 1, 2), 1, 'first');
            limTop = ncols - find(all(ui <= ncols, 1), 1, 'last');
            limBottom =  nrows - find(all(vi <+ nrows, 2), 1, 'last');
            [~, locmin] = max(abs([limLeft limRight limTop limBottom]));
            if locmin == 1;
                closestBoundary = limLeft;
            elseif locmin == 2;
                closestBoundary = limRight;
            elseif locmin == 3;
                closestBoundary = limTop;
            elseif locmin == 4;
                closestBoundary = limBottom;
            end;

            %Determine if the image has reached its targed
            if scaleDirection < 0;
                if closestBoundary <= 1;
                    proceed = 0;
                    scaleFactor = scaleFactorInc+currentInc;
                else;
                    nTimes = nTimes + 1;
                end;
            elseif scaleDirection > 0;
                if closestBoundary >= 1;
                    proceed = 0;
                    scaleFactor = scaleFactorInc-currentInc;
                else;
                    nTimes = nTimes + 1;
                end;
            end;
        end;
    end;
end;

%---Update the maps with the adequte scaling factor
s2b = s2*scaleFactor;
[ut,vt] = pol2cart(theta,s2b); % Convert back to catesian coordinates
map_xNew = ut + ncols/2; % Re-offset center x
map_yNew = vt + nrows/2; % Re-offset center y


% %---if an image is imported
% [Iundist, ~] = imagesbuiltinImageInterpolation2D(frame_save, ui, vi, 'nearest', 0);
% figure; imshow(Iundist);

