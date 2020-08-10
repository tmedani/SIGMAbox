function Sigma_save_session_for_GUI(handles,hObject)


% Takfarinas's version
init_parameter = handles.init_parameter;
feature_result = handles.feature_result;
init_method = handles.init_method;
performance_result = handles.performance_result;
selected_model = handles.selected_model;
session_name=handles.init_parameter.full_session_name;

% check if the session file is already created
if ~isempty(dir(fullfile(session_name,'*.mat')))
    answer = questdlg(['Session "' session_name '" is already saved with the same name'], ...
        'SIGMA Message', ...
        'Replace session','Specify New Name','Cancel','Replace session');
    % Handle response
    switch answer
        case 'Replace session'
            disp([answer ' This session will be saved.'])
        case 'Specify New Name'
            disp([answer ' Please Insert new name for this session.'])
            [handles.init_parameter, ~] = Sigma_create_session(handles.init_parameter);
            init_parameter = handles.init_parameter;
            session_name=handles.init_parameter.full_session_name;
            guidata(hObject, handles);
        case 'Cancel'
            disp('This session is not saved.')
            return
    end       
end
wait_title = 'Save Session';
wait_message = 'Session is Saving...';
h_wait = Sigma_waiting(wait_title, wait_message);
Sigma_save_session(session_name,init_parameter,feature_result,init_method,...
    performance_result,selected_model);
delete(h_wait)


%msgbox('You session is correctly saved on the output directory','SIGMA save session')
choice = questdlg('You session is correctly saved on the current session folder'...
    ,'SIGMA save session','Ok', 'Open folder','Open folder');
% Handle response
switch choice
    case 'OK'
        disp('Goood')
    case 'Open folder'
        winopen(init_parameter.full_session_name);
end

end