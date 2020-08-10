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
    % takfa
    set(handles.lda_menubar,'Checked','on');
    set(handles.qda_menubar,'Checked','off');
    set(handles.svm_menubar,'Checked','off');
elseif(strcmp(button_tag , char('DC_rb_QDA')))
    handles.init_parameter.classification_method = 'QDA';
    % takfa
    set(handles.lda_menubar,'Checked','off');
    set(handles.qda_menubar,'Checked','on');
    set(handles.svm_menubar,'Checked','off');
elseif(strcmp(button_tag , char('DC_rb_SVM')))
    handles.init_parameter.classification_method = 'SVM';
    % takfa
    set(handles.lda_menubar,'Checked','off');
    set(handles.qda_menubar,'Checked','off');
    set(handles.svm_menubar,'Checked','on');
elseif(strcmp(button_tag , char('DC_rb_DTC')))
    handles.init_parameter.classification_method = 'DTC';
    % takfa
    set(handles.lda_menubar,'Checked','off');
    set(handles.qda_menubar,'Checked','off');
    set(handles.svm_menubar,'Checked','off');
end


% UPDATE CROSS VALIDATION METHOD
button_tag = char(get(handles.DC_bg_cross_validation.SelectedObject, 'Tag'));
% Assing method to init_parameter
if( strcmp(button_tag , 'DC_cb_LOEO'))
    handles.init_parameter.cross_validation_method = 'LOEO';
    %takfa
    set(handles.loso_menubar,'Checked','off');
    set(handles.loeo_menubar,'Checked','on');
    
elseif(strcmp(button_tag , char('DC_cb_LOSO')))
    handles.init_parameter.cross_validation_method = 'LOSO';
    
    %takfa
    set(handles.loso_menubar,'Checked','on');
    set(handles.loeo_menubar,'Checked','off');
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