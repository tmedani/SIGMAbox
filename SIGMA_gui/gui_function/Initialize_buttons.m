function Initialize_buttons(handles, hObject)
%%%------------------------------------------------------------------------
%   Initialize_buttons(handles, hObject)
%
%   Function task:
%   Initialize the button value of the GUI
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
% select subjects
set(handles.DL_pb_subject_select, 'Enable', 'off');
% data viz
set(handles.DL_pb_data_viz, 'Enable', 'off');
% Subject remove
set(handles.DP_pb_subject_remove, 'Enable', 'off');
% compute features
set(handles.FEM_pb_compute, 'Enable', 'off');
% compute features
set(handles.FEM_pb_compute, 'Enable', 'off');
% compute features ranking
set(handles.FR_pb_compute_FR, 'Enable', 'off');
%visualize features ranking
set(handles.FR_pb_display_FR, 'Enable', 'off');
%visualize compute clasification
set(handles.DC_pb_compute, 'Enable', 'off');
%visualize display classification results
set(handles.DC_pb_display, 'Enable', 'off');

%takfarinas
%visualize display classification results
set(handles.DC_select_best_model, 'Enable', 'off');
set(handles.DC_save_session, 'Enable', 'off');

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