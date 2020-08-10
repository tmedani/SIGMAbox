function handles = DL_set_color(handles, hObject, nb_color)
%%%------------------------------------------------------------------------
%   handles = DL_set_color(handles, hObject, nb_color)
%
%   Function task:
%
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






set(handles.DL, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_path_text, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_Data_Compatibility_info, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_info_subject, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_Data_Compatibility_text, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_suject_text, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_subject_list_text, 'BackgroundColor', handles.color{nb_color});
set(handles.DL_panel_data_visualisation, 'BackgroundColor', handles.color{nb_color});


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