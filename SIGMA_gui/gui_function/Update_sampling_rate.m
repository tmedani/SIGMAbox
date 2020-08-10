function Update_sampling_rate(handles, hObject)
%%%------------------------------------------------------------------------
%   Update_sampling_rate(handles, hObject)
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
resampling_active = get(handles.DP_cb_resampling_enable, 'Value');

if(  resampling_active == 1 )
    %Set  sampling rate at user choise
    
    %Get user sampling rate choice
    STR_user_sampling_rate = get(handles.DP_sampling_edit, 'String');
    % convert to number
    sampling_rate = str2double(STR_user_sampling_rate);
    % set user sampling rate
    set(handles.DP_st_experimental_sampling, 'String', sampling_rate)
    %Set resampling to 1 in inti_parameter
    handles.init_parameter.resample_data = 1; 
else
    % set sampling rat at data value
    set(handles.DP_st_experimental_sampling, 'String', num2str(handles.init_parameter.sampling_rate_by_data))
    % set sampling rate
    sampling_rate = handles.init_parameter.sampling_rate_by_data;
    % add no sample to init_parameter
    handles.init_parameter.resample_data = 0; 
    
end

% Set initparamer sampling rate
handles.init_parameter.sampling_rate = sampling_rate;

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







