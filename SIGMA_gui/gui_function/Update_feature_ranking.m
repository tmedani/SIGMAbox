function handles = Update_feature_ranking(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Update_feature_ranking(handles, hObject)
%
%   Function task:
%   Update init_parameter feature ranking part using the user choice
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

% UPDATE NUMBER OF FEATURE
%Get maximum features number
if(isempty(handles.feature_result) < 0.5)
    mmax = size(handles.feature_result.o_features_matrix, 1);
else
    mmax = 1;
end
% get numeric value
nb_feature_str = get(handles.FR_edit_nb_feature, 'String');
% Conversion
[nb_feature, status] = str2num(nb_feature_str);
if(status == 1)
    rectified_value = min(max(round(nb_feature), 1), mmax);
    handles.init_parameter.nb_features = rectified_value;
    set(handles.FR_edit_nb_feature, 'String', rectified_value),
else
    set(handles.FR_edit_nb_feature, 'String', 'badformat');
end

% UPDATE probe probability
% get numeric value
nb_probe_str = get(handles.FR_edit_probability_probe, 'String');
% Conversion
[nb_probe, status] = str2num(nb_probe_str);
if(status == 1)
    rectified_value = max(min(nb_probe, 1), 0);
    handles.init_parameter.threshold_probe = rectified_value;
    set(handles.FR_edit_probability_probe, 'String', rectified_value),
else
    set(handles.FR_edit_probability_probe, 'String', 'badformat');
end


% UPDATE NOMBER FEATURES and probe variable choice
% get selected button
button_tag = char(get(handles.FR_bg_nb_feature.SelectedObject, 'Tag'));
% Assing method to init_parameter
if( strcmp(button_tag , 'FR_rb_nb_feature'))
    stop_criteria = '';
elseif(strcmp(button_tag , char('FR_rb_probe_variable')))
    % TO CHANGE ACCORDING TO TOOLBOX
    stop_criteria = '_probe';
end


% UPDATE RANKING METHOD
% get selected button
button_tag = char(get(handles.FR_bg_ranking_method.SelectedObject, 'Tag'));
if( strcmp(button_tag , 'FR_rb_GS'))
% Assing method to init_parameter
    ranking_method = 'gram_schmidt';
    %Enable probe variable
    set(handles.FR_rb_probe_variable, 'Enable', 'on')
    set(handles.FR_edit_probability_probe, 'Enable', 'on')
else
     ranking_method = handles.init_parameter.adv_ranking_method;
     stop_criteria = '';
     % disable probe variable because not compatible with advances methods
     set(handles.FR_rb_probe_variable, 'Enable', 'off')
    set(handles.FR_edit_probability_probe, 'Enable', 'off')
end

% update init_parameter
handles.init_parameter.ranking_method = [ ranking_method, stop_criteria ];

%Update ranking display
set(handles.FR_st_selected_adv_method, 'String', handles.init_parameter.adv_ranking_method )



% update button status
Set_button_availability(handles, hObject)

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