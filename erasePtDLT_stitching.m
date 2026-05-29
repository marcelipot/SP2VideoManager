function [] = erasePtDLT_stitching(varargin);


handles = guidata(gcf);
ptEC = get(handles.selectPtDLT_stitching, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    return;
end;


if handles.activeVideo_stitching == 1;
    handles.ptDLTLeft(ptEC, 1:4) = NaN;
    eval(['circleEC = handles.markerDLTLeftP' num2str(ptEC) ';']);
    circleEC.Visible = 'off'; 
    circleEC.FaceColor = [1 0 1];
    eval(['handles.markerDLTLeftP' num2str(ptEC) ' = circleEC;']); 
else;
    handles.ptDLTRight(ptEC, 1:4) = NaN;
    eval(['circleEC = handles.markerDLTRightP' num2str(ptEC) ';']);
    circleEC.Visible = 'off'; 
    circleEC.FaceColor = [1 0 1];
    eval(['handles.markerDLTRightP' num2str(ptEC) ' = circleEC;']);
end;
set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');


guidata(handles.hf_w1_welcome, handles);
