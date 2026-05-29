function [] = doOptimisation2Select_screen(varargin);

handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
valOptimisation = get(handles2.applyOptimisation2_qual, 'Value');
VidInfo.FishEye.doOptimisation2 = valOptimisation;

if VidInfo.FishEye.doOptimisation2 == 1;
    VidInfo.FishEye.doOptimisation1 = 0;
    set(handles2.applyOptimisation1_qual, 'Value', 0);
end;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
