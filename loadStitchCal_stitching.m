function [] = loadStitchCal_stitching(varargin);


handles = guidata(gcf);

if isempty(handles.pathLeftfile_stitching) == 1 | isempty(handles.pathRightfile_stitching) == 1;
    return;
end;


if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

%---Select and load
[file,path] = uigetfile({'*.*';'*.MAT';'*.mat'},...
                      'Select your set of stitching parameters', handles.defaultpath);
if file == 0;
    return;
end;
fileEC = [path file]; 

set(handles.txtProgress_stitching, 'String', 'Loading stitching ...', 'Visible', 'on');
drawnow;
load(fileEC);



%---Load DLT points
%Create empty var
handles.ptDLTLeft = NaN(50,4); %create 50 empty points
handles.ptDLTLeft_lastSelect = 0;
handles.ptDLTRight = NaN(50,4); %create 50 empty points
handles.ptDLTRight_lastSelect = 0;
set(handles.selectPtDLT_stitching, 'value', 1);

%Fill the values in
if isempty(ptDLT_validLeft) == 0;
    for lineEC = 1:length(ptDLT_validLeft(:,1));
        handles.ptDLTLeft(lineEC,:) = ptDLT_validLeft(lineEC, :);
    end;
end;
if isempty(ptDLT_validRight) == 0;
    for lineEC = 1:length(ptDLT_validRight(:,1));
        handles.ptDLTRight(lineEC,:) = ptDLT_validRight(lineEC, :);
    end;
end;


%---Load stiching points
%Create empty var
handles.ptStitchingLeft = zeros(50,2); %create 50 empty points
handles.ptStitichingLeft_lastSelect = 0;
handles.ptStitchingRight = zeros(50,2); %create 50 empty points
handles.ptStitichingRight_lastSelect = 0;
set(handles.selectPtStitching_stitching, 'value', 1);

%Fill the values in
if isempty(ptStitching_valid) == 0;
    for lineEC = 1:length(ptStitching_valid(:,1));
        handles.ptStitchingLeft(lineEC,:) = ptStitching_valid(lineEC, 1:2);
        handles.ptStitchingRight(lineEC,:) = ptStitching_valid(lineEC, 3:4);
    end;
end;



%---Reset points position
handles.ptDLTLeft_lastSelect = 1;
handles.ptDLTRight_lastSelect = 1;
handles.ptStitchingLeft_lastSelect = 1;
handles.ptStitchingRight_lastSelect = 1;
handles.activeDrop = 1; %DLT dropdown menue active
set(handles.selectDLTcoorX_EDIT_stitching, 'String', '');
set(handles.selectDLTcoorY_EDIT_stitching, 'String', '');

%---display stitching points for left vid
ispointVisible = 0;
for ptStitching = 1:50; %left vid axes
    eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
    uistack(circleEC, 'top');
    p = nsidedpoly(8, 'Center', handles.ptStitchingLeft(ptStitching,:), 'Radius', 10);
    circleEC.Shape = p;

    if handles.activeVideo_stitching == 1;
        if handles.ptStitchingLeft(ptStitching,1) ~= 0 & handles.ptStitchingLeft(ptStitching,2) ~= 0;
            circleEC.Visible = 'on';
            ispointVisible = 1;
            handles.ptcurrentDisplay = 'stitch';
        else;
            circleEC.Visible = 'off';
        end;
    else;
        circleEC.Visible = 'off';
    end;
    circleEC.FaceColor = [1 0 0];
    circleEC.EdgeColor = [1 0 0];
    eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
    clear circleEC;
end;


%---display DLT points for left vid
for ptDLT = 1:50; %left vid axes
    eval(['circleEC = handles.markerDLTLeftP' num2str(ptDLT) ';']);
    uistack(circleEC, 'top');
    if isnan(handles.ptDLTLeft(ptDLT,1)) == 0 & isnan(handles.ptDLTLeft(ptDLT,2)) == 0;
        p = nsidedpoly(8, 'Center', handles.ptDLTLeft(ptDLT,1:2), 'Radius', 10);
    else;
        p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    end;
    circleEC.Shape = p;
    
    if handles.activeVideo_stitching == 1;
        if isnan(handles.ptDLTLeft(ptDLT,1)) == 0 & isnan(handles.ptDLTLeft(ptDLT,2)) == 0;
            if ispointVisible == 0;
                %---only display DLT points is no stitching points
                circleEC.Visible = 'on';
                handles.ptcurrentDisplay = 'dlt';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
    else;
        circleEC.Visible = 'off';
    end;
    circleEC.FaceColor = [1 0 1];
    circleEC.EdgeColor = [1 0 1];
    eval(['handles.markerDLTLeftP' num2str(ptDLT) ' = circleEC;']);
    clear circleEC;
end;


%---display stitching points for right vid
ispointVisible = 0;
for ptStitching = 1:50; %left vid axes
    eval(['circleEC = handles.markerDispRightP' num2str(ptStitching) ';']);
    uistack(circleEC, 'top');
    p = nsidedpoly(8, 'Center', handles.ptStitchingRight(ptStitching,:), 'Radius', 10);
    circleEC.Shape = p;

    if handles.activeVideo_stitching == 2;
        if handles.ptStitchingRight(ptStitching,1) ~= 0 & handles.ptStitchingRight(ptStitching,2) ~= 0;
            circleEC.Visible = 'on';
            ispointVisible = 1;
            handles.ptcurrentDisplay = 'stitch';
        else;
            circleEC.Visible = 'off';
        end;
    else;
        circleEC.Visible = 'off';
    end;
    circleEC.FaceColor = [1 0 0];
    circleEC.EdgeColor = [1 0 0];
    eval(['handles.markerDispRightP' num2str(ptStitching) ' = circleEC;']);
    clear circleEC;
end;

%---display DLT points for right vid
for ptDLT = 1:50; %left vid axes
    eval(['circleEC = handles.markerDLTRightP' num2str(ptDLT) ';']);
    uistack(circleEC, 'top');
    if isnan(handles.ptDLTRight(ptDLT,1)) == 0 & isnan(handles.ptDLTRight(ptDLT,2)) == 0;
        p = nsidedpoly(8, 'Center', handles.ptDLTRight(ptDLT,1:2), 'Radius', 10);
    else;
        p = nsidedpoly(8, 'Center', [0 0], 'Radius', 10);
    end;
    circleEC.Shape = p;
    
    if handles.activeVideo_stitching == 2;
        if isnan(handles.ptDLTRight(ptDLT,1)) == 0 & isnan(handles.ptDLTRight(ptDLT,2)) == 0;
            if ispointVisible == 0;
                %---only display DLT points is no stitching points
                circleEC.Visible = 'on';
                handles.ptcurrentDisplay = 'dlt';
            else;
                circleEC.Visible = 'off';
            end;
        else;
            circleEC.Visible = 'off';
        end;
    else;
        circleEC.Visible = 'off';
    end;
    circleEC.FaceColor = [1 0 1];
    circleEC.EdgeColor = [1 0 1];
    eval(['handles.markerDLTRightP' num2str(ptDLT) ' = circleEC;']);
    clear circleEC;
end;
set(handles.selectPtDLT_stitching, 'value', 1);



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
listStitching = get(handles.selectPtStitching_stitching, 'String');
if countPt == 0;
    listStitching{1,1} = 'Auto';
else;
    listStitching{1,1} = 'Manual';
end;
set(handles.selectPtStitching_stitching, 'String', listStitching, 'Value', 1);

handles.savedOutputStichingNormal = savedOutputStichingNormal;
handles.savedOutputStichingTop = savedOutputStichingTop;

if isempty(VidInfo) == 0;
    VidInfo.VidObjLeft = handles.VidInfoLeftStitching.VidObj;
    VidInfo.VidObjRight = handles.VidInfoRightStitching.VidObj;
    VidInfo.FrameECLeft = handles.VidInfoLeftStitching.FrameEC;
    VidInfo.FrameECRight = handles.VidInfoRightStitching.FrameEC;
    VidInfo.DurationLeft = handles.VidInfoLeftStitching.Duration;
    VidInfo.DurationRight = handles.VidInfoRightStitching.Duration;
    VidInfo.Rate = handles.VidInfoLeftStitching.Rate;
end;
handles.VidInfo = VidInfo;


set(handles.txtProgress_stitching, 'String', '', 'Visible', 'off');
guidata(handles.hf_w1_welcome, handles);

