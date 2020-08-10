function handles = DP_update_frequency_band(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = DP_update_frequency_band(handles, hObject)
%
%   Function task:
%   Update the frequency bands value accoring to the user choice
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
% something strange
handles.init_parameter.apply_filter = ones(size(handles.init_parameter.method));
handles.frequency_button_name = handles.init_parameter.frequency_button_name;

% Update frequency bands and check box state
% find number of button
nbButton = length(handles.init_parameter.frequency_button_name);
% load selected bands
selected_band = handles.init_parameter.selected_band;

for cButton = 1:(nbButton-1) % loop on all buttons except the "all" one
    % Get value of button
    check_value = get(eval( ['handles.' , handles.frequency_button_name{cButton} ]), 'Value');
%      check_value = get(eval( ['handles.' , ...
%          handles.init_parameter.frequency_button_name{cButton} ]), 'Value');
    % Modify selected band
    selected_band = DP_modify_selected_band(selected_band, cButton, check_value);
end


% Code the behavior of "all" button

if(length(selected_band) == (nbButton-1))
    set(eval( ['handles.' , handles.frequency_button_name{nbButton} ]), 'Value', 1);
else
    set(eval( ['handles.' , handles.frequency_button_name{nbButton} ]), 'Value', 0);
end

% Upsate data structure
nb_bands = length(selected_band);
handles.init_parameter.selected_band = selected_band;
handles.init_parameter.nb_bands = nb_bands;

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