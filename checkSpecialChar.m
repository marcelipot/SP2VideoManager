specialChar_fileECNew = 0;
specialChar_fileOut = 0;
specialChar_inputfolder = 0;
specialChar_outputfolder = 0;
specialChar_MDIR = 0;
specialChar_inputfile = 0;
specialChar_path = 0;


if exist('fileECNew') == 1;
    lispecial = strfind(fileECNew, '-');
    if isempty(lispecial) == 0;
        specialChar_fileECNew = 1;
    end;
end;

if exist('fileECNew') == 1;
    lispecial = strfind(fileECNew, ' ');
    if isempty(lispecial) == 0;
        specialChar_fileECNew = 1;
    end;
end;

if exist('fileECNew') == 1;
    lispecial = strfind(fileECNew, '''');
    if isempty(lispecial) == 0;
        specialChar_fileECNew = 1;
    end;
end;

if exist('fileECNew') == 1;
    lispecial = strfind(fileECNew, '&');
    if isempty(lispecial) == 0;
        specialChar_fileECNew = 1;
    end;
end;


if exist('fileOut') == 1;
    lispecial = strfind(fileOut, '-');
    if isempty(lispecial) == 0;
        specialChar_fileOut = 1;
    end;
end;

if exist('fileOut') == 1;
    lispecial = strfind(fileOut, ' ');
    if isempty(lispecial) == 0;
        specialChar_fileOut = 1;
    end;
end;

if exist('fileOut') == 1;
    lispecial = strfind(fileOut, '''');
    if isempty(lispecial) == 0;
        specialChar_fileOut = 1;
    end;
end;

if exist('fileOut') == 1;
    lispecial = strfind(fileOut, '&');
    if isempty(lispecial) == 0;
        specialChar_fileOut = 1;
    end;
end;


if exist('videoinputfolder') == 1;
    lispecial = strfind(videoinputfolder, '-');
    if isempty(lispecial) == 0;
        specialChar_inputfolder = 1;
    end;
end;

if exist('videoinputfolder') == 1;
    lispecial = strfind(videoinputfolder, ' ');
    if isempty(lispecial) == 0;
        specialChar_inputfolder = 1;
    end;
end;

if exist('videoinputfolder') == 1;
    lispecial = strfind(videoinputfolder, '''');
    if isempty(lispecial) == 0;
        specialChar_inputfolder = 1;
    end;
end;

if exist('videoinputfolder') == 1;
    lispecial = strfind(videoinputfolder, '&');
    if isempty(lispecial) == 0;
        specialChar_inputfolder = 1;
    end;
end;


if exist('videooutputfolder') == 1;
    lispecial = strfind(videooutputfolder, '-');
    if isempty(lispecial) == 0;
        specialChar_outputfolder = 1;
    end;
end;

if exist('videooutputfolder') == 1;
    lispecial = strfind(videooutputfolder, ' ');
    if isempty(lispecial) == 0;
        specialChar_outputfolder = 1;
    end;
end;

if exist('videooutputfolder') == 1;
    lispecial = strfind(videooutputfolder, '''');
    if isempty(lispecial) == 0;
        specialChar_outputfolder = 1;
    end;
end;

if exist('videooutputfolder') == 1;
    lispecial = strfind(videooutputfolder, '&');
    if isempty(lispecial) == 0;
        specialChar_outputfolder = 1;
    end;
end;


if exist('MDIR') == 1;
    lispecial = strfind(MDIR, '-');
    if isempty(lispecial) == 0;
        specialChar_MDIR = 1;
    end;
end;

if exist('MDIR') == 1;
    lispecial = strfind(MDIR, ' ');
    if isempty(lispecial) == 0;
        specialChar_MDIR = 1;
    end;
end;

if exist('MDIR') == 1;
    lispecial = strfind(MDIR, '''');
    if isempty(lispecial) == 0;
        specialChar_MDIR = 1;
    end;
end;

if exist('MDIR') == 1;
    lispecial = strfind(MDIR, '&');
    if isempty(lispecial) == 0;
        specialChar_MDIR = 1;
    end;
end;


if exist('inputfile') == 1;
    lispecial = strfind(inputfile, '-');
    if isempty(lispecial) == 0;
        specialChar_inputfile = 1;
    end;
end;

if exist('inputfile') == 1;
    lispecial = strfind(inputfile, ' ');
    if isempty(lispecial) == 0;
        specialChar_inputfile = 1;
    end;
end;

if exist('inputfile') == 1;
    lispecial = strfind(inputfile, '''');
    if isempty(lispecial) == 0;
        specialChar_inputfile = 1;
    end;
end;

if exist('inputfile') == 1;
    lispecial = strfind(inputfile, '&');
    if isempty(lispecial) == 0;
        specialChar_inputfile = 1;
    end;
end;


if exist('path') == 1;
    lispecial = strfind(path, '-');
    if isempty(lispecial) == 0;
        specialChar_path = 1;
    end;
end;

if exist('path') == 1;
    lispecial = strfind(path, ' ');
    if isempty(lispecial) == 0;
        specialChar_path = 1;
    end;
end;

if exist('path') == 1;
    lispecial = strfind(path, '''');
    if isempty(lispecial) == 0;
        specialChar_path = 1;
    end;
end;

if exist('path') == 1;
    lispecial = strfind(path, '&');
    if isempty(lispecial) == 0;
        specialChar_path = 1;
    end;
end;
