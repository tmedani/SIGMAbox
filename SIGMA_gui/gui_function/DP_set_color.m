function handles = DP_set_color(handles, hObject, nb_color)
%%%------------------------------------------------------------------------
%   handles = DP_set_color(handles, hObject, nb_color)
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



set(handles.DP, 'BackgroundColor', handles.color{nb_color});
set(handles.DP_panel_frequency_band, 'BackgroundColor', handles.color{nb_color});
set(handles.DP_panel_sampling_rate, 'BackgroundColor', handles.color{nb_color});
for cB = 1:(length(handles.frequency_button_name))
    set(eval( ['handles.' handles.frequency_button_name{cB} ] ), 'BackgroundColor', handles.color{nb_color});
end
for cB = 1:(length(handles.frequency_button_name)-1)
    set(eval( ['handles.DP_st_',  lower(handles.frequency_button_name{cB}(4:end)) ] ), 'BackgroundColor', handles.color{nb_color});
end

set(handles.DP_st_exp_SR, 'BackgroundColor', handles.color{nb_color});
set(handles.DP_st_experimental_sampling, 'BackgroundColor', handles.color{nb_color});
set(handles.DP_MHZ, 'BackgroundColor', handles.color{nb_color});
set(handles.DP_cb_resampling_enable, 'BackgroundColor', handles.color{nb_color});

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