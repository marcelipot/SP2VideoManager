function [] = dropdownBrightness_screen(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
valEC = get(handles2.dropdownBrightness_qual, 'value');

VidInfo.ImageEnhance.Brightness = valEC - 10;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
