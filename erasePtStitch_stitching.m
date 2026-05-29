function [] = erasePtStitch_stitching(varargin);


handles = guidata(gcf);
ptEC = get(handles.selectPtStitching_stitching, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    return;
end;


if handles.activeVideo_stitching == 1;
    handles.ptStitchingLeft(ptEC, 1:2) = [0 0];
    eval(['circleEC = handles.markerDispLeftP' num2str(ptEC) ';']);
    p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    circleEC.Shape = p;
    circleEC.Visible = 'off'; 
    circleEC.FaceColor = [1 0 0];
    eval(['handles.markerDispLeftP' num2str(ptEC) ' = circleEC;']);
else;
    handles.ptStitchingRight(ptEC, 1:2) = [0 0];
    eval(['circleEC = handles.markerDispRightP' num2str(ptEC) ';']);
    p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    circleEC.Shape = p;
    circleEC.Visible = 'off'; 
    circleEC.FaceColor = [1 0 0];
    eval(['handles.markerDispRightP' num2str(ptEC) ' = circleEC;']);
end;

if handles.activeVideo_stitching == 1;
    countPt = 0;
    for lineEC = 1:50
        ptEC = handles.ptStitchingLeft(lineEC, 1:2);
        if ptEC(1) ~= 0 & ptEC(2) ~= 0;
            countPt = countPt + 1;
        end;
    end;
else;
    countPt = 0;
    for lineEC = 1:50
        ptEC = handles.ptStitchingRight(lineEC, 1:2);
        if ptEC(1) ~= 0 & ptEC(2) ~= 0;
            countPt = countPt + 1;
        end;
    end;
end;
if countPt == 0;
    listStitching = get(handles.selectPtStitching_stitching, 'String');
    listStitching{1,1} = 'Auto';
    set(handles.selectPtStitching_stitching, 'String', listStitching, 'Value', 1);
end;

guidata(handles.hf_w1_welcome, handles);
