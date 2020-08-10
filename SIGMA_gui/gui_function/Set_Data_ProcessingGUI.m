function handles = Set_Data_ProcessingGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_Data_ProcessingGUI(handles, hObject)
%
%   Function task:
%   % generate the Data Processing GUI part display according to
%   init_parameter
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
%Set frequency bands
selected_band = handles.init_parameter.selected_band;

set(handles.DP_delta, 'Value', 1-isempty(find(selected_band == 1)) );
set(handles.DP_theta, 'Value', 1-isempty(find(selected_band == 2)) );
set(handles.DP_mu, 'Value', 1-isempty(find(selected_band == 3)) );
set(handles.DP_alpha, 'Value', 1-isempty(find(selected_band == 4)) );
set(handles.DP_beta, 'Value', 1-isempty(find(selected_band == 5)) );
set(handles.DP_gamma, 'Value', 1-isempty(find(selected_band == 6)) );
set(handles.DP_gamma_high, 'Value', 1-isempty(find(selected_band == 7)) );
set(handles.DP_total_bandwidth, 'Value', 1-isempty(find(selected_band == 8)) );
set(handles.DP_all, 'Value', 1-isempty(find(selected_band == 9)) );


% set all buttons on the value of "all"
% Modifiaction Takfarinas 20/04/2018
if isfield(handles,'sigma_load_session')
    if handles.sigma_load_session ==1
        Set_all_frequency_button_on(handles, hObject)
    end
else
    Set_all_frequency_button_on(handles, hObject)
end

% update init parameter
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);


% set resample
% set resample button
set(handles.DP_cb_resampling_enable, 'Value', handles.init_parameter.resample_data);
%Set resample value
%set(handles.DP_sampling_edit, 'String', num2str(handles.init_parameter.sampling_rate_by_default))
set(handles.DP_st_experimental_sampling, 'String', num2str(handles.init_parameter.sampling_rate_by_data))


% update methods
handles = Update_method_from_principal_gui(handles, hObject);

%Diverse updates
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