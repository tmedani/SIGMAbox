function handles = FR_set_color(handles, hObject, nb_color)
%%%------------------------------------------------------------------------
%   handles = FR_set_color(handles, hObject, nb_color)
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

% set color of Feature ranking
set(handles.FR, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_bg_nb_feature, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_bg_ranking_method, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_rb_nb_feature, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_rb_probe_variable, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_st_probe_probability_desc, 'BackgroundColor', handles.color{nb_color});
set(handles.FR_rb_GS, 'BackgroundColor', handles.color{nb_color});

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