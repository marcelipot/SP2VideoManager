function [] = dropdownContrast_stitching(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
valEC = get(handles2.dropdownContrast_qual, 'value');

VidInfo.ImageEnhance.Contract = valEC - 10;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedStitching, handles2);
