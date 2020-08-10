function i_handles = AM_subject2left(i_handles, hObject)
%%%------------------------------------------------------------------------
%   i_handles = AM_subject2left(i_handles, hObject)
%
%   Function task:
%   Manage the un-selection of subject from the list for applying the model
%   
%   Inputs :
%   i_handles : structure containing GUI informations
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
select_index = get(i_handles.AM_selected_data, 'Value');
% Add unselected methods to i_handles
if isempty(i_handles.selected_subject);
    return;
end
i_handles.unselected_subject = sort([ i_handles.unselected_subject , i_handles.selected_subject(select_index)]);
% remove method from selected
i_handles.selected_subject = setdiff(i_handles.selected_subject, i_handles.unselected_subject);

% Update list boxes
set( i_handles.AM_selected_data, 'String', i_handles.selected_subject );
set( i_handles.AM_available_data, 'String', i_handles.unselected_subject);
set( i_handles.AM_selected_data, 'Value', 1);
set( i_handles.AM_available_data, 'Value', 1);

%Update init parameter
% i_handles.init_parameter.subject = i_handles.init_parameter.subject_index(i_handles.selected_subject);
% i_handles.init_parameter.nb_subject = length(i_handles.init_parameter.subject);

guidata(hObject, i_handles);

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



