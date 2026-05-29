function [] = cancelsynch_relay(varargin);


handles2 = guidata(gcf);
%uiresume(handles2.hf_w2_welcome);

fh = findobj(0,'type','figure');
nfh=length(fh); % Total number of open figures, including GUI and figures with visibility 'off'
% Scan through open figures - GUI figure number is [] (i.e. size is zero)
for i = 1:nfh;
    % Close all figures with a Number size is greater than zero
    if strcmpi((fh(i).Name), 'Relay synchronisation') == 1;
%         figure(fh(i).Number);
        close(fh(i).Number);
    end;
end;
