function loadPtDLT_screen(varargin);



handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;

if isempty(VidInfo.FishEye) == 0;
    [file,path] = uigetfile({'*.*';'*.MAT';'*.mat'},...
                          'Select your calibration points', handles2.defaultpath);
    
    if file == 0
        return;
    end;
    set(handles2.mainInfos_qual, 'String', 'Loading points ...');
    drawnow;

    %-------------------------------Load data----------------------------------
    filename = [path file];
    set(handles2.mainInfos_qual, 'String', 'Loading calibration points ...');
    drawnow;
    load(filename);
    VidInfo.FishEye.ptDLTAll = ptDLTAll;

    ptDLTValid = [];         %point for optimisation
    if isempty(ptDLTAll) == 0;
        for liEC = 1:length(ptDLTAll(:,1));
            ptEC = ptDLTAll(liEC,:);
            indexNaN = find(isnan(ptEC) == 1);
            if isempty(indexNaN) == 1;
                %full set of points
                ptDLTValid = [ptDLTValid; ptEC];
            end;
        end;
    end;

    %---Update tools and display
    set(handles2.selectPtDLT_qual, 'enable', 'on', 'value', 1);
    set(handles2.selectDLTcoorX_EDIT_qual, 'enable', 'off', 'string', '');
    set(handles2.selectDLTcoorY_EDIT_qual, 'enable', 'off', 'string', '');
    set(handles2.erasePtDLT_qual, 'enable', 'off');
    if length(ptDLTValid) >= 6;
        set(handles2.applyOptimisation1_qual, 'enable', 'on');
        set(handles2.applyOptimisation2_qual, 'enable', 'on');
    else;
        set(handles2.applyOptimisation1_qual, 'enable', 'off'); 
        set(handles2.applyOptimisation2_qual, 'enable', 'off'); 
    end;
    if length(ptDLTValid) >= 4;
        set(handles2.applyTopDown_qual, 'enable', 'on');
        set(handles2.apply2_qual, 'enable', 'on');
        set(handles2.restore2_qual, 'enable', 'on');
    else;
        set(handles2.applyTopDown_qual, 'enable', 'off'); 
        set(handles2.apply2_qual, 'enable', 'off');
        set(handles2.restore2_qual, 'enable', 'off');
    end;

    for ptDLT = 1:50; 
        axes(handles2.mainVideo_qual); hold on;

        eval(['circleEC = handles2.markerDLTP' num2str(ptDLT) ';']);
        if ptDLT <= length(ptDLTAll(:,1));
            uCircle = ptDLTAll(ptDLT,1);
            vCircle = ptDLTAll(ptDLT,2);
            if isnan(uCircle) == 1;
                p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
                colorEC = [1 0 0];
                visibleEC = 'off';
            else;
                p = nsidedpoly(10, 'Center', [uCircle vCircle], 'Radius', 10);
                %inactive point... red
                colorEC = [1 0 0];
                visibleEC = 'on';
            end;
        else;
            p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
            colorEC = [1 0 0];
            visibleEC = 'off';
        end;
        circleEC = plot(p, 'FaceColor', colorEC, 'EdgeColor', colorEC, 'Visible', visibleEC);
        eval(['handles2.markerDLTP' num2str(ptDLT) ' = circleEC;']);
        clear circle;
    end;

    set(handles2.mainInfos_qual, 'String', '');
end;


handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
set(handles2.mainInfos_qual, 'String', '');
drawnow;
%--------------------------------------------------------------------------

