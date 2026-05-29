function [] = compressionlevelPanning_conv(varargin);


handles = guidata(gcf);
poscomp = get(handles.popCompressionPanning_conv, 'value');

if poscomp == 1;
    handles.CurrenCompressionPanning = 15;
elseif poscomp == 2;
    handles.CurrenCompressionPanning = 14;
elseif poscomp == 3;
    handles.CurrenCompressionPanning = 13;
elseif poscomp == 4;
    handles.CurrenCompressionPanning = 12;
elseif poscomp == 5;
    handles.CurrenCompressionPanning = 11;
elseif poscomp == 6;
    handles.CurrenCompressionPanning = 10;
elseif poscomp == 7;
    handles.CurrenCompressionPanning = 9;
elseif poscomp == 8;
    handles.CurrenCompressionPanning = 8;
elseif poscomp == 9;
    handles.CurrenCompressionPanning = 7;
elseif poscomp == 10;
    handles.CurrenCompressionPanning = 6;
elseif poscomp == 11;
    handles.CurrenCompressionPanning = 5;
elseif poscomp == 12;
    handles.CurrenCompressionPanning = 4;
elseif poscomp == 13;
    handles.CurrenCompressionPanning = 3;
end;
 
guidata(handles.hf_w1_welcome, handles);

