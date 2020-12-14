function [feature_result] = Sigma_feature_ranking3(init_parameter,...
    init_method,feature_result,leave_one_subject_out_results,Nfeat)
%%%------------------------------------------------------------------------
%  [feature_result] = Sigma_feature_ranking3(init_parameter,...
%                             init_method,feature_result,...
%                             leave_one_subject_out_results,Nfeat)
%  Function task:
%
% On this Version We remplace the features methods selectrion withe the
% function Sigma_ranking_methods ;
% This script use the Gram Schmit method for the Orthogonal
% Forward Regression to rank the features and also to identify
% the associated method
% The number of argument
%
%  Inputs :
%
%  Outputs :
%
%
%--------------------------------------------------------------------------
%
%  Main Variables
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%% Section 1 : Checking the input

nVarargs  =  nargin;
% General case, without a loop on the number of features and LOSO
if (nVarargs == 3)
    % The number of features to rank
    nb_features = init_parameter.nb_features;
    % The feature matrix
    if isfield(feature_result,'o_features_matrix_normalize')
        % normalized with the Zscore
        o_features_matrix = feature_result.o_features_matrix_normalize;
    else
        % not normalized
        o_features_matrix = feature_result.o_features_matrix;
    end
    % The labels
    label = feature_result.label;
end

% Leave one out case with a fixed number of feature
if (nVarargs == 4)
    % The number of features to rank
    nb_features = init_parameter.nb_features;
    % The feature matrix
    o_features_matrix = ...
        leave_one_subject_out_results.o_features_matrix_leave_one_out;
    % The label
    label = leave_one_subject_out_results.label_leave_one_out;
end

% Leave one out case and à specific number of feature to the study
if (nVarargs == 5)
    % The number of features to rank
    nb_features = Nfeat;
    % The feature matrix
    o_features_matrix = ...
        leave_one_subject_out_results.o_features_matrix_leave_one_out;
    % The label
    label = leave_one_subject_out_results.label_leave_one_out;
end


%% Test the number of feature to rank
nb_feature_to_rank = init_parameter.nb_features;
nb_real_of_feature = size(feature_result.o_features_matrix,1);

if(nb_feature_to_rank > nb_real_of_feature)
    warndlg(['Number of Feature to rank  =  '  num2str(nb_feature_to_rank)...
        ' is greater than the real number of features' ...
        ', please reduce this number under ' num2str(nb_real_of_feature)...
        ' (the real number of features)' ],'SIGMA Warning !!');
    return
end


% get the selected method for the ranking
ranking_method = init_parameter.ranking_method;

% Identification of the feaures
o_features_matrix_id = feature_result.o_features_matrix_id;


%%    displaying Information on the screen
if init_parameter.sigma_show_comment == 1
    disp('**************** Start of OFR Ranking Algorithm ***************')
    disp(['You have selected the ' , ranking_method,...
        ' method for the ranking'])
    disp(['The feature matrix has the dimension of : '...
        num2str(size(o_features_matrix))])
    
    if (nVarargs <= 3)
        disp('You have selected "All the feature matrix" for the ranaking ...')
    end
    if (nVarargs > 3)
        disp('You have selected the "LOSO feature matrix" for the ranking ...')
    end
end


%%    Writing the Information on the LogFile
if init_parameter.sigma_write_logFile == 1
    cd(init_parameter.sigma_directory)
    cd(init_parameter.data_output)
    mkdir(init_parameter.session_name)
    cd(init_parameter.session_name)
    logFilename = init_parameter.logFilename;
    fid  =  fopen(logFilename,'a');
    fprintf(fid,'\n %s','*** Start of OFR Ranking Algorithm ***');
    fprintf(fid,'\n %s',['You have selected the ' , ranking_method,...
        ' method for the ranking']);
    fprintf(fid,'\n %s',['The feature matrix has the dimension of : '...
        num2str(size(o_features_matrix))]);
    
    if (nVarargs <= 3)
        fprintf(fid,'\n %s',...
            'You have selected "All the feature matrix" for the ranaking ...');
    end
    if (nVarargs > 3)
        fprintf(fid,'\n %s',...
            'You have selected the "LOSO feature matrix" for the ranking ...');
    end
    fclose(fid);
    cd(init_parameter.sigma_directory)
end


%% The choice of the OFR method and the idx_best_features
[idx_best_features,performance_ranking] = Sigma_ranking_methods...
    (init_parameter,o_features_matrix,label,nb_features,ranking_method);

if isempty(idx_best_features)
    warning('-----------------------------------------------------------' )
    disp('-----------------------Warning-------------------------------' )
    disp(['No feature selection with the ' ...
        num2str(init_parameter.threshold_probe*100)...
        ' %, please repeat the process' ] )
    warning('No feature selected from the ofr...' )
else
    % Features Identification
    feature_result.performance_ranking = performance_ranking;
    [ best_organisation, best_organisation_infos] = ...
        Sigma_feature_identification(init_parameter,...
        init_method,feature_result,idx_best_features);
    
    
    % Creat the matrix with only the best features
    if (nVarargs <= 3)
        o_best_features_matrix = o_features_matrix(idx_best_features,:);
        feature_result.o_best_features_matrix =  o_best_features_matrix;
        feature_result.idx_best_features = idx_best_features;
        feature_result.performance_ranking = performance_ranking;
        feature_result.best_organisation = best_organisation;
        feature_result.best_organisation_infos = best_organisation_infos;
    end
    
    if (nVarargs > 3)
        % Creat the matrix with only the best features
        o_best_features_matrix = o_features_matrix(idx_best_features,:);
        feature_result.features_results_leave_one_subject_out.o_best_features_matrix...
            =  o_best_features_matrix;
        feature_result.features_results_leave_one_subject_out.idx_best_features...
            = idx_best_features;
        feature_result.features_results_leave_one_subject_out.performance_ranking...
            = performance_ranking;
        feature_result.features_results_leave_one_subject_out.best_organisation...
            = best_organisation;
    end
    
    
    if init_parameter.sigma_write_logFile == 1
        cd(init_parameter.sigma_directory)
        cd(init_parameter.data_output)
        %            mkdir(init_parameter.session_name)
        cd(init_parameter.session_name)
        logFilename = init_parameter.logFilename;
        fid  =  fopen(logFilename,'a');
        fprintf(fid,'\n %s','*** End of OFR Ranking Function ***');
        fclose(fid);
        cd(init_parameter.sigma_directory)
    end
    
    fclose('all');
    
    if init_parameter.sigma_show_comment == 1
        disp('************ End of OFR Ranking Function **************')
    end
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