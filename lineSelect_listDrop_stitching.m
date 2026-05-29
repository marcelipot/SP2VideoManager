function [] = lineSelect_listDrop_stitching(varargin);


handles2 = guidata(gcf);
valEC = get(handles2.lineSelectDrop_qual, 'value');

if valEC == 1;
    %no line selected
    set(handles2.refinept1Push_qual, 'style', 'pushbutton', 'Value', 0, 'enable', 'off', 'String', 'Pt 1');
    set(handles2.refinept2Push_qual, 'style', 'pushbutton', 'Value', 0, 'enable', 'off', 'String', 'Pt 2');
    set(handles2.refinept3Push_qual, 'style', 'pushbutton', 'Value', 0, 'enable', 'off', 'String', 'Pt 3');
    set(handles2.refinept4Push_qual, 'style', 'pushbutton', 'Value', 0, 'enable', 'off', 'String', 'Pt 4');
    set(handles2.refinept5Push_qual, 'style', 'pushbutton', 'Value', 0, 'enable', 'off', 'String', 'Pt 5');

else;
    %line selected
    if valEC == 2 | valEC == 3;
        txt1 = 'L.Cor';
        txt2 = 'Pt 15';
        txt3 = 'Pt 25';
        txt4 = 'Pt 35';
        txt5 = 'R.Cor';
    else;
        txt1 = 'B.Cor';
        txt2 = '+2La';
        txt3 = '+4La';
        txt4 = '+6La';
        txt5 = 'T.Cor';
    end;
    set(handles2.refinept1Push_qual, 'style', 'togglebutton', 'Value', 0, 'enable', 'on', 'String', txt1);
    set(handles2.refinept2Push_qual, 'style', 'togglebutton', 'Value', 0, 'enable', 'on', 'String', txt2);
    set(handles2.refinept3Push_qual, 'style', 'togglebutton', 'Value', 0, 'enable', 'on', 'String', txt3);
    set(handles2.refinept4Push_qual, 'style', 'togglebutton', 'Value', 0, 'enable', 'on', 'String', txt4);
    set(handles2.refinept5Push_qual, 'style', 'togglebutton', 'Value', 0, 'enable', 'on', 'String', txt5);
end;



guidata(handles2.hf_w2_advancedStitching, handles2);
