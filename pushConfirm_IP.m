function [] = pushConfirm_IP(varargin);

handles2 = guidata(gcf);
handles2.proceedIP = 1;

if get(handles2.createnetworkcheck_main, 'value') == 1;
    
    errorIP = 0;
    
    val = get(handles2.IPv1edit_main, 'String');
    if isempty(val) == 1;
        errorIP = 1;
    end;
    li = strfind(val, ',');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ';');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ' ');
    if isempty(li) == 0;
       errorIP = 1;
    end;
    valnum = str2num(val);
    if isempty(valnum) == 1;
        errorIP = 1;
    end;
    if valnum < 0;
        errorIP = 1;
    end;
    IP1 = valnum;
    
    val = get(handles2.IPv2edit_main, 'String');
    if isempty(val) == 1;
        errorIP = 1;
    end;
    li = strfind(val, ',');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ';');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ' ');
    if isempty(li) == 0;
       errorIP = 1;
    end;
    valnum = str2num(val);
    if isempty(valnum) == 1;
        errorIP = 1;
    end;
    if valnum < 0;
        errorIP = 1;
    end;
    IP2 = valnum;
    
    val = get(handles2.IPv3edit_main, 'String');
    if isempty(val) == 1;
        errorIP = 1;
    end;
    li = strfind(val, ',');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ';');
    if isempty(li) == 0;
        errorIP = 1;
    end;
    li = strfind(val, ' ');
    if isempty(li) == 0;
       errorIP = 1;
    end;
    valnum = str2num(val);
    if isempty(valnum) == 1;
        errorIP = 1;
    end;
    if valnum < 0;
        errorIP = 1;
    end;
    IP3 = valnum;
    
    MDIR = getenv('USERPROFILE');
    if errorIP == 0;
        IPaddress = [num2str(IP1) '.' num2str(IP2) '.' num2str(IP3)];
    else;
        errorwindow = errordlg('Incorrect IP Address', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
    
    username = get(handles2.Usernameedit_main, 'String');
    password = get(handles2.Passwordedit_main, 'String');
    volume = get(handles2.Volumeedit_main, 'String');
    
    if ispc == 1;
    %     net use * \\remotepc\share /u:domainname\username password
        command = ['net use * \\' IPaddress '\' volume '/u:' username ' ' password];
    elseif ismac == 1;
        command = ['mount_smbfs //' password ':' username '@' IPaddress '/' volume ' /Applications/SP2VideoManager/Mount'];
    end;
    [status, out] = system(command);
    if status ~= 0;
        errorwindow = errordlg('Impossible to connect', 'Error');
        if ispc == 1;
            jFrame = get(handle(errorwindow), 'javaframe');
            jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
            jFrame.setFigureIcon(jicon);
            clc;
        end;
        return;
    end;
    
else;
    if ismac == 1;
        load /Applications/SP2VideoManager/IPList.mat;
    elseif ispc == 1;
        MDIR = getenv('USERPROFILE');
        load([MDIR '\SP2VideoManager\IPList.mat']);
    end;
    
   IPaddress = IPlist{handles2.CurrentIP,1};
   username = IPlist{handles2.CurrentIP,2};
   password = IPlist{handles2.CurrentIP,3};
   volume = IPlist{handles2.CurrentIP,4};
   
   if ispc == 1;
       command = ['net use * \\' IPaddress '\' volume ' /u:' username ' ' password];
   elseif ismac == 1;
       command = ['mount_smbfs //' password ':' username '@' IPaddress '/' volume ' /Applications/SP2VideoManager/Mount'];
   end;
   [status, out] = system(command);

   if status ~= 0;
       if strfind(out, 'Multiple connection to a server') ~= 1;
            errorwindow = errordlg('Impossible to connect', 'Error');
            if ispc == 1;
                jFrame = get(handle(errorwindow), 'javaframe');
                jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
                jFrame.setFigureIcon(jicon);
                clc;
            end;
            return;
       end;
    end;
    
end;

handles2.IPlist = IPlist;
guidata(handles2.hf_w2_welcome, handles2);
uiresume(handles2.hf_w2_welcome);

