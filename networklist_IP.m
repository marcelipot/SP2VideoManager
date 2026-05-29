function [] = networklist_IP(varargin);


handles2 = guidata(gcf);
handles2.CurrentIP = get(handles2.knownnetworklist_main, 'value');

guidata(handles2.hf_w2_welcome, handles2);