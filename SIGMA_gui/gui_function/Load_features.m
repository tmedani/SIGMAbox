function handles = Load_features(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Compute_features(handles, hObject)
%
%   Function task:
%   Load the features provided by the user
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
init_parameter = handles.init_parameter;
feature_result = handles.feature_result;
init_method = handles.init_method;
if isfield(handles,'AM_Load_custom_feature')
    AM_Load_custom_feature = handles.AM_Load_custom_feature;
    feature_result.AM_Load_custom_feature = AM_Load_custom_feature;
end
[init_parameter_custom,feature_result_custom] = ...
      Sigma_load_custom_feature(init_parameter,init_method,feature_result);

if isempty(init_parameter_custom)&& isempty(feature_result_custom)
    %msgbox('No file selected','SIGMA Warning','warn')
    return
else
    % mettre a jour le nom de la session
    init_parameter_custom.session_name = init_parameter.session_name;
    init_parameter_custom.full_session_name = ...
                                          init_parameter.full_session_name;
    init_parameter_custom.logFilename = init_parameter.logFilename;
    init_parameter_custom.diaryFilename = init_parameter.diaryFilename;   
    
    init_parameter=init_parameter_custom;
    feature_result=feature_result_custom;    
end

handles.init_parameter=init_parameter;
handles.feature_result=feature_result;
% remove the feature associated for each method after the assembling
if ~isfield(handles.feature_result,'remove_individual_features')
    handles.feature_result.remove_individual_features=...
        handles.init_parameter.remove_individual_features;
else
    handles.feature_result.remove_individual_features=...
        handles.init_parameter.remove_individual_features;
end
% assemble the features, to get the BIG o_feature_matrix
feature_result=Sigma_feature_assembling...
                               (init_method,init_parameter,feature_result);
handles.feature_result=feature_result;
handles.feature_result.o_features_matrix_original = ...
                                  handles.feature_result.o_features_matrix;
%% Feature normalisation (ZSCORE)
handles.feature_result.o_features_matrix_normalize = ... 
                    (zscore((handles.feature_result.o_features_matrix)'))';

% number of computed features and epoch
handles.feature_result.nb_features = ...
                         size(handles.feature_result.o_features_matrix, 1);
handles.feature_result.nb_epoch = ...
                         size(handles.feature_result.o_features_matrix, 2);

% Display results Linear separability
tf=handles.feature_result.linear_Separability+1;
yes_or_no={'No','Yes'};
set(handles.FEM_st_linear_separability, 'String', yes_or_no(tf));
set(handles.learning_panel, 'Visible', 'on')

% Display results
set(handles.FEM_st_nb_features_computed, 'String', ...  
                                       handles.feature_result.nb_features);
% Display results
set(handles.FEM_st_nb_epoch_computed, 'String',...
                                          handles.feature_result.nb_epoch);
% Set the maximum number of feature in Feature Ranking and change
% init_method
set(handles.FR_edit_nb_feature, 'String', ...
                                       handles.feature_result.nb_features);
handles.init_parameter.nb_features = handles.feature_result.nb_features;

% Set the compute structure
handles.computed.subject = handles.init_parameter.subject;
handles.computed.freq_band = handles.init_parameter.selected_band;
handles.computed.init_method = handles.init_method;
handles.computed.threshold_probe = handles.init_parameter.threshold_probe;
handles.computed.nb_features = handles.init_parameter.nb_features;
% just to inform the loading process
handles.load_custom_feature=1;

% set the button availability
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
% % %   File created by T. MEDANI
% % %   Creation Date : 25/01/2018
% % %   Updates and contributors :
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------