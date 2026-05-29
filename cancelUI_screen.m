function [] = cancelUI_screen(varargin);


handles2 = [];
guidata(gcf, handles2);

uiresume(gcf);