function [feature_matrix_all_term, feature_matrix_cross_term,...
            feature_matrix_cross_term_id] = Sigma_creat_cross_term_feature...  
                                                    (input_feature_matrix)
%%%------------------------------------------------------------------------
%   [feature_matrix_cross_term, feature_matrix_all_term] = ...
%                       Sigma_creat_cross_term_feature(input_feature_matrix)
%
%   Function task:
%   Compute the first ordre cross terme from a Matrix feature
%
%   Inputs :
%   input_feature_matrix : structure containing GUI informations
%
%   Outputs :
%   feature_matrix_all_term   : the feature matrix containing all the terms
%                               simple and cross, size of n(n+1) feature
%                               and m epochs (examples)
%   feature_matrix_cross_term : Only the feature matrix of the cross terms
%   feature_matrix_cross_term_id : An identification of the cross feature matrix
%                           containing the combinairon of the index of the
%                           original feature
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

% cross terms for feature matrix
% size(features_results.o_features_matrix)
%
% feature = features_results.o_features_matrix;
%
% feature = [4 5 6;4 5 6;4 5 6;4 5 6;4 5 6];

feature = input_feature_matrix;

cross_feature = [];
cross_feature_id = [nan(size(feature,1),2)];
for ind = 1:size(feature,2)
    cross_feature_epoch = [];
    for ind1 = 1:size(feature,1)
        temp = feature(ind1,ind)*feature(:,ind);
        cross_feature_epoch = [cross_feature_epoch;temp];
        if ind==1
            cross_feature_id = [cross_feature_id; repmat(ind1,length(feature(:,ind)),1) (1:length(feature(:,ind)))'];
        end
    end
    cross_feature = [cross_feature cross_feature_epoch];
end

all_feature = [feature;cross_feature];

% The outputs : 

feature_matrix_all_term  =  all_feature;
feature_matrix_cross_term  =  cross_feature;
feature_matrix_cross_term_id  =  cross_feature_id;

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
% % %   File created by T. MEDANI
% % %   Creation Date : 12/01/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------

