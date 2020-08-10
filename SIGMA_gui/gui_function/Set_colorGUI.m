function handles = Set_colorGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_colorGUI(handles, hObject)
%
%   Function task:
%   
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
% Set colors of GUI

% Data loading
if( strcmp(get(handles.DL_pb_subject_select, 'Enable'),  'off')  ) % no data selected
    handles = DL_set_color(handles, hObject, 1);
elseif(strcmp(get(handles.DL_pb_subject_select, 'Enable'),  'on') && (length(handles.init_parameter.subject) < 0.5)) % data loaded but no subject selected
    handles = DL_set_color(handles, hObject, 2);
elseif(strcmp(get(handles.DL_pb_subject_select, 'Enable'),  'on') && (length(handles.init_parameter.subject) > 0.5)) % subject selected
    handles = DL_set_color(handles, hObject, 3);
end


% data processing
if( handles.init_parameter.nb_subject  < 0.5) % no subject selected
    handles = DP_set_color(handles, hObject, 1);
elseif( (handles.init_parameter.nb_subject > 0.5) &&  (handles.init_parameter.nb_bands > 0.5) )% 1 subject dans one band selected
    handles = DP_set_color(handles, hObject, 3);
else  % other cases
    handles = DP_set_color(handles, hObject, 2);
end

%Feature extraction
% OK : 1 subject, 1 band, 1 method
if( (length(handles.init_parameter.subject) > 0.5) &&  (handles.init_parameter.nb_bands > 0.5) && (length(handles.init_parameter.method) > 0.5))
    handles = FEM_set_color(handles, hObject, 3);
    % ready : 1 subject, 1 band, 0 method
elseif((length(handles.init_parameter.subject) > 0.5) &&  (handles.init_parameter.nb_bands > 0.5) && (length(handles.init_parameter.method) < 0.5))
    handles = FEM_set_color(handles, hObject, 2);
else
    handles = FEM_set_color(handles, hObject, 1);
end

% Feature ranking
% feature result non empty
if( isempty(handles.features_results) < 0.5 )
    handles = FR_set_color(handles, hObject, 3);
else
    handles = FR_set_color(handles, hObject, 1);
end


% Data classification

% OK : if feature ranking clasification results is enables
if( strcmp(get(handles.DC_pb_compute, 'Enable'),  'off') )
    handles = DC_set_color(handles, hObject, 1);
else
    handles = DC_set_color(handles, hObject,3);
end


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