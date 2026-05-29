function [] = popSelectPtDLT_screen(varargin);


handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
ptDLTAll = VidInfo.FishEye.ptDLTAll;

ptEC = get(handles2.selectPtDLT_qual, 'value');
ptEC = ptEC - 1;

if ptEC == 0;
    set(handles2.hf_w2_advancedImage, 'WindowButtonDownFcn', '');
else;
    set(handles2.hf_w2_advancedImage, 'WindowButtonDownFcn', @clickDLTScreen);
end;


%---reset DLT point to visible
for ptDLT = 1:50; %left vid axes
    eval(['circleEC = handles2.markerDLTP' num2str(ptDLT) ';']);
    if ptDLT == ptEC
        circleEC.FaceColor = [0 1 0];
        circleEC.EdgeColor = [0 1 0]; 
    else;
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0]; 
    end;
    circleEC.Visible = 'on'; 
    eval(['handles2.markerDLTP' num2str(ptDLT) ' = circleEC;']);
    clear circleEC;
end;

%---Display real world coordinates
if ptEC == 0;
    set(handles2.selectDLTcoorX_EDIT_qual, 'String', '', 'enable', 'off');
    set(handles2.selectDLTcoorY_EDIT_qual, 'String', '', 'enable', 'off');
    set(handles2.erasePtDLT_qual, 'enable', 'off');
else;
    valEC = ptDLTAll(ptEC, 3);
    if isnan(valEC) == 1;
        set(handles2.selectDLTcoorX_EDIT_qual, 'String', '', 'enable', 'on');
    else;
        set(handles2.selectDLTcoorX_EDIT_qual, 'String', num2str(valEC), 'enable', 'on');
    end;
    valEC = ptDLTAll(ptEC, 4);
    if isnan(valEC) == 1;
        set(handles2.selectDLTcoorY_EDIT_qual, 'String', '', 'enable', 'on');
    else;
        set(handles2.selectDLTcoorY_EDIT_qual, 'String', num2str(valEC), 'enable', 'on');
    end;
    set(handles2.erasePtDLT_qual, 'enable', 'on');
end;

guidata(handles2.hf_w2_advancedImage, handles2);
