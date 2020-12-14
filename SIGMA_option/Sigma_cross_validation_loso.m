function  [scores,prediction,index_selected, ClObj] = Sigma_cross_validation_loso(features_results,init_parameter,best_index)
% This function compute the crosscorrelation base on leave one subject out
% [scores,prediction,index_selected] = 
%  Sigma_cross_validation_loeo2(features_results,init_parameter,best_index)
% OR
% [scores,prediction,index_selected] =
%       Sigma_cross_validation_loeo2(features_results,init_parameter)
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
%     [scores prediction]=predict(classObj,features) ; is the output of the
%     Matlab function predict for the positive classe : scores=scores(2),
%     index_selected : is the liste of the index selected to rank the best
%     features

%% Extract the parameters of this function
o_features_matrix=features_results.o_features_matrix;
label=features_results.label;
maxFeatNum=init_parameter.nb_features;
number_of_feature=maxFeatNum;
classificationMethod=init_parameter.classification_method;
ranking_method=init_parameter.ranking_method;

%% Start
disp('You are runing the LOSO method for training your model ... ');
disp(['You have selected the : ' ranking_method ' with '...
    classificationMethod '....']);
index_selected=[];

nb_subject=init_parameter.nb_subject;
%nb_epochs=features_results.nb_epochs;
nb_epochs=features_results.epoch;

%epoch = size(o_features_matrix,2);
%scores = nan(number_of_feature,sum(nb_epochs));
scores_nc = nan(number_of_feature,sum(nb_epochs));
scores_pc = nan(number_of_feature,sum(nb_epochs));
prediction = nan(number_of_feature,sum(nb_epochs));

epoch=1;
%test=[];
% waitbar
h = waitbar(0,'LOSO...','Name','SIGMA : Cross-Validation');
for l_subject = 1:nb_subject
    waitbar(l_subject/nb_subject,h,['LOSO : subject ' num2str(l_subject)...
        '/' num2str(nb_subject) ]);    
    epoch_to_romove=epoch:epoch+nb_epochs(l_subject)-1;
    %epoch_to_romove
    %test=[test; {epoch_to_romove}]
    %epoch=nb_epochs(l_subject);
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
    if nb_argin==2
        nb_features=number_of_feature;
        [idx_best_features]=Sigma_ranking_methods(init_parameter,...
            otherFeats,otherLabels,nb_features,ranking_method);
        idx=idx_best_features;
        idx=idx(:);
        index_selected=[index_selected idx(:)];
    end
    
    if nb_argin==3
        idx=best_index(:);
        index_selected=[index_selected idx];
    end
    
    %% LOSO Algorithme
    for l_feat = 1:number_of_feature
        waitbar(l_subject/nb_subject,h,['LOSO : subject '...
            num2str(l_subject) '/' num2str(nb_subject)...
            ', feat : ' num2str(l_feat) '/' num2str(number_of_feature) ]);
        featuresChosen = otherFeats(idx(1:l_feat),:);
        c_cost1 = sum(otherLabels == 1);
        c_cost2 = sum(otherLabels == -1);
        %c_classname = [-1 1];
        %         c_class=unique(otherLabels);
        c_classname = [1 -1];%[c_class(1) c_class(2)];
        c_cost = [0 (c_cost2 / (c_cost1 + c_cost2));...
            (c_cost1 / (c_cost1 + c_cost2)) 0];
        if(classificationMethod == 'LDA')
            %disp('You have selected the : LDA Classification....')
            classObj = fitcdiscr(featuresChosen', otherLabels', ...
                'ClassNames', c_classname, 'Cost', c_cost,...
                'Prior', [.5 .5]);
        end
        
        if(classificationMethod == 'QDA')
            %disp('You have selected the : QDA Classification....')
            classObj = fitcdiscr(featuresChosen',otherLabels',...
                'DiscrimType','diagLinear', ...
                'ClassNames', c_classname, 'Cost', c_cost,...
                'Prior', [.5 .5]);
        end
        
        if(classificationMethod == 'SVM')
            %disp('You have selected the : SVM Classification....')
            classObj = fitcdiscr(featuresChosen',otherLabels',...
                'KernelScale','auto','Standardize',...
                true,'OutlierFraction',0.05);
        end
        
        % [~,sc] = predict(classObj,currFeats(idx(1:l_feat))');
        % scores(l_feat,epoch) = sc(2);
        
        %% Save the results on the output matrix
        [YP, sc]=predict(classObj,currFeats(idx(1:l_feat),:)');
        %scores(l_feat,epoch_to_romove) = sc(2);
        % negative classe's score
        scores_nc(l_feat,epoch_to_romove) = sc(2); 
        scores_pc(l_feat,epoch_to_romove) = sc(1); 
        scores={scores_nc, scores_pc};
        prediction(l_feat,epoch_to_romove) = YP;        
        
        %ClObj{l_feat}=classObj;
        ClObj(l_feat).classObj=classObj;
        
        %epoch_to_romove=epoch:nb_epochs(l_subject);
    end
    % selects epoch of the next l_subject
    epoch=sum(nb_epochs(1:l_subject))+1; 
end

%% Learning final model on the whole database
for l_feat = 1:number_of_feature
    featuresChosen = o_features_matrix(idx(1:l_feat),:);
    otherLabels = label;
    c_cost1 = sum(otherLabels == 1);
    c_cost2 = sum(otherLabels == -1);
    %c_classname = [-1 1];
    %         c_class=unique(otherLabels);
    c_classname = [1 -1];%[c_class(1) c_class(2)];
    c_cost = [0 (c_cost2 / (c_cost1 + c_cost2));...
        (c_cost1 / (c_cost1 + c_cost2)) 0];
    if(classificationMethod == 'LDA')
        %disp('You have selected the : LDA Classification....')
        classObj = fitcdiscr(featuresChosen', otherLabels', ...
            'ClassNames', c_classname, 'Cost', c_cost, 'Prior', [.5 .5]);
    end
    
    if(classificationMethod == 'QDA')
        %disp('You have selected the : QDA Classification....')
        classObj = fitcdiscr(featuresChosen',otherLabels',...
            'DiscrimType','diagLinear', ...
            'ClassNames', c_classname, 'Cost', c_cost, 'Prior', [.5 .5]);
    end
    ClObj(l_feat).classObj=classObj;
    
    %epoch_to_romove=epoch:nb_epochs(l_subject);
end
close(h)% close the waitbar
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

