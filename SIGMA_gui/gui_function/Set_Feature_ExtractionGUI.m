function handles = Set_Feature_ExtractionGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_Feature_ExtractionGUI(handles, hObject)
%
%   Function task:
%   % generate theFeature Extraction GUI part display according to
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

% Update the method list
handles = Set_method_GUI(handles, hObject);

set(handles.FEM_st_nb_features_computed, 'String', num2str(0)),
set(handles.FEM_st_nb_epoch_computed, 'String', num2str(0)),

% Display results Linear separability
% tf=handles.feature_result.linear_Separability+1;
% yes_or_no={'No','Yes'};
set(handles.FEM_st_linear_separability, 'String', 0);


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