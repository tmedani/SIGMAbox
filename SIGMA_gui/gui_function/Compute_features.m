function handles = Compute_features(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Compute_features(handles, hObject)
%
%   Function task:
%   Compute the features based on the signal provided by the user
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
% this function compute feature used for classification

% get sampling rate of data
handles.init_parameter.sampling_rate_default = 0;
handles.init_parameter = Sigma_frequency_initialisation(handles.init_parameter);
% /§§§§§!!!!! modify this function to allow for resampling : init_parameter=Sigma_resampling_init(init_parameter)

% compute filter parameters
handles.init_parameter = Sigma_filter_parameter(handles.init_parameter);
handles.init_method = Sigma_method_initialisation(handles.init_parameter);

% make the gui invisible
% modification takfa
if handles.init_parameter.gui_visible==1 
    set(handles.learning_panel, 'Visible', 'on')
else
    set(handles.learning_panel, 'Visible', 'off')
end


handles.feature_result = Sigma_feature_extraction(handles.init_parameter,handles.init_method);
if isempty(handles.feature_result)
    return;
end
%% Features assembling
% remove the feature associated for each method after the assembling
%handles.feature_result.remove_individual_features='N';
% assemble the features, get the BIG o_feature_matrix

handles.feature_result = Sigma_feature_assembling(handles.init_method,handles.init_parameter,handles.feature_result);
handles.feature_result.o_features_matrix_original = handles.feature_result.o_features_matrix;

%% Feature normalisation (ZSCORE)
%handles.feature_result.o_features_matrix_normalize = (zscore((handles.feature_result.o_features_matrix)'))';

% number of computed features and epoch
handles.feature_result.nb_features = size(handles.feature_result.o_features_matrix, 1);
handles.feature_result.nb_epoch = size(handles.feature_result.o_features_matrix, 2);

% make the gui visible
% modification takfa
% if handles.init_parameter.gui_visible==1 
%     set(handles.learning_panel, 'Visible', 'on')
% else
%     set(handles.learning_panel, 'Visible', 'on')
% end
set(handles.learning_panel, 'Visible', 'on')


% Display results
set(handles.FEM_st_nb_features_computed, 'String', handles.feature_result.nb_features)
% Display results
set(handles.FEM_st_nb_epoch_computed, 'String', handles.feature_result.nb_epoch)

% Display results Linear separability
tf=handles.feature_result.linear_Separability+1;
yes_or_no={'No','Yes'};
set(handles.FEM_st_linear_separability, 'String', yes_or_no(tf));

% Set the maximum number of feature in Feature Ranking and change
% init_method
set(handles.FR_edit_nb_feature, 'String', handles.feature_result.nb_features)
handles.init_parameter.nb_features = handles.feature_result.nb_features;

% Set the compute structure
handles.computed.subject = handles.init_parameter.subject;
handles.computed.freq_band = handles.init_parameter.selected_band;
handles.computed.init_method = handles.init_method;
handles.computed.threshold_probe = handles.init_parameter.threshold_probe;
handles.computed.nb_features = handles.init_parameter.nb_features;




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



