function selected_model=Sigma_get_best_model...
                         (init_parameter,feature_result,performance_result)
%%%------------------------------------------------------------------------
% function selected_model=Sigma_get_best_model(init_parameter,
%                                       feature_result,performance_result)
%  Function task:
%  Select the best model according to the best AUC obtained on the training
%  phase
%
%  Inputs :
%  init_parameter : structure containing the initial parameters of SIGMA
%  feature_result : structure containing the results of the feature
%  extraction
%  performance_result : The results of the cross validation on the trainig
%  phase
%  Outputs :
%   selected_model : structure containing the performance of the best model
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
%%%------------------------------------------------------------------------

%% SECTION 1 : Selecting the best results
%TODO get this from the parmeters
selection_method = 'ofr';

if strcmp(selection_method,'ofr')
    % Get the number of the features with the best AUC
    % Max AUC : todo select best model accordin to the others critéria
    [auc_model, index_max_auc] = max(performance_result.performance(:,8));
    selected_model.auc_model = auc_model;
    % The number of the features giving the best AUC
    if isfield(feature_result,'feature_matrix_cross_term_id')
        nb_feat_model = index_max_auc+1;
    else
         nb_feat_model = index_max_auc;
    end
    selected_model.nb_feat_model = nb_feat_model;
    
    % Get the ranking of these features with the OFR
    best_feat_ofr_model = feature_result.idx_best_features...   
                                                         (1:nb_feat_model);
    selected_model.best_feat_ofr_model = best_feat_ofr_model;
    % Get the matrix of the best features
    % not normalized
    best_feature_training_ofr = feature_result.o_features_matrix...
                                                   (best_feat_ofr_model,:);
    selected_model.best_feature_training_ofr = best_feature_training_ofr;
    % normalized
    best_feature_training_normalize_ofr = ...
         feature_result.o_features_matrix_normalize(best_feat_ofr_model,:);
    selected_model.best_feature_training_normalize_ofr = ...
                                       best_feature_training_normalize_ofr;
    
    best_feature_std_ofr_model = feature_result.o_features_matrix_std...    
                                                     (best_feat_ofr_model);
    best_feature_mean_ofr_model = feature_result.o_features_matrix_mean...
                                                     (best_feat_ofr_model);
    selected_model.best_feature_std_ofr_model = ...
                                                best_feature_std_ofr_model;
    selected_model.best_feature_mean_ofr_model = ...
                                               best_feature_mean_ofr_model;    
    
    best_organisation_ofr_model = feature_result.best_organisation...    
                                                       (1:nb_feat_model,:);
    selected_model.best_organisation_ofr_model = ...
                                               best_organisation_ofr_model;
    selected_model.best_organisation_info_model = ...
                                    feature_result.best_organisation_infos;
end

%% The bagging model
% TODO : all this should be checked for the method used before
if strcmp(selection_method,'bag')
    % TODO : exeption in the case of the bagging in différente to the ofr
    %%% Get the ranking of these features with the OFR + bagging
    best_feat_bag_model = ...
              Sigma_election_best_index(performance_result.index_selected);
    % romove the duplicated and keep the order
    [~,index]  =  unique(best_feat_bag_model,'first');
    best_feat_bag_model = best_feat_bag_model(sort(index));
    
    selected_model.best_feat_bag_model = best_feat_bag_model;
    
    % keep the feature matrix% not normalized
    best_feature_training_bag = feature_result.o_features_matrix...
                                                   (best_feat_bag_model,:);
    selected_model.best_feature_training_bag = best_feature_training_bag;
    % normalized
    best_feature_training_normalize_bag = ...
         feature_result.o_features_matrix_normalize(best_feat_bag_model,:);
    selected_model.best_feature_training_normalize_bag = ...
                                       best_feature_training_normalize_bag;
    
    % Get the std and the mean for the bagging
    best_feature_std_bag_model = ...
                 feature_result.o_features_matrix_std(best_feat_bag_model);
    best_feature_mean_bag_model = ...
               feature_result.o_features_matrix_mean(best_feat_bag_model) ;
    selected_model.best_feature_std_bag_model = ...
                                                best_feature_std_bag_model;
    selected_model.best_feature_mean_bag_model = ...
                                               best_feature_mean_bag_model;
    
    %%% Identification of the features  ofr + bagging
    init_parameter.sigma_show_comment = ~init_parameter.sigma_show_comment;
    init_parameter.sigma_show_comment = ~init_parameter.sigma_show_comment;
end

%%% Performance of this model (the selected model)
performance_model = performance_result.performance(index_max_auc,:);
performance_model_infos = performance_result.performance_infos;
selected_model.performance_model = performance_model;
selected_model.performance_model_infos = performance_model_infos;

% The target, label to predicts
% outputs = Sigma_adapt_label(performance_result.prediction...
%                                       (index_max_auc,:)); % The predition
% targets = Sigma_adapt_label(feature_result.label);
%%%Confusion Matrix  transform the labes
[confusion_matrix , classes]  =  confusionmat(feature_result.label ,...
                        performance_result.prediction(index_max_auc , :));

selected_model.confusion_matrix = confusion_matrix;
selected_model.classes = classes;
selected_model.origine_label = feature_result.label;
selected_model.predicted_label = ...
                          performance_result.prediction(index_max_auc , :);
% This selection is not correct ,  it select the last model
% Compute the new model using all the data:
%% TODO : add here the baggig model on the selected features
o_best_features_matrix = feature_result.o_best_features_matrix;
o_best_features_matrix_selected = ...
                                 o_best_features_matrix(1:nb_feat_model,:);
label = feature_result.label;

classificationMethod = init_parameter.classification_method;
if(classificationMethod  ==  'LDA')
    classObj  =  fitcdiscr(o_best_features_matrix_selected' , label');
    %classObj  =  fitcknn(featuresChosen' , otherLabels')
end

if(classificationMethod  ==  'QDA')
    classObj  =  fitcdiscr(o_best_features_matrix_selected' ,...
                                    label' , 'DiscrimType' , 'diagLinear');
end

if(classificationMethod  ==  'SVM')   
    %You should get all this from the gui
    ic_data  =  o_best_features_matrix_selected';
    ic_label  = label';
    c_kernel  = init_parameter.svm_parameter.c_kernel;
    c_gaussian_value  = init_parameter.svm_parameter.c_gaussian_value;
    c_polynomial_value  =  init_parameter.svm_parameter.c_polynomial_value;
    c_constraint  =  init_parameter.svm_parameter.c_constraint  ;
    c_class = unique(ic_label);
    c_classname  =  [c_class(1) c_class(2)];
    c_cost1  =  sum(ic_label  ==  1);
    c_cost2  =  sum(ic_label  ==  -1);
    c_cost  =  [0 (c_cost2 / (c_cost1 + c_cost2));...
        (c_cost1 / (c_cost1 + c_cost2)) 0];
    % stability check variables
    c_tolkkt  =  5e-2; % KKT tolerance
    
    l_constraint = performance_result.best_hyperparameter...
                                                {nb_feat_model}.constraint;
    l_condition = performance_result.best_hyperparameter...
                                                 {nb_feat_model}.condition;
    c_kernel0  =  c_kernel{1};
    
    disp(['You have selected the "' c_kernel0 '" kernel for your SVM'])
    
    if (strcmp(c_kernel0 ,  'polynomial')  ==  1)
        model  =  fitcsvm(ic_data ,  ic_label , ...
            'KernelFunction' ,  'polynomial' , ...
            'PolynomialOrder' ,  c_polynomial_value(l_condition) , ...
            'BoxConstraint' ,  c_constraint(l_constraint) , ...
            'KKTTolerance' ,  c_tolkkt ,  ...
            'ClassNames' ,  c_classname , ...
            'Cost' ,  c_cost);
    else
        if (strcmp(c_kernel0 ,  'rbf')  ==  1)
            model  =  fitcsvm(ic_data ,  ic_label , ...
                'KernelFunction' ,  'rbf' , ...
                'KernelScale' ,  c_gaussian_value(l_condition) , ...
                'BoxConstraint' ,  c_constraint(l_constraint) , ...
                'KKTTolerance' ,  c_tolkkt ,  ...
                'ClassNames' ,  c_classname , ...
                'Cost' ,  c_cost);
        else
            model  =  fitcsvm(ic_data ,  ic_label , ...
                'KernelFunction' ,  c_kernel0 , ...
                'BoxConstraint' ,  c_constraint(l_constraint) , ...
                'KKTTolerance' ,  c_tolkkt ,  ...
                'ClassNames' ,  c_classname , ...
                'Cost' ,  c_cost);
            
        end
    end
    classObj = model;
end
%%
selected_model.classObj = classObj;
% MSG
msg1 = ['The best model is selected according to the best AUC  =  '...
                                num2str(100*selected_model.auc_model) '%'];
% if isfield(feature_result,'feature_matrix_cross_term_id')
%     msg2 = ['The best model is obtained using the ' ...
%             num2str(selected_model.nb_feat_model) ...
%                 ' best ranked features (cross terms)'];
% else
    msg2 = ['The best model is obtained using the ' ...
            num2str(selected_model.nb_feat_model) ' best ranked features'];
% end
msgbox({msg1;msg2}  , 'SIGMA : select best model')

end

%%
% % %----------------------------------------------------------------------
% % %                  Brain Computer Interface team
% % %
% % %                            _---~~(~~-_.
% % %                          _{        )   )
% % %                         ,    ) -~~- (  , -' )_
% % %                       (  `- , _..`. ,  )-- '_ , )
% % %                      ( ` _)  (  -~( -_ ` ,   }
% % %                      (_-  _  ~_-~~~~` ,    , ' )
% % %                        `~ -^(    __;- , ((()))
% % %                              ~~~~ {_ -_(())
% % %                                     `\  }
% % %                                       { }
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 17/11/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names] ,  comprehensive BCI
% % %             toolbox ,  available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors ,  2016
% % %   Creative Commons License ,  CC-BY-NC-SA
% % %----------------------------------------------------------------------