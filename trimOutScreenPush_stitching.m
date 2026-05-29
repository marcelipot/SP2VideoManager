function [] = trimOutScreenPush_stitching(varargin);

handles = guidata(gcf);


trimOutEdit = handles.trimOutScreenEdit_stitching;
if handles.activeVideo_stitching == 1;
    pathfileEC = handles.pathLeftfile_stitching;
    trimInValEC = handles.trimInValLeft_stitching;
    trimOutValEC = handles.trimOutValLeft_stitching;
    VidInfo = handles.VidInfoLeftStitching;
else;
    pathfileEC = handles.pathRightfile_stitching;
    trimInValEC = handles.trimInValRight_stitching;
    trimOutValEC = handles.trimOutValRight_stitching;
    VidInfo = handles.VidInfoRightStitching;
end;


if isempty(pathfileEC) == 1;
    return;
end;

valEC = VidInfo.FrameEC;
if valEC == 1;
    trimOutValEC = [];
else;    
    trimOutValEC = valEC;
end;
set(trimOutEdit, 'String', num2str(valEC));

if isempty(trimInValEC) == 0;
    if valEC <= handles.trimInValLeft_stitching;
        trimOutValEC = [];
        if handles.activeVideo_stitching == 1;
            handles.trimOutValLeft_stitching = trimOutValEC;
        else;
            handles.trimOutValRight_stitching = trimOutValEC;
        end;
        set(trimOutEdit, 'String', '');

        if ismac == 1;
            errorwindow = errordlg('Trim In frame cannot be superior or equal to Trim Out frame', 'Error');
        elseif ispc == 1;
            MDIR = getenv('USERPROFILE');
            errorwindow = errordlg('Trim In frame cannot be superior or equal to Trim Out frame', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;

if handles.activeVideo_stitching == 1;
    handles.pathLeftfile_stitching = pathfileEC;
    handles.trimInValLeft_stitching = trimInValEC;
    handles.trimOutValLeft_stitching = trimOutValEC;
    handles.VidInfoLeftStitching = VidInfo;
else;
    handles.pathRightfile_stitching = pathfileEC;
    handles.trimInValRight_stitching = trimInValEC;
    handles.trimOutValRight_stitching = trimOutValEC;
    handles.VidInfoRightStitching = VidInfo;
end;


guidata(handles.hf_w1_welcome, handles);

