function advancedSettingConvert_stitching(varargin);



handles = guidata(gcf);
handles2 = advancedSettingConvertUI_stitching;

if isempty(handles2) == 1;
    return;
end;

%---Get new data
VidInfo = handles2.VidInfo;

% filetosave = handles2.filetosave;
handles.VidInfo = VidInfo;
% handles.filetosave = filetosave;

guidata(handles.hf_w1_welcome, handles);



