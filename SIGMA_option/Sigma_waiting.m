function h_wait = Sigma_waiting(wait_title, wait_message)

h_wait = figure('units','pixels');
h_wait.NumberTitle = 'off';
h_wait.Name = ['SIGMA : ', wait_title];
h_wait_pos = get(h_wait,'position');
h_wait_pos = [h_wait_pos(1) h_wait_pos(2) h_wait_pos(3)/2 h_wait_pos(4)/4];
set(h_wait,'position',h_wait_pos);
set(h_wait, 'MenuBar', 'none');
set(h_wait, 'ToolBar', 'none');
set(h_wait, 'Resize', 'off');
%set(h_wait, 'closerequestfcn', 'close(''h_wait'')')
uicontrol('style','text','string',...
    [wait_message,' Please Wait'],...
    'units','pixels','position',...
    [h_wait_pos(3)/4 h_wait_pos(4)/4 100 50]);
figure(h_wait)
end
% add delete(h_wait) just after your code