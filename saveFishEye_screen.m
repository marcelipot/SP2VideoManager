function [] = saveFishEye_screen(varargin);

handles2 = guidata(gcf);

if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;

filetosave = handles2.filetosave;

%---Select and load
[file,path] = uiputfile({'*.mat'},...
                      'Save your parameters', handles2.defaultpath);

if file == 0
    return;
end;
fileEC = [path file];    

save(fileEC, 'filetosave');
