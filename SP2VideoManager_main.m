
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%-----------------------------Determine path-------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if ismac == 1;
    if isdir('/Applications/SP2VideoManager') == 0;
        errorwindow = errordlg('Impossible to run: Root folder missing', 'Error');
        return;
    else;
        
        if isfile('/Applications/SP2VideoManager/icons.mat') == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            return;
        end;
        
        if isfile('/Applications/SP2VideoManager/IPList.mat') == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            return;
        end;
        
        if isfile('/Applications/SP2VideoManager/listVideo4KFiles.mat') == 1;
            command = 'rm /Applications/SP2VideoManager/listVideo4KFiles.mat';
            [status, cmdout] = system(command);
            
            command = 'rm /Applications/SP2VideoManager/listVideoPanningFiles.mat';
            [status, cmdout] = system(command);
        end;
        
        if isdir('/Applications/SP2VideoManager/Temp/') == 1;
            command = ['rm /Applications/SP2VideoManager/Temp/*'];
            [status, cmdout] = system(command);
        else;
            command = ['mkdir /Applications/SP2VideoManager/Temp'];
            [status, cmdout] = system(command);
        end;
        
        if isdir('/opt/homebrew/bin/ffmpeg') == 1;
            if isdir('/opt/homebrew/bin/ffmpeg') == 0;
                errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
                return;
            else;
                if isfile('/opt/homebrew/bin/ffmpeg') == 0;
                    errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
                    if ispc == 1;
                        jFrame = get(handle(errorwindow), 'javaframe');
                        jicon = javax.swing.ImageIcon([MDIR '\SP2Viewer\SpartaManager_IconSoftware.png']);
                        jFrame.setFigureIcon(jicon);
                        clc;
                    end;
                    return;
                end;
            end;
        else;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2Viewer\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
        end;

        if isdir('/Applications/SP2VideoManager/FishEyeParam/') == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            return;
        end;
        
        tempfolder = '/Applications/SP2VideoManager/Temp/';
        
    end;
    
    MDIR = '/Applications/SP2VideoManager';
    user_name = char(java.lang.System.getProperty('user.name'));
    handles.defaultpath = ['/Users/',user_name,'/Desktop'];
    handles.lastPath_analyser = handles.defaultpath;
    handles.lastPath_database = handles.defaultpath;
    handles.lastPath_player = handles.defaultpath;
    
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    if isdir([MDIR '\SP2VideoManager']) == 0;
        errorwindow = errordlg('Impossible to run: Root folder missing', 'Error');
        jFrame = get(handle(errorwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
        return;
    else;
        if isfile([MDIR '\SP2VideoManager\icons.mat']) == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        end;
        
        if isfile([MDIR '\SP2VideoManager\IPList.mat']) == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        end;
        
        if isfile([MDIR '\SP2VideoManager\listVideo4KFiles.mat']) == 1;
            command = ['del /Q ' MDIR '\SP2VideoManager\listVideo4KFiles.mat'];
            [status, cmdout] = system(command);
            
            command = ['del /Q ' MDIR '\SP2VideoManager\listVideoPanningFiles.mat'];
            [status, cmdout] = system(command);
        end;
        
        if isdir([MDIR '\SP2VideoManager\Temp']) == 1;
            command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
            [status, cmdout] = system(command);
        else;
            command = ['mkdir ' MDIR '\SP2VideoManager\Temp'];
            [status, cmdout] = system(command);
        end;
        
        if isdir([MDIR '\SP2VideoManager\ffmpeg']) == 1;
            if isdir([MDIR '\SP2VideoManager\ffmpeg\bin']) == 0;
                errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
                return;
            else;
                if isfile([MDIR '\SP2VideoManager\ffmpeg\bin\ffmpeg.exe']) == 0;
                    errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
                    jFrame = get(handle(errorwindow), 'javaframe');
                    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                    jFrame.setFigureIcon(jicon);
                    clc;
                    return;
                end;
            end;
        else;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        end;

        if isdir([MDIR '\SP2VideoManager\FishEyeParam']) == 0;
            errorwindow = errordlg('Impossible to run: Root folder incomplete', 'Error');
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
            return;
        end;
        
        tempfolder = [MDIR '\SP2VideoManager\Temp'];
    end;
    
    %---Last path and default path
    handles.defaultpath = winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop');
    handles.lastPath_analyser = handles.defaultpath;
    handles.lastPath_database = handles.defaultpath;
    handles.lastPath_player = handles.defaultpath;
    
else;
    errordlg('Impossible to run: Unknown OS', 'Error');
    return;
end;
%Add java path for pdf parser function
javaaddpath('iText-4.2.0-com.itextpdf.jar')

handles.MDIR = MDIR;
resolution = get(0,'ScreenSize');
resolution = resolution(1,3:4);
if resolution(1) < 1280;
    warningwindow = warndlg('A minimum resolution of 1280x720 is advised to run this application', 'Warning');
    if ispc == 1;
        jFrame = get(handle(warningwindow), 'javaframe');
        jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
        jFrame.setFigureIcon(jicon);
        clc;
        return;
    end;
end;
handles.defaultpathinputPanning = handles.defaultpath;
handles.defaultpathinput4K = handles.defaultpath;
handles.defaultpathoutputPanning = handles.defaultpath;
handles.defaultpathoutput4K = handles.defaultpath;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------






%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------Create the main window--------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%---Create the welcome window
pos = [(resolution(1)-1000)./2 (resolution(2)-500)./2 1000 562];
handles.hf_w1_welcome = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', 'windowstyle', 'normal', 'color', [0 0 0], 'units', 'pixels', 'position', pos,...
    'WindowButtonDownFcn', '', 'WindowButtonUpFcn', '', 'WindowKeyPressFcn', '', 'WindowKeyReleaseFcn', '', ...
    'CloseRequestFcn', @closeguimain, 'SizeChangedFcn', @Resize_SP2manager);
set(handles.hf_w1_welcome, 'Name', 'Sparta 2 Video Manager', 'NumberTitle', 'off');
if ispc == 1;
    jFrame = get(handle(handles.hf_w1_welcome), 'javaframe');
    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;
%-------------------------------------------------------------------------

%-----------------------------Load Icones---------------------------------
if ispc == 1;
    load([MDIR '\SP2VideoManager\icons.mat']);
    handles.icones = icones;
    clear icones;
    
    load([MDIR '\SP2VideoManager\IPList.mat']);
    handles.IPlist = IPlist;
    clear IPList;
    
elseif ismac == 1;
    load /Applications/SP2VideoManager/icons.mat;
    handles.icones = icones;
    clear icones;
    
    load /Applications/SP2VideoManager/IPList.mat;
    handles.IPlist = IPlist;
    clear IPList;
end;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------








%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%-----------------------------------Main-----------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if ismac == 1;
    font1 = 14;
    font2 = 13;
    font3 = 12;
    font4 = 9;
elseif ispc == 1;
    font1 = 13;
    font2 = 12;
    font3 = 11;
    font4 = 8;
end;
handles.font1 = font1;
handles.font2 = font2;
handles.font3 = font3;
handles.font4 = font4;

handles.current_panel = 'entry';


%---Create line on the top
handles.lineTop_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [0, 522, 1000, 1], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
set(handles.lineTop_main, 'units', 'normalized');

%---Txt top last update
handles.txtTitle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [10, 532, 300, 25], 'String', 'SP2 Video Manager', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtTitle_main, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt Software version
handles.txtsoftwareversion_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [700, 532, 290, 25], 'String', 'Version v01.10', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Right');
set(handles.txtsoftwareversion_main, 'fontunits', 'normalized', 'units', 'normalized');

%---create logo_aargos
handles.logo_aargos_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [10, 15, 120, 30], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
imshow(handles.icones.logo_AARGOS);

%---create SA logo
handles.logo_sa_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [830, 10, 150, 50], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
imshow(handles.icones.logo_SAL);

%---Create vertical lines
% handles.lineLeft_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [20, 70, 1, 440], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
% handles.lineMiddle_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [500, 70, 1, 440], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);
% handles.lineRight_main = axes('parent', handles.hf_w1_welcome, 'units', 'pixels', 'Position', [980, 70, 1, 440], 'color', [1 1 1], 'Xcolor', [1 1 1], 'XTick', [], 'Ycolor', [1 1 1], 'YTick', []);



%---Selection tool
%---Entry list management
if ismac == 1;
    handles.EntryList_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [5, 490, 200, 30], 'callback', @select_EntryList, 'value', 1, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Entry list management');
    set(handles.EntryList_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
    
    %---File transfer
    handles.FileTransfer_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [205, 490, 200, 30], 'callback', @select_FileTransfer, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'File Transfer');
    set(handles.FileTransfer_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
    
    %---Other operations
    handles.OtherOperations_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [405, 490, 200, 30], 'callback', @select_OtherOperations, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Other operations');
    set(handles.OtherOperations_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
elseif ispc == 1;
    handles.EntryList_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'togglebutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [5, 490, 200, 30], 'callback', @select_EntryList, 'value', 1, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Entry list management');
    set(handles.EntryList_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
    
    %---File transfer
    handles.FileTransfer_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'togglebutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [205, 490, 200, 30], 'callback', @select_FileTransfer, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'File Transfer');
    set(handles.FileTransfer_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
    
    %---Other operations
    handles.OtherOperations_toggle_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'togglebutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [405, 490, 200, 30], 'callback', @select_OtherOperations, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Other operations');
    set(handles.OtherOperations_toggle_main, 'fontunits', 'normalized', 'units', 'normalized');
end;

%---Help button
handles.help_button_main = uicontrol('parent', handles.hf_w1_welcome, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [960, 490, 30, 30], 'callback', @helpButton_entry, 'cdata', imresize(handles.icones.question_offb, [30 30]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.help_button_main, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Help');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------









%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%----------------------------Entry list management-------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%---Initialise
handles.entrListFull_entry = [];
handles.heats2keepVal = 20;
handles.fontDiff = 0;
handles.fileEntryListPath = [];

%---Create panel
handles.entrylistPanel_entry = uipanel('parent', handles.hf_w1_welcome, 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 990, 480], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.7 0.7 0.7], ...
    'bordertype', 'etchedin');
set(handles.entrylistPanel_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt
handles.txtselectSourceList_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [10, 440, 100, 30], 'String', 'Select source :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtselectSourceList_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---dropdown menu
listSource = {''; 'Swimming Australia'; 'Swimming NSW'; 'Swimming QLD'; 'Omega Timing'};
if ismac == 1;
    handles.popSelectSourceList_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [100, 440, 190, 30], 'Callback', @popSelectSourceList_entry, ...
        'String', listSource, 'ForegroundColor', [0.1 0.1 0.1], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
elseif ispc == 1;
    handles.popSelectSourceList_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [110, 440, 180, 30], 'Callback', @popSelectSourceList_entry, ...
        'String', listSource, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0.1 0.1 0.1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
end;
set(handles.popSelectSourceList_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---Round selection
%---Txt
handles.txtselectRound_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [305, 440, 120, 30], 'String', 'Select seperator :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtselectRound_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---dropdown menu
listSource = {''; 'Heat'; 'Final'};
if ismac == 1;
    handles.popSelectRound_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [421, 440, 90, 30], ...
        'String', listSource, 'ForegroundColor', [0.1 0.1 0.1], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', '');
elseif ispc == 1;
    handles.popSelectRound_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [425, 440, 75, 30], ...
        'String', listSource, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0.1 0.1 0.1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', '');
end;
set(handles.popSelectRound_entry, 'fontunits', 'normalized', 'units', 'normalized');


%---File selection
%---Txt
handles.txtselectFile_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [515, 440, 80, 30], 'String', 'Select file :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtselectFile_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---file path
handles.txtpathFile_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [595, 445, 250, 25], 'String', '', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtpathFile_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---create load file icon
handles.loadList_button_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [850, 445, 25, 25], 'callback', @loadEntryList_entry, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.loadList_button_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select entrly list file (pdf or txt)');


%---Start scrapping
handles.startScrapping_button_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [890, 445, 90, 25], 'callback', @startScrappingEntry_entry, ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Start');
set(handles.startScrapping_button_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Start scrapping file');


%---Table entry list
colorrowEntry = [0.2 0.2 0.2];
edittableEntry = false;
ColWidthEntry = {50 40 40 85 85 85 85 85 85 85 85 85 85};
sumColEntry = (50+40+40+85+85+85+85+85+85+85+85+85+85);
handles.tabCol1RatioEntry = 50./sumColEntry;
handles.tabCol2RatioEntry = 40./sumColEntry;
handles.tabCol3RatioEntry = 40./sumColEntry;
handles.tabCol4RatioEntry = 85./sumColEntry;
handles.tabCol5RatioEntry = 85./sumColEntry;
handles.tabCol6RatioEntry = 85./sumColEntry;
handles.tabCol7RatioEntry = 85./sumColEntry;
handles.tabCol8RatioEntry = 85./sumColEntry;
handles.tabCol9RatioEntry = 85./sumColEntry;
handles.tabCol10RatioEntry = 85./sumColEntry;
handles.tabCol11RatioEntry = 85./sumColEntry;
handles.tabCol12RatioEntry = 85./sumColEntry;
handles.tabCol13RatioEntry = 85./sumColEntry;
handles.tableEntryList_entry = uitable('parent', handles.entrylistPanel_entry, 'Visible', 'off', 'units', 'pixels', 'FontName', 'Antiqua', 'FontSize', font3-5, ...
    'FontWeight', 'Bold', 'position', [5 40 980 395], 'ColumnEditable', false, 'ColumnName', [], 'RowName', [], ...
    'ColumnEditable', edittableEntry, 'ColumnWidth', ColWidthEntry, 'backgroundcolor', colorrowEntry, 'foregroundcolor', [1 1 1]);
set(handles.tableEntryList_entry, 'Units', 'normalized', 'fontunits', 'normalized');


%---Check
handles.checkkeepEmptyRows_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'radiobutton', 'Visible', 'off', 'units', 'pixels', ...
    'position', [10, 10, 200, 25], 'String', 'Fit to google sheet template', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, ...
    'HorizontalAlignment', 'Left', 'callback', @checkkeepEmptyRows_entry, 'Value', 1);
set(handles.checkkeepEmptyRows_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---Heats to keep
%---Txt
handles.txtheat2Keep_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', 'position', [220, 2, 150, 30], 'String', 'Heats to keep (up to) :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtheat2Keep_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---Box to enter the number of heats
handles.editheat2Keep_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Edit', 'Visible', 'off', 'units', 'pixels', 'position', [370, 10, 40, 25], ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'callback', @editheat2Keep_entry, 'String', '20', 'enable', 'off', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.editheat2Keep_entry, 'units', 'normalized', 'fontunits', 'normalized');



%---Fontsize
%---txt
handles.txtmodifFont_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', 'position', [425, 2, 130, 30], 'String', 'Modify font size :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtmodifFont_entry, 'fontunits', 'normalized', 'units', 'normalized');

%---minus and plus button
handles.minusmodifFont_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'off', 'units', 'pixels', ...
    'position', [550, 5, 25, 15], 'callback', @minusmodifFont_entry, ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', '-');
set(handles.minusmodifFont_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Start scrapping file');

handles.plusmodifFont_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'off', 'units', 'pixels', ...
    'position', [550, 21, 25, 15], 'callback', @plusmodifFont_entry, ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', '+');
set(handles.plusmodifFont_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Start scrapping file');


%---Export button
handles.save_button_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'off', 'units', 'pixels', ...
    'position', [925, 10, 25, 25], 'callback', @save_button_entry, 'cdata', imresize(handles.icones.save_offb, [25 25]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.save_button_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Reset session');

%---Reset button
handles.reset_button_entry = uicontrol('parent', handles.entrylistPanel_entry, 'Style', 'Pushbutton', 'Visible', 'off', 'units', 'pixels', ...
    'position', [955, 10, 25, 25], 'callback', @resetEntryList_entry, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.reset_button_entry, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Reset session');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------Video Trasfer panel-----------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%---Initialisation
handles.inputfolderPanning = 0;
handles.outputfolderPanning = 0;
handles.inputfolder4K = 0;
handles.outputfolder4K = 0;

handles.checkboxPanning = 1;
handles.checkbox4K = 1;
handles.checkboxRemuxPanning = 0;
handles.checkboxRemux4K = 0;
handles.fisheye4K = 0;
handles.Currenfisheye4K = 1;

handles.trimPanning = 8;
handles.addPanning = 0;
handles.trim4K = 0;
handles.add4K = 0;

handles.Processed4K = {};
handles.ProcessedPanning = {};
handles.listVideo4KFiles = {};
handles.listVideoPanningFiles = {};

handles.isStitchingFile = 0;
handles.isFishEyeFile = 0;

listVideo4KFiles = {};
listVideoPanningFiles = {};
if ispc == 1;
    save([MDIR '\SP2VideoManager\listVideoPanningFiles.mat'], 'listVideoPanningFiles');
    save([MDIR '\SP2VideoManager\listVideo4KFiles.mat'], 'listVideo4KFiles');
elseif ismac == 1;
    save('/Applications/SP2VideoManager/listVideoPanningFiles.mat', 'listVideoPanningFiles');
    save('/Applications/SP2VideoManager/listVideo4KFiles.mat', 'listVideo4KFiles');
end;

handles.refreshPlay = 0;
handles.refreshTime = 30;


%---Create panel
handles.pannigVideoPanel_conv = uipanel('parent', handles.hf_w1_welcome, 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 5, 990, 480], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.7 0.7 0.7], ...
    'bordertype', 'etchedin');
set(handles.pannigVideoPanel_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Create checkbox panning videos
handles.PanningVideo_check_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 430, 250, 25], 'horizontalAlignment', 'left', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'String', 'Batch Compression Settings');
set(handles.PanningVideo_check_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt input Panning
handles.txtinputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [25, 390, 110, 25], 'String', 'Input Folder :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtinputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt path input Panning
handles.pathinputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [135, 390, 275, 25], 'String', '', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.pathinputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Folder icon input Panning
handles.folderinputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [415, 390, 25, 25], 'callback', @folderinputPanning_conv, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.folderinputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select input panning video folder');

%---Txt output Panning
handles.txtoutputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [25, 355, 110, 25], 'String', 'Output Folder :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtoutputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt path output Panning
handles.pathoutputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [135, 355, 275, 25], 'String', '', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.pathoutputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Folder icon output Panning
handles.folderoutputPanning_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [415, 355, 25, 25], 'callback', @folderoutputPanning_conv, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.folderoutputPanning_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select output panning video folder');

%---Toggle button to select 4K or Panning processing
if ismac == 1;
    handles.select4K_toggle_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [5, 320, 150, 25], 'callback', @select_convBatch4K_conv, 'value', 1, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '4K Processing');
    set(handles.select4K_toggle_conv, 'fontunits', 'normalized', 'units', 'normalized');
    
    handles.selectPanning_toggle_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [160, 320, 150, 25], 'callback', @select_convBatchPanning_conv, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Panning Processing');
    set(handles.selectPanning_toggle_conv, 'fontunits', 'normalized', 'units', 'normalized');
    
elseif ispc == 1;
    handles.select4K_toggle_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'togglebutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [5,320, 150, 25], 'callback', @select_convBatch4K_conv, 'value', 1, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '4K Processing');
    set(handles.select4K_toggle_conv, 'fontunits', 'normalized', 'units', 'normalized');
    
    handles.selectPanning_toggle_conv = uicontrol('parent', handles.pannigVideoPanel_conv, 'Style', 'pushbutton', 'Visible', 'on', 'units', 'pixels', ...
        'position', [160, 320, 150, 25], 'callback', @select_convBatchPanning_conv, 'value', 0, ...
        'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Panning Processing');
    set(handles.selectPanning_toggle_conv, 'fontunits', 'normalized', 'units', 'normalized');
end;

%---Panel for 4K processing
handles.batchprocessing4KPanel_conv = uipanel('parent', handles.pannigVideoPanel_conv, 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 440, 310], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.7 0.7 0.7], ...
    'bordertype', 'etchedin');
set(handles.batchprocessing4KPanel_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Load FishEye session file
handles.loadSessionFishEye_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 250, 200, 25], 'callback', @loadSessionFishEye_conv, 'String', 'Load Image Correction File', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3);
set(handles.loadSessionFishEye_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select a session file for image correction');

%---Delete fishEye
handles.deleteSessionFishEye_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [210, 250, 25, 25], 'callback', @deleteSessionFishEye_conv, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'on', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.deleteSessionFishEye_conv, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Reset image correction parameters');

%---Load Stitching session file
handles.loadSessionStitching_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 220, 200, 25], 'callback', @loadSessionStitching_conv, 'String', 'Load Stitching File', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3);
set(handles.loadSessionStitching_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select a session file for stitching');

%---Delete stitching
handles.deleteSessionStitching_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [210, 220, 25, 25], 'callback', @deleteSessionStitching_conv, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'on', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.deleteSessionStitching_conv, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Reset image correction parameters');

%---start icone
handles.start4Kbatch_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [335, 230, 30, 30], 'callback', @start4Kbatch_conv, 'cdata', imresize(handles.icones.play_offb, [30 30]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.start4Kbatch_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select output panning video folder');

%---Refresh icone
handles.refresh4Kbatch_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [300, 230, 30, 30], 'callback', @refresh4Kbatch_conv, 'cdata', imresize(handles.icones.swapVideo, [30 30]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.refresh4Kbatch_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select output panning video folder');

%---File being process
handles.fileprocess4K_conv = uicontrol('parent', handles.batchprocessing4KPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 150, 440, 55], 'String', 'Processing   :   ...', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.fileprocess4K_conv, 'fontunits', 'normalized', 'units', 'normalized');


%---Panel for panning processing
handles.batchprocessingPanningPanel_conv = uipanel('parent', handles.pannigVideoPanel_conv, 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 5, 440, 310], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.7 0.7 0.7], ...
    'bordertype', 'etchedin');
set(handles.batchprocessingPanningPanel_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt Trim Panning
handles.txttrimPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [15, 310, 40, 25], 'String', 'Trim', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txttrimPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.edittrimPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [55, 312, 40, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @edittrimPanning_conv, 'String', num2str(handles.trimPanning), ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.edittrimPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.frametrimPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [100, 310, 60, 25], 'String', 'frames', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frametrimPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt Add Panning
handles.txtaddPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [160, 310, 40, 25], 'String', 'Add', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtaddPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.editaddPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [195, 312, 40, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @editaddPanning_conv, 'String', num2str(handles.addPanning), ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.editaddPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.frameaddPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [240, 310, 60, 25], 'String', 'frames', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frameaddPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Compression level
handles.txtCompressionPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [300, 310, 90, 25], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3, ...
    'String', 'Bitrate:');
set(handles.txtCompressionPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');

listDrop = {'17 Mbits/s'; '16 Mbits/s'; '15 Mbits/s'; '14 Mbits/s'; '13 Mbits/s'; '12 Mbits/s'; '11 Mbits/s'; '10 Mbits/s'; ...
        '9 Mbits/s'; '8 Mbits/s'; '7 Mbits/s'; '6 Mbits/s'; '5 Mbits/s'};
handles.CurrenCompressionPanning = 15;
if ismac == 1;
    handles.popCompressionPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [355, 317, 110, 20], ...
        'String', listDrop, 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @compressionlevelPanning_conv);
elseif ispc == 1;
    handles.popCompressionPanning_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [355, 317, 95, 20], ...
        'String', listDrop, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @compressionlevelPanning_conv);
end;
set(handles.popCompressionPanning_conv, 'fontunits', 'normalized', 'units', 'normalized');


%---Txt Refresh
handles.txtrefresh_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [15, 265, 105, 25], 'String', 'Refresh every :', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtrefresh_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.editrefresh_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', 'position', [120, 267, 30, 25], 'String', num2str(handles.refreshTime), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @editrefresh_conv, ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.editrefresh_conv, 'fontunits', 'normalized', 'units', 'normalized');

handles.txtsecond_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [160, 265, 20, 25], 'String', 's', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtsecond_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Txt update
handles.txtupdate_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [190, 265, 200, 25], 'String', 'Next update at :    -- : -- : --', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.txtupdate_conv, 'fontunits', 'normalized', 'units', 'normalized');

%---Play/Pause icone
handles.playrefresh_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [400, 265, 30, 30], 'callback', @playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [30 30]), ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.playrefresh_conv, 'fontunits', 'normalized', 'units', 'normalized', 'Tooltipstring', 'Select output panning video folder');

%---File being process
handles.fileprocess_conv = uicontrol('parent', handles.batchprocessingPanningPanel_conv, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', 'position', [10, 190, 440, 55], 'String', 'Processing   :   ...', ...
    'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.fileprocess_conv, 'fontunits', 'normalized', 'units', 'normalized');




%---Table
colorrow = [0.2 0.2 0.2];
edittablelist = false;
ColWidth = {420 80};
handles.tabCol1Ratio = 420./(420+80);
handles.tabCol2Ratio = 80./(420+80);
handles.tablePanning_conv = uitable('parent', handles.pannigVideoPanel_conv, 'Visible', 'off', 'units', 'pixels', 'FontName', 'Antiqua', 'FontSize', font4, ...
    'FontWeight', 'Bold', 'position', [460 10 520 460], 'ColumnEditable', false, 'ColumnName', [], 'RowName', [], ...
    'ColumnEditable', edittablelist, 'ColumnWidth', ColWidth, 'backgroundcolor', colorrow, 'foregroundcolor', [1 1 1]);
set(handles.tablePanning_conv, 'Units', 'normalized', 'units', 'normalized');
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------







%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------Other tools-------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%---Initialise
handles.sourceSlider = 0;
handles.feefoffpanningVal_single = [];
handles.feefoff4KVal_single = [];
handles.path4Kfile_single = [];
handles.pathPanningfile_single = [];
handles.activeVideo_single = [];

handles.pathScreenfile_screen = [];
handles.trimInVal_screen = [];
handles.trimOutVal_screen = [];

handles.pathRelayfile_relay = [];
handles.feetoffVal_relay = [];
handles.trimOutVal_relay = [];
handles.RTVal_relay = [];

handles.pathLeftfile_stitching = [];
handles.pathRightfile_stitching = [];
handles.ptDLTLeft = NaN(50,4); %create 50 empty points
handles.ptDLTRight = NaN(50,4); %create 50 empty points
handles.ptStitchingLeft = zeros(50,2); %create 50 empty points
handles.ptStitchingRight = zeros(50,2); %create 50 empty points
handles.trimInValLeft_stitching = [];
handles.trimOutValLeft_stitching = [];
handles.trimInValRight_stitching = [];
handles.trimOutValRight_stitching = [];


%---Create panel
handles.otherPanel_other = uipanel('parent', handles.hf_w1_welcome, 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 5, 990, 480], 'BackgroundColor', [0.2 0.2 0.2], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.7 0.7 0.7], ...
    'bordertype', 'etchedin');
set(handles.otherPanel_other, 'fontunits', 'normalized', 'units', 'normalized');





%-----------------------------single file button---------------------------
handles.singlePanning_button_other = uicontrol('parent', handles.otherPanel_other, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 420, 130, 30], 'callback', @create_singlePanning_other, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Re-sync panning');
set(handles.singlePanning_button_other, 'fontunits', 'normalized', 'units', 'normalized');


%---Create panel Single file
handles.singleFilePanel_single = uipanel('parent', handles.otherPanel_other, 'Visible', 'off', 'units', 'pixels', ...
    'position', [150, 5, 835, 470], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.6 0.6 0.6], ...
    'bordertype', 'etchedin');
set(handles.singleFilePanel_single, 'fontunits', 'normalized', 'units', 'normalized');

%---Load panning file
handles.selecttxtPanning_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select a panning file:', 'position', [5, 440, 150, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxtPanning_single, 'fontunits', 'normalized', 'units', 'normalized');

handles.filenamePanning_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [155, 440, 240, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filenamePanning_single, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelectPanning_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [400, 440, 25, 25], 'callback', @pushSelectPanning_single, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelectPanning_single, 'fontunits', 'normalized', 'units', 'normalized');

%---Load 4K file
handles.selecttxt4K_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select a 4K file:', 'position', [440, 440, 110, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxt4K_single, 'fontunits', 'normalized', 'units', 'normalized');

handles.filename4K_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [550, 440, 240, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filename4K_single, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelect4K_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [795, 440, 25, 25], 'callback', @pushSelect4K_single, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelect4K_single, 'fontunits', 'normalized', 'units', 'normalized');


%---Register frames
handles.registerfeetoffPanningPush_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 412, 130, 25], 'enable', 'off', ...
    'String', 'Register Panning', 'callback', @registerfeetoffPanningPush_single, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.registerfeetoffPanningPush_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the feet off frame for the panning video');

handles.registerfeetoffPanningEdit_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [145, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @registerfeetoffPanningEdit_single, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.registerfeetoffPanningEdit_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the feet off frame for the panning video');

handles.registerfeetoff4KPush_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [240, 412, 130, 25], 'enable', 'off', ...
    'String', 'Register 4K', 'callback', @registerfeetoff4KPush_single, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.registerfeetoff4KPush_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the feet off frame for the 4K video');

handles.registerfeetoff4KEdit_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [375, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @registerfeetoff4KEdit_single, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.registerfeetoff4KEdit_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the feet off frame for the 4K video');


%---Compression setting
handles.txtCompression_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [460, 408, 120, 25], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3, ...
    'String', 'Bitrate (Mbits/s):');
set(handles.txtCompression_single, 'fontunits', 'normalized', 'units', 'normalized');

if ismac == 1;
    handles.popCompression_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [580, 405, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_single);
elseif ispc == 1;
    handles.popCompression_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [580, 412, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_single);
end;
set(handles.popCompression_single, 'fontunits', 'normalized', 'units', 'normalized');


%---Start processing
handles.startProcessing_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [750, 412, 25, 25], 'callback', @startProcessing_single, 'cdata', imresize(handles.icones.play_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.startProcessing_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Start processing');


%---Cancel processing
handles.cancelProcessing_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [780, 412, 25, 25], 'callback', @cancelProcessing_single, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.cancelProcessing_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Reset session');

%---Progress bar
handles.txtProgress_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 392, 820, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0 1 0], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3-1, ...
    'String', '');
set(handles.txtProgress_single, 'fontunits', 'normalized', 'units', 'normalized');


%---Player
handles.mainVideoPanning_single = axes('parent', handles.singleFilePanel_single, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
set(handles.mainVideoPanning_single, 'units', 'normalized', 'units', 'normalized');

handles.mainVideo4K_single = axes('parent', handles.singleFilePanel_single, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
set(handles.mainVideo4K_single, 'units', 'normalized', 'units', 'normalized');



%---player slider
posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControl_push_singlePanning = controllib.widget.Slider(handles.singleFilePanel_single, posSlider, [1:20]);
handles.sliderControl_push_singlePanning.Value = 1;
handles.sliderControl_push_singlePanning.FontSize = 1;
addlistener(handles.sliderControl_push_singlePanning, 'ValueChanged', @sliderControl_push_single);
handles.sliderControl_push_singlePanningPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];

posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControl_push_single4K = controllib.widget.Slider(handles.singleFilePanel_single, posSlider, [1:20]);
handles.sliderControl_push_single4K.Value = 1;
handles.sliderControl_push_single4K.FontSize = 1;
addlistener(handles.sliderControl_push_single4K, 'ValueChanged', @sliderControl_push_single);
handles.sliderControl_push_single4KPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];


%---Previous chap player button
handles.prevChapControl_push_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 30, 30], 'callback', @prevChapControl_push_single, 'cdata', imresize(handles.icones.prevChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevChapControl_push_single, 'fontunits', 'normalized', 'units', 'normalized');

%---Previous frame player button
handles.prevFrameControl_push_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [35, 5, 30, 30], 'callback', @prevFrameControl_push_single, 'cdata', imresize(handles.icones.prevFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevFrameControl_push_single, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Frame player button
handles.nextFrameControl_push_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [65, 5, 30, 30], 'callback', @nextFrameControl_push_single, 'cdata', imresize(handles.icones.nextFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextFrameControl_push_single, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Chap player button
handles.nextChap_push_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 30, 30], 'callback', @nextChap_push_single, 'cdata', imresize(handles.icones.nextChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextChap_push_single, 'fontunits', 'normalized', 'units', 'normalized');

%---text frame count
handles.frameCount_TXT_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [150, 10, 200, 20], ...
    'String', 'Frame =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frameCount_TXT_single, 'fontunits', 'normalized', 'units', 'normalized');

%---text time count
handles.timeCount_TXT_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [360, 10, 200, 20], ...
    'String', 'Time =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.timeCount_TXT_single, 'fontunits', 'normalized', 'units', 'normalized');

%---swap videos button
handles.swapVid_push_single = uicontrol('parent', handles.singleFilePanel_single, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [790, 5, 30, 30], 'callback', @swapVid_push_single, 'cdata', imresize(handles.icones.swapVideo, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.swapVid_push_single, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Swap videos');
%--------------------------------------------------------------------------






%---------------------------------Relay button-----------------------------
handles.relayPanning_button_other = uicontrol('parent', handles.otherPanel_other, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 380, 130, 30], 'callback', @create_relayPanning_other, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Trim Relay');
set(handles.relayPanning_button_other, 'fontunits', 'normalized', 'units', 'normalized');


%---Create panel screen file
handles.relayPanel_relay = uipanel('parent', handles.otherPanel_other, 'Visible', 'off', 'units', 'pixels', ...
    'position', [150, 5, 835, 470], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.6 0.6 0.6], ...
    'bordertype', 'etchedin');
set(handles.relayPanel_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---Load panning file
handles.selecttxtRelay_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select a file:', 'position', [5, 440, 150, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxtRelay_relay, 'fontunits', 'normalized', 'units', 'normalized');

handles.filenameRelay_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [155, 440, 640, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filenameRelay_relay, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelectRelay_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [795, 440, 25, 25], 'callback', @pushSelectRelay_relay, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelectRelay_relay, 'fontunits', 'normalized', 'units', 'normalized');


%---feet off frame
handles.feetOffRelayPush_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 412, 100, 25], 'enable', 'off', ...
    'String', 'Feet off', 'callback', @feetOffRelayPush_relay, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.feetOffRelayPush_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the feet off frame');

handles.feetOffRelayEdit_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [115, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @feetOffRelayEdit_relay, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.feetOffRelayEdit_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the feet off frame');

handles.trimOutRelayPush_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [190, 412, 100, 25], 'enable', 'off', ...
    'String', 'Cut Out', 'callback', @trimOutRelayPush_relay, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.trimOutRelayPush_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the cut out frame');

handles.trimOutRelayEdit_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [295, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @trimOutRelayEdit_relay, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.trimOutRelayEdit_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut out frame');

%---RT
handles.RTtxtRelay_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'RT (s) :', 'position', [360, 410, 55, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.RTtxtRelay_relay, 'fontunits', 'normalized', 'units', 'normalized');

handles.RTEditRelay_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [415, 412, 40, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @RTEditRelay_relay, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.RTEditRelay_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut out frame');



%---Compression setting
handles.txtCompression_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [465, 408, 120, 25], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3, ...
    'String', 'Bitrate (Mbits/s):');
set(handles.txtCompression_relay, 'fontunits', 'normalized', 'units', 'normalized');

if ismac == 1;
    handles.popCompression_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [585, 412, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_relay);
elseif ispc == 1;
    handles.popCompression_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [585, 412, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_relay);
end;
set(handles.popCompression_relay, 'fontunits', 'normalized', 'units', 'normalized');


%---Start processing
handles.startProcessing_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [750, 412, 25, 25], 'callback', @startProcessing_relay, 'cdata', imresize(handles.icones.play_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.startProcessing_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Start processing');


%---Cancel processing
handles.cancelProcessing_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [780, 412, 25, 25], 'callback', @cancelProcessing_relay, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.cancelProcessing_relay, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Reset session');

%---Progress bar
handles.txtProgress_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 392, 820, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0 1 0], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3-1, ...
    'String', '');
set(handles.txtProgress_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---Player
handles.mainVideoRelay_relay = axes('parent', handles.relayPanel_relay, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
set(handles.mainVideoRelay_relay, 'units', 'normalized', 'units', 'normalized');

% handles.mainVideo4K_single = axes('parent', handles.singleFilePanel_single, 'units', 'pixels', ...
%     'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
%     'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
% set(handles.mainVideo4K_single, 'units', 'normalized', 'units', 'normalized');



%---player slider
posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControl_push_relay = controllib.widget.Slider(handles.relayPanel_relay, posSlider, [1:20]);
handles.sliderControl_push_relay.Value = 1;
handles.sliderControl_push_relay.FontSize = 1;
addlistener(handles.sliderControl_push_relay, 'ValueChanged', @sliderControl_push_single);
handles.sliderControl_push_relayPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];

%---Previous chap player button
handles.prevChapControl_push_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 30, 30], 'callback', @prevChapControl_push_single, 'cdata', imresize(handles.icones.prevChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevChapControl_push_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---Previous frame player button
handles.prevFrameControl_push_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [35, 5, 30, 30], 'callback', @prevFrameControl_push_single, 'cdata', imresize(handles.icones.prevFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevFrameControl_push_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Frame player button
handles.nextFrameControl_push_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [65, 5, 30, 30], 'callback', @nextFrameControl_push_single, 'cdata', imresize(handles.icones.nextFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextFrameControl_push_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Chap player button
handles.nextChap_push_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 30, 30], 'callback', @nextChap_push_single, 'cdata', imresize(handles.icones.nextChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextChap_push_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---text frame count
handles.frameCount_TXT_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [150, 10, 200, 20], ...
    'String', 'Frame =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frameCount_TXT_relay, 'fontunits', 'normalized', 'units', 'normalized');

%---text time count
handles.timeCount_TXT_relay = uicontrol('parent', handles.relayPanel_relay, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [360, 10, 200, 20], ...
    'String', 'Time =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.timeCount_TXT_relay, 'fontunits', 'normalized', 'units', 'normalized');
%--------------------------------------------------------------------------





%--------------------------------screen button-----------------------------
handles.screen4K_button_other = uicontrol('parent', handles.otherPanel_other, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 340, 130, 30], 'callback', @create_screen_other, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Convert 4K');
set(handles.screen4K_button_other, 'fontunits', 'normalized', 'units', 'normalized');


%---Create panel screen file
handles.screenPanel_screen = uipanel('parent', handles.otherPanel_other, 'Visible', 'off', 'units', 'pixels', ...
    'position', [150, 5, 835, 470], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.6 0.6 0.6], ...
    'bordertype', 'etchedin');
set(handles.screenPanel_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---Load panning file
handles.selecttxtScreen_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select a file:', 'position', [5, 440, 150, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxtScreen_screen, 'fontunits', 'normalized', 'units', 'normalized');

handles.filenameScreen_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [155, 440, 640, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filenameScreen_screen, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelectScreen_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [795, 440, 25, 25], 'callback', @pushSelectScreen_screen, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelectScreen_screen, 'fontunits', 'normalized', 'units', 'normalized');




%---Trim frames
handles.trimInScreenPush_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 412, 130, 25], 'enable', 'off', ...
    'String', 'Cut In', 'callback', @trimInScreenPush_screen, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.trimInScreenPush_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the cut in frame');

handles.trimInScreenEdit_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [145, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @trimInScreenEdit_screen, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.trimInScreenEdit_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

handles.trimOutScreenPush_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [215, 412, 130, 25], 'enable', 'off', ...
    'String', 'Cut Out', 'callback', @trimOutScreenPush_screen, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.trimOutScreenPush_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the cut out frame');

handles.trimOutScreenEdit_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [350, 412, 60, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @trimOutScreenEdit_screen, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.trimOutScreenEdit_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut out frame');


%---Compression setting
handles.txtCompression_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [420, 408, 120, 25], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3, ...
    'String', 'Bitrate (Mbits/s):');
set(handles.txtCompression_screen, 'fontunits', 'normalized', 'units', 'normalized');

if ismac == 1;
    handles.popCompression_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [540, 412, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_screen);
elseif ispc == 1;
    handles.popCompression_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [540, 412, 150, 25], 'enable', 'off', ...
        'String', 'Not available', 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0 0], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3, 'Callback', @popCompression_screen);
end;
set(handles.popCompression_screen, 'fontunits', 'normalized', 'units', 'normalized');


%---Advance setting
handles.advancedSetting_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [700, 412, 50, 25], 'callback', @advancedSettingConvert_screen, 'cdata', imresize(handles.icones.properties_offb, [25 25]), ...
    'BackgroundColor', [0.55 0.55 0.55], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.advancedSetting_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Advanced settings');




%---Start processing
handles.startProcessing_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [770, 412, 25, 25], 'callback', @startProcessing_screen, 'cdata', imresize(handles.icones.play_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.startProcessing_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Start processing');


%---Cancel processing
handles.cancelProcessing_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [800, 412, 25, 25], 'callback', @cancelProcessing_screen, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.cancelProcessing_screen, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Reset session');

%---Progress bar
handles.txtProgress_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 392, 820, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0 1 0], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3-1, ...
    'String', '');
set(handles.txtProgress_screen, 'fontunits', 'normalized', 'units', 'normalized');


%---Player
handles.mainVideoScreen_screen = axes('parent', handles.screenPanel_screen, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
set(handles.mainVideoScreen_screen, 'units', 'normalized', 'units', 'normalized');

% handles.mainVideo4K_single = axes('parent', handles.singleFilePanel_single, 'units', 'pixels', ...
%     'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
%     'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
% set(handles.mainVideo4K_single, 'units', 'normalized', 'units', 'normalized');



%---player slider
posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControl_push_screen = controllib.widget.Slider(handles.screenPanel_screen, posSlider, [1:20]);
handles.sliderControl_push_screen.Value = 1;
handles.sliderControl_push_screen.FontSize = 1;
addlistener(handles.sliderControl_push_screen, 'ValueChanged', @sliderControl_push_single);
handles.sliderControl_push_screenPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];

%---Previous chap player button
handles.prevChapControl_push_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 30, 30], 'callback', @prevChapControl_push_single, 'cdata', imresize(handles.icones.prevChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevChapControl_push_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---Previous frame player button
handles.prevFrameControl_push_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [35, 5, 30, 30], 'callback', @prevFrameControl_push_single, 'cdata', imresize(handles.icones.prevFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevFrameControl_push_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Frame player button
handles.nextFrameControl_push_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [65, 5, 30, 30], 'callback', @nextFrameControl_push_single, 'cdata', imresize(handles.icones.nextFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextFrameControl_push_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Chap player button
handles.nextChap_push_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 30, 30], 'callback', @nextChap_push_single, 'cdata', imresize(handles.icones.nextChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextChap_push_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---text frame count
handles.frameCount_TXT_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [150, 10, 200, 20], ...
    'String', 'Frame =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frameCount_TXT_screen, 'fontunits', 'normalized', 'units', 'normalized');

%---text time count
handles.timeCount_TXT_screen = uicontrol('parent', handles.screenPanel_screen, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [360, 10, 200, 20], ...
    'String', 'Time =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.timeCount_TXT_screen, 'fontunits', 'normalized', 'units', 'normalized');
%--------------------------------------------------------------------------





%-----------------------------stitching button-----------------------------
handles.stitching4K_button_other = uicontrol('parent', handles.otherPanel_other, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 300, 130, 30], 'callback', @create_stitching_other, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', 'Create 4K stitch');
set(handles.stitching4K_button_other, 'fontunits', 'normalized', 'units', 'normalized');


%---Create panel stichting file
handles.stitchingPanel_stiching = uipanel('parent', handles.otherPanel_other, 'Visible', 'off', 'units', 'pixels', ...
    'position', [150, 5, 835, 470], 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'ShadowColor', [0.6 0.6 0.6], ...
    'bordertype', 'etchedin');
set(handles.stitchingPanel_stiching, 'fontunits', 'normalized', 'units', 'normalized');


%---Load left file
handles.selecttxtLeftvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select left side file:', 'position', [0, 438, 150, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxtLeftvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.filenameLeftvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [145, 440, 230, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filenameLeftvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelectLeftvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [380, 440, 25, 25], 'callback', @pushSelectLeftVid_stitching, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelectLeftvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---Load right file
handles.selecttxtRightvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', 'Select right side file:', 'position', [405, 438, 160, 25], ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.selecttxtRightvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.filenameRightvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'String', '', 'position', [565, 440, 230, 25], ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'left');
set(handles.filenameRightvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.pushSelectRightvid_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [805, 440, 25, 25], 'callback', @pushSelectRightVid_stitching, 'cdata', imresize(handles.icones.import_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'center');
set(handles.pushSelectRightvid_stitching, 'fontunits', 'normalized', 'units', 'normalized');



%---Define pairing points
handles.selectptStithcing_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 412, 55, 20], ...
    'String', 'Pairing:', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.selectptStithcing_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');


%Select point dropdow
listPointStitch{1,1} = 'Auto';
for ptEC = 1:50;
    textEC = ['Pt ' num2str(ptEC)];
    eval(['listPointStitch{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
end;
if ismac == 1;
    handles.selectPtStitching_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [60, 410, 75, 25], 'Callback', @popSelectPtStich_stichting, 'enable', 'off', ...
        'String', listPointStitch, 'ForegroundColor', [0.1 0.1 0.1], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
elseif ispc == 1;
    handles.selectPtStitching_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [60, 410, 75, 25], 'Callback', @popSelectPtStich_stichting, 'enable', 'off', ...
        'String', listPointStitch, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0.1 0.1 0.1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
end;
set(handles.selectPtStitching_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%Delete point
handles.erasePtStitch_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [138, 412, 25, 25], 'callback', @erasePtStitch_stitching, 'cdata', imresize(handles.icones.eraser_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.erasePtStitch_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Delete point');



%---Define DLT points
handles.selectDLTpt_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [190, 412, 50, 20], ...
    'String', 'Ref pts:', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.selectDLTpt_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%list
istPointDLT{1,1} = '';
for ptEC = 1:50;
    textEC = ['Pt ' num2str(ptEC)];
    eval(['listPointDLT{' num2str(ptEC+1) ',1} = ' '''' textEC '''' ';']);
end;
if ismac == 1;
    handles.selectPtDLT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [240, 410, 60, 25], 'Callback', @popSelectPtDLT_stichting, 'enable', 'off', ...
        'String', listPointDLT, 'ForegroundColor', [0.1 0.1 0.1], 'BackgroundColor', [1 1 1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
elseif ispc == 1;
    handles.selectPtDLT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Popupmenu', 'Visible', 'on', ...
        'units', 'pixels', 'position', [240, 410, 60, 25], 'Callback', @popSelectPtDLT_stichting, 'enable', 'off', ...
        'String', listPointDLT, 'ForegroundColor', [1 1 1], 'BackgroundColor', [0.1 0.1 0.1], ...
        'FontName', 'Book Antiqua', 'FontWeight', 'Bold', 'Fontsize', font3);
end;
set(handles.selectPtDLT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%x and y coordinates boxes
handles.selectDLTcoorX_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [302, 412, 15, 20], ...
    'String', 'x:', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.selectDLTcoorX_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.selectDLTcoorX_EDIT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [320, 412, 30, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @coorXDLT_stitching, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.selectDLTcoorX_EDIT_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

handles.selectDLTcoorY_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [352, 412, 15, 20], ...
    'String', 'y:', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.selectDLTcoorY_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

handles.selectDLTcoorY_EDIT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [365, 412, 30, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @coorYDLT_stitching, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.selectDLTcoorY_EDIT_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

%Delete dlt pt
handles.erasePtDLT_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [400, 412, 25, 25], 'callback', @erasePtDLT_stitching, 'cdata', imresize(handles.icones.eraser_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.erasePtDLT_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Delete point');

% %save dlt pt
% handles.savePtDLT_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
%     'position', [246, 412, 25, 25], 'callback', @saveStitchDLT_stitching, 'cdata', imresize(handles.icones.save_offb, [25 25]), 'enable', 'off', ...
%     'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
% set(handles.savePtDLT_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Save stitching data');
% 
% %Load dlt pt
% handles.loadPtDLT_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
%     'position', [273, 412, 25, 25], 'callback', @loadStitchDLT_stitching, 'cdata', imresize(handles.icones.import_offb, [25 25]), 'enable', 'off', ...
%     'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
% set(handles.loadPtDLT_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Load stitching data');



%---Trim frames
handles.trimInScreenPush_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [455, 412, 60, 25], 'enable', 'off', ...
    'String', 'Cut In', 'callback', @trimInScreenPush_stitching, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.trimInScreenPush_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the cut in frame');

handles.trimInScreenEdit_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [517, 412, 40, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @trimInScreenEdit_stitching, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.trimInScreenEdit_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut if frame');

handles.trimOutScreenPush_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [560, 412, 60, 25], 'enable', 'off', ...
    'String', 'Cut Out', 'callback', @trimOutScreenPush_stitching, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.trimOutScreenPush_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Click to register the cut out frame');

handles.trimOutScreenEdit_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Edit', 'Visible', 'on', 'units', 'pixels', ...
    'position', [622, 412, 40, 25], 'enable', 'off', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'callback', @trimOutScreenEdit_stitching, 'String', '', ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'Center');
set(handles.trimOutScreenEdit_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Enter frame to register the cut out frame');



%Save cal stitching
handles.saveCalStitch_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [694, 412, 25, 25], 'callback', @saveStitchCal_stitching, 'cdata', imresize(handles.icones.save_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.saveCalStitch_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Save stitching data');

%Load cal stitching
handles.loadCalStitch_stiching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [721, 412, 25, 25], 'callback', @loadStitchCal_stitching, 'cdata', imresize(handles.icones.import_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.loadCalStitch_stiching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Load stitching data');


%---preview stitching
handles.previewStitch_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [748, 412, 25, 25], 'callback', @previewStitch_stitching, 'cdata', imresize(handles.icones.preview_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.previewStitch_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Preview');


%---Start processing
handles.startProcessing_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [775, 412, 25, 25], 'callback', @startProcessing_stitching, 'cdata', imresize(handles.icones.play_offb, [25 25]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.startProcessing_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Start processing');


%---delete all
handles.cancelProcessing_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Pushbutton', 'Visible', 'on', 'units', 'pixels', ...
    'position', [803, 412, 25, 25], 'callback', @cancelProcessing_stitching, 'cdata', imresize(handles.icones.redcross_offb, [25 25]), 'enable', 'off', ...
    'BackgroundColor', [0.26 0.26 0.26], 'ForegroundColor', [0.26 0.26 0.26], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'String', '');
set(handles.cancelProcessing_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Delete all');


%---Progress bar
handles.txtProgress_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'off', 'units', 'pixels', ...
    'position', [5, 392, 820, 20], 'HorizontalAlignment', 'left', ...
    'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [0 1 0], 'FontName', 'Book Antiqua', 'FontAngle', 'Italic', ...
    'FontWeight', 'Bold', 'Fontsize', font3-1, ...
    'String', '');
set(handles.txtProgress_stitching, 'fontunits', 'normalized', 'units', 'normalized');


%---Player
handles.mainLeftVideo_stitching = axes('parent', handles.stitchingPanel_stiching, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'on');
set(handles.mainLeftVideo_stitching, 'units', 'normalized', 'units', 'normalized');

handles.mainRightVideo_stitching = axes('parent', handles.stitchingPanel_stiching, 'units', 'pixels', ...
    'Position', [5, 50, 820, 340], 'color', [0 0 0], ...
    'Xcolor', [0.1 0.1 0.1], 'XTick', [], 'Ycolor', [0.1 0.1 0.1], 'YTick', [], 'Visible', 'off');
set(handles.mainRightVideo_stitching, 'units', 'normalized', 'units', 'normalized');


%---player slider
posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControlLeft_push_stitching = controllib.widget.Slider(handles.stitchingPanel_stiching, posSlider, [1:20]);
handles.sliderControlLeft_push_stitching.Value = 1;
handles.sliderControlLeft_push_stitching.FontSize = 1;
addlistener(handles.sliderControlLeft_push_stitching, 'ValueChanged', @sliderControl_push_single);
handles.sliderControlLeft_push_stitchingPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];

posWindow = get(gcf, 'Position');
posSlider = [5, 25, 820, 40];
handles.sliderControlRight_push_stitching = controllib.widget.Slider(handles.stitchingPanel_stiching, posSlider, [1:20]);
handles.sliderControlRight_push_stitching.Value = 1;
handles.sliderControlRight_push_stitching.FontSize = 1;
addlistener(handles.sliderControlRight_push_stitching, 'ValueChanged', @sliderControl_push_single);
handles.sliderControlRight_push_stitchingPositionNorm = [posSlider(1)./posWindow(3) posSlider(2)./posWindow(4) posSlider(3)./posWindow(3) posSlider(4)./posWindow(4)];


%---Previous chap player button
handles.prevChapControl_push_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [5, 5, 30, 30], 'callback', @prevChapControl_push_single, 'cdata', imresize(handles.icones.prevChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevChapControl_push_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---Previous frame player button
handles.prevFrameControl_push_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [35, 5, 30, 30], 'callback', @prevFrameControl_push_single, 'cdata', imresize(handles.icones.prevFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.prevFrameControl_push_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Frame player button
handles.nextFrameControl_push_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [65, 5, 30, 30], 'callback', @nextFrameControl_push_single, 'cdata', imresize(handles.icones.nextFramePlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextFrameControl_push_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---Next Chap player button
handles.nextChapControl_push_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [95, 5, 30, 30], 'callback', @nextChap_push_single, 'cdata', imresize(handles.icones.nextChapPlayer, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.nextChapControl_push_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---text frame count
handles.frameCount_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [150, 10, 200, 20], ...
    'String', 'Frame =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.frameCount_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---text time count
handles.timeCount_TXT_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [360, 10, 200, 20], ...
    'String', 'Time =      /     ', 'BackgroundColor', [0.1 0.1 0.1], 'ForegroundColor', [1 1 1], ...
    'FontName', 'Book Antiqua', 'FontAngle', 'Italic', 'FontWeight', 'Normal', 'Fontsize', font3, 'HorizontalAlignment', 'Left');
set(handles.timeCount_TXT_stitching, 'fontunits', 'normalized', 'units', 'normalized');

%---swap videos button
handles.swapVid_push_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
    'position', [790, 5, 30, 30], 'callback', @swapVid_push_stitching, 'cdata', imresize(handles.icones.swapVideo, [30 30]), ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.swapVid_push_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Swap videos');

% %---load lens correction button
% handles.loadFisheye_stitching = uicontrol('parent', handles.stitchingPanel_stiching, 'Style', 'Push', 'Visible', 'on', 'units', 'pixels', ...
%     'position', [755, 5, 30, 30], 'callback', @loadFisheye_stitching, 'cdata', imresize(handles.icones.fisheye_offb, [30 30]), ...
%     'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', 'enable', 'off', ...
%     'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
% set(handles.loadFisheye_stitching, 'fontunits', 'normalized', 'units', 'normalized', 'tooltipstring', 'Load image correction');


%---Create pairing stitching points
for ptStitching = 1:50; %left vid axes
    axes(handles.mainLeftVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles.markerDispLeftP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;
for ptStitching = 1:50; %Right vid axes
    axes(handles.mainRightVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 0], 'EdgeColor', [1 0 0], 'Visible', 'off');
    eval(['handles.markerDispRightP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;

%---Create DLT stitching points
for ptStitching = 1:50; %left vid axes
    axes(handles.mainLeftVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
    eval(['handles.markerDLTLeftP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;
for ptStitching = 1:50; %Right vid axes
    axes(handles.mainRightVideo_stitching); hold on;
    p = nsidedpoly(10, 'Center', [5 5], 'Radius', 10);
    circle = plot(p, 'FaceColor', [1 0 1], 'EdgeColor', [1 0 1], 'Visible', 'off');
    eval(['handles.markerDLTRightP' num2str(ptStitching) ' = circle;']);
    clear circle;
end;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%---------------------------reset the units--------------------------------
set(handles.logo_aargos_main, 'units', 'normalized');
set(handles.logo_sa_main, 'units', 'normalized');
%--------------------------------------------------------------------------



%-------------------------------Save data----------------------------------
handles.FigPos = get(handles.hf_w1_welcome, 'position');
set(handles.hf_w1_welcome, 'units', 'Normalized');
guidata(handles.hf_w1_welcome, handles);
%--------------------------------------------------------------------------


% close(hlaunch);
