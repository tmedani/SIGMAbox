function handles = AM_subject2right(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = AM_subject2right(handles, hObject)
%
%   Function task:
%   Manage the selection of subjects from the list for applying the model
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

% get selected subject
select_index = get(handles.AM_available_data, 'Value');
% Add selected subject to handles
if isempty(handles.unselected_subject)
    return;
end
handles.selected_subject = sort([ handles.selected_subject , handles.unselected_subject(select_index)]);
% Remove method from un selected
handles.unselected_subject = setdiff(handles.unselected_subject, handles.selected_subject);

% Update list Boxes
set( handles.AM_selected_data, 'String', handles.selected_subject )
set( handles.AM_available_data, 'String', handles.unselected_subject )
set( handles.AM_selected_data, 'Value', 1)
set( handles.AM_available_data, 'Value', 1)

% Update init parameter
% handles.init_parameter.subject = handles.init_parameter.subject_index(handles.selected_subject);
% handles.init_parameter.nb_subject = length(handles.init_parameter.subject);

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