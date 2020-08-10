function handles = FEM_method2left(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = FEM_method2left(handles, hObject)
%
%   Function task:
%   Manage the un-selection of feature extraction method
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
 select_index = get(handles.FEM_selected, 'Value');

% Add unselected methods to handles
if ~isempty(handles.selected_method)
    handles.unselected_method = sort([ handles.unselected_method , handles.selected_method(select_index)]);
else
    msgbox('There no method to remove','SIGMA Warning','warn');
    return
end

%handles.unselected_method
% remove method from selected
handles.selected_method = setdiff(handles.selected_method, handles.unselected_method);
%handles.selected_method

% update listbox
%  Create new cell array
unselected_method_name = cell(1, length(handles.unselected_method) );
for cM = 1:length(handles.unselected_method)
    % Aurélien version
    %unselected_method_name{cM} = handles.init_method(handles.unselected_method(cM)).method_name;
    
    % takfarinas 29/01/2018 colored version
    unselected_method_name{cM} = handles.init_method(handles.unselected_method(cM)).method_color_html;    
end

selected_method_name = cell(1, length(handles.selected_method) );
for cM = 1:length(handles.selected_method)
    % Aurélien version
    %selected_method_name{cM} = handles.init_method(handles.selected_method(cM)).method_name;
    
    % takfarinas 29/01/2018 colored version
     selected_method_name{cM} = handles.init_method(handles.selected_method(cM)).method_color_html;   
end


    
    unselected_method = handles.unselected_method;
    wt_method_list = handles.init_parameter.wt_method_list;
    wt_method_unselected = unselected_method(unselected_method>=wt_method_list(1) & unselected_method<=wt_method_list(end));
    handles.wt_method_unselected = wt_method_unselected;

set( handles.FEM_selected, 'String', selected_method_name )
set( handles.FEM_unselected, 'String', unselected_method_name )

set( handles.FEM_unselected, 'Value', 1)
set( handles.FEM_selected, 'Value', 1)

set( handles.FEM_unselected, 'Max', length(handles.unselected_method ))
set( handles.FEM_selected, 'Max', length(handles.selected_method ))

set( handles.FEM_nb_selected_methode, 'String', length(handles.selected_method ))
set( handles.FEM_nb_available_methode, 'String', length(handles.unselected_method))



% uptade init_parameter
handles.init_parameter.method = handles.selected_method;
handles.init_parameter.nb_method = length(handles.init_parameter.method);
handles.init_parameter.apply_filter = ones(size(handles.init_parameter.method));

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