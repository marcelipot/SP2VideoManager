function [] = clickActionRefine_screen(varargin)

handles2 = guidata(gcf);


set(gcf, 'unit', 'pixels');
pt = get(gcf, 'CurrentPoint');

VidInfo = handles2.VidInfo;
frame = VidInfo.ActiveFrame;

set(handles2.mainVideo_qual, 'units', 'pixels');
Paxe = get(handles2.mainVideo_qual, 'position');
pt_act = [pt(1,1)-Paxe(1,1) pt(1,2)-Paxe(1,2)];

[Height, Width, ~] = size(frame);
% ImageXlim = VidInfo.xlimValCurrent;
% ImageYlim = VidInfo.ylimValCurrent;
ImageXlim = roundn(xlim(handles2.mainVideo_qual) - 1, 0);
ImageYlim = roundn(ylim(handles2.mainVideo_qual) - 1, 0);

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
    ratioW = W./Wnew;
    ratioH = H./Hnew;
    coorU = (pt_act(1,1)-limL).*ratioW;
    coorV = (pt_act(1,2)-limD).*ratioH;

    coorU = coorU + ImageXlim(1,1);
    coorV = coorV + (Height-ImageYlim(1,2));
    coorV = Height - coorV;

    if get(handles2.refinept1Push_qual, 'Value') == 1;
        ptEC = 1;
    end;
    if get(handles2.refinept2Push_qual, 'Value') == 1;
        ptEC = 2;
    end;
    if get(handles2.refinept3Push_qual, 'Value') == 1;
        ptEC = 3;
    end;
    if get(handles2.refinept4Push_qual, 'Value') == 1;
        ptEC = 4;
    end;
    if get(handles2.refinept5Push_qual, 'Value') == 1;
        ptEC = 5;
    end;
    lineEC = get(handles2.lineSelectDrop_qual, 'Value') - 1;
    VidInfo.FishEye.refinePoints(lineEC,(ptEC*2)-1:(ptEC*2)) = [coorU coorV];


    if lineEC == 1;
        colourEC = [1 0 0];
    elseif lineEC == 2;
        colourEC = [1 1 0];
    elseif lineEC == 3;
        colourEC = [0 1 1];
    elseif lineEC == 4;
        colourEC = [1 0 1];
    end;
    eval(['circleEC = handles2.markerDispL' num2str(lineEC) 'P' num2str(ptEC) ';']);
    if isvalid(circleEC) == 0;
        axes(handles2.mainVideo_qual); hold on;
        p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
        circleEC = plot(p, 'FaceColor', colourEC, 'EdgeColor', colourEC, 'Visible', 'on');
    else;
        p = nsidedpoly(8, 'Center', [coorU coorV], 'Radius', 10);
        circleEC.Shape = p;
        circleEC.Visible = 'on'; 
    end;
    eval(['handles2.markerDispL' num2str(lineEC) 'P' num2str(ptEC) ' = circleEC;']);
    clear circleEC;
    set(handles2.hf_w2_advancedImage, 'WindowButtonDownFcn', '');
    
    set(handles2.refinept1Push_qual, 'Value', 0);
    set(handles2.refinept2Push_qual, 'Value', 0);
    set(handles2.refinept3Push_qual, 'Value', 0);
    set(handles2.refinept4Push_qual, 'Value', 0);
    set(handles2.refinept5Push_qual, 'Value', 0);

    fullRow = VidInfo.FishEye.refinePoints(lineEC,:);
    index = find(fullRow == 0);
    if isempty(index) == 0;
        fullRow(index) = [];
    end;
    if length(fullRow) == 10;
        %full row with 5 points
        %draw lines
        hold on;
        %straight line using first and last point
        hl_straight = line([fullRow(1) fullRow(end-1)], [fullRow(2) fullRow(end)], 'Color', colourEC, 'LineWidth', 1, 'Linestyle', '--');
    
        %Spline line using all points
        xx = fullRow(1) : (fullRow(end-1)-fullRow(1))./10 : fullRow(end-1);
        yy = spline(fullRow(1:2:end), fullRow(2:2:end), xx);
        hl_spline = line(xx, yy, 'Color', colourEC, 'LineWidth', 1, 'Linestyle', ':');
    end;
    handles2.VidInfo = VidInfo;
end;
set(handles2.mainVideo_qual, 'units', 'normalized');
guidata(handles2.hf_w2_advancedImage, handles2);

