function handles = Init_parameter2gui(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Init_parameter2gui(handles, hObject)
%
%   Function task:
%   Use the init_paramter informations to generate the GUI display
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
% set gui display from init_parameter values

% Set data loading
handles = Set_Data_LoadingGUI(handles, hObject);

%set Data processing
handles = Set_Data_ProcessingGUI(handles, hObject);

% set feature computation
handles = Set_Feature_ExtractionGUI(handles, hObject);

%set feature ranking
handles = Set_Feature_RankingGUI(handles, hObject);

%set data classification
handles = Set_Data_classificationGUI(handles, hObject);

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