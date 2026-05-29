function [] = view_listDrop_stitching(varargin);


handles2 = guidata(gcf);
valEC = get(handles2.viewDrop_qual, 'value');


%---Change fov data
VidInfo = handles2.VidInfo;
if valEC == 1;
    VidInfo.viewAngle = 'NormalView';
elseif valEC == 2;
    VidInfo.viewAngle = 'TopDown';
end;


%---Save parameters
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedStitching, handles2);


%---Apply parameters
%recalculate mapping data for new FOV
% applyFishEyeUI_screen;

