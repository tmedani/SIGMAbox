function handles = DP_subject2left(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = DP_subject2left(handles, hObject)
%
%   Function task:
%   Manage the un-selection of subjects from the Data Processing list
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
% get selected methods
select_index = get(handles.DP_list_subject_selected, 'Value');
% Add unselected methods to handles
if ~isfield(handles,'unselected_subject')
    msgbox('SIGMA >> No Subject Selected' ,'SIGMA Message','warn');
    return
end
handles.unselected_subject = sort([ handles.unselected_subject , handles.selected_subject(select_index)]);
% remove method from selected
handles.selected_subject = setdiff(handles.selected_subject, handles.unselected_subject);

% update listbox by adding cell array of string containing subject names
unselected_subject_name = cell(1, length(handles.unselected_subject) );
if isempty(handles.init_parameter.subject_name)
    msgbox('SIGMA >> No Subject Selected' ,'SIGMA Message','warn');
    return;
end
for cM = 1:length(handles.unselected_subject)
    % version aurélien
    unselected_subject_name{cM} = handles.init_parameter.subject_name{handles.unselected_subject(cM)};
    % version takfarinas    
end
selected_subject_name = cell(1, length(handles.selected_subject) );
for cM = 1:length(handles.selected_subject)
    selected_subject_name{cM} = handles.init_parameter.subject_name{handles.selected_subject(cM)};
end
% Update list boxes
set( handles.DP_list_subject_selected, 'String', selected_subject_name )
set( handles.DL_list_subject_available, 'String', unselected_subject_name )
set( handles.DP_list_subject_selected, 'Value', 1)
set( handles.DL_list_subject_available, 'Value', 1)

handles.DP_suject_text.String=num2str(length(handles.DP_list_subject_selected.String));
handles.DL_suject_text.String=num2str(length((handles.init_parameter.subject_index)) - length(handles.DP_list_subject_selected.String));


%Update init parameter
handles.init_parameter.subject = handles.init_parameter.subject_index(handles.selected_subject);
handles.init_parameter.nb_subject = length(handles.init_parameter.subject);

Set_button_availability(handles, hObject)
guidata(hObject, handles);
disp(handles.selected_subject)
disp(handles.unselected_subject)

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