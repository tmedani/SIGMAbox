function Update_wavelet(handles, hObject)
%%%------------------------------------------------------------------------
%   Update_wavelet(handles, hObject)
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

% set wavelet button state
wavelet_active = get(handles.DP_cb_wavelet_enable, 'Value');
%if active, enable xavelet
if(wavelet_active == 1)
    handles.init_parameter.wavelet_transform = 1;
    % Activate edit button
    set(handles.DP_pb_wavelet_edit, 'Enable', 'on')
else
     handles.init_parameter.wavelet_transform = 0;
     %disable edit button
     set(handles.DP_pb_wavelet_edit, 'Enable', 'off')
end

% update gui data
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