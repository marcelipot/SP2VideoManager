function [] = clickDLTStitching(varargin)

handles = guidata(gcf);


set(gcf, 'unit', 'pixels');
pt = get(gcf, 'CurrentPoint');

if handles.activeVideo_stitching == 1;
    VidInfo = handles.VidInfoLeftStitching;
    mainVideoAxe = handles.mainLeftVideo_stitching;
else;
    VidInfo = handles.VidInfoRightStitching;
    mainVideoAxe = handles.mainRightVideo_stitching;
end;
frame = VidInfo.ActiveFrame;

set(handles.otherPanel_other, 'units', 'pixels'); %Panel main
PpanelMain = get(handles.otherPanel_other, 'Position'); %Panel main
set(handles.otherPanel_other, 'units', 'normalized'); %Panel main
set(handles.stitchingPanel_stiching, 'units', 'pixels'); %Panel Sub
PpanelSub = get(handles.stitchingPanel_stiching, 'Position'); %Panel Sub
set(handles.stitchingPanel_stiching, 'units', 'normalized'); %Panel Sub
PpanelAll = [PpanelMain(1)+PpanelSub(1) PpanelMain(2)+PpanelSub(2) PpanelSub(3) PpanelSub(4)];
 
set(mainVideoAxe, 'units', 'pixels');
Paxe = get(mainVideoAxe, 'position');

Paxe(1) = Paxe(1) + PpanelAll(1);
Paxe(2) = Paxe(2) + PpanelAll(2);

pt_act = [pt(1,1)-Paxe(1,1) pt(1,2)-Paxe(1,2)];

[Height, Width, ~] = size(frame);
% ImageXlim = VidInfo.xlimValCurrent;
% ImageYlim = VidInfo.ylimValCurrent;
ImageXlim = roundn(xlim(mainVideoAxe) - 1, 0);
ImageYlim = roundn(ylim(mainVideoAxe) - 1, 0);

H = ImageYlim(2) - ImageYlim(1); %Height;
W = ImageXlim(2) - ImageXlim(1); %Width;

limL = (Paxe(1,3)-W)/2;
limR = limL+W;
limD = (Paxe(1,4)-H)/2;
limT = limD+H;


if limL >= 0 & limD >= 0;
    %The image fit to the screen or the image size is increased

    %identify which axe will be the limitating one
    Hlimtest1 = Paxe(1,4);
    ratioWH = W./H;
    Wlimtest1 = Hlimtest1.*ratioWH;

    Wlimtest2 = Paxe(1,3);
    ratioHW = H./W;
    Hlimtest2 = Wlimtest2.*ratioHW;

    if Wlimtest1 >= Paxe(1,3);
        %The limitating axe will be the horizontal one
        limL = 0;
        limR = Paxe(1,3);
        Wnew = Paxe(1,3);

        ratioHW = H./W;
        Hnew = Wnew.*ratioHW;
        limD = (Paxe(1,4)-Hnew)/2;
        limT = limD+Hnew;
    else;
        if Hlimtest2 >= Paxe(1,4);
            %The limitating axe is the vertical one
            limD = 0;
            limT = Paxe(1,4);
            Hnew = Paxe(1,4);

            ratioWH = W./H;
            Wnew = Hnew.*ratioWH;
            limL = (Paxe(1,3)-Wnew)/2;
            limR = limL+Wnew;
        end;
    end;
else;
    %The image doesn't fit to the screen and the image size is decreased
    if limD < 0;
        %the limitating axe is the vertical one
        limD = 0;
        limT = Paxe(1,4);
        Hnew = Paxe(1,4);

        ratioWH = W./H;
        Wnew = Hnew.*ratioWH;
        limL = (Paxe(1,3)-Wnew)/2;
        limR = limL+Wnew;
    end;

    if limL < 0;
        %the limitating axe is the horizontal one
        limL = 0;
        limR = Paxe(1,3);
        Wnew = Paxe(1,3);

        ratioHW = H./W;
        Hnew = Wnew.*ratioHW;
        limD = (Paxe(1,4)-Hnew)/2;
        limT = limD+Hnew;
    end;
end;

if pt_act(1,1) >= limL & pt_act(1,1) <= limR & pt_act(1,2) >= limD & pt_act(1,2) <= limT;
    ptEC = get(handles.selectPtDLT_stitching, 'value');
    ptEC = ptEC - 1;

    if ptEC ~= 0;
        ratioW = W./Wnew;
        ratioH = H./Hnew;
        coorU = (pt_act(1,1)-limL).*ratioW;
        coorV = (pt_act(1,2)-limD).*ratioH;
    
        coorU = coorU + ImageXlim(1,1);
        coorV = coorV + (Height-ImageYlim(1,2));
        coorV = Height - coorV;
    
        if handles.activeVideo_stitching == 1;
            handles.ptDLTLeft(ptEC, 1:2) = [coorU coorV];
        else;
            handles.ptDLTRight(ptEC, 1:2) = [coorU coorV];
        end;
        
        if handles.activeVideo_stitching == 1;
            eval(['circleEC = handles.markerDLTLeftP' num2str(ptEC) ';']);
        else;
            eval(['circleEC = handles.markerDLTRightP' num2str(ptEC) ';']);
        end;

        uistack(circleEC, 'top');
        if isvalid(circleEC) == 0;
            axes(mainVideoAxe); hold on;
            p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
            circleEC = plot(p, 'FaceColor', [1 1 0], 'EdgeColor', [1 1 0], 'Visible', 'on');
        else;
            p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
            circleEC.Shape = p;
            circleEC.Visible = 'on'; 
            circleEC.FaceColor = [1 1 0];
            circleEC.EdgeColor = [1 1 0];
        end;
        if handles.activeVideo_stitching == 1;
            eval(['handles.markerDLTLeftP' num2str(ptEC) ' = circleEC;']);
        else;
            eval(['handles.markerDLTRightP' num2str(ptEC) ' = circleEC;']);
        end;
        clear circleEC;
    end;
end;
set(mainVideoAxe, 'units', 'normalized');

if handles.activeVideo_stitching == 1;
    handles.mainLeftVideo_stitching = mainVideoAxe;
else;
    handles.mainRightVideo_stitching = mainVideoAxe;
end;

guidata(handles.hf_w1_welcome, handles);

