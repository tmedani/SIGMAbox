function [performance_result, feature_result]=Sigma_cross_validation...
    (feature_result,init_parameter,init_method)
%%%------------------------------------------------------------------------
%  [performance_result]=Sigma_cross_validation
%                              (feature_result,init_parameter,init_method)
%
%  Function task:
%   Compute the performances of the classification from the training
%
% Inputs : TODO

% Outputs :
% performance_result : structure containig the following informations
%             cross_validation_method: 'LOSO' or 'LHSO' or 'LOEO'
%             classification_method: 'LDA' or 'QDA' or 'SVM'
% scores: structure of the Matrix of scores (propabilities of the
% positive classe) resulted from the predict function NxM where:
%             N is the number of the features (output of the OFR)
%             M is the number of examples (epochs) = size of the labels
%       scores =     [NxM double]    [NxM double] where the firste is
%       the Negative score, the seconde is the positive score
% TODO : should be modified to includ both of the positive and negative
% classes
% prediction: Matrix with the size  NxM,
%             each line contains the output labels predicted usigne
%             the number of line features
% index_selected: Matrix containing the index of the selected features,
% the size of this matrix is NxNbCV,
%             where N is the number of the selected features and the
%             NbCV is the number of the CrossValidation itteration
%             in the case of  the LOSO : NbCV = nb_subject
%             in the case of  the LHSO : NbCV = 2*nb_subject
%             in the case of  the LOEO : NbCV = nb_epochs (all epochs)
% performance: Containig the performance result explaned in the
% performance_infos size of Nx8
% performance_infos: {'Accuracy'  'Sensitivity'  'Specificity'
%     'Precision'  'Recall'  'F-Measure'  'G-mean'  'Auc'}
% best_voted_index: Contains the index of the best voted index
%             (bagging) of the all cross validation iteration (NbCV)
%             [size = Nx1]
%             best_organisation: Contain the best feature selection withe
%             the identification of the features see
% best_organisation_infos [size = Nx5]
%             best_organisation_infos: {1x5 cell}
% Dependences :
%  Sigma_cross_validation_lhso
%  Sigma_cross_validation_loeo
%  Sigma_cross_validation_loso
%  Sigma_compute_performance
%  Sigma_election_best_index
%  Sigma_feature_identification
%
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------



%% SECTION 1 :  Initialisation
cross_validation_method=init_parameter.cross_validation_method;
classification_method=init_parameter.classification_method;
% remise de la matrice initiale
feature_result.o_features_matrix = feature_result.o_features_matrix_normalize;
%% SECTION 2 :   Computing the cross validation & classification

if ~strcmp(classification_method,'SVM')
    
    % Message pour tester la distribution des feature
    if sum(feature_result.is_normal_distribution == 0) ~= 0
        promptMessage = sprintf(['There is at least one feature with no normal distribution,'...
            '\n SVM is adviced for this analysis,'...
            '\n Do you want to Continue processing with the selected method,'...
            '\n or Cancel to abort processing and change parameters?']);
        button = questdlg(promptMessage, 'SIGMA Warning', 'Continue',...
            'Cancel', 'Continue');
        if strcmpi(button, 'Cancel')
            disp('aborted')
            performance_result = [];
            return; % Or break or continue
        end
        disp('continue')        
    end
    
    % remove the non normal distribution feature
    if sum(feature_result.is_normal_distribution == 0) ~= 0
        index_not_normal = find(feature_result.is_normal_distribution == 0);        
               
        promptMessage = sprintf(['Do you want to remove the feature with no normal distribution']);
            
        button = questdlg(promptMessage, 'SIGMA Warning', 'Yes',...
            'No','Cancel','Yes');
        switch button
            case 'Yes'
                disp('Removing the no normal distribution ... ')
                % Remove the non normal feature from the best feature matrix
                % keep original version
                feature_result.before_removing_no_normal_feature.o_best_features_matrix  = feature_result.o_best_features_matrix; 
                feature_result.before_removing_no_normal_feature.idx_best_features  = feature_result.idx_best_features;
                feature_result.before_removing_no_normal_feature.nb_features  = feature_result.nb_features; 
                feature_result.before_removing_no_normal_feature.o_best_features_matrix  = feature_result.o_best_features_matrix; 
                feature_result.before_removing_no_normal_feature.channel_method  = feature_result.channel_method; 
                feature_result.before_removing_no_normal_feature.performance_ranking  = feature_result.performance_ranking; 
                feature_result.before_removing_no_normal_feature.best_organisation  = feature_result.best_organisation; 
                feature_result.before_removing_no_normal_feature.best_organisation  = feature_result.best_organisation; 
                feature_result.before_removing_no_normal_feature.is_normal_distribution = feature_result.is_normal_distribution;
                % new version 
                feature_result.o_best_features_matrix(index_not_normal,:) = [];
                feature_result.nb_features = size(feature_result.o_best_features_matrix,1);
                feature_result.idx_best_features(index_not_normal) = [];
                %feature_result.channel_method(index_not_normal,:) = nan;
                feature_result.performance_ranking(index_not_normal) = [];
                feature_result.best_organisation(index_not_normal,:) = [];
                feature_result.is_normal_distribution(index_not_normal) = [];
                %index_not_normal
                
                promptMessage = sprintf([num2str(length(index_not_normal))...
                    ' feature(s) with no normal distributioon are removed \n'...
                    'The number of selected feature(s) is updated to ' ...
                    num2str(feature_result.nb_features)]);
                uiwait(msgbox(promptMessage));
                
            case 'No'
                disp('All the feature will be included')
            case 'Cancel'
                performance_result = [];
                return; % Or break or continue
        end
        disp('continue')        
    end
    
    
    
    %% Compute the cross validation accordinf to the chosen method
           
    %%% LOEO
    if strcmp(cross_validation_method,'LOEO')
        disp(['You have selected the :  ' classification_method...
            ' & ' cross_validation_method ' ...'])
        [scores,prediction,index_selected, classObj]=...
            Sigma_cross_validation_loeo(feature_result,init_parameter);
    end
    %%% LOSO
    if strcmp(cross_validation_method,'LOSO')
        if ~(init_parameter.nb_subject<2)
            disp(['You have selected the :  ' classification_method...
                ' & ' cross_validation_method ' ...'])
            [scores,prediction,index_selected, classObj]=...
                Sigma_cross_validation_loso(feature_result,init_parameter);
        else
            msgbox(['LOSO is impossible with one subject,',...
                'please put more subject or change CV method'],...
                'SIGMA error','error');
            performance_result=[];
            return
        end
    end
    %%% LHSO
    if strcmp(cross_validation_method,'LHSO')
        disp(['You have selected the :  ' classification_method...
            ' & ' cross_validation_method ' ...'])
        [scores,prediction,index_selected, classObj]=...
            Sigma_cross_validation_lhso(feature_result,init_parameter);
    end
    %%% LXSO
    if strcmp(cross_validation_method,'LxSO')
        disp(['You have selected the :  ' classification_method...
            ' & ' cross_validation_method ' ...'])
        [scores,prediction,index_selected,labels_lxso, classObj] = ...
            Sigma_cross_validation_lxso(feature_result,...
            init_parameter,best_index);
        label=labels_lxso;
    end
    
end

if strcmp(classification_method,'SVM')
    %%% LOEO
    if strcmp(cross_validation_method,'LOEO')
        disp(['You have selected the :  ' classification_method...
            ' & ' cross_validation_method ' ...']);
        tic
        result = Call_sigma_svm_loeo_finale(feature_result,init_parameter);
        toc
        %result = Call_sigma_svm_loso(feature_result,init_parameter)
        scores = result.score;
        prediction = result.prediction;
        index_selected = result.index;
        classObj = result.classifier;
        best_hyperparameter=result.best_hyperparameter;
        
    end
    %%% LOSO
    if strcmp(cross_validation_method,'LOSO')
        if ~(init_parameter.nb_subject<2)
            if strcmp(cross_validation_method,'LOSO')
                disp(['You have selected the :  ' classification_method...
                    ' & ' cross_validation_method ' ...']);
                result = Call_sigma_svm_loso_finale...
                    (feature_result,init_parameter);
                scores = result.score;
                prediction = result.prediction;
                index_selected = result.index;
                classObj = result.classifier;
                best_hyperparameter=result.best_hyperparameter;
            end
        else
            msgbox(['LOSO is impossible with one subject, please put,'...
                'more subject or change CV method'],'SIGMA error','error');
            performance_result=[];
            return
        end
    end
    
end


%% Change the prediction according to the new thershold





%% SECTION 3 :   Compute the performance of the classification
disp('Compute the performance of the model ...')
scores_pc = scores{2}; % score of the positive class
if strcmp(cross_validation_method,'LxSO')
    [performance,performance_infos]=Sigma_compute_performance...
        (labels_lxso,prediction,scores_pc);
else
    [performance,performance_infos]=Sigma_compute_performance...
        (feature_result.label,prediction,scores_pc);
end

%%% get the best voted ranking for the bagging
best_voted_index=Sigma_election_best_index(index_selected);
%%%% not bagging all the data
best_ofr_index=feature_result.idx_best_features;
%% identification of the features
% TODO harmonize all these variable about bagging and ofr
selection_method='ofr';
if strcmp(selection_method,'ofr')
    disp('OFR on all data')
    [best_organisation, best_organisation_infos]=...
        Sigma_feature_identification(init_parameter,init_method,...
        feature_result,best_ofr_index);
end
if strcmp(selection_method,'bag')
    disp('BAG : best voted index')
    [best_organisation, best_organisation_infos]=...
        Sigma_feature_identification(init_parameter,init_method,...
        feature_result,best_voted_index);
end

%% Check the Index of the bagging and not bagging :
if length(find(best_ofr_index==best_voted_index'))==length(best_ofr_index)
    disp('The voted index and the index on all data are the same');
end

%% SECTION 4 :  Outpus
% Output
performance_result.classification_method=...
    init_parameter.classification_method;
performance_result.cross_validation_method=cross_validation_method;
performance_result.scores=scores;
performance_result.prediction=prediction;
performance_result.index_selected=index_selected;
performance_result.performance=performance;
performance_result.performance_infos=performance_infos;
performance_result.best_voted_index=best_voted_index;
performance_result.best_organisation_voted=best_organisation;
performance_result.best_organisation_infos=best_organisation_infos;
performance_result.classObj=classObj;
% only for the SVM method for now
if strcmp(classification_method,'SVM')
    performance_result.best_hyperparameter=best_hyperparameter;
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
% % %   Creation Date : 03/11/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------