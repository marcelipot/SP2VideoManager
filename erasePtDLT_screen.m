function [] = erasePtDLT_screen(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
ptDLTAll = VidInfo.FishEye.ptDLTAll;

ptEC = get(handles2.selectPtDLT_qual, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    return;
end;

ptDLTAll(ptEC, 1:4) = NaN;
eval(['circleEC = handles2.markerDLTP' num2str(ptEC) ';']);
circleEC.Visible = 'off'; 
circleEC.FaceColor = [1 0 0];
circleEC.EdgeColor = [1 0 0];
eval(['handles2.markerDLTP' num2str(ptEC) ' = circleEC;']); 

set(handles2.selectDLTcoorX_EDIT_qual, 'String', '');
set(handles2.selectDLTcoorY_EDIT_qual, 'String', '');

ptDLTValid = [];         %point for optimisation
for liEC = 1:length(ptDLTAll(:,1));
    ptEC = ptDLTAll(liEC,:);
    indexNaN = find(isnan(ptEC) == 1);
    if isempty(indexNaN) == 1;
        %full set of points
        ptDLTValid = [ptDLTValid; ptEC];
    end;
end;
if isempty(ptDLTValid) == 1;
    nbpoints = 0;
else;
    nbpoints = length(ptDLTValid(:,1));
end;
if nbpoints >= 4;
    set(handles2.applyTopDown_qual, 'enable', 'on', 'value', 0);
else;
    set(handles2.applyTopDown_qual, 'enable', 'off', 'value', 0);
end;
if nbpoints >= 6;
    set(handles2.applyOptimisation1_qual, 'enable', 'on', 'value', 0);
    set(handles2.applyOptimisation2_qual, 'enable', 'on', 'value', 0);
else;
    set(handles2.applyOptimisation1_qual, 'enable', 'off', 'value', 0);
    set(handles2.applyOptimisation2_qual, 'enable', 'off', 'value', 0);
end;


VidInfo.FishEye.ptDLTAll = ptDLTAll;
handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
