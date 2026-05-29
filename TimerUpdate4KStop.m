function [] = TimerUpdate4KStop(varargin);


handles = guidata(gcf);

if ismac == 1;
    command = ['rm /Applications/SP2VideoManager/Temp/*'];
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
end;
[status, cmdout] = system(command);