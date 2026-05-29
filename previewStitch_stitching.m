function [] = previewStitch_stitching(varargin);


handles = guidata(gcf);

if isempty(handles.pathLeftfile_stitching) == 1 | isempty(handles.pathRightfile_stitching) == 1;
    return;
end;

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;


%---Check DLT point
ptDLT_validLeft = [];
countLeft = 0;
for lineEC = 1:50;
    ptECLeft = handles.ptDLTLeft(lineEC,:);
    if isnan(ptECLeft(1,1)) == 0 & isnan(ptECLeft(1,2)) == 0 ...
            & isnan(ptECLeft(1,3)) == 0 & isnan(ptECLeft(1,4)) == 0;
        ptDLT_validLeft = [ptDLT_validLeft; ptECLeft];
        countLeft = countLeft + 1;
    end;
end;
ptDLT_validRight = [];
countRight = 0;
for lineEC = 1:50;
    ptECRight = handles.ptDLTRight(lineEC,:);
    if isnan(ptECRight(1,1)) == 0 & isnan(ptECRight(1,2)) == 0 ...
            & isnan(ptECRight(1,3)) == 0 & isnan(ptECRight(1,4)) == 0;
        ptDLT_validRight = [ptDLT_validRight; ptECRight];
        countRight = countRight + 1;
    end;
end;
if countLeft < 2 | countRight < 2 | countLeft+countRight < 6;
    ptDLT_validLeft = [];
    ptDLT_validRight = [];
end;
%---


%---Check stitching point... if manual
ptStitching_valid = [];
for lineEC = 1:50;
    ptECLeft = handles.ptStitchingLeft(lineEC,:);
    ptECRight = handles.ptStitchingRight(lineEC,:);
    if ptECLeft(1,1) ~= 0 & ptECLeft(1,2) ~= 0 & ptECRight(1,1) ~= 0 & ptECRight(1,2) ~= 0;
        ptStitching_valid = [ptStitching_valid; [ptECLeft ptECRight]];
    end;
end;

if isempty(ptStitching_valid) == 0;
    if length(ptStitching_valid(:,1)) < 20;
        ptStitching_valid = [];
    end;
end;

if isempty(ptStitching_valid) == 1;
    if ispc == 1;
        errorwindow = errordlg('Not enough valid pairs of points', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
        return;
    elseif ismac == 1;
        errordlg('Not enough valid pairs of points', 'Error');
        return;
    end;
    return;
end;
%---


%---Load current frames
imgLeft = read(handles.VidInfoLeftStitching.VidObj, handles.VidInfoLeftStitching.FrameEC);
imgRight = read(handles.VidInfoRightStitching.VidObj, handles.VidInfoRightStitching.FrameEC);
%---


%---Image matching (auto: sift / manual)
if isempty(ptStitching_valid) == 1; %Auto
    %---Get features and pair images
    grayL = im2gray(imgLeft);
    grayR = im2gray(imgRight);

    pointsL = detectSIFTFeatures(grayL, 'NumLayersInOctave', 3);
    pointsR = detectSIFTFeatures(grayR, 'NumLayersInOctave', 3);

    pointsL = selectStrongest(pointsL, 8000); %only keep 50 strongest features
    pointsR = selectStrongest(pointsR, 8000); %only keep 50 strongest features

    [featL, validPtsL] = extractFeatures(grayL, pointsL); %get descriptors
    [featR, validPtsR] = extractFeatures(grayR, pointsR); %get descriptors

    indexPairs = matchFeatures(featL, featR, 'MaxRatio', 0.7, 'Unique', true); %create pairs
    matchedPtsL = validPtsL(indexPairs(:,1));
    matchedPtsR = validPtsR(indexPairs(:,2));

    ptsL_stitching = matchedPtsL.Location;
    ptsR_stitching = matchedPtsR.Location;

%     figure;imshow(imgRight);
%     hold on;
%     plot(ptsR(:,1), ptsR(:,2), 'r+');

else; %manual
    ptsL_stitching = ptStitching_valid(:,1:2);
    ptsR_stitching = ptStitching_valid(:,3:4);

%     figure;imshow(imgRight);
%     hold on;
%     plot(ptsR(:,1), ptsR(:,2), 'r+');

end;
%---


%---Calculate 2 stitching options
[savedOutputStichingNormal, savedOutputStichingTop] = estimateStitching_stitching(imgLeft, imgRight, ...
    ptsL_stitching, ptsR_stitching, ptDLT_validLeft, ptDLT_validRight);
%---


handles.savedOutputStichingNormal = savedOutputStichingNormal;
handles.savedOutputStichingTop = savedOutputStichingTop;
guidata(handles.hf_w1_welcome, handles);
%---



%---Display extra settings window
advancedSettingConvert_stitching;
handles = guidata(gcf);
%---


guidata(handles.hf_w1_welcome, handles);

