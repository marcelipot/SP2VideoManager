function applyFishEyeUI_screen(varargin);



handles2 = guidata(gcf);
set(handles2.mainInfos_qual, 'String', 'Applying image correction ...');
drawnow;

VidInfo = handles2.VidInfo;
ptDLTAll = VidInfo.FishEye.ptDLTAll;
ptDLTValid = [];         %point for optimisation
if isempty(ptDLTAll) == 0;
    for liEC = 1:length(ptDLTAll(:,1));
        ptEC = ptDLTAll(liEC,:);
        indexNaN = find(isnan(ptEC) == 1);
        if isempty(indexNaN) == 1;
            %full set of points
            ptDLTValid = [ptDLTValid; ptEC];
        end;
    end;
end;
isOptimisationDone = 0;
redisplayCurrentpoints = 0;


% if ismac == 1;
%     filein = '/Applications/SP2VideoManager/Temp/tempParams.mat';
% elseif ispc == 1;
%     MDIR = getenv('USERPROFILE');
%     filein = [MDIR '\SP2VideoManager\Temp\tempParams.mat'];
% end;
% if isfile(filein) == 1;
%     load(filein);
% else;
%     map_x = [];
%     map_y = [];
%     extraMappingParams = [];
% end;
% VidInfo.FishEye.map_x = map_x;
% VidInfo.FishEye.map_y = map_y;
% VidInfo.FishEye.extraMappingParams = extraMappingParams;

frame = VidInfo.ActiveFrame;
[nrows, ncols, ~] = size(frame);

if isempty(VidInfo.FishEye) == 1;
    if ismac == 1;
        errorwindow = errordlg('Fish eye parameters not selected', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Fish eye parameters not selected', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;
if isempty(VidInfo.FishEye.keepValid) == 1;
    if ismac == 1;
        errorwindow = errordlg('Valid image format not selected', 'Error');
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        errorwindow = errordlg('Valid image format not selected', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
end;


%---Apply fish eye
if isempty(VidInfo.FishEye) == 1;
    optimisationState = 1; %update tools for map not existing
else;
    if isempty(VidInfo.FishEye.map_xOpt) == 0;
        optimisationState = 4; %update tools for map being already optimised
    else;
        if isempty(VidInfo.FishEye.map_xIni) == 0;
            optimisationState = 3; %update tools for map existing but not optimised
        else;
            optimisationState = 2; %update tools for map not existing
        end;
    end;
end;

if optimisationState ~= 0;
    if strcmpi(class(VidInfo.FishEye.param), 'cameraParameters');
        %pinhole model
        
        %create initial maps
        imsizein = [nrows ncols];
        imsizeout = [2160 3840];

        params = VidInfo.FishEye.param;
        p.fx = params.FocalLength(1); %Focal length x
        p.fy = params.FocalLength(2); %Focal length y
        p.cx = params.PrincipalPoint(1); %Principal point x
        p.cy = params.PrincipalPoint(2); %Principal point y
        p.k1 = params.RadialDistortion(1); %Radial distortion coef 1
        p.k2 = params.RadialDistortion(2); %Radial distortion coef 2
        if length(params.RadialDistortion) == 6;
            p.k3 = params.RadialDistortion(3); %Radial distortion coef 3
            p.k4 = params.RadialDistortion(4); %Radial distortion coef 4
            p.k5 = params.RadialDistortion(5); %Radial distortion coef 5
            p.k6 = params.RadialDistortion(6); %Radial distortion coef 6
        else;
            if length(params.RadialDistortion) == 5;
                p.k3 = params.RadialDistortion(3); %Radial distortion coef 3
                p.k4 = params.RadialDistortion(4); %Radial distortion coef 4
                p.k5 = params.RadialDistortion(5); %Radial distortion coef 5
                p.k6 = 0;
            else;
                if length(params.RadialDistortion) == 4;
                    p.k3 = params.RadialDistortion(3); %Radial distortion coef 3
                    p.k4 = params.RadialDistortion(4); %Radial distortion coef 4
                    p.k5 = 0;
                    p.k6 = 0;
                else;
                    if length(params.RadialDistortion) == 3;
                        p.k3 = params.RadialDistortion(3); %Radial distortion coef 3
                        p.k4 = 0;
                        p.k5 = 0;
                        p.k6 = 0;
                    else;
                        p.k3 = 0;
                        p.k4 = 0;
                        p.k5 = 0;
                        p.k6 = 0;
                    end;
                end;
            end;
        end;
        p.p1 = params.TangentialDistortion(1); %tangential distortion coef 1
        p.p2 = params.TangentialDistortion(2); %tangential distortion coef 2
        p.s1 = 0; %prism distortion coef 1
        p.s2 = 0; %prism distortion coef 2
        p.s3 = 0; %prism distortion coef 3
        p.s4 = 0; %prism distortion coef 4
        p.KK = [p.fx 0 p.fx; 0 p.fy p.cy; 0 0 1]; %Internal param matrix

        if optimisationState == 2;
            %Have camera param but no map... run initialisation
            if strcmpi(handles2.correctionUpdateTrigger, 'new') == 1;
                caseOptim = 1;
            else
                caseOptim = 0;
            end;

        elseif optimisationState == 3 | optimisationState == 4;
            if optimisationState == 3;
                %Have initial maps but no optimised map
                %Check if they are points for optimisation
                if isempty(ptDLTValid) == 1;
                    nbpoints = 0;
                else;
                    nbpoints = length(ptDLTValid(:,1));
                end;

                if nbpoints < 4;
                    caseOptim = 1;
                else;
                    caseOptim = 2;
                end;

            elseif optimisationState == 4;
                %have both initial and optimised map
                %run optimisation again
                caseOptim = 2;
            end;
        end;

        if caseOptim == 1;
            %Not enough points for optimisation so run initial param again
            [map_xIni, map_yIni, extraMappingParamsIni] = initUndistortPinHoleMap(p, imsizein, imsizeout, VidInfo.FishEye.keepValid);
            [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest',0); 

            VidInfo.FishEye.map_xIni = map_xIni;
            VidInfo.FishEye.map_yIni = map_yIni;
            VidInfo.FishEye.map_xOpt = [];
            VidInfo.FishEye.map_yOpt = [];
            VidInfo.FishEye.extraMappingParamsIni = extraMappingParamsIni;
            VidInfo.FishEye.extraMappingParamsIni.viewType = VidInfo.FishEye.keepValid;
            VidInfo.ActiveFrameIni = frame;

            set(handles2.loadPtDLT_qual, 'enable', 'on');
            set(handles2.savePtDLT_qual, 'enable', 'on');
            set(handles2.deleteallPtDLT_qual, 'enable', 'on');
            set(handles2.selectPtDLT_qual, 'enable', 'on');
            set(handles2.selectDLTcoorX_EDIT_qual, 'enable', 'on');
            set(handles2.selectDLTcoorY_EDIT_qual, 'enable', 'on');
            set(handles2.erasePtDLT_qual, 'enable', 'on');

        elseif caseOptim == 2;
            %Enough points to trigger optimisation if selected... trigger the optimisation step
            set(handles2.mainInfos_qual, 'String', 'Optimising image correction ...');
            drawnow;
            
            doOptimisation1 = VidInfo.FishEye.doOptimisation1;
            doOptimisation2 = VidInfo.FishEye.doOptimisation2;
            doTopDown = VidInfo.FishEye.doTopDown;
            if doOptimisation1 == 0 & doOptimisation2 == 0 & doTopDown == 0;
                %just rebuild the image and re-display at the end of the code the points
                redisplayCurrentpoints = 1;
                [map_xIni, map_yIni, extraMappingParamsIni] = initUndistortPinHoleMap(p, imsizein, imsizeout, VidInfo.FishEye.keepValid);
%                 [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest',0); 
    
                VidInfo.FishEye.map_xIni = map_xIni;
                VidInfo.FishEye.map_yIni = map_yIni;
                VidInfo.FishEye.map_xOpt = [];
                VidInfo.FishEye.map_yOpt = [];
                VidInfo.FishEye.extraMappingParamsIni = extraMappingParamsIni;
                VidInfo.FishEye.extraMappingParamsIni.viewType = VidInfo.FishEye.keepValid;
                VidInfo.ActiveFrameIni = frame;

                redisplayCurrentpoints = 1;
                [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest',0); 
            else;

                %Enough points to trigger optimisation if selected... trigger the optimisation step
                extraMappingParams = VidInfo.FishEye.extraMappingParamsIni;

                %inverse map back the point to the original image (points
                %clicked on the image undistorted with the first set of
                %parameters
                [ptxMapped, ptyMapped] = ptUndistortPinHoleMapping_screen(ptDLTValid(:,1), ptDLTValid(:,2), ...
                    p, 'inverse', imsizein, imsizeout, extraMappingParams);


                % Check point projection
%                 [ptxMapped ptyMapped]
%                 figure; imshow(VidInfo.ActiveFrame);
%                 hold on; plot(ptxMapped, ptyMapped, 'r+');
%                 drawnow;
% 
%                 [frameTest, ~] = imagesbuiltinImageInterpolation2D(VidInfo.ActiveFrame, ...
%                     VidInfo.FishEye.map_xIni, VidInfo.FishEye.map_yIni, 'nearest',0); 
%                 figure; imshow(frameTest);
%                 hold on; plot(ptxProj, ptyProj, 'g+');
% 
%                 eee=eee

                ptDLTValidMapped = [ptxMapped ptyMapped ptDLTValid(:,3) ptDLTValid(:,4)];
                VidInfo.FishEye.ptDLTAllOri = ptDLTValidMapped;

                %run optimisation and/or projection
                if doOptimisation1 == 1;
                    [map_xOpt, map_yOpt, pOpt, extraMappingParamsOpt] = optiUndistortPinHoleMap1(p, imsizein, imsizeout, ...
                        VidInfo.FishEye.keepValid, ptDLTValidMapped, doOptimisation1, doTopDown, frame);
                end;
                if doOptimisation2 == 1;
                    [map_xOpt, map_yOpt, pOpt, extraMappingParamsOpt] = optiUndistortPinHoleMap2(p, imsizein, imsizeout, ...
                        VidInfo.FishEye.keepValid, ptDLTValidMapped, doOptimisation2, doTopDown, frame);
                end;
                
                [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xOpt, map_yOpt, 'nearest', 0);
                %Project point forward to the new corrected image for
                %display
                if doTopDown == 0;
                    [ptxProj, ptyProj] = ptUndistortPinHoleMapping_screen(ptxMapped, ptyMapped, ...
                        pOpt, 'forward', imsizein, imsizeout, extraMappingParams);
    
                    VidInfo.FishEye.ptDLTAllOpt = [ptxProj ptyProj ptDLTValid(:,3) ptDLTValid(:,4)];
                else;
                    VidInfo.FishEye.ptDLTAllOpt = zeros(length(ptDLTValidMapped(:,1)),2);
                end;
                VidInfo.FishEye.map_xOpt = map_xOpt;
                VidInfo.FishEye.map_yOpt = map_yOpt;
                VidInfo.FishEye.paramOpt = pOpt;
                VidInfo.FishEye.extraMappingParamsOpt = extraMappingParamsOpt;
                VidInfo.ActiveFrameOpt = frame;
                isOptimisationDone = 1; %flag necessary just to know what points to display at the bottom of the code
            end;
        end;

    elseif strcmpi(class(VidInfo.FishEye.param), 'fisheyeParameters');
        %create initial maps
        imsizein = [nrows ncols];
        imsizeout = [2160 3840];

        Intrinsics = VidInfo.FishEye.param.Intrinsics;
        pFishEye.MappingCoefficients = Intrinsics.MappingCoefficients; %Mapping coeficients
        pFishEye.DistortionCenter = Intrinsics.DistortionCenter; %Focal length y
        pFishEye.StretchMatrix = Intrinsics.StretchMatrix; %Principal point x
        pFishEye.ImageSize = Intrinsics.ImageSize; %Principal point y

        if optimisationState == 2;
            %Have camera param but no map... run initialisation
            if strcmpi(handles2.correctionUpdateTrigger, 'new') == 1;
                caseOptim = 1;
            else
                caseOptim = 0;
            end;

        elseif optimisationState == 3 | optimisationState == 4;
            if optimisationState == 3;
                %Have initial maps but no optimised map
                %Check if they are points for optimisation
                if isempty(ptDLTValid) == 1;
                    nbpoints = 0;
                else;
                    nbpoints = length(ptDLTValid(:,1));
                end;

                if nbpoints < 4;
                    caseOptim = 1;
                else;
                    caseOptim = 2;
                end;

            elseif optimisationState == 4;
                %have both initial and optimised map
                %run optimisation again
                caseOptim = 2;
            end;
        end;

        if caseOptim == 1;
            [map_xIni, map_yIni, extraMappingParamsIni] = initUndistortFishEyeMap(pFishEye, imsizein, imsizeout, VidInfo.FishEye.keepValid, frame);
            [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest', 0);

            VidInfo.FishEye.map_xIni = map_xIni;
            VidInfo.FishEye.map_yIni = map_yIni;
            VidInfo.FishEye.map_xOpt = [];
            VidInfo.FishEye.map_yOpt = [];

            VidInfo.FishEye.extraMappingParamsIni = extraMappingParamsIni;
            VidInfo.FishEye.extraMappingParamsIni.viewType = VidInfo.FishEye.keepValid;
            VidInfo.ActiveFrameIni = frame;

            set(handles2.loadPtDLT_qual, 'enable', 'on');
            set(handles2.savePtDLT_qual, 'enable', 'on');
            set(handles2.deleteallPtDLT_qual, 'enable', 'on');
            set(handles2.selectPtDLT_qual, 'enable', 'on');
            set(handles2.selectDLTcoorX_EDIT_qual, 'enable', 'on');
            set(handles2.selectDLTcoorY_EDIT_qual, 'enable', 'on');
            set(handles2.erasePtDLT_qual, 'enable', 'on');

        elseif caseOptim == 2;
            set(handles2.mainInfos_qual, 'String', 'Optimising image correction ...');
            drawnow;

            doOptimisation1 = VidInfo.FishEye.doOptimisation1;
            doOptimisation2 = VidInfo.FishEye.doOptimisation2;
            doTopDown = VidInfo.FishEye.doTopDown;
            if doOptimisation1 == 0 & doOptimisation2 == 0 & doTopDown == 0;
                %just rebuild the image and re-display at the end of the code the points
%                 [~, pFishEye_IntrinsicsLens] = undistortFisheyeImage(frame, Intrinsics, 'Outputview', 'full');        
                [map_xIni, map_yIni, extraMappingParamsIni] = initUndistortFishEyeMap(pFishEye, imsizein, imsizeout, VidInfo.FishEye.keepValid);
%                 [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest',0); 

                VidInfo.FishEye.map_xIni = map_xIni;
                VidInfo.FishEye.map_yIni = map_yIni;
                VidInfo.FishEye.map_xOpt = [];
                VidInfo.FishEye.map_yOpt = [];
                VidInfo.FishEye.extraMappingParamsIni = extraMappingParamsIni;
                VidInfo.FishEye.extraMappingParamsIni.viewType = VidInfo.FishEye.keepValid;
                VidInfo.ActiveFrameIni = frame;

                redisplayCurrentpoints = 1;
                [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xIni, map_yIni, 'nearest',0); 
            else;
                %Enough points to trigger optimisation if selected... trigger the optimisation step
                extraMappingParams = VidInfo.FishEye.extraMappingParamsIni;
    
                %inverse map back the point to the original image (points
                %clicked on the image undistorted with the first set of
                %parameters
                [ptxMapped, ptyMapped] = ptUndistortFishEyeMapping_screen(ptDLTValid(:,1), ptDLTValid(:,2), ...
                    pFishEye, 'inverse', imsizein, imsizeout, extraMappingParams);
    
                ptDLTValidMapped = [ptxMapped ptyMapped ptDLTValid(:,3) ptDLTValid(:,4)];
                VidInfo.FishEye.ptDLTAllOri = ptDLTValidMapped;


%                 % Check point projection
%                 [ptxMapped ptyMapped]
%                 figure; imshow(VidInfo.ActiveFrame);
%                 hold on; plot(ptxMapped, ptyMapped, 'r+');
%                 eee=eee
% 
%                 [frameTest, ~] = imagesbuiltinImageInterpolation2D(VidInfo.ActiveFrame, ...
%                     VidInfo.FishEye.map_xIni, VidInfo.FishEye.map_yIni, 'nearest',0); 
%                 figure; imshow(frameTest);
%                 hold on; plot(ptxProj, ptyProj, 'g+');
% 
%                 eee=eee


                %run optimisation and/or projection
                if doOptimisation1 == 1;
                    [map_xOpt, map_yOpt, pOpt, extraMappingParamsOpt] = optiUndistortFishEyeMap1(pFishEye, imsizein, imsizeout, ...
                        VidInfo.FishEye.keepValid, ptDLTValidMapped, doOptimisation1, doTopDown, frame);
                end;
                if doOptimisation2 == 1;
                    [map_xOpt, map_yOpt, pOpt, extraMappingParamsOpt] = optiUndistortFishEyeMap2(pFishEye, imsizein, imsizeout, ...
                        VidInfo.FishEye.keepValid, ptDLTValidMapped, doOptimisation2, doTopDown, frame);
                end;

                [frame, ~] = imagesbuiltinImageInterpolation2D(frame, map_xOpt, map_yOpt, 'nearest', 0);

                %Project point forward to the new corrected image for display
                if doTopDown == 0;
                    [ptxProj, ptyProj] = ptUndistortFishEyeMapping_screen(ptxMapped, ptyMapped, ...
                        pFishEye, 'forward', imsizein, imsizeout, extraMappingParams);
    
                    VidInfo.FishEye.ptDLTAllOpt = [ptxProj ptyProj ptDLTValid(:,3) ptDLTValid(:,4)];
                else;
                    VidInfo.FishEye.ptDLTAllOpt = zeros(length(ptDLTValidMapped(:,1)),2);
                end;
                VidInfo.FishEye.ptDLTAllOpt = [ptxProj ptyProj ptDLTValid(:,3) ptDLTValid(:,4)];
                VidInfo.FishEye.map_xOpt = map_xOpt;
                VidInfo.FishEye.map_yOpt = map_yOpt;
                VidInfo.FishEye.paramOpt = pOpt;
                VidInfo.FishEye.extraMappingParamsOpt = extraMappingParamsOpt;
                VidInfo.ActiveFrameOpt = frame;
                isOptimisationDone = 1; %flag necessary just to know what points to display at the bottom of the code
            end;
        end;
    end;

    
    %% Section to review for camera modes that are not
    [rows, cols, ~] = size(frame);
    if strcmpi(VidInfo.FishEye.keepValid, 'Full');
        %Keep the entire image: just remove the rows and cols to make it 16/9
        if roundn(cols./rows,-3) < roundn(16/9,-3);
            %they are too many rows... need to remove some to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            rowsFrom = floor((rows-nbrowsTOT)./2) + 1;
            rowsTo = rows-floor((rows-nbrowsTOT)./2) - 1;
            frameProcessed = frame(rowsFrom:rowsTo,:,:);
            frame = imresize(frameProcessed, [2160 3840], 'nearest');

        elseif roundn(cols./rows,-3) > roundn(16/9,-3);
            %they are too many cols... need to add black rows to have 16/9 ratio
            nbrowsTOT = (cols.*9)./16;
            missingRows = floor((rows-nbrowsTOT)./2); 
            frame2a1 = zeros(missingRows,cols);
%                         frame2a2 = [frame2a1; frame(:,:,1); frame2a1];
            frame2a2 = cat(1,frame2a1,frame(:,:,1),frame2a1);
%                         frame2b1 = zeros(missingRows,cols);
%                         frame2b2 = [frame2b1; frame(:,:,2); frame2b1];
            frame2b2 = cat(1,frame2a1,frame(:,:,2),frame2a1);
%                         frame2c1 = zeros(missingRows,cols);
%                         frame2c2 = [frame2c1; frame(:,:,3); frame2c1];
            frame2c2 = cat(1,frame2a1,frame(:,:,3),frame2a1);

%                         frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
            frameProcessed = cat(3,frame2a2,frame2b2,frame2c2);
%                         frame(:,:,1) = frame2a2;
%                         frame(:,:,2) = frame2b2;
%                         frame(:,:,3) = frame2c2;
            frame = imresize(frameProcessed, [2160 3840], 'nearest');
        else;
            %no need to change the ratio
            %already 16/9
        end;

    elseif strcmpi(VidInfo.FishEye.keepValid, 'Valid');
        %Crop the image to 16/9
        [checkH, checkW, ~] = size(frame);
        if checkH > 2160 & checkW > 3840;
            midFrameRows = (rows./2) - 2160./2;
            midFrameCols = (cols./2) - 3840./2;
            posRec = [midFrameCols midFrameRows 3840 2160];

            frame = imcrop(frame, posRec);    
        end;
    end;
    %---

    VidInfo.xlimValCurrent = [1 cols];
    VidInfo.ylimValCurrent = [1 rows];
end;


%---Apply enhancement
if VidInfo.ImageEnhance.Contract ~= 0;
    contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
    HSV = rgb2hsv(frame);
    HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
    HSV(HSV > 1) = 1;
    frame = hsv2rgb(HSV);
end;

if VidInfo.ImageEnhance.Brightness ~= 0;
    contrastamt = VidInfo.ImageEnhance.Brightness./10;
    if VidInfo.ImageEnhance.Brightness < 0;
        olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
        frame = imadjust(frame, [0 1], [1-olhi olhi], 1);
%         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
    else;
        olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
        frame = imadjust(frame, [1-olhi olhi], [0 1], 1);
%         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
    end;
end;


%---update the axes
if isfield(handles2, 'qualVideoimdisplayed') == 1;
    %field exist
    if isvalid(handles2.qualVideoimdisplayed) == 1;
        %exist and valid
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
    else;
        %not valid: need to create it again
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(frame);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});



for ptDLT = 1:50; 
    axes(handles2.mainVideo_qual); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
    clear circle;
end;
set(handles2.loadPtDLT_qual, 'enable', 'on');
set(handles2.savePtDLT_qual, 'enable', 'on');
set(handles2.deleteallPtDLT_qual, 'enable', 'on');
set(handles2.selectPtDLT_qual, 'value', 1, 'enable', 'on');
set(handles2.selectDLTcoorX_EDIT_qual, 'String', '', 'enable', 'off');
set(handles2.selectDLTcoorY_EDIT_qual, 'String', '', 'enable', 'off');
set(handles2.erasePtDLT_qual, 'enable', 'off');
drawnow;

if redisplayCurrentpoints == 1;
    ptEC = get(handles2.selectPtDLT_qual, 'value');
    ptEC = ptEC - 1;
    for ptDLT = 1:50; 
        axes(handles2.mainVideo_qual); hold on;

        if ptDLT <= length(ptDLTValid(:,1));
            uCircle = ptDLTValid(ptDLT,1);
            vCircle = ptDLTValid(ptDLT,2);
            if isnan(uCircle) == 1;
                p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                colorEC = [1 0 0];
                visibleEC = 'off';
            else;
                p = nsidedpoly(10, 'Center', [uCircle vCircle], 'Radius', 10);
                if ptEC == ptDLT;
                    %active point... green
                    colorEC = [0 1 0];
                else;
                    %inactive point... red
                    colorEC = [1 0 0];
                end;
                visibleEC = 'on';
            end;
        else;
            p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
            colorEC = [1 0 0];
            visibleEC = 'off';
        end;
        circle = plot(p, 'FaceColor', colorEC, 'EdgeColor', colorEC, 'Visible', visibleEC);
        eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
        clear circle;
    end;
end;

if strcmpi(handles2.correctionUpdateTrigger, 'new') == 1;
    if isOptimisationDone == 1;
        %---Update control points
        ptEC = get(handles2.selectPtDLT_qual, 'value');
        ptEC = ptEC - 1;
        for ptDLT = 1:50; 
            axes(handles2.mainVideo_qual); hold on;
    
            if ptDLT <= length(ptxProj(:,1));
                uCircle = ptxProj(ptDLT,1);
                vCircle = ptyProj(ptDLT,1);
                if isnan(uCircle) == 1;
                    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                    colorEC = [1 0 0];
                    visibleEC = 'off';
                else;
                    p = nsidedpoly(10, 'Center', [uCircle vCircle], 'Radius', 10);
                    if ptEC == ptDLT;
                        %active point... green
                        colorEC = [0 1 0];
                    else;
                        %inactive point... red
                        colorEC = [1 0 0];
                    end;
                    visibleEC = 'on';
                end;
            else;
                p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                colorEC = [1 0 0];
                visibleEC = 'off';
            end;
            circle = plot(p, 'FaceColor', colorEC, 'EdgeColor', colorEC, 'Visible', visibleEC);
            eval(['handles2.markerDLTP' num2str(ptDLT) ' = circle;']);
            clear circle;
        end;
    
        %---Disable tools for initialisation
        set(handles2.loadFishEye_qual, 'enable', 'off');
        set(handles2.defineFishEye_qual, 'enable', 'off');
        set(handles2.multiThreadRadio_qual, 'enable', 'off');
        set(handles2.fisheyeType1Radio_qual, 'enable', 'off');
        set(handles2.fisheyeType2Radio_qual, 'enable', 'off');
        set(handles2.fisheyeType3Radio_qual, 'enable', 'off');
        set(handles2.fisheyeType4Radio_qual, 'enable', 'off');
        set(handles2.validImageDrop_qual, 'enable', 'off');
    end;
end;


%---save data
handles2.correctionUpdateTrigger = 'new';
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);

set(handles2.mainInfos_qual, 'String', '');
