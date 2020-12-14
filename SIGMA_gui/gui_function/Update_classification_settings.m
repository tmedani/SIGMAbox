function handles = Update_classification_settings(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Update_classification_settings(handles, hObject)
%
%   Function task:
%   Update init_parameter data classification part using the user choice
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


% UPDATE CLASSIFICATION ALGORITHM
% get selected button
button_tag = char(get(handles.DC_bg_classification_method.SelectedObject, 'Tag'));
% Assing method to init_parameter
if( strcmp(button_tag , 'DC_rb_LDA'))
    handles.init_parameter.classification_method = 'LDA';
elseif(strcmp(button_tag , char('DC_rb_QDA')))
    handles.init_parameter.classification_method = 'QDA';
elseif(strcmp(button_tag , char('DC_rb_SVM')))
    handles.init_parameter.classification_method = 'SVM';
elseif(strcmp(button_tag , char('DC_rb_DTC')))
    handles.init_parameter.classification_method = 'DTC';
end


% UPDATE CROSS VALIDATION METHOD
button_tag = char(get(handles.DC_bg_cross_validation.SelectedObject, 'Tag'));
% Assing method to init_parameter
if( strcmp(button_tag , 'DC_cb_LOEO'))
    handles.init_parameter.cross_validation_method = 'LOEO';
elseif(strcmp(button_tag , char('DC_cb_LOSO')))
    handles.init_parameter.cross_validation_method = 'LOSO';
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