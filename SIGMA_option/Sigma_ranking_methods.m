function [ranking, performance_ranking]=Sigma_ranking_methods...
            (init_parameter,features,label,nb_feature,ranking_method_name)
%%%------------------------------------------------------------------------
%  init_parameter = Sigma_parameter_initialisation(varargin)
%
%  Function task:
% 
%     [ranking]=Sigma_ranking_methods(init_parameter,features,label,nb_feature,ranking_method)
%     Computes ranks of the nb_feature attributes (predictors) for input data matrix features
%     and response vector label, using the specified method ranking_method
%     among the following list by the number of the method
%     ranking_method_name={'relieff','fsv','llcfs','inffs','LaplacianScore','MCFS','udfs','cfs'}
% 
%     % Liste of the ranking methods available in this toolbox: (work with matlab without any extension)
%     these methods are available on the FS library
%      Matlab Code-Library for Feature Selection
%      A collection of S-o-A feature selection methods
%      Version 4.2.17 April 2017
%      Support: Giorgio Roffo
%      E-mail: giorgio.roffo@glasgow.ac.uk
%     Please refers to this toolbox for more details and the related paper :
%     Feature Selection Library (MATLAB Toolbox), Giorgio Roffo
% 
%  Inputs :
%
%  Outputs :
%
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------

% Initialisation

X_train=features;
Y_train=label;
numF=nb_feature;


%ranking_method_liste=
% {'gram_schmidt','gram_schmidt_probe','relieff','fsv','llcfs','Inf-FS',
%                                    'LaplacianScore','MCFS','udfs','cfs'};

ranking_method_selected=ranking_method_name;

switch lower(ranking_method_selected)
    
    case 'gram_schmidt'
        
        [ranking,cosines] = gram_schmidt(X_train,Y_train , numF); % cosinus angle best ranging
        performance_ranking=cosines;
    case 'gram_schmidt_probe'
        %o_features_matrix=features;
        ic_feature=features;
        ic_output=label';
        ic_threshold= init_parameter.threshold_probe;
        ranking_selected = Sigma_ofr_with_probe(ic_feature', ic_output, ic_threshold);
        if ~isempty(ranking_selected)
            idx_best_features=ranking_selected(:,1);
            performance_ranking=ranking_selected(:,2);
        else
            idx_best_features=[];
            performance_ranking=[];
        end
        ranking=idx_best_features;
    case 'relieff' %%  OK
        %% Supervised
        % Relief-F
        [ranking, w] = reliefF( X_train', Y_train', 20);
        %ranking_relieff=ranking(1:numF);
        performance_ranking=w(1:numF);
        %ranking=
    case 'fsv'
        [ ranking , w] = fsvFS( X_train', Y_train', numF );
        %ranking_fsv=ranking(1:numF);
        performance_ranking=w(1:numF);
    case 'llcfs'
        % Feature Selection and Kernel Learning for Local Learning-Based Clustering
        [ranking, perfor]= llcfs( X_train' );
        %ranking_llcfs=ranking(1:numF);
        performance_ranking=perfor(1:numF);
        %% Unsupervised
    case 'inf-fs'
        [ ranking , w] = mutInfFS( X_train', Y_train', numF );
        %ranking_mutinffs=ranking(1:numF);
        performance_ranking=w(1:numF);
    case 'laplacianscore' %% you arrived here
        %'LaplacianScore'
        W = dist(X_train);
        W = -W./max(max(W)); % it's a similarity
        [lscores] = LaplacianScore(X_train', W);
        [junk, ranking] = sort(-lscores);
        %ranking_laplacian=ranking(1:numF);
        performance_ranking=  junk(1:numF); % not sure! to be checked
    case 'mcfs'
        % MCFS: Unsupervised Feature Selection for Multi-Cluster Data
        options = [];
        options.k = 5; %For unsupervised feature selection, you should tune
        %this parameter k, the default k is 5.
        options.nUseEigenfunction = 4;  %You should tune this parameter.
        [FeaIndex,~] = MCFS_p(X_train',numF,options);
        ranking = FeaIndex{1};
        %ranking_mcfs=ranking(1:numF);
        
    case 'udfs'  %% OK
        % Regularized Discriminative Feature Selection for Unsupervised Learning
        nClass = 2;
        [ranking, score] =  UDFS(X_train' , nClass );
        ranking_udfs=ranking(1:numF);
        performance_ranking=  score(1:numF); % not sure! to be checked
        
    case 'cfs' %% OK
        % BASELINE - Sort features according to pairwise correlations
        [ranking, score] = cfs(X_train');
        %ranking_cfs=ranking(1:numF);
        performance_ranking=  score(1:numF); % not sure! to be checked
end

ranking=ranking(:);
if length(ranking)<=numF % in the case of the nb selected feature is < to the desired
    ranking=ranking(1:length(ranking));
    performance_ranking=performance_ranking(1:length(ranking));
    init_parameter.nb_features_old=init_parameter.nb_features;
    init_parameter.nb_features=length(ranking);
else
    ranking=ranking(1:numF);
    performance_ranking=performance_ranking(1:numF);;
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
