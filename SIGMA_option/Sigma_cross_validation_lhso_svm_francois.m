function  [scores,prediction,index_selected, ClObj] = Sigma_cross_validation_lhso(features_results,init_parameter,best_index)

%% This function compute the crosscorrelation base on leave half subject out
% [scores,prediction,index_selected] = Sigma_cross_validation_loeo2(features_results,init_parameter,best_index)
% OR
% [scores,prediction,index_selected] = Sigma_cross_validation_loeo2(features_results,init_parameter)
%
% INPUTS:
% features=features_results.o_features_matrix;
% labels=features_results.labels;
% maxFeatNum=init_parameter.nb_features;
% classificationMethod=init_parameter.classification_method;
%     % -features : the matrix of the features extracted from the data, size = NxM
%     % where N is the number of line, represent the number of features
%     % and M is the number of rows, representing the number of epochs (examples)
%     % - labels : is the vector of labels, -1 and 1 , related to the two classes
%     % of the data, the size of this vector is : Mx1
%     % - maxFeatNum : is the number of feature to rank, used by the
%     % gram_schmit_function otr the others OFR algorithm
%     % - classificationMethod : contain the name of the classification method,
%     % LDA, QDA or SVM for instance
%     % - best_voted_index : optional, it's a vector of index of the features to
%     % use, mainly is the output of the function : Sigma_election_best_index
%     % - best_index : Optional input, if it's included, the OFR does not used in
%     % this function, the selected feature will be thoese specified by this
%     % vector
% OUTPUTS :
% [scores prediction]=predict(classObj,features) ; is the output of the
% Matlab function predict for the positive classe : scores=scores(2),
% index_selected : is the liste of the index selected to rank the best
% features

%% Extract the parameters of this function
o_features_matrix=features_results.o_features_matrix;
%%% TODO Use the normalised features matrix, apply it here and on the other
%%% function LOSO and LOEO
labels=features_results.labels;
%maxFeatNum=init_parameter.nb_features;
maxFeatNum=size(features_results.o_best_features_matrix,1);
classificationMethod=init_parameter.classification_method;
ranking_method=init_parameter.ranking_method;

%% Start
display('You are runing the LOEO method for training your model ... ')
display(['You have selected the : ' ranking_method ' with ' classificationMethod '....'])
index_selected=[];

nb_subject=init_parameter.nb_subject;
nb_epochs=features_results.epochs;

%epochs = size(o_features_matrix,2);
scores_nc = nan(maxFeatNum,sum(nb_epochs));
scores_pc = nan(maxFeatNum,sum(nb_epochs));
prediction = nan(maxFeatNum,sum(nb_epochs));

epoch=1;
h = waitbar(0,'LHSO...','Name','SIGMA : Cross-Validation');
for subject = 1:nb_subject
    waitbar(epoch/epochs,h,['LHSO : subject ' num2str(subject) '/' num2str(nb_subject) ])
    
    epoch_to_romove_all=epoch:epoch+nb_epochs(subject)-1;
    epoch_to_romove_par_1=epoch_to_romove_all(1:round(length(epoch_to_romove_all)/2));
    epoch_to_romove_par_2=epoch_to_romove_all(round(length(epoch_to_romove_all)/2)+1:end);
    epoch_to_romove_par_1_2={epoch_to_romove_par_1;epoch_to_romove_par_2};
    
    
    for half=1:2
        epoch_to_romove=epoch_to_romove_par_1_2{half};
        %%% TODO : make sure that the chosen half subject contain same both of data (-1 and -1 for the embalacement)
        %epoch=nb_epochs(subject);
        %%% Part of feature to remove and the to test
        currFeats = o_features_matrix(:,epoch_to_romove);
        
        %%% Part of the feature to train
        otherFeats = o_features_matrix;
        otherFeats(:,epoch_to_romove) = [];
        %%% Part of the labels to train
        otherLabels = labels;
        otherLabels(epoch_to_romove) = [];
        
        %% OFR Algorithmes
        nb_argin=nargin;
        if nargin==2
            %         nb_features=maxFeatNum;
            %             [idx_best_features]=Sigma_ranking_methods(init_parameter,otherFeats,otherLabels,nb_features,ranking_method);
            %             idx=idx_best_features;
            %             idx=idx(:);
            %             index_selected=[index_selected idx(:)];
            nb_features=maxFeatNum;
            %% Running the OFR
            
            if strcmp(ranking_method,'gram_schmidt_probe')
                % On the all feature feature matrix
                [idx_best_features]=features_results.idx_best_features;
            else
                % On the leave one out feature matrix
                [idx_best_features]=Sigma_ranking_methods(init_parameter,otherFeats,otherLabels,nb_features,ranking_method);
            end
            
            %[idx] = gram_schmidt(otherFeats, otherLabels, maxFeatNum);
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
        for feat = 1:maxFeatNum
            waitbar(epoch/epochs,h,['LHSO : subject ' num2str(subject) '/' num2str(nb_subject) ', feat : ' num2str(feat) '/' num2str(maxFeatNum) ])
            
            featuresChosen = otherFeats(idx(1:feat),:);
            %% Should be Modified and validated by François
            if(classificationMethod == 'SVM')
                % This is the code of françois
                %                 %display('You have selected the : SVM Classification....')
                %                 [o_svm, o_stat] = sigma_svm(featuresChosen', otherLabels');
                %                 %[o_svm, o_stat] = Sigma_svm_gui(featuresChosen', otherLabels',parame...) % same thing but from the GUI
                %                 classObj = o_svm.svm;
                %                 [YP, sc]=my_svmclassify(classObj,currFeats(idx(1:feat),:)');
                % %                 classObj = fitcdiscr(featuresChosen',otherLabels','KernelScale',...
                %                   'auto','Standardize',true,'OutlierFraction',0.05);
                [classObj_list{feat,subject}, performance{subject}, score{subject}] = sigma_fitcsvm(featuresChosen',otherLabels',currFeats(idx(1:feat),:)');
            else
                if(classificationMethod == 'LDA')
                    %display('You have selected the : LDA Classification....')
                    classObj = fitcdiscr(featuresChosen',otherLabels');
                    [YP, sc]=predict(classObj,currFeats(idx(1:feat),:)');
                end
                
                if(classificationMethod == 'QDA')
                    %display('You have selected the : QDA Classification....')
                    classObj = fitcdiscr(featuresChosen',otherLabels','DiscrimType','diagLinear');
                    [YP, sc]=predict(classObj,currFeats(idx(1:feat),:)');
                end
                %% Save the results
                scores_nc(feat,epoch_to_romove) = sc(1); % negative classe's score
                scores_pc(feat,epoch_to_romove) = sc(2); % positive classe's score
                scores={scores_nc, scores_pc};
                prediction(feat,epoch_to_romove) = YP;
                %ClObj{feat}=classObj;
                ClObj(feat).classObj=classObj;
                %epoch_to_romove=epoch:nb_epochs(subject);
            end
        end
    end
    epoch=sum(nb_epochs(1:subject))+1; % selects epochs of the next subject
end
% if(classificationMethod == 'SVM')
%     best_performance = 0;
%     constraint = -1;
%     kernel = -1;
%     condition = -1;
%     for feat = 1:maxFeatNum
%         for l_constraint = 1 : size(performance,1)
%             for l_kernel = 1 : size(performance,2)
%                 l_condition = 1;
%                 while (isempty(performance{l_constraint, l_kernel, l_condition}) == 0)
%                     total_accuracy = 0;
%                     for subject = 1:nb_subject
%                         result = performance{subject};
%                         accuracy = result{l_constraint, l_kernel, l_condition};
%                         total_accuracy = total_accuracy + accuracy / nb_subject;
%                     end
%                     if (best_performance < total_accuracy),
%                         best_performance = total_accuracy;
%                         constraint = l_constraint;
%                         kernel = l_kernel;
%                         condition = l_condition;
%                     end
%                     l_condition = l_condition + 1;
%                 end
%             end
%         end
%         %% Save the results
%         score = score{constraint, kernel, condition};
%         scores_nc(feat,epoch_to_romove) = sc(1); % negative classe's score
%         scores_pc(feat,epoch_to_romove) = sc(2); % positive classe's score
%         scores=score;
%         prediction(feat,epoch_to_romove) = YP;
%         %ClObj{feat}=classObj;
%         ClObj(feat).classObj=classObj;
%     end
% end
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
