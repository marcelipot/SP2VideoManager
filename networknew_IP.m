function [] = networknew_IP(varargin);


handles2 = guidata(gcf);
if get(handles2.createnetworkcheck_main, 'value') == 1;
    %Turned on
    set(handles2.IPv1edit_main, 'enable', 'on');
    set(handles2.IPv2edit_main, 'enable', 'on');
    set(handles2.IPv3edit_main, 'enable', 'on');
    set(handles2.Usernameedit_main, 'enable', 'on');
    set(handles2.Passwordedit_main, 'enable', 'on');
    set(handles2.Volumeedit_main, 'enable', 'on');

else;
    %Turned off
    set(handles2.IPv1edit_main, 'enable', 'off');
    set(handles2.IPv2edit_main, 'enable', 'off');
    set(handles2.IPv3edit_main, 'enable', 'off');
    set(handles2.Usernameedit_main, 'enable', 'off');
    set(handles2.Passwordedit_main, 'enable', 'off');
    set(handles2.Volumeedit_main, 'enable', 'off');
end;


guidata(handles2.hf_w2_welcome, handles2);