function [scores,prediction,index_selected, ClObj] = Sigma_cross_validation_loeo(features_results,init_parameter,best_index)
%[results, results_infos, index_selected,prediction] = ...
%   Sigma_cross_validation_loeo(features_results,init_parameter,best_index)
%% This function compute the crosscorrelation base on leave one epoch out
% [scores,prediction,index_selected, ClObj] = ...
%                   Sigma_cross_validation_loeo...
%                                    (features,labels,maxFeatNum,...
%                                   classificationMethod,best_voted_index)
% Used to train the model of calassification based on the Leave One l_epoch
%  Out and returns the performances measures used in the classification's
%  methods

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
% -results : matrix contaning the differents measure of classification,
% the size of this matrix is NxR, where N is the number of the feature to
% rank, R is the number of measures computed in this script
% -results_infos : contain the name of measured output, for now it comput
% th following measures :
% results_infos={'Auc','Accuracy', 'Sensitivity', 'Specificity',...
% 'Precision', 'Recall', 'F-Measure', 'G-mean' };
% Where :
% -Auc : Area under the curve :
% accuracy = (tp+tn)/N;
% sensitivity = tp_rate;
% specificity = tn_rate;
% precision = tp/(tp+fp);
% recall = sensitivity;
% f_measure = 2*((precision*recall)/(precision + recall));
% gmean = sqrt(tp_rate*tn_rate);

% p = length of the positif example
% n = length of the negatif example
% N = p+n;
%
% tp = sum(ACTUAL(idx)==PREDICTED(idx)); % number of the true positif
% tn = sum(ACTUAL(~idx)==PREDICTED(~idx)); %% number of the true negatif
% fp = n-tn;% number of the false positif
% fn = p-tp;% number of the false negatif
%
% tp_rate = tp/p;
% tn_rate = tn/n;


%%%%%%% The normalized are used in all this function
%% Extract the parameters of this function
if isfield(features_results,'o_features_matrix_normalize')
    % normalized with the Zscore
    o_features_matrix=features_results.o_features_matrix_normalize;
else
    % not normalized
    o_features_matrix=features_results.o_features_matrix;
end


label=features_results.label;
number_of_feature=size(features_results.o_best_features_matrix,1);

classification_method=init_parameter.classification_method;
ranking_method=init_parameter.ranking_method;

%% SECTION 1 :   Initialisation

% display(['You have selected the :  ' classification_method '....'])
number_of_epoch = size(o_features_matrix,2);
% scores = nan(number_of_feature,epochs);
scores_nc= nan(number_of_feature,number_of_epoch);
scores_pc= nan(number_of_feature,number_of_epoch);
prediction = nan(number_of_feature,number_of_epoch);

index_selected=[];

message=[ init_parameter.cross_validation_method ' & ' ...
    init_parameter.classification_method];
h = waitbar(0,[message '...'],'Name','SIGMA : Cross-Validation');
for l_epoch = 1:number_of_epoch
    waitbar(l_epoch/number_of_epoch,h,[message ' : epoch '...
        num2str(l_epoch) '/' num2str(number_of_epoch) ])
    %%% Part of feature to remove and the to test
    currFeats = o_features_matrix(:,l_epoch);
    %%% Part of the feature to train
    otherFeats = o_features_matrix;
    otherFeats(:,l_epoch) = [];
    %%% Part of the label to train
    otherLabels = label;
    otherLabels(l_epoch) = [];
    
    if nargin==2
        nb_features=number_of_feature;
        %% Running the OFR
        if strcmp(ranking_method,'gram_schmidt_probe')
            % On the all feature feature matrix
            [idx_best_features]=features_results.idx_best_features;
        else
            % On the leave one out feature matrix
            [idx_best_features]=Sigma_ranking_methods(init_parameter,...
                otherFeats,otherLabels,nb_features,ranking_method);
        end
        
        %[idx] = gram_schmidt(otherFeats, otherLabels, number_of_feature);
        idx=idx_best_features;
        idx=idx(:);
        index_selected=[index_selected idx(:)];
    end
    
    if nargin==3
        idx=best_index(:);
        index_selected=[index_selected idx];
    end
    
    for l_feature = 1:number_of_feature
        waitbar(l_epoch/number_of_epoch,h,[message ' : epoch ' ...
            num2str(l_epoch) '/' num2str(number_of_epoch)...
            ', feature : ' num2str(l_feature) '/' ...
                                    num2str(number_of_feature) ]);
        %l_feature
        featuresChosen = otherFeats(idx(1:l_feature),:);
        
        c_cost1 = sum(otherLabels == 1);
        c_cost2 = sum(otherLabels == -1);
        %   c_classname = [-1 1];
        %   c_class=unique(otherLabels);
        c_classname = [1 -1];%[c_class(1) c_class(2)];
        c_cost = [0 (c_cost2 / (c_cost1 + c_cost2));...
            (c_cost1 / (c_cost1 + c_cost2)) 0];
        if(classification_method == 'LDA')
            %display('You have selected the : LDA Classification....')
            classObj = fitcdiscr(featuresChosen',otherLabels',...
              'ClassNames', c_classname, 'Cost', c_cost, 'Prior', [.5 .5]);
        end
        
        if(classification_method == 'QDA')
            %display('You have selected the : QDA Classification....')
            classObj = fitcdiscr(featuresChosen',otherLabels',...
              'DiscrimType','diagLinear',...
              'ClassNames', c_classname, 'Cost', c_cost, 'Prior', [.5 .5]);
        end
        
        % will never reach this line! if loop is applied outisde 
        if(classification_method == 'SVM')          
            classObj = fitcsvm(featuresChosen',otherLabels');            
        end
        
        %%% save the results
        [YP, sc]=predict(classObj,currFeats(idx(1:l_feature))');
        %scores(l_feature,l_epoch) = sc(2);
        scores_nc(l_feature,l_epoch) = sc(2); % negative classe's score
        scores_pc(l_feature,l_epoch) = sc(1); % positive classe's score
        scores={scores_nc, scores_pc};
        prediction(l_feature,l_epoch) = YP;
        %ClObj{l_feature}=classObj;
        ClObj(l_feature).classObj=classObj;
    end
end
%close the wait bar
close(h)
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
% % %   Creation Date : 21/06/2017
% % %   Updates and contributors :
% % %       21/06/2017 Takfarinas MEDANI
% % %
% % %   Citation: [creator and contributor names], SigmaBOX, available
% % %   online 2017.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2017
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
