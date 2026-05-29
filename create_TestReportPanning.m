if ismac == 1;
    font1 = 12;
    font2 = 16;
    font3 = 15;
elseif ispc == 1;
    font1 = 8;
    font2 = 12;
    font3 = 11;
end;

pos = [(resolution(1)-500)./2 (resolution(2)-200)./2 500 180];
handles.hf_w2_welcome = figure('visible', 'on', 'menubar', 'none', 'toolbar', 'none', ...
    'windowstyle', 'normal', 'color', [0 0 0], 'units', 'pixels', 'position', pos);
set(handles.hf_w2_welcome, 'Name', 'Test Report', 'NumberTitle', 'off');
if ispc == 1;
    jFrame = get(handle(handles.hf_w2_welcome), 'javaframe');
    jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
    jFrame.setFigureIcon(jicon);
    clc;
end;

handles.txtTitleIni_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [10, 160, 245, 20], 'String', 'From:', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'HorizontalAlignment', 'Left');
set(handles.txtTitleIni_main, 'fontunits', 'normalized');

txt = handles.inputfolderPanning;
li = strfind(txt, '/');
if isempty(li) == 1;
    txt2 = txt;
else;
    if length(li) >= 3;
        txt2 = ['Path:  ' txt(1:li(2)) ' ... ' txt(li(end):end)];
    else;
        txt2 = ['Path:  ' txt(li(end):end)];
    end;
end;
handles.txtfileIni1_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 130, 230, 20], 'String', txt2, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni1_main, 'fontunits', 'normalized', 'tooltip', txt);

txt = ['File:  ' fileEC];
handles.txtfileIni2_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 110, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni2_main, 'fontunits', 'normalized');
posExtent = get(handles.txtfileIni2_main, 'Extent');
posReal = get(handles.txtfileIni2_main, 'Position');
if posExtent(3) >= posReal(3);
    li = strfind(txt, '_');
    txtmod = [txt(1:li(1)-1) ' ... ' txt(end-8:end)];
    set(handles.txtfileIni2_main, 'String', txtmod, 'tooltip', txt);
end;

txt = ['Compression:  ---'];
handles.txtfileIni3_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 90, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni3_main, 'fontunits', 'normalized');

txt = ['Duration:  ---'];
handles.txtfileIni4_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 70, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni4_main, 'fontunits', 'normalized');

txt = ['Frame Rate:  ---'];
handles.txtfileIni5_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 50, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni5_main, 'fontunits', 'normalized');

txt = ['Resolution:  ---' ];
handles.txtfileIni6_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [30, 30, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileIni6_main, 'fontunits', 'normalized');



handles.txtTitleEnd_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [260, 160, 245, 20], 'String', 'To:', ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font2, 'HorizontalAlignment', 'Left');
set(handles.txtTitleEnd_main, 'fontunits', 'normalized');

txt = handles.outputfolderPanning;
li = strfind(txt, '/');
if isempty(li) == 1;
    txt2 = txt;
else;
    if length(li) >= 3;
        txt2 = ['Path:  ' txt(1:li(2)) ' ... ' txt(li(end):end)];
    else;
        txt2 = ['Path:  ' txt(li(end):end)];
    end;
end;
handles.txtfileEnd1_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 130, 230, 20], 'String', txt2, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd1_main, 'fontunits', 'normalized', 'tooltip', txt);

txt = ['File:  ' fileOut];
handles.txtfileEnd2_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 110, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd2_main, 'fontunits', 'normalized');
posExtent = get(handles.txtfileEnd2_main, 'Extent');
posReal = get(handles.txtfileEnd2_main, 'Position');
if posExtent(3) >= posReal(3);
    li = strfind(txt, '_');
    txtmod = [txt(1:li(1)-1) ' ... ' txt(end-8:end)];
    set(handles.txtfileEnd2_main, 'String', txtmod, 'tooltip', txt);
end;

txt = ['Compression:  ---' ];
handles.txtfileEnd3_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 90, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd3_main, 'fontunits', 'normalized');

txt = ['Duration:  ---' ];
handles.txtfileEnd4_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 70, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd4_main, 'fontunits', 'normalized');

txt = ['Frame Rate:  ---' ];
handles.txtfileEnd5_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 50, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd5_main, 'fontunits', 'normalized');

txt = ['Resolution:  ---' ];
handles.txtfileEnd6_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [280, 30, 230, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font1, 'HorizontalAlignment', 'Left');
set(handles.txtfileEnd6_main, 'fontunits', 'normalized');



txt = ['Status:  Processing'];
handles.txtProcessing_main = uicontrol('parent', handles.hf_w2_welcome, 'Style', 'Text', 'Visible', 'on', 'units', 'pixels', ...
    'position', [1, 5, 500, 20], 'String', txt, ...
    'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'FontName', 'Book Antiqua', ...
    'FontAngle', 'Italic', 'FontWeight', 'Bold', 'Fontsize', font3, 'HorizontalAlignment', 'center');
set(handles.txtProcessing_main, 'fontunits', 'normalized');

drawnow;