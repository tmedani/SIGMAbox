function handles = Set_Data_LoadingGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_Data_LoadingGUI(handles, hObject)
%
%   Function task:
%   % generate the Data loading GUI part display according to
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

% load subject and initialize subjects
handles = DL_load_subjects(handles, hObject);

% set selected subjects
% update listbox
selected_subject_name = cell(1, length(handles.init_parameter.subject) );
% update listbox by adding cell array of string containing subject names
for l_subject_number = 1:length(handles.init_parameter.subject)
    % aurélien version
    %selected_subject_name{l_subject_number} = handles.init_parameter.subject_name{handles.init_parameter.subject(l_subject_number)};

    %takfa version
    subject = handles.init_parameter.subject(l_subject_number); % the select subject for the simulation
    subject_index = handles.init_parameter.subject_index ;% the real list subject (all subject)
    ind = find(subject_index == subject);
    selected_subject_name{l_subject_number} = handles.init_parameter.subject_name{ind};
    
    % encore takfa
    % handles.selected_subject=handles.init_parameter.subject;
%     subject_number=handles.init_parameter.subject_number % the ranking on the subject in the list

end
% aurélien
if ~isfield(handles,'sigma_load_session')
    unselected_subject = setdiff(handles.init_parameter.subject_number, handles.init_parameter.subject);
    unselected_subject_name = cell(1, length(unselected_subject) );
    for l_unselect_subject = 1:length(unselected_subject)
        unselected_subject_name{l_unselect_subject} = handles.init_parameter.subject_name{unselected_subject(l_unselect_subject)};
    end
end
%takfa 10 04 2018
if isfield(handles,'sigma_load_session')
    if handles.sigma_load_session == 1
        unselected_subject = setdiff(handles.init_parameter.subject_index, handles.init_parameter.subject);
        
        unselected_subject_name = cell(1, length(unselected_subject) );
        for l_unselect_subject = 1:length(unselected_subject)
            unselected_subject_name{l_unselect_subject} = ['subject_' num2str(unselected_subject(l_unselect_subject))];
        end
        
    end
end


% set the number of available subjects
set(handles.DL_suject_text, 'String', num2str(length(handles.init_parameter.subject)));
% Update list Boxes
set( handles.DP_list_subject_selected, 'String', selected_subject_name )
set( handles.DL_list_subject_available, 'String', unselected_subject_name )

set( handles.DP_list_subject_selected, 'Value', 1)
set( handles.DL_list_subject_available, 'Value', 1)

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