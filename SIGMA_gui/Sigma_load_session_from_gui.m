function Sigma_load_session_from_gui(hObject, eventdata, handles)

[FileName,PathName] = uigetfile('*.mat','Select the session *.mat');
if( FileName == 0)
    disp('load cancelled')
    msgbox('No data selected')
    handles.sigma_load_session = 0;
    return
else
    opening_session_name = [ PathName, FileName ];
    handles = Sigma_load_sessionGUI( opening_session_name, handles, hObject );
    
    % Update the gui according to init_paramter and other sata structures
    handles = Init_parameter2gui(handles, hObject);
    
    set(handles.FEM_st_nb_features_computed, 'String', ...
        size(handles.feature_result.o_features_matrix_normalize,1)),
    set(handles.FEM_st_nb_epoch_computed, 'String', ...
        size(handles.feature_result.o_features_matrix_normalize,2));
    set(handles.FEM_st_linear_separability, 'String', ...
        handles.feature_result.linear_Separability);
    set(handles.DP_suject_text,'String',length(handles.DP_list_subject_selected.String));
    set(handles.DL_suject_text,'String',length((handles.init_parameter.subject_index)) - length(handles.DP_list_subject_selected.String));
    
    set( handles.FEM_nb_selected_methode, 'String', length(handles.selected_method ))
    set( handles.FEM_nb_available_methode, 'String', length(handles.unselected_method))
    guidata(hObject, handles);
    
    h=msgbox('   Your session is correctely loaded   ','SIGMA Loadind session');
    uiwait(h)
    guidata(hObject, handles);

end