function  [scores,prediction,index_selected, ClObj] = ...
    Sigma_cross_validation_lhso(features_results,init_parameter,best_index)
% This function compute the crosscorrelation base on leave half subject out
% [scores,prediction,index_selected] = Sigma_cross_validation_loeo2...
%                              (features_results,init_parameter,best_index)
% OR
% [scores,prediction,index_selected] = ...
%             Sigma_cross_validation_loeo2(features_results,init_parameter)
%
% INPUTS:
% features=features_results.o_features_matrix;
% labels=features_results.labels;
% maxFeatNum=init_parameter.nb_features;
% classificationMethod=init_parameter.classification_method;
% -features : the matrix of the features extracted from the data,
% size = NxM
% where N is the number of line, represent the number of features
% and M is the number of rows, representing the number of epochs (examples)
% - labels : is the vector of labels, -1 and 1 , related to the two classes
% of the data, the size of this vector is : Mx1
% - maxFeatNum : is the number of feature to rank, used by the
% gram_schmit_function otr the others OFR algorithm
% - classificationMethod : contain the name of the classification method,
% LDA, QDA or SVM for instance
% - best_voted_index : optional, it's a vector of index of the features to
% use, mainly is the output of the function : Sigma_election_best_index
% - best_index : Optional input, if it's included, the OFR does not used in
% this function, the selected feature will be thoese specified by this
% vector
% OUTPUTS :
% [scores prediction]=predict(classObj,features) ; is the output of the
% Matlab function predict for the positive classe : scores=scores(2),
% index_selected : is the liste of the index selected to rank the best
% features

%% Extract the parameters of this function
%o_features_matrix=features_results.o_features_matrix;
%% Extract the parameters of this function
if isfield(features_results,'o_features_matrix_normalize')
    % normalized with the Zscore
    o_features_matrix=features_results.o_features_matrix_normalize;
else
    % not normalized
    o_features_matrix=features_results.o_features_matrix;
end

%%% TODO Use the normalised features matrix, apply it here and on the other
%%% function LOSO and LOEO
label=features_results.label;
%maxFeatNum=init_parameter.nb_features;
maxFeatNum=size(features_results.o_best_features_matrix,1);
number_of_feature=maxFeatNum;
classification_method=init_parameter.classification_method;
ranking_method=init_parameter.ranking_method;

%% Start
disp('You are runing the LOEO method for training your model ... ')
disp(['You have selected the : ' ranking_method ' with '...
    classification_method '....'])
index_selected=[];

number_of_subject=init_parameter.number_of_subject;
number_of_epoch=features_results.epochs;

%epochs = size(o_features_matrix,2);
scores_nc = nan(number_of_feature,sum(number_of_epoch));
scores_pc = nan(number_of_feature,sum(number_of_epoch));
prediction = nan(number_of_feature,sum(number_of_epoch));

epoch=1;
h = waitbar(0,'LHSO...','Name','SIGMA : Cross-Validation');
for l_subject = 1:number_of_subject
    waitbar(epoch/epochs,h,['LHSO : subject ' num2str(l_subject)...
        '/' num2str(number_of_subject) ])
    
    epoch_to_romove_all=epoch:epoch+number_of_epoch(l_subject)-1;
    epoch_to_romove_par_1=epoch_to_romove_all...
        (1:round(length(epoch_to_romove_all)/2));
    epoch_to_romove_par_2=epoch_to_romove_all...
        (round(length(epoch_to_romove_all)/2)+1:end);
    epoch_to_romove_par_1_2={epoch_to_romove_par_1;epoch_to_romove_par_2};
    
    
    for half=1:2
        epoch_to_romove=epoch_to_romove_par_1_2{half};
        %%% TODO : make sure that the chosen half 
        %l_subject contain same both of data (-1 and -1)
        %epoch=number_of_epoch(l_subject);
        %%% Part of feature to remove and the to test
        currFeats = o_features_matrix(:,epoch_to_romove);
        
        %%% Part of the feature to train
        otherFeats = o_features_matrix;
        otherFeats(:,epoch_to_romove) = [];
        %%% Part of the label to train
        otherLabels = label;
        otherLabels(epoch_to_romove) = [];
        
        %% OFR Algorithmes
        nb_argin=nargin;
        if nargin==2
            %% Running the OFR
            if strcmp(ranking_method,'gram_schmidt_probe')
                % On the all feature feature matrix
                [idx_best_features]=features_results.idx_best_features;
            else
                % On the leave one out feature matrix
                [idx_best_features]=Sigma_ranking_methods...
                    (init_parameter,otherFeats,otherLabels,...
                    number_of_feature,ranking_method);
            end
            idx=idx_best_features;
            idx=idx(:);            
            %%% ********** reviens ici pour continuer ********** %%%            
            index_selected=[index_selected idx(:)];
        end
        if nargin==3
            idx=best_index(:);
            index_selected=[index_selected idx];
        end
        %% LHSO Algorithme
        for l_feat = 1:number_of_feature
            waitbar(epoch/epochs,h,['LHSO : subject ' num2str(l_subject)...
                '/' num2str(number_of_subject) ', feat : '...
                num2str(l_feat) '/' num2str(number_of_feature) ])
            
            featuresChosen = otherFeats(idx(1:l_feat),:);
            
            if(classification_method == 'LDA')
                %disp('You have selected the : LDA Classification....')
                classObj = fitcdiscr(featuresChosen',otherLabels');
                [YP, sc]=predict(classObj,currFeats(idx(1:l_feat),:)');
            end
            
            if(classification_method == 'QDA')
                %disp('You have selected the : QDA Classification....')
                classObj = fitcdiscr(featuresChosen',otherLabels',...
                    'DiscrimType','diagLinear');
                [YP, sc]=predict(classObj,currFeats(idx(1:l_feat),:)');
            end
            
            
            %% Should be Modified and validated by François
            % Never reach this line 
            if(classification_method == 'SVM')
                %disp('You have selected the : SVM Classification....')
                [o_svm, o_stat] = sigma_svm(featuresChosen', otherLabels');
                classObj = o_svm.svm;
                [YP, sc]=my_svmclassify(classObj,...
                                              currFeats(idx(1:l_feat),:)');                
            end
                        
            %% Save the results
            % negative classe's score
            scores_nc(l_feat,epoch_to_romove) = sc(1); 
            % positive classe's score
            scores_pc(l_feat,epoch_to_romove) = sc(2); 
            scores={scores_nc, scores_pc};
            prediction(l_feat,epoch_to_romove) = YP;
            ClObj(l_feat).classObj=classObj;
        end
    end
    % selects epochs of the next l_subject
    epoch=sum(number_of_epoch(1:l_subject))+1; 
end
close(h)
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
% % %   Creation Date : 28/05/2017
% % %   Updates and contributors :
% % %       28/05/2017 Takfarinas MEDANI
% % %
% % %   Citation: [creator and contributor names], SigmaBOX, available
% % %   online 2017.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2017
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
