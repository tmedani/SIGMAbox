function Sigma_3DScatterPlot(init_parameter,init_method,feature_result)
%%%------------------------------------------------------------------------
%   handles = Compute_features(handles, hObject)
%
%   Function task:
%   Load the features provided by the user
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


 % TODO : The hyper plan should be added from the classification method

data_in.feature_result=feature_result;
data_in.init_parameter=init_parameter;
data_in.init_method=init_method;

% Check the size of the best matrix!
if size(feature_result.o_best_features_matrix,1)<3
    msgbox('The Best feature matrix contain less then 3 features, 3D presentation is impossible ...',...
        'SIGMA Error','error','modal');
    return;
else
    clickA3DPoint(data_in)
end
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
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 03/11/2016
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------

