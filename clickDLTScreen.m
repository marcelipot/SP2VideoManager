function [] = clickDLTScreen(varargin)

handles2 = guidata(gcf);


set(gcf, 'unit', 'pixels');
pt = get(gcf, 'CurrentPoint');

VidInfo = handles2.VidInfo;
mainVideoAxe = handles2.mainVideo_qual;
frame = VidInfo.ActiveFrameIni;
ptDLTAll = VidInfo.FishEye.ptDLTAll;

set(mainVideoAxe, 'units', 'pixels');
Paxe = get(mainVideoAxe, 'position');
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
    ptEC = get(handles2.selectPtDLT_qual, 'value');
    ptEC = ptEC - 1;

    if ptEC ~= 0;
        ratioW = W./Wnew;
        ratioH = H./Hnew;
        coorU = (pt_act(1,1)-limL).*ratioW;
        coorV = (pt_act(1,2)-limD).*ratioH;
    
        coorU = coorU + ImageXlim(1,1);
        coorV = coorV + (Height-ImageYlim(1,2));
        coorV = Height - coorV;
    
        ptDLTAll(ptEC, 1:2) = [coorU coorV];
        eval(['circleEC = handles2.markerDLTP' num2str(ptEC) ';']);
   
        uistack(circleEC, 'top');
        if isvalid(circleEC) == 0;
            axes(mainVideoAxe); hold on;
            p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
            circleEC = plot(p, 'FaceColor', [0 1 0], 'EdgeColor', [0 1 0], 'Visible', 'on');
        else;
            p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
            circleEC.Shape = p;
            circleEC.Visible = 'on'; 
            circleEC.FaceColor = [0 1 0];
            circleEC.EdgeColor = [0 1 0];
        end;
        eval(['handles2.markerDLTP' num2str(ptEC) ' = circleEC;']);
        clear circleEC;
    end;

    ptDLTValid = [];         %point for optimisation
    for liEC = 1:length(ptDLTAll(:,1));
        ptEC = ptDLTAll(liEC,:);
        indexNaN = find(isnan(ptEC) == 1);
        if isempty(indexNaN) == 1;
            %full set of points
            ptDLTValid = [ptDLTValid; ptEC];
        end;
    end;
    if isempty(ptDLTValid) == 1;
        nbpoints = 0;
    else;
        nbpoints = length(ptDLTValid(:,1));
    end;
    if nbpoints >= 4;
        set(handles2.applyTopDown_qual, 'enable', 'on', 'value', 0);
    else;
        set(handles2.applyTopDown_qual, 'enable', 'off', 'value', 0);
    end;
    if nbpoints >= 6;
        set(handles2.applyOptimisation1_qual, 'enable', 'on', 'value', 0);
        set(handles2.applyOptimisation2_qual, 'enable', 'on', 'value', 0);
    else;
        set(handles2.applyOptimisation1_qual, 'enable', 'off', 'value', 0);
        set(handles2.applyOptimisation2_qual, 'enable', 'off', 'value', 0);
    end;
end;
set(mainVideoAxe, 'units', 'normalized');

VidInfo.FishEye.ptDLTAll = ptDLTAll;
handles2.VidInfo = VidInfo;
handles2.mainVideo_qual = mainVideoAxe;
guidata(handles2.hf_w2_advancedImage, handles2);

