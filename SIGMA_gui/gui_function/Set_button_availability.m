function Set_button_availability(handles, hObject)
%%%------------------------------------------------------------------------
%   Set_button_availability(handles, hObject)
%
%   Function task:
%   Determine and set the availability of all buttons accoring to tu
%   progression of user in the GUI
%   
%   Inputs :
%   handles : structure containing GUI informations
%   hObject : necessary for the GUI management
%
%   Outputs : 
%       
%   handles : structure containing GUI informations
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%       
%
%   Dependencies
%       
%
%   NB: this code is copyrighted. 
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------
%% Data Loading
% SUBJECT SELECTION : subject selected and data compatible
if(handles.init_parameter.data_compatibility == 1)
    set(handles.DL_pb_subject_select, 'Enable', 'on');
    set(handles.DP_pb_subject_remove, 'Enable', 'on');
    set(handles.DL_pb_data_viz, 'Enable', 'on');
else
    set(handles.DL_pb_subject_select, 'Enable', 'off');
    set(handles.DP_pb_subject_remove, 'Enable', 'off');
    set(handles.DL_pb_data_viz, 'Enable', 'off');
end


% Set subject selection button availability
% button available only if there is a subject to move
if( length(handles.init_parameter.subject) >= length(handles.init_parameter.subject_number)  )
    set(handles.DL_pb_subject_select, 'Enable', 'off');
    set(handles.DP_pb_subject_remove, 'Enable', 'on');
elseif(length(handles.init_parameter.subject) < 0.5)
    set(handles.DL_pb_subject_select, 'Enable', 'on');
    set(handles.DP_pb_subject_remove, 'Enable', 'off');
else
    set(handles.DL_pb_subject_select, 'Enable', 'on');
    set(handles.DP_pb_subject_remove, 'Enable', 'on');
end

%% Data Processing

% condition BAND EDIT
%if data are compatibles
% if(handles.init_parameter.data_compatibility == 1)
%     set(handles.DP_pb_freq_band_edit, 'Enable', 'on');
% else
%     set(handles.DP_pb_freq_band_edit, 'Enable', 'off');
% end


% condition RESAMPLE Edit
%if data are compatibles
if(handles.init_parameter.data_compatibility == 1)
    set(handles.DP_cb_resampling_enable, 'Enable', 'on');
    set(handles.DP_cb_resampling_enable, 'Value', 0);
    set(handles.DP_sampling_edit, 'Enable', 'on');
else
    set(handles.DP_cb_resampling_enable, 'Enable', 'off');
    set(handles.DP_cb_resampling_enable, 'Value', 0);
    set(handles.DP_sampling_edit, 'Enable', 'off');
end

%% Feature extraction Methods

% METHOD EDIT condition : only one method selected + method editable
% only one method selected and at least one method is prsent in the list
if( (length(get(handles.FEM_selected, 'Value')) == 1) && (length(handles.init_parameter.method) > 0.5))
    %Check method editability
    %if(isempty(handles.selected_method) < 0.5)  %if some methods are selected
    if (isempty(handles.init_parameter.method) < 0.5) % modification Takfarinas 
        handles.selected_method = handles.init_parameter.method;
        %Find the method number
        method_number = get(handles.FEM_selected, 'Value');
        init_met_method_number = handles.selected_method(method_number);
        % Check and detect the number of parameters to change and their
        % index for future changing
        [nb_parameter_to_change, parameter_index] = Check_method_editable_parameter(handles.init_method(init_met_method_number));
        if(nb_parameter_to_change > 0.5)
            set(handles.FEM_pb_method_edit, 'Enable', 'on');
        else
            set(handles.FEM_pb_method_edit, 'Enable', 'off');
        end
        
    end
else
    set(handles.FEM_pb_method_edit, 'Enable', 'off');
end


% Condition COMPUTE FEATURE : subject selected, min 1 method selected
cond1 = handles.init_parameter.nb_subject; % number of subject
cond2 = handles.init_parameter.nb_method;  % number of method
cond3 = size(handles.init_parameter.selected_band, 2); % at least 1 band

if(cond1*cond2*cond3 > 0.5)
    set(handles.FEM_pb_compute, 'Enable', 'on');
else
    set(handles.FEM_pb_compute, 'Enable', 'off');
end

%% Feature Ranking

% if advanced mùethod selected
if(get(handles.FR_rb_other_adv_method, 'Value') == 1)
    % force the ranking method to be the number of features
    set(handles.FR_rb_nb_feature, 'Value', 1);
    set(handles.FR_pb_edit_advanced_method, 'Enable', 'on')
   
    % advanced method chosen
    set(handles.FR_st_selected_adv_method, 'Visible', 'on')
else
    set(handles.FR_pb_edit_advanced_method, 'Enable', 'off')
    %set(handles.FR_advance_panel, 'Visible', 'off')
    
    % advanced method chosen
    set(handles.FR_st_selected_adv_method, 'Visible', 'off')
    
end

if( (get(handles.FR_rb_nb_feature, 'Value') == 1) )
    % Button feature number edit
    set(handles.FR_edit_nb_feature, 'Enable', 'on')
    % Button probe probability
    set(handles.FR_edit_probability_probe, 'Enable', 'off')
    
    if(get(handles.FR_rb_other_adv_method, 'Value')== 1)
        % button advanced method
        set(handles.FR_pb_edit_advanced_method, 'Enable', 'on')
        %set(handles.FR_advance_panel, 'Enable', 'on')
        
        % advanced method chosen
        set(handles.FR_st_selected_adv_method, 'Visible', 'on')
    end
else
    set(handles.FR_edit_nb_feature, 'Enable', 'off')
    set(handles.FR_edit_probability_probe, 'Enable', 'on')
    
    if(get(handles.FR_rb_other_adv_method, 'Value') == 0)
        % button advanced method
        set(handles.FR_pb_edit_advanced_method, 'Enable', 'off')
        %set(handles.FR_advance_panel, 'Enable', 'off')
        % advanced method chosen
        set(handles.FR_st_selected_adv_method, 'Visible', 'off')
    end
end





% condition COMPUTE FEATURE RANKING
% Existance de feature results
cond1 = isempty(handles.feature_result);
if(cond1 < 0.5)
    set(handles.FR_pb_compute_FR, 'Enable', 'on');
else
    set(handles.FR_pb_compute_FR, 'Enable', 'off');
end


% condition DISPLAY FEATURE RANKING RESULTS
% if ranking done and results available
cond1 = isempty(handles.feature_result);
if(cond1 < 0.5)
    cond2 = isfield(handles.feature_result,'o_best_features_matrix');
    if( cond2 > 0.5)
        set(handles.FR_pb_display_FR, 'Enable', 'on')
        % takfa
        set(handles.FR_pb_3D_FR, 'Enable', 'on')
        
    else
        set(handles.FR_pb_display_FR, 'Enable', 'off')
        % takfa
        set(handles.FR_pb_3D_FR, 'Enable', 'off')
        
    end
else
    set(handles.FR_pb_display_FR, 'Enable', 'off')
    % takfa
    set(handles.FR_pb_3D_FR, 'Enable', 'off')
end

%% Data Classification

% condition COMPUTE CLASSIFICATION
cond1 = isempty(handles.feature_result); % If feature results exist
if(cond1 < 0.5)
    cond2 = isfield(handles.feature_result,'o_best_features_matrix');
    if( cond2 > 0.5)
        set(handles.DC_pb_compute, 'Enable', 'on')
    else
        set(handles.DC_pb_compute, 'Enable', 'off')
    end
else
    set(handles.DC_pb_compute, 'Enable', 'off')
end

% Condition EDIT CLASSIFICATION METHOD
if( get(handles.DC_rb_SVM, 'Value') == 1 )
    set(handles.DC_pb_edit_classification_method, 'Enable', 'on');
else
    set(handles.DC_pb_edit_classification_method, 'Enable', 'off');
end


% condition DISPLAY CLASSIFICATION RESULTS
% classification results are computed
cond1 = isempty(handles.feature_result);
if( cond1 < 0.5)
    set(handles.DC_pb_display, 'Enable', 'on')
    %      set(handles.DC_pb_apply_model, 'Enable', 'on')
    set(handles.DC_select_best_model, 'Enable', 'on')
    set(handles.DC_save_session, 'Enable', 'on');
    
    
else
    set(handles.DC_pb_display, 'Enable', 'off')
    set(handles.DC_pb_apply_model, 'Enable', 'off')
    set(handles.DC_select_best_model, 'Enable', 'off')
    set(handles.DC_save_session, 'Enable', 'off');
    
end
% %
%  if isfield(handles,'selected_model')
%     if ~isempty(handles.selected_model)
%     set(handles.DC_pb_apply_model, 'Enable', 'on');
%     end
%  end

% Verify is parameters changed after feature computation
handles = Verify_computed_structures_up_to_date(handles, hObject);

% Set colors
%  handles = set_colorGUI(handles, hObject);

guidata(hObject, handles);

end

%% END OF FILE
% % %----------------------------------------------------------------------
% % %                  Brain Computer Interface team
% % % 
% % %                            _---~~(~~-_.
% % %                          _{        )   )
% % %                        ,   ) -~~- ( ,-' )_
% % %                       (  `-,_..`., )-- '_,)
% % %                      ( ` _)  (  -~( -_ `,  }
% % %                      (_-  _  ~_-~~~~`,  ,' )
% % %                        `~ -^(    __;-,((()))
% % %                              ~~~~ {_ -_(())
% % %                                     `\  }
% % %                                       { }
% % %   File created by A. BAELDE
% % %   Creation Date : 13/01/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
