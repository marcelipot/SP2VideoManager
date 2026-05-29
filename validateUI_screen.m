function [] = validateUI_screen(varargin);

handles2 = guidata(gcf);
guidata(handles2.hf_w2_advancedImage, handles2);

uiresume(gcf);

guidata(handles2.hf_w2_advancedImage, handles2);