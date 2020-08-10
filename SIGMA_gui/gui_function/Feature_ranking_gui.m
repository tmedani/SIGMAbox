function handles = Feature_ranking_gui(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Feature_ranking_gui(handles, hObject)
%
%   Function task:
%   Call the feature ranking method core function
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
% Rank features
handles.feature_result = Sigma_feature_ranking3(handles.init_parameter ,...
                        handles.init_method , handles.feature_result);
%handles.init_parameter.nb_features = handles.feature_result.nb_features;

% Set the computed structure
handles.computed.init_parameter = handles.init_parameter;
handles.computed.init_method = handles.init_method;
handles.computed.feature_result = handles.feature_result;
handles.computed.DL = handles.DL;
handles.computed.DP = handles.DP;
handles.computed.FR = handles.FR;

% computed gui
handles.computed.subject = handles.init_parameter.subject;
handles.computed.freq_band = handles.init_parameter.selected_band;
handles.computed.init_method = handles.init_method;
handles.computed.threshold_probe = handles.init_parameter.threshold_probe;
handles.computed.nb_features = handles.init_parameter.nb_features;


Set_button_availability(handles, hObject);
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
 


