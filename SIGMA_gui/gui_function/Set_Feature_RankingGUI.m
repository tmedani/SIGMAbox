function handles = Set_Feature_RankingGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_Feature_RankingGUI(handles, hObject)
%
%   Function task:
%   % generate the Feature Rankingn GUI part display according to
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



%Set nb feature
nb_feature = handles.init_parameter.nb_features;
set(handles.FR_edit_nb_feature, 'String', num2str(nb_feature));

% set probe probability
probe_threshold = handles.init_parameter.threshold_probe;
set(handles.FR_edit_probability_probe, 'String', num2str(probe_threshold));

% Ranking method
if(  isempty( strfind(handles.init_parameter.ranking_method, 'probe')) < 0.5  )
    set(handles.FR_rb_probe_variable, 'Value', 1);
else
    set(handles.FR_rb_nb_feature, 'Value', 1);
end


% set ranking method ( only gram schmidt available )
set(handles.FR_rb_GS, 'Value', 1);


%Set selected advanced method
set(handles.FR_st_selected_adv_method, 'String', handles.init_parameter.adv_ranking_method);


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
