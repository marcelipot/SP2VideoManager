function [] = pushCancel_IP(varargin);

handles2 = guidata(gcf);
handles2.proceedIP = 0;
guidata(handles2.hf_w2_welcome, handles2);
uiresume(handles2.hf_w2_welcome);