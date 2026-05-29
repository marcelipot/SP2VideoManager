function [filenameNew, specialChar] = checkFilename(filename);

specialChar = 0;
lispecial = strfind(filename, '-');
if isempty(lispecial) == 0;
    specialChar = 1;
end;

lispecial = strfind(filename, ' ');
if isempty(lispecial) == 0;
    specialChar = 1;
end;

lispecial = strfind(filename, '_');
if isempty(lispecial) == 0;
    specialChar = 1;
end;

lispecial = strfind(filename, '&');
if isempty(lispecial) == 0;
    specialChar = 1;
end;

lispecial = strfind(filename, '''');
if isempty(lispecial) == 0;
    specialChar = 1;
end;

if specialChar == 0;
    filenameNew = filename;
else;
    filenameNew = ['"' filename '"'];
end;