function [] = restoreImage_qual(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
sourceButton = varargin{3};

if strcmpi(sourceButton, 'load') == 1;
    set(handles2.dropdownContrast_load, 'Value', 10);
else;
    set(handles2.dropdownContrast_qual, 'Value', 10);
end;
valContrast = 0;
VidInfo.ImageEnhance.Contract = valContrast;

if strcmpi(sourceButton, 'load') == 1;
    set(handles2.dropdownBrightness_load, 'Value', 10);
else;
    set(handles2.dropdownBrightness_qual, 'Value', 10);
end;
valBrightness = 0;
VidInfo.ImageEnhance.Brightness = valBrightness;

frame = handles2.VidInfo.ActiveFrame;
refreshImage_Qual;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_analyser, handles2);