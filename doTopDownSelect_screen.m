function [] = doTopDownSelect_screen(varargin);

handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
valTopDown = get(handles2.applyTopDown_qual, 'Value');
VidInfo.FishEye.doTopDown = valTopDown;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
