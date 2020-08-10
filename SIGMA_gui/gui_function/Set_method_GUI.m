function handles = Set_method_GUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_method_GUI(handles, hObject)
%
%   Function task:
%   Manage the feature extraction method GUI
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
% Create a cell array of method name
nb_method = length(handles.init_method);
% assign method numbers
sm = 1; % selected method index
usm = 1; %unselected method index
unselected_method_names = {};
selected_method_names = {};

for cM = 1:nb_method
    if( isempty(find( handles.init_parameter.method == cM)) > 0.5)
       % Aurélien version
       % unselected_method_names{usm} = handles.init_method(cM).method_name;
        % takfarinas 29/01/2018 colored version
        unselected_method_names{usm} = handles.init_method(cM).method_color_html; 
        % correction Takfa
        usm=usm+1;
    else        
        % Aurélien version
        %selected_method_names{sm} = handles.init_method(cM).method_name;
        % takfarinas 29/01/2018 colored version
        selected_method_names{usm} = handles.init_method(cM).method_color_html;        
        % correction Takfa
        sm=sm+1;
    end
end

% % verification
% if(length(selected_method_names ) ~= handles.init_parameter.nb_method)
%     error('The length of the input method is not correct')
% end

%display methods in list
% unselected_method_names=unselected_method_names_takfa;
                
set(handles.FEM_unselected, 'String', unselected_method_names);
set(handles.FEM_unselected, 'Max', max(length(unselected_method_names), 1));

set(handles.FEM_nb_available_methode,'String',length(unselected_method_names))

% add method names and numbers in handles
handles.selected_method = handles.init_parameter.method;
handles.unselected_method = setdiff(1:nb_method, handles.init_parameter.method);

% change selection limit of selected method
% aurélien
% set(handles.FEM_unselected, 'String', selected_method_names);
% set(handles.FEM_unselected, 'Max', max(length(unselected_method_names),1));
% takfarinas 10/04/2018
index_not_empty = (~cellfun(@isempty,selected_method_names));
set(handles.FEM_selected, 'String', selected_method_names(index_not_empty));
set(handles.FEM_selected, 'Max', max(length(unselected_method_names),1));

% modification takfarinas 10/04/2018
if ~isfield(handles,'sigma_load_session')
    %if handles.sigma_load_session == 1
        % aurélien sans condition if
        handles = FEM_method2right(handles, hObject);
        handles = FEM_method2left(handles, hObject);
    %end
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
