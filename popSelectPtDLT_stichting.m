function [] = popSelectPtDLT_stichting(varargin);


handles = guidata(gcf);
ptEC = get(handles.selectPtDLT_stitching, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');
else;
    set(handles.hf_w1_welcome, 'WindowButtonDownFcn', @clickDLTStitching);
end;

if handles.activeVideo_stitching == 1;
    handles.ptDLTLeft_lastSelect = ptEC;
    %---reset DLT point to visible
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTLeftP' num2str(ptStitching) ';']);
        if ptStitching == ptEC
            circleEC.FaceColor = [1 1 0];
            circleEC.EdgeColor = [1 1 0]; 
        else;
            circleEC.FaceColor = [1 0 1];
            circleEC.EdgeColor = [1 0 1]; 
        end;
        circleEC.Visible = 'on'; 
        eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---reset stitching point to red and invisible
    set(handles.selectPtStitching_stitching, 'Value', 1);
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0]; 
        circleEC.Visible = 'off'; 
        eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---Display real world coordinates
    if ptEC == 0;
        set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    else;
        valEC = handles.ptDLTLeft(ptEC, 3);
        if isnan(valEC) == 1;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        else;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', num2str(valEC));
        end;
        valEC = handles.ptDLTLeft(ptEC, 4);
        if isnan(valEC) == 1;
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
        else;
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', num2str(valEC));
        end;
    end;

else;
    handles.ptDLTRight_lastSelect = ptEC;
    %---reset DLT point to visible
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDLTRightP' num2str(ptStitching) ';']);
        if ptStitching == ptEC
            circleEC.FaceColor = [1 1 0];
            circleEC.EdgeColor = [1 1 0]; 
        else;
            circleEC.FaceColor = [1 0 1];
            circleEC.EdgeColor = [1 0 1]; 
        end;
        circleEC.Visible = 'on'; 
        eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---reset stitching point to red and invisible
    set(handles.selectPtStitching_stitching, 'Value', 1);
    for ptStitching = 1:50; %left vid axes
        eval(['circleEC = handles.markerDispRightP' num2str(ptStitching) ';']);
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0]; 
        circleEC.Visible = 'off'; 
        eval(['handles.markerDispRightP' num2str(ptStitching) ' = circleEC;']);
        clear circleEC;
    end;

    %---Display real world coordinates
    if ptEC == 0;
        set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
    else;
        valEC = handles.ptDLTRight(ptEC, 3);
        if isnan(valEC) == 1;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
        else;
            set(handles.selectDLTcoorX_EDIT_stitching, 'String', num2str(valEC));
        end;
        valEC = handles.ptDLTRight(ptEC, 4);
        if isnan(valEC) == 1;
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');
        else;
            set(handles.selectDLTcoorY_EDIT_stitching, 'String', num2str(valEC));
        end;
    end;
end;
handles.ptcurrentDisplay = 'dlt';
handles.activeDrop = 1; %DLT dropdown menue active

guidata(handles.hf_w1_welcome, handles);
