function [] = multiThreadSelect_screen(varargin);

handles2 = guidata(gcf);

VidInfo = handles2.VidInfo;
valThread = get(handles2.multiThreadRadio_qual, 'Value');
VidInfo.FishEye.multithreadOption = valThread;

handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
