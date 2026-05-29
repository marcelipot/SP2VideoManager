function [] = validateUI_stitching(varargin);

handles2 = guidata(gcf);
guidata(handles2.hf_w2_advancedStitching, handles2);

uiresume(gcf);

guidata(handles2.hf_w2_advancedStitching, handles2);