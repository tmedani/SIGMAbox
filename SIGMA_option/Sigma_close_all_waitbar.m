function Sigma_close_all_waitbar
% This function force all the open waitbar to close

F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);

end