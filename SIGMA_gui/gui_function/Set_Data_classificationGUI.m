function handles = Set_Data_classificationGUI(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_Data_classificationGUI(handles, hObject)
%
%   Function task:
%   % generate the Data classification GUI part display according to
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

% set classifiation mathod
DC_method = handles.init_parameter.classification_method;

if(strcmp(DC_method, 'LDA') > 0.5)
    set(handles.DC_rb_LDA, 'Value', 1);
elseif (strcmp(DC_method, 'QDA') > 0.5)
    set(handles.DC_rb_QDA, 'Value', 1);
elseif (strcmp(DC_method, 'SVM') > 0.5)
    set(handles.DC_rb_SVM, 'Value', 1);
elseif (strcmp(DC_method, 'DTC') > 0.5)
    set(handles.DC_rb_DTC, 'Value', 1);
end


%Set cross validation method
DC_CV_method = handles.init_parameter. cross_validation_method;

if(strcmp(DC_CV_method, 'LOEO') > 0.5)
    set(handles.DC_cb_LOEO, 'Value', 1);
elseif (strcmp(DC_method, 'LOSO') > 0.5)
    set(handles.DC_cb_LOSO, 'Value', 1);
end


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