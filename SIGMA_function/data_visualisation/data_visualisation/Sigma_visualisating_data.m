function  Sigma_visualisating_data(varargin)
%==========================================================================
%% This function is part of the BCI toolbox, it's used by the main function to call the Data-visualization GUI.
%==========================================================================

if nargin == 0
    init_parameter=Sigma_parameter_initialisation;
    init_parameter.subject_index = init_parameter.subject(1);
    uiwait(msgbox(['You have selected defaut mode, the first subject' ...
                    ' in SIGMA_data will be displayed'],...
                    'SIGMA Message','warn'));
end

if nargin == 1
    handles=varargin{1};
    init_parameter=handles.init_parameter;
    
    init_parameter.subject_index = 1;
    uiwait(msgbox(['You have selected defaut mode, the first subject' ...
                    ' in SIGMA_data will be displayed'],...
                    'SIGMA Message','warn'));
end

if nargin == 2
    handles=varargin{1};
    init_parameter=varargin{2};
    handles.init_parameter=init_parameter;
end

 if isfield(init_parameter, 'sigma_display_data') 
     if init_parameter.sigma_display_data==1
     %launch visualisation of data
     %Sigma_related_toolbox_and_file(mfilename)
     handles.init_parameter = init_parameter;
     Sigma_data_visualisation(handles);
     end
 else
     disp('SIGMA>> Visulisation data is not selected')
 end
 
 %varargout = handles;
end
%%
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
% % %   File modified by Takfarinas MEDANI
% % %   Creation Date : 08/09/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : takfarinas.medani@espci.fr    
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------