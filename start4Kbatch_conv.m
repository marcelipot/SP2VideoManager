function [] = start4Kbatch_conv(varargin);



handles = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
end;

%check the folder exist
if handles.inputfolderPanning == 0;
    errorwindow = errordlg('Select an input folder', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
else;
    if isdir(handles.inputfolderPanning) == 0;
        errorwindow = errordlg('Input videos folder deleted', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;

if handles.outputfolderPanning == 0;
    errorwindow = errordlg('Select an output folder', 'Error');
    if ispc == 1;
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
    end;
    return;
else;
    %check the folder exist
    if isdir(handles.outputfolderPanning) == 0;
        errorwindow = errordlg('Output videos folder deleted', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
end;
   
%clear folder
if ismac == 1;
    if isdir('/Applications/SP2VideoManager/Temp') == 0;
        command = ['mkdir /Applications/SP2VideoManager/Temp'];
        [status, cmdout] = system(command);
    end;
    command = ['rm /Applications/SP2VideoManager/Temp/*'];
    [status, cmdout] = system(command);

    load /Applications/SP2VideoManager/listVideoPanningFiles.mat;
    
elseif ispc == 1;
    if isdir([MDIR '\SP2VideoManager\Temp']) == 0;
        command = ['mkdir ' MDIR '\SP2VideoManager\Temp'];
        [status, cmdout] = system(command);
    end;
    command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
    [status, cmdout] = system(command);

    load([MDIR '\SP2VideoManager\listVideoPanningFiles.mat']);
end;
   

if isempty(listVideoPanningFiles) == 1;
    dummy{1,1} = 'No Video available';
    dummy{1,2} = '';
    set(handles.tablePanning_conv, 'data', dummy);
    table_extent = get(handles.tablePanning_conv, 'Extent');
    table_position = get(handles.tablePanning_conv, 'Position');
    set(handles.tablePanning_conv, 'Position', [table_position(1) table_position(2)+table_position(4)-table_extent(4) table_extent(3) table_extent(4)]);
else;
    for i = 1:length(listVideoPanningFiles(:,1));
        fileEC = listVideoPanningFiles{i,1};
        fileStatus = listVideoPanningFiles{i,2};

        if strcmpi(fileStatus, 'Waiting') == 1 | strcmpi(fileStatus, 'Processing') == 1;
            fileprocess = listVideoPanningFiles{i,1};
            listDir = dir(handles.inputfolderPanning);

            inputfileExist = 0;
            for carac = 1:length(listDir);
                fileCheck = listDir(carac);
                NameEC = fileCheck.name;
                if strcmpi(NameEC, fileprocess) == 1;
                    inputfileExist = 1;
                end;
            end;
            if inputfileExist == 0;
                listVideoPanningFiles{i,2} = 'Deleted';
                set(handles.tablePanning_conv, 'data', listVideoPanningFiles);

                table_extent = get(handles.tablePanning_conv, 'Extent');
                table_position = get(handles.tablePanning_conv, 'Position');
                posLeft = table_position(1);
                posBottom = table_position(2)+table_position(4)-table_extent(4);
                posWidth = table_extent(3);
                posHeight = table_extent(4);

                set(gcf, 'units', 'pixels');
                posFig = get(gcf, 'position');
                set(gcf, 'units', 'normalized');
                set(handles.tablePanning_conv, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

                drawnow;
                if ismac == 1
                    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                elseif ispc == 1;
                    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                end;
            else;
                listVideoPanningFiles{i,2} = 'Processing';
                set(handles.tablePanning_conv, 'data', listVideoPanningFiles);

                table_extent = get(handles.tablePanning_conv, 'Extent');
                table_position = get(handles.tablePanning_conv, 'Position');
                posLeft = table_position(1);
                posBottom = table_position(2)+table_position(4)-table_extent(4);
                posWidth = table_extent(3);
                posHeight = table_extent(4);

                set(gcf, 'units', 'pixels');
                posFig = get(gcf, 'position');
                set(gcf, 'units', 'normalized');    
                set(handles.tablePanning_conv, 'Visible', 'on', 'Position', [posLeft posBottom posWidth posHeight]);

                drawnow;
                if ismac == 1;
                    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                elseif ispc == 1;
                    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                end;

                inputFileprocess = [handles.inputfolderPanning '\' fileprocess];
                [folderEC, nameEC, extEC] = fileparts(inputFileprocess);
                outputFileprocess = [handles.outputfolderPanning '\' nameEC '_conv' extEC];

                startProcessing4K_conv(inputFileprocess, outputFileprocess, handles.VidCorrectionBatch, handles.fileprocess4K_conv);
            
                listVideoPanningFiles{i,2} = 'Done';
                set(handles.tablePanning_conv, 'data', listVideoPanningFiles);
                
                if ismac == 1;
                    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
                elseif ispc == 1;
                    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
                end;
            end;
        end;
    end;
end;

guidata(handles.hf_w1_welcome, handles);

