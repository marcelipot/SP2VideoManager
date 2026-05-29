function [] = popSelectPtStich_stichting(varargin);


handles = guidata(gcf);
ptEC = get(handles.selectPtStitching_stitching, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');
else;
    set(handles.hf_w1_welcome, 'WindowButtonDownFcn', @clickCalibStitching);
end;

if handles.activeVideo_stitching == 1;
    handles.ptStitichingLeft_lastSelect = ptEC;
    %---reset stichting point to visible
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
        if ptStitching == ptEC
            circleEC.FaceColor = [0 1 0];
            circleEC.EdgeColor = [0 1 0]; 
        else;
            circleEC.FaceColor = [1 0 0];
            circleEC.EdgeColor = [1 0 0]; 
        end;
        circleEC.Visible = 'on'; 
        eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---reset DLT point to purple and invisible
    set(handles.selectPtDLT_stitching, 'Value', 1);
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTLeftP' num2str(ptStitching) ';']);
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0]; 
        circleEC.Visible = 'off'; 
        eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;
    set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
    set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');

else;
    handles.ptStitichingRight_lastSelect = ptEC;
    %---reset stichting point to visible
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispRightP' num2str(ptStitching) ';']);
        if ptStitching == ptEC
            circleEC.FaceColor = [0 1 0];
            circleEC.EdgeColor = [0 1 0]; 
        else;
            circleEC.FaceColor = [1 0 0];
            circleEC.EdgeColor = [1 0 0]; 
        end;
        circleEC.Visible = 'on'; 
        eval(['handles.markerDispRightP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---reset DLT point to purple and invisible
    set(handles.selectPtDLT_stitching, 'Value', 1);
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTRightP' num2str(ptStitching) ';']);
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0]; 
        circleEC.Visible = 'off'; 
        eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;
    set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
    set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
end;
handles.ptcurrentDisplay = 'stitch';
handles.activeDrop = 2; %Stitching dropdown menue active

guidata(handles.hf_w1_welcome, handles);
