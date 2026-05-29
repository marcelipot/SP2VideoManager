function restoreStitchingUI_stitching(varargin);



handles2 = guidata(gcf);
set(handles2.mainInfos_qual, 'String', 'Applying stitching ...');
drawnow;

VidInfo = handles2.VidInfo;

%---Display current frame
imgLeft = read(VidInfo.VidObjLeft, VidInfo.FrameECLeft);
imgRight = read(VidInfo.VidObjRight, VidInfo.FrameECRight);
VidInfoLeft.ActiveFrame = imgLeft;
VidInfoRight.ActiveFrame = imgRight;
set(handles2.viewDrop_qual, 'Value', 1);
VidInfo.viewAngle = 'NormalView';
set(handles2.validImageDrop_qual, 'Value', 1);
VidInfo.keepValid = 'Full';

imgPanorama = createStitchImg_stitching(imgLeft, imgRight, handles2.savedOutputStichingNormal, handles2.savedOutputStichingTop, VidInfo.viewAngle);
VidInfo.ActiveFrame = imgPanorama;

%---Apply enhancement
if VidInfo.ImageEnhance.Contract ~= 0;
    contrastamt = 1 + VidInfo.ImageEnhance.Contract./10;
    HSV = rgb2hsv(imgPanorama);
    HSV(:, :, 2) = HSV(:, :, 2) * contrastamt;
    HSV(HSV > 1) = 1;
    imgPanorama = hsv2rgb(HSV);
end;

if VidInfo.ImageEnhance.Brightness ~= 0;
    contrastamt = VidInfo.ImageEnhance.Brightness./10;
    if VidInfo.ImageEnhance.Brightness < 0;
        olhi = tan((contrastamt+1)*pi/4)*0.5 + 0.5;
        imgPanorama = imadjust(imgPanorama, [0 1], [1-olhi olhi], 1);
%         frame = imadjust(frame, [(VidInfo.ImageEnhance.Brightness./10) 0]);
    else;
        olhi = tan((1-contrastamt)*pi/4)*0.5 + 0.5;
        imgPanorama = imadjust(imgPanorama, [1-olhi olhi], [0 1], 1);
%         frame = imadjust(frame, [0 (VidInfo.ImageEnhance.Brightness./10)]);
    end;
end;

% figure; imshow(imgPanorama)



%---update the axes
if isfield(handles2, 'qualVideoimdisplayed') == 1;
    %field exist
    if isvalid(handles2.qualVideoimdisplayed) == 1;
        %exist and valid
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(imgPanorama);
    else;
        %not valid: need to create it again
        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(imgPanorama);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(imgPanorama);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});


set(handles2.mainInfos_qual, 'String', '');
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedStitching, handles2);
