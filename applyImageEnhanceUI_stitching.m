function applyImageEnhanceUI_stitching(varargin);


handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
frame = VidInfo.ActiveFrame;

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
%         cla(handles2.mainVideo_qual);
%         set(handles2.qualVideoimdisplayed, 'cdata', frame);
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    else;
        %not valid: need to create it again

        cla(handles2.mainVideo_qual, 'reset');
        axes(handles2.mainVideo_qual);
        handles2.qualVideoimdisplayed = imshow(frame);
%         axes(handles2.mainVideo_qual);
%         handles2.qualVideoimdisplayed = imshow(frame);
%         xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%         ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
    end;
else;
    %create field
    cla(handles2.mainVideo_qual, 'reset');
    axes(handles2.mainVideo_qual);
    handles2.qualVideoimdisplayed = imshow(frame);
%     xlim(handles2.mainVideo_qual, VidInfo.xlimValCurrent);
%     ylim(handles2.mainVideo_qual, VidInfo.ylimValCurrent);
end;
[tb,btns] = axtoolbar(handles2.mainVideo_qual, {'zoomin','zoomout','pan'});

% VidInfo.ActiveFrame = frame;
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedStitching, handles2);

