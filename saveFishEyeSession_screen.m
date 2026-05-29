function saveFishEyeSession_screen(varargin);



handles2 = guidata(gcf);

%---------------------------load video-------------------------------------
VidInfo = handles2.VidInfo;
%--------------------------------------------------------------------------




%------------------------------------Save----------------------------------
[file,location] = uiputfile('*.mat','Save your session', handles2.defaultpath);

if file == 0;
    return;
end;

filename = [location file];
save(filename, 'VidInfo');
%--------------------------------------------------------------------------

