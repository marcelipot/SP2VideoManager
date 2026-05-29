function [] = frameratetoDrop_stitching(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
valEC = get(handles2.frameratetoDrop_qual, 'value');

if valEC == 1;
    %No mod
    VidInfo.exportRate = VidInfo.Rate;
    VidInfo.isexportRateDefault = 1;
elseif valEC == 2;
    %50fps
    VidInfo.exportRate = 50;
    VidInfo.isexportRateDefault = 0;
elseif valEC == 3;
    %25fps
    VidInfo.exportRate = 25;
    VidInfo.isexportRateDefault = 0;
end;
handles2.VidInfo = VidInfo;

guidata(handles2.hf_w2_advancedStitching, handles2);
