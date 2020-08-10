function handles = Call_method_edit_gui(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Call_method_edit_gui(handles, hObject)
%
%   Function task:
%   Call the GUI used to modify the feature extraction method parameters
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

% choice of the current method selected
method_number = get(handles.FEM_selected, 'Value');
init_met_method_number = handles.selected_method(method_number);
[nb_parameter_to_change, parameter_index] = Check_method_editable_parameter(handles.init_method(init_met_method_number));

% Call gui and make the principal invisible
set(handles.learning_panel, 'Visible', 'off')
varargout = Method_edit_gui(handles.init_method(init_met_method_number));
set(handles.learning_panel, 'Visible', 'on')

% Change method paramters according to gui and update init_method
handles.init_method(init_met_method_number) = varargout;


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