function [] = closeguimain(varargin)


handles = guidata(gcf);

try;
    stop([handles.TimerScanFolder handles.TimerUpdatePanning handles.TimerUpdate4K]);
end;

if ismac == 1;
    command = ['rm /Applications/SP2VideoManager/Temp/*'];
    [status, cmdout] = system(command);
elseif ispc == 1;
    MDIR = getenv('USERPROFILE');
    command = ['del /Q ' MDIR '\SP2VideoManager\Temp\*'];
    [status, cmdout] = system(command);
end;

close all;
clc;