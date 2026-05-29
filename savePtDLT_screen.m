function savePtDLT_screen(varargin);



handles2 = guidata(gcf);
VidInfo = handles2.VidInfo;
ptDLTAll = VidInfo.FishEye.ptDLTAll;

if isempty(VidInfo.FishEye) == 0;
    [file,location] = uiputfile('*.mat','Save your calibration points', handles2.defaultpath);

    if file == 0;
        return;
    end;
    
    filename = [location file];
    save(filename, 'ptDLTAll');
end;
