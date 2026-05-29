function [] = Resize_SP2manager(varargin);


try;
    handles = guidata(gcf);
    
    %---Main
    %---Resize Help icon
    set(handles.help_button_main, 'units', 'pixels');
    pos = get(handles.help_button_main, 'position');
    set(handles.help_button_main, 'cdata', imresize(handles.icones.question_offb, [pos(3) pos(4)]));
    set(handles.help_button_main, 'units', 'normalized');

    %---Resize input folder icon conv
    set(handles.folderinputPanning_conv, 'units', 'pixels');
    pos = get(handles.folderinputPanning_conv, 'position');
    set(handles.folderinputPanning_conv, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.folderinputPanning_conv, 'units', 'normalized');

    %---Resize output folder icon conv
    set(handles.folderoutputPanning_conv, 'units', 'pixels');
    pos = get(handles.folderoutputPanning_conv, 'position');
    set(handles.folderoutputPanning_conv, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.folderoutputPanning_conv, 'units', 'normalized');

    %---Resize play icon conv
    set(handles.playrefresh_conv, 'units', 'pixels');
    pos = get(handles.playrefresh_conv, 'position');
    set(handles.playrefresh_conv, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.playrefresh_conv, 'units', 'normalized');

    
    %---ENTRY
    %---Resize folder icon entry
    set(handles.loadList_button_entry, 'units', 'pixels');
    pos = get(handles.loadList_button_entry, 'position');
    set(handles.loadList_button_entry, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.loadList_button_entry, 'units', 'normalized');

    %---Resize red cross icon entry
    set(handles.reset_button_entry, 'units', 'pixels');
    pos = get(handles.reset_button_entry, 'position');
    set(handles.reset_button_entry, 'cdata', imresize(handles.icones.redcross_offb, [pos(3) pos(4)]));
    set(handles.reset_button_entry, 'units', 'normalized');

    %---Resize save icon entry
    set(handles.save_button_entry, 'units', 'pixels');
    pos = get(handles.save_button_entry, 'position');
    set(handles.save_button_entry, 'cdata', imresize(handles.icones.save_offb, [pos(3) pos(4)]));
    set(handles.save_button_entry, 'units', 'normalized');


  

    %---Slider Other single
    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');

    posSliderNew(1,1) = handles.sliderControl_push_singlePanningPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_singlePanningPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_singlePanningPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_singlePanningPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_singlePanning.Position = posSliderNew;


    posSliderNew(1,1) = handles.sliderControl_push_single4KPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_single4KPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_single4KPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_single4KPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_single4K.Position = posSliderNew;


    %---Resize folder panning icon other single
    set(handles.pushSelectPanning_single, 'units', 'pixels');
    pos = get(handles.pushSelectPanning_single, 'position');
    set(handles.pushSelectPanning_single, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.pushSelectPanning_single, 'units', 'normalized');

    %---Resize folder 4K icon other single
    set(handles.selecttxt4K_single, 'units', 'pixels');
    pos = get(handles.selecttxt4K_single, 'position');
    set(handles.selecttxt4K_single, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.selecttxt4K_single, 'units', 'normalized');

    %---Resize start processing icon single
    set(handles.startProcessing_single, 'units', 'pixels');
    pos = get(handles.startProcessing_single, 'position');
    set(handles.startProcessing_single, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.startProcessing_single, 'units', 'normalized');

    %---Resize reset icon other single
    set(handles.cancelProcessing_single, 'units', 'pixels');
    pos = get(handles.cancelProcessing_single, 'position');
    set(handles.cancelProcessing_single, 'cdata', imresize(handles.icones.redcross_offb, [pos(3) pos(4)]));
    set(handles.cancelProcessing_single, 'units', 'normalized');

    %---Resize Prev Chap icon other single
    set(handles.prevChapControl_push_single, 'units', 'pixels');
    pos = get(handles.prevChapControl_push_single, 'position');
    set(handles.prevChapControl_push_single, 'cdata', imresize(handles.icones.prevChapPlayer, [pos(3) pos(4)]));
    set(handles.prevChapControl_push_single, 'units', 'normalized');

    %---Resize Prev Frame icon other single
    set(handles.prevFrameControl_push_single, 'units', 'pixels');
    pos = get(handles.prevFrameControl_push_single, 'position');
    set(handles.prevFrameControl_push_single, 'cdata', imresize(handles.icones.prevFramePlayer, [pos(3) pos(4)]));
    set(handles.prevFrameControl_push_single, 'units', 'normalized');

    %---Resize Next Frame icon other single
    set(handles.nextFrameControl_push_single, 'units', 'pixels');
    pos = get(handles.nextFrameControl_push_single, 'position');
    set(handles.nextFrameControl_push_single, 'cdata', imresize(handles.icones.nextFramePlayer, [pos(3) pos(4)]));
    set(handles.nextFrameControl_push_single, 'units', 'normalized');

    %---Resize Next Chap icon other single
    set(handles.nextChap_push_single, 'units', 'pixels');
    pos = get(handles.nextChap_push_single, 'position');
    set(handles.nextChap_push_single, 'cdata', imresize(handles.icones.nextChapPlayer, [pos(3) pos(4)]));
    set(handles.nextChap_push_single, 'units', 'normalized');

    %---Resize play icon conv
    set(handles.swapVid_push_single, 'units', 'pixels');
    pos = get(handles.swapVid_push_single, 'position');
    set(handles.swapVid_push_single, 'cdata', imresize(handles.icones.swapVideo, [pos(3) pos(4)]));
    set(handles.swapVid_push_single, 'units', 'normalized');


    %---Slider Other screen
    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');

    posSliderNew(1,1) = handles.sliderControl_push_screenPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_screenPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_screenPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_screenPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_screen.Position = posSliderNew;

    %---Resize folder panning icon other screen
    set(handles.pushSelectScreen_screen, 'units', 'pixels');
    pos = get(handles.pushSelectScreen_screen, 'position');
    set(handles.pushSelectScreen_screen, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.pushSelectScreen_screen, 'units', 'normalized');

    %---Resize play icon other screen
    set(handles.startProcessing_screen, 'units', 'pixels');
    pos = get(handles.startProcessing_screen, 'position');
    set(handles.startProcessing_screen, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.startProcessing_screen, 'units', 'normalized');

    %---Resize cancel icon other screen
    set(handles.cancelProcessing_screen, 'units', 'pixels');
    pos = get(handles.cancelProcessing_screen, 'position');
    set(handles.cancelProcessing_screen, 'cdata', imresize(handles.icones.redcross_offb, [pos(3) pos(4)]));
    set(handles.cancelProcessing_screen, 'units', 'normalized');

    %---Resize prev chap icon other screen
    set(handles.prevChapControl_push_screen, 'units', 'pixels');
    pos = get(handles.prevChapControl_push_screen, 'position');
    set(handles.prevChapControl_push_screen, 'cdata', imresize(handles.icones.prevChapPlayer, [pos(3) pos(4)]));
    set(handles.prevChapControl_push_screen, 'units', 'normalized');

    %---Resize prev frame icon other screen
    set(handles.prevFrameControl_push_screen, 'units', 'pixels');
    pos = get(handles.prevFrameControl_push_screen, 'position');
    set(handles.prevFrameControl_push_screen, 'cdata', imresize(handles.icones.prevFramePlayer, [pos(3) pos(4)]));
    set(handles.prevFrameControl_push_screen, 'units', 'normalized');

    %---Resize next chap icon other screen
    set(handles.nextFrameControl_push_screen, 'units', 'pixels');
    pos = get(handles.nextFrameControl_push_screen, 'position');
    set(handles.nextFrameControl_push_screen, 'cdata', imresize(handles.icones.nextFramePlayer, [pos(3) pos(4)]));
    set(handles.nextFrameControl_push_screen, 'units', 'normalized');

    %---Resize next chap icon other screen
    set(handles.nextChap_push_screen, 'units', 'pixels');
    pos = get(handles.nextChap_push_screen, 'position');
    set(handles.nextChap_push_screen, 'cdata', imresize(handles.icones.nextChapPlayer, [pos(3) pos(4)]));
    set(handles.nextChap_push_screen, 'units', 'normalized');



    %---Slider Other screen
    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');

    posSliderNew(1,1) = handles.sliderControl_push_relayPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControl_push_relayPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControl_push_relayPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControl_push_relayPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControl_push_relay.Position = posSliderNew;

    %---Resize folder panning icon other screen
    set(handles.pushSelectRelay_relay, 'units', 'pixels');
    pos = get(handles.pushSelectRelay_relay, 'position');
    set(handles.pushSelectRelay_relay, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.pushSelectRelay_relay, 'units', 'normalized');

    %---Resize play icon other screen
    set(handles.startProcessing_relay, 'units', 'pixels');
    pos = get(handles.startProcessing_relay, 'position');
    set(handles.startProcessing_relay, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.startProcessing_relay, 'units', 'normalized');

    %---Resize cancel icon other screen
    set(handles.cancelProcessing_relay, 'units', 'pixels');
    pos = get(handles.cancelProcessing_relay, 'position');
    set(handles.cancelProcessing_relay, 'cdata', imresize(handles.icones.redcross_offb, [pos(3) pos(4)]));
    set(handles.cancelProcessing_relay, 'units', 'normalized');

    %---Resize prev chap icon other screen
    set(handles.prevChapControl_push_relay, 'units', 'pixels');
    pos = get(handles.prevChapControl_push_relay, 'position');
    set(handles.prevChapControl_push_relay, 'cdata', imresize(handles.icones.prevChapPlayer, [pos(3) pos(4)]));
    set(handles.prevChapControl_push_relay, 'units', 'normalized');

    %---Resize prev frame icon other screen
    set(handles.prevFrameControl_push_relay, 'units', 'pixels');
    pos = get(handles.prevFrameControl_push_relay, 'position');
    set(handles.prevFrameControl_push_relay, 'cdata', imresize(handles.icones.prevFramePlayer, [pos(3) pos(4)]));
    set(handles.prevFrameControl_push_relay, 'units', 'normalized');

    %---Resize next chap icon other screen
    set(handles.nextFrameControl_push_relay, 'units', 'pixels');
    pos = get(handles.nextFrameControl_push_relay, 'position');
    set(handles.nextFrameControl_push_relay, 'cdata', imresize(handles.icones.nextFramePlayer, [pos(3) pos(4)]));
    set(handles.nextFrameControl_push_relay, 'units', 'normalized');

    %---Resize next chap icon other screen
    set(handles.nextChap_push_relay, 'units', 'pixels');
    pos = get(handles.nextChap_push_relay, 'position');
    set(handles.nextChap_push_relay, 'cdata', imresize(handles.icones.nextChapPlayer, [pos(3) pos(4)]));
    set(handles.nextChap_push_relay, 'units', 'normalized');



    %---Slider Other stitch
    set(handles.hf_w1_welcome, 'units', 'Pixels');
    posWindow = get(handles.hf_w1_welcome, 'Position');
    set(handles.hf_w1_welcome, 'units', 'Normalized');

    posSliderNew(1,1) = handles.sliderControlLeft_push_stitchingPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControlLeft_push_stitchingPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControlLeft_push_stitchingPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControlLeft_push_stitchingPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControlLeft_push_stitching.Position = posSliderNew;

    posSliderNew(1,1) = handles.sliderControlRight_push_stitchingPositionNorm(1,1).*posWindow(1,3);
    posSliderNew(1,2) = handles.sliderControlRight_push_stitchingPositionNorm(1,2).*posWindow(1,4);
    posSliderNew(1,3) = handles.sliderControlRight_push_stitchingPositionNorm(1,3).*posWindow(1,3);
    posSliderNew(1,4) = handles.sliderControlRight_push_stitchingPositionNorm(1,4).*posWindow(1,4);
    handles.sliderControlRight_push_stitching.Position = posSliderNew;

    %---Resize folder icon other stichting left
    set(handles.pushSelectLeftvid_stitching, 'units', 'pixels');
    pos = get(handles.pushSelectLeftvid_stitching, 'position');
    set(handles.pushSelectLeftvid_stitching, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.pushSelectLeftvid_stitching, 'units', 'normalized');

    %---Resize folder icon other stichting left
    set(handles.pushSelectRightvid_stitching, 'units', 'pixels');
    pos = get(handles.pushSelectRightvid_stitching, 'position');
    set(handles.pushSelectRightvid_stitching, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.pushSelectRightvid_stitching, 'units', 'normalized');

    %---Resize folder icon other stichting delete point
    set(handles.erasePtDLT_stiching, 'units', 'pixels');
    pos = get(handles.erasePtDLT_stiching, 'position');
    set(handles.erasePtDLT_stiching, 'cdata', imresize(handles.icones.eraser_offb, [pos(3) pos(4)]));
    set(handles.erasePtDLT_stiching, 'units', 'normalized');

%     %---Resize other stichting save cal point
%     set(handles.savePtDLT_stiching, 'units', 'pixels');
%     pos = get(handles.savePtDLT_stiching, 'position');
%     set(handles.savePtDLT_stiching, 'cdata', imresize(handles.icones.save_offb, [pos(3) pos(4)]));
%     set(handles.savePtDLT_stiching, 'units', 'normalized');
% 
%     %---Resize other stitching load cal point
%     set(handles.loadPtDLT_stiching, 'units', 'pixels');
%     pos = get(handles.loadPtDLT_stiching, 'position');
%     set(handles.loadPtDLT_stiching, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
%     set(handles.loadPtDLT_stiching, 'units', 'normalized');

    %---Resize folder icon other stichting delete point
    set(handles.erasePtStitch_stiching, 'units', 'pixels');
    pos = get(handles.erasePtStitch_stiching, 'position');
    set(handles.erasePtStitch_stiching, 'cdata', imresize(handles.icones.eraser_offb, [pos(3) pos(4)]));
    set(handles.erasePtStitch_stiching, 'units', 'normalized');

    %---Resize other stichting save cal point
    set(handles.saveCalStitch_stiching, 'units', 'pixels');
    pos = get(handles.saveCalStitch_stiching, 'position');
    set(handles.saveCalStitch_stiching, 'cdata', imresize(handles.icones.save_offb, [pos(3) pos(4)]));
    set(handles.saveCalStitch_stiching, 'units', 'normalized');

    %---Resize other stitching load cal point
    set(handles.loadCalStitch_stiching, 'units', 'pixels');
    pos = get(handles.loadCalStitch_stiching, 'position');
    set(handles.loadCalStitch_stiching, 'cdata', imresize(handles.icones.import_offb, [pos(3) pos(4)]));
    set(handles.loadCalStitch_stiching, 'units', 'normalized');

%     %---Resize folder icon other stichting load fisheye
%     set(handles.loadFisheye_stitching, 'units', 'pixels');
%     pos = get(handles.loadFisheye_stitching, 'position');
%     set(handles.loadFisheye_stitching, 'cdata', imresize(handles.icones.fisheye_offb, [pos(3) pos(4)]));
%     set(handles.loadFisheye_stitching, 'units', 'normalized');

    %---Resize play icon other stichting
    set(handles.startProcessing_stitching, 'units', 'pixels');
    pos = get(handles.startProcessing_stitching, 'position');
    set(handles.startProcessing_stitching, 'cdata', imresize(handles.icones.play_offb, [pos(3) pos(4)]));
    set(handles.startProcessing_stitching, 'units', 'normalized');

    %---Resize cancel icon other stichting
    set(handles.cancelProcessing_stitching, 'units', 'pixels');
    pos = get(handles.cancelProcessing_stitching, 'position');
    set(handles.cancelProcessing_stitching, 'cdata', imresize(handles.icones.redcross_offb, [pos(3) pos(4)]));
    set(handles.cancelProcessing_stitching, 'units', 'normalized');

    %---Resize prev chap icon other stichting
    set(handles.prevChapControl_push_stitching, 'units', 'pixels');
    pos = get(handles.prevChapControl_push_stitching, 'position');
    set(handles.prevChapControl_push_stitching, 'cdata', imresize(handles.icones.prevChapPlayer, [pos(3) pos(4)]));
    set(handles.prevChapControl_push_stitching, 'units', 'normalized');

    %---Resize prev frame icon other stichting
    set(handles.prevFrameControl_push_stitching, 'units', 'pixels');
    pos = get(handles.prevFrameControl_push_stitching, 'position');
    set(handles.prevFrameControl_push_stitching, 'cdata', imresize(handles.icones.prevFramePlayer, [pos(3) pos(4)]));
    set(handles.prevFrameControl_push_stitching, 'units', 'normalized');

    %---Resize next chap icon other stichting
    set(handles.nextFrameControl_push_stitching, 'units', 'pixels');
    pos = get(handles.nextFrameControl_push_stitching, 'position');
    set(handles.nextFrameControl_push_stitching, 'cdata', imresize(handles.icones.nextFramePlayer, [pos(3) pos(4)]));
    set(handles.nextFrameControl_push_stitching, 'units', 'normalized');

    %---Resize next chap icon other stichting
    set(handles.nextChapControl_push_stitching, 'units', 'pixels');
    pos = get(handles.nextChapControl_push_stitching, 'position');
    set(handles.nextChapControl_push_stitching, 'cdata', imresize(handles.icones.nextChapPlayer, [pos(3) pos(4)]));
    set(handles.nextChapControl_push_stitching, 'units', 'normalized');

    %---Resize swap vid icon other stichting
    set(handles.swapVid_push_stitching, 'units', 'pixels');
    pos = get(handles.swapVid_push_stitching, 'position');
    set(handles.swapVid_push_stitching, 'cdata', imresize(handles.icones.swapVideo, [pos(3) pos(4)]));
    set(handles.swapVid_push_stitching, 'units', 'normalized');

    %---Resize preview icon other stichting
    set(handles.previewStitch_stitching, 'units', 'pixels');
    pos = get(handles.previewStitch_stitching, 'position');
    set(handles.previewStitch_stitching, 'cdata', imresize(handles.icones.preview_offb, [pos(3) pos(4)]));
    set(handles.previewStitch_stitching, 'units', 'normalized');





    if get(handles.EntryList_toggle_main, 'value') == 1;
        %if manage entry list
        %resize the col of the table

        if isempty(handles.entrListFull_entry) == 0;
            entryListDisp = handles.entrListFull_entry;

            set(handles.txtpathFile_entry, 'fontunits', 'points');
            ft = get(handles.txtpathFile_entry, 'fontsize');
            set(handles.txtpathFile_entry, 'fontunits', 'normalized');

            set(handles.tableEntryList_entry, 'units', 'pixels', 'fontunits', 'points');
            pos = get(handles.tableEntryList_entry, 'position');
            PixelTot = pos(3);
            colWidth = {floor(handles.tabCol1RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol2RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol3RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol4RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol5RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol6RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol7RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol8RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol9RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol10RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol11RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol12RatioEntry.*PixelTot)-1 ...
                floor(handles.tabCol13RatioEntry.*PixelTot)-1};
            set(handles.tableEntryList_entry, 'ColumnWidth', colWidth);
            set(handles.tableEntryList_entry, 'fontsize', ft-5+handles.fontDiff);
            set(handles.tableEntryList_entry, 'units', 'normalized', 'fontunits', 'normalized');

            sepRace1 = handles.sepRace1;
            entryList = handles.entrListFull_entry;
            
            if isempty(entryList) == 0;
                heats2keepVal = handles.heats2keepVal;
                valTemplate = handles.checkkeepEmptyRows_entry;
                
                entryListDisp = entrylistTransform_entry(entryList, heats2keepVal, valTemplate, sepRace1);
            
                set(handles.tableEntryList_entry, 'data', entryListDisp);
                table_extent = get(handles.tableEntryList_entry, 'Extent');
                table_position = get(handles.tableEntryList_entry, 'Position');
                while table_extent(4) < table_position(4);
                    %up/down scroll bar
                    entryListDisp{end+1, 1} = [];
                    set(handles.tableEntryList_entry, 'data', entryListDisp);
                    drawnow;
                
                    table_extent = get(handles.tableEntryList_entry, 'Extent');
                    table_position = get(handles.tableEntryList_entry, 'Position');
                end;
                
                set(handles.tableEntryList_entry, 'visible', 'on');
                drawnow;
            end;
        end;        
    end;

    if get(handles.FileTransfer_toggle_main, 'value') == 1;
        
    end;
%     try;
%         if ismac == 1;
%             load /Applications/SP2VideoManager/listVideoPanningFiles.mat;
%         elseif ispc == 1;
%             MDIR = getenv('USERPROFILE');
%             load([MDIR '\SP2VideoManager\listVideoPanningFiles.mat']);
%         end;
%     catch;
%         listVideoPanningFiles = [];
%     end;
%     
%     set(handles.txttrimPanning_main, 'fontunits', 'points');
%     ft = get(handles.txttrimPanning_main, 'fontsize');
%     set(handles.txttrimPanning_main, 'fontunits', 'normalized');
%         
%     set(handles.txtinputPanning_main, 'fontunits', 'points');
%     set(handles.pathinputPanning_main, 'fontunits', 'points');
%     set(handles.txtoutputPanning_main, 'fontunits', 'points');
%     set(handles.pathoutputPanning_main, 'fontunits', 'points');
% 
%     set(handles.txtinputPanning_main, 'fontsize', ft-1);
%     set(handles.pathinputPanning_main, 'fontsize', ft-1);
%     set(handles.txtoutputPanning_main, 'fontsize', ft-1);
%     set(handles.pathoutputPanning_main, 'fontsize', ft-1);
% 
%     set(handles.txtinputPanning_main, 'fontunits', 'normalized');
%     set(handles.pathinputPanning_main, 'fontunits', 'normalized');
%     set(handles.txtoutputPanning_main, 'fontunits', 'normalized');
%     set(handles.pathoutputPanning_main, 'fontunits', 'normalized');
%         
%     if isempty(listVideoPanningFiles) == 0;
%         set(handles.tablePanning_main, 'units', 'pixels');
%         pos = get(handles.tablePanning_main, 'position');
%         PixelTot = pos(3);
%         colWidth = {floor(handles.tabCol1Ratio.*PixelTot)-1 floor(handles.tabCol2Ratio.*PixelTot)-1};
%         set(handles.tablePanning_main, 'ColumnWidth', colWidth);
%         set(handles.tablePanning_main, 'units', 'normalized');
%         set(handles.tablePanning_main, 'fontsize', ft-1);
%         
%         poslim1 = get(handles.lineLeft_main, 'Position');
%         table_extent = get(handles.tablePanning_main, 'Extent');
%         table_position = get(handles.tablePanning_main, 'Position');
%         set(handles.tablePanning_main, 'Position', [poslim1(1)+0.002 table_position(2)+table_position(4)-table_extent(4)-0.001 table_position(3)+0.001 table_extent(4)+0.001]);
%     end;
%     
%     if ischar(handles.inputfolderPanning) == 1;
%         disppath = handles.inputfolderPanning;
%         if isempty(strfind(disppath, '...')) == 1;
%             posExtent = get(handles.pathinputPanning_main, 'Extent');
%             posReal = get(handles.pathinputPanning_main, 'Position');
%             if posExtent(3) >= posReal(3);
%                 li = strfind(disppath, '/');
%                 if isempty(li) == 1;
% 
%                 else;
%                     if length(li) >= 3;
%                         disppath = [disppath(1:li(2)) ' ... ' disppath(li(end):end)];
%                     else;
%                         disppath = disppath(li(end):end);
%                     end;
%                 end;
%                 set(handles.pathinputPanning_main, 'String', disppath);
%             end;
%         end;
%     end;
%     if ischar(handles.outputfolderPanning) == 1;
%         disppath = handles.outputfolderPanning;
%         if isempty(strfind(disppath, '...')) == 1;
%             posExtent = get(handles.pathoutputPanning_main, 'Extent');
%             posReal = get(handles.pathoutputPanning_main, 'Position');
%             if posExtent(3) >= posReal(3);
%                 li = strfind(disppath, '/');
%                 if isempty(li) == 1;
% 
%                 else;
%                     if length(li) >= 3;
%                         disppath = [disppath(1:li(2)) ' ... ' disppath(li(end):end)];
%                     else;
%                         disppath = disppath(li(end):end);
%                     end;
%                 end;
%                 set(handles.pathoutputPanning_main, 'String', disppath);
%             end;
%         end;
%     end;


    
    try;
        guidata(handles.hf_w1_welcome, handles);
    end;
end;

