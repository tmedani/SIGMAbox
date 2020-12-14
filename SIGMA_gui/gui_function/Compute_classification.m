function handles = Compute_classification(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Compute_classification(handles, hObject)
%
%   Function task:
%   Compute the classification model using the selected features 
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
%% Pre calculations
% Determine what to compute before classification
if handles.load_custom_feature==0
c1 = isequal(handles.computed.subject, handles.init_parameter.subject);
c2 = isequal(handles.computed.freq_band, handles.init_parameter.selected_band);
c3 = isequal(handles.computed.init_method, handles.init_method);
c4 = isequal(handles.computed.threshold_probe, handles.init_parameter.threshold_probe);
c5 = isequal(handles.computed.nb_features, handles.init_parameter.nb_features);
end
% modification takfa
if handles.load_custom_feature==1
c1 = 1;c2 = 1;c3 = 1;c4 = 1;c5 = 1;
end

% 
% if( c1*c2*c3 < 0.5 ) % compute features
%     disp('features need to be re-cmputed : you changed them')
%     handles = Compute_features(handles, hObject);
%     %handles = Ceature_ranking_gui(handles, hObject);
% elseif( c4*c5 < 0.5) % rank features
%     %handles = Ceature_ranking_gui(handles, hObject);
% end

% Hide the principal panel
set(handles.learning_panel, 'Visible', 'on')
disp('not visible')

%% Calculation of classification
%Compute classification
handles.performance_result = Sigma_cross_validation(handles.feature_result,handles.init_parameter,handles.init_method);


%% Update of GUI
set(handles.learning_panel, 'Visible', 'on')
disp('visible')
% updates button and handles
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