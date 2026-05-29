function [] = saveStitchCal_stitching(varargin);


handles = guidata(gcf);

if isempty(handles.pathLeftfile_stitching) == 1 | isempty(handles.pathRightfile_stitching) == 1;
    return;
end;


if ispc == 1;
    MDIR = getenv('USERPROFILE');
elseif ismac == 1;
    MDIR = '/Applications';
end;


%---Save DLT points
ptDLT_validLeft = [];
countLeft = 0;
for lineEC = 1:50;
    ptECLeft = handles.ptDLTLeft(lineEC,:);
    if isnan(ptECLeft(1,1)) == 0 & isnan(ptECLeft(1,2)) == 0 ...
            & isnan(ptECLeft(1,3)) == 0 & isnan(ptECLeft(1,4)) == 0;
        ptDLT_validLeft = [ptDLT_validLeft; ptECLeft];
        countLeft = countLeft + 1;
    end;
end;
ptDLT_validRight = [];
countRight = 0;
for lineEC = 1:50;
    ptECRight = handles.ptDLTRight(lineEC,:);
    if isnan(ptECRight(1,1)) == 0 & isnan(ptECRight(1,2)) == 0 ...
            & isnan(ptECRight(1,3)) == 0 & isnan(ptECRight(1,4)) == 0;
        ptDLT_validRight = [ptDLT_validRight; ptECRight];
        countRight = countRight + 1;
    end;
end;

% if countLeft < 2;
%     if ispc == 1;
%         errorwindow = errordlg('Not enough valid DLT points on the left video', 'Error');
%         jFrame = get(handle(errorwindow), 'javaframe');
%         jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%         jFrame.setFigureIcon(jicon);
%         clc;
%         return;
%     elseif ismac == 1;
%         errordlg('Not enough valid DLT points on the left video', 'Error');
%         return;
%     end;
%     return;
% end;
% if countRight < 2;
%     if ispc == 1;
%         errorwindow = errordlg('Not enough valid DLT points on the right video', 'Error');
%         jFrame = get(handle(errorwindow), 'javaframe');
%         jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%         jFrame.setFigureIcon(jicon);
%         clc;
%         return;
%     elseif ismac == 1;
%         errordlg('Not enough valid DLT points on the right video', 'Error');
%         return;
%     end;
%     return;
% end;



ptStitching_valid = [];
for lineEC = 1:50;
    ptECLeft = handles.ptStitchingLeft(lineEC,:);
    ptECRight = handles.ptStitchingRight(lineEC,:);
    if ptECLeft(1,1) ~= 0 & ptECLeft(1,2) ~= 0 & ptECRight(1,1) ~= 0 & ptECRight(1,2) ~= 0;
        ptStitching_valid = [ptStitching_valid; [ptECLeft ptECRight]];
    end;
end;

% if isempty(ptStitching_valid) == 1;
%     if ispc == 1;
%         errorwindow = errordlg('Not enough valid pairs of points', 'Error');
%         jFrame = get(handle(errorwindow), 'javaframe');
%         jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%         jFrame.setFigureIcon(jicon);
%         clc;
%         return;
%     elseif ismac == 1;
%         errordlg('PNot enough valid pairs of points', 'Error');
%         return;
%     end;
%     return;
% else;
%     if length(ptStitching_valid(:,1)) < 20;
%         if ispc == 1;
%             errorwindow = errordlg('Not enough valid pairs of points', 'Error');
%             jFrame = get(handle(errorwindow), 'javaframe');
%             jicon = javax.swing.ImageIcon([MDIR '\SP2VideoManager\SpartaManager_IconSoftware.png']);
%             jFrame.setFigureIcon(jicon);
%             clc;
%             return;
%         elseif ismac == 1;
%             errordlg('PNot enough valid pairs of points', 'Error');
%             return;
%         end;
%         return;
%     end;
% end;

% FishEyeLeft = handles.VidInfoLeftStitching.FishEye;
% FishEyeRight = handles.VidInfoRightStitching.FishEye;

VidInfo = handles.VidInfo;
savedOutputStichingNormal = handles.savedOutputStichingNormal;
savedOutputStichingTop = handles.savedOutputStichingTop;

%---Select and load
[file,path] = uiputfile({'*.mat'},...
                      'Save your stitching parameters', handles.defaultpath);

if file == 0
    return;
end;
fileEC = [path file];    
save(fileEC, 'ptDLT_validLeft', 'ptDLT_validRight', 'ptStitching_valid', 'VidInfo', 'savedOutputStichingNormal', 'savedOutputStichingTop');


