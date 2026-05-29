function [] = pressKeySelectpt_stitching(varargin);


handles = guidata(gcf);


if strcmpi(get(handles.selectPtStitching_stitching, 'enable'), 'on');

    lastKey = get(gcf, 'CurrentKey');
    lastKey = num2str(lastKey);

    changePop = 0;
    if strcmpi(lastKey, 'uparrow') == 1;
        changePop = -1;
    elseif strcmpi(lastKey, 'downarrow') == 1;
        changePop = 1;
    end;

    if changePop ~= 0;

        if handles.activeDrop == 1;
            ptEC = get(handles.selectPtDLT_stitching, 'value');
        else;
            ptEC = get(handles.selectPtStitching_stitching, 'value');
        end;
        ptEC = ptEC + changePop;

        if ptEC == 0;
            return;
        end;
        if ptEC == 52;
            return;
        end;
        if handles.activeDrop == 1;
            set(handles.selectPtDLT_stitching, 'value', ptEC);
        else;
            set(handles.selectPtStitching_stitching, 'value', ptEC);
        end;

        ptEC = ptEC - 1;
        if ptEC == 0;
            set(handles.hf_w1_welcome, 'WindowButtonDownFcn', '');
        else;
            if handles.activeDrop == 1;
                set(handles.hf_w1_welcome, 'WindowButtonDownFcn', @clickCalibDLT);
            else;
                set(handles.hf_w1_welcome, 'WindowButtonDownFcn', @clickCalibStitching);
            end;
        end;

        if handles.activeVideo_stitching == 1;
            if handles.activeDrop == 1;
                handles.ptDLTLeft_lastSelect = ptEC;
                for ptStitching = 1:50; %left vid axes
                    eval(['circleEC = handles.markerDLTLeftP' num2str(ptStitching) ';']);
                    if ptStitching == ptEC
                        circleEC.FaceColor = [1 1 0];
                        circleEC.EdgeColor = [1 1 0]; 
                    else;
                        circleEC.FaceColor = [1 0 1];
                        circleEC.EdgeColor = [1 0 1]; 
                    end;
                    eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circleEC;']);
                    clear circleEC;
                end;
            else;
                handles.ptStitichingLeft_lastSelect = ptEC;
                for ptStitching = 1:50; %left vid axes
                    eval(['circleEC = handles.markerDispLeftP' num2str(ptStitching) ';']);
                    if ptStitching == ptEC
                        circleEC.FaceColor = [0 1 0];
                        circleEC.EdgeColor = [0 1 0]; 
                    else;
                        circleEC.FaceColor = [1 0 0];
                        circleEC.EdgeColor = [1 0 0]; 
                    end;
                    eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circleEC;']);
                    clear circleEC;
                end;
            end;
        
        else;
            if handles.activeDrop == 1;
                handles.ptDLTRight_lastSelect = ptEC;
                for ptStitching = 1:50; %left vid axes
                    eval(['circleEC = handles.markerDLTRightP' num2str(ptStitching) ';']);
                    if ptStitching == ptEC
                        circleEC.FaceColor = [1 1 0];
                        circleEC.EdgeColor = [1 1 0]; 
                    else;
                        circleEC.FaceColor = [1 0 1];
                        circleEC.EdgeColor = [1 0 1]; 
                    end;
                    eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circleEC;']);
                    clear circleEC;
                end;
            else;
                handles.ptStitichingRight_lastSelect = ptEC;
                for ptStitching = 1:50; %left vid axes
                    eval(['circleEC = handles.markerDispRightP' num2str(ptStitching) ';']);
                    if ptStitching == ptEC
                        circleEC.FaceColor = [0 1 0];
                        circleEC.EdgeColor = [0 1 0]; 
                    else;
                        circleEC.FaceColor = [1 0 0];
                        circleEC.EdgeColor = [1 0 0]; 
                    end;
                    eval(['handles.markerDispRightP' num2str(ptStitching) ' = circleEC;']);
                    clear circleEC;
                end;
            end;
        end;
    end;
end;

guidata(handles.hf_w1_welcome, handles);
