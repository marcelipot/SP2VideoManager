function [] = coorYDLT_stitching(varargin);

handles = guidata(gcf);

if handles.activeVideo_stitching == 1;
    ptDLT = handles.ptDLTLeft;
else;
    ptDLT = handles.ptDLTRight;
end;
ptEC = get(handles.selectPtDLT_stitching, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    return;
end;

valEC = get(handles.selectDLTcoorY_EDIT_stitching, 'String');
valEC = str2num(valEC);

if isempty(valEC) == 1;
    set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    if handles.activeVideo_stitching == 1;
        handles.ptDLTLeft(ptEC,4) = NaN;
    else;
        handles.ptDLTRight(ptEC,4) = NaN;
    end;
    guidata(handles.hf_w1_welcome, handles);
    return;
end;

ptDLT(ptEC,4) = valEC;
if handles.activeVideo_stitching == 1;
    handles.ptDLTLeft = ptDLT;
else;
    handles.ptDLTRight = ptDLT;
end;

guidata(handles.hf_w1_welcome, handles);

