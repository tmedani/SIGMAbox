function handles = FE_set_frequency_bandsGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = FE_set_frequency_bandsGUI(handles, hObject)
%
%   Function task:
%   Set the GUI values of frequency bands accoring to user choice
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
% Update init_paramter using values provided by edit fields

nbButton = length(handles.init_parameter.frequency_button_name);
for cB = 1:(nbButton-1) % minimum values
    % add value to field
    set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_mf' ] ), 'String', num2str(handles.init_parameter.freq_bands(cB,1)));
end

for cB = 1:(nbButton-1) % maximum values
    set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_maf' ] ), 'String', num2str(handles.init_parameter.freq_bands(cB,2)));
end

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

