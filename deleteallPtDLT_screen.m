function deleteallPtDLT_screen(varargin);



handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
ptDLTAll = VidInfo.FishEye.ptDLTAll;

if isempty(VidInfo.FishEye) == 0;
    
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
    
    VidInfo.FishEye.ptDLTAll = NaN(50,4);
    VidInfo.FishEye.ptDLTAllOri = NaN(50,4);
    VidInfo.FishEye.ptDLTAllOpt = NaN(50,4);
    
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
        circleEC.FaceColor = [1 0 0];
        circleEC.EdgeColor = [1 0 0];
        circleEC.Visible = 'off'; 
        eval(['handles2.markerDLTP' num2str(ptDLT) ' = circleEC;']);
        clear circleEC;
    end;

    set(handles2.mainInfos_qual, 'String', '');
end;


handles2.VidInfo = VidInfo;
guidata(handles2.hf_w2_advancedImage, handles2);
%--------------------------------------------------------------------------

