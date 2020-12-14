function o_output = Call_sigma_svm_loso_finale(features_results, init_parameter, best_index)

%% Section 1 - Initializations
%o_features_matrix = features_results.o_features_matrix;


% Extract the parameters of this function
if isfield(features_results,'o_features_matrix_normalize')
    % normalized with the Zscore
    o_features_matrix=features_results.o_features_matrix_normalize;
else
    % not normalized
    o_features_matrix=features_results.o_features_matrix;
end

label = features_results.label;
subject_epochs=features_results.subject_epoch;
% extract the assicited epochs for each subject
subject_epochs_index=[subject_epochs (1:length(subject_epochs))'];
nb_subject=init_parameter.nb_subject;
subject=init_parameter.subject;
clear epcohs_of_subject;
for l_subj=1:nb_subject
    index=find(subject_epochs_index(:,1)==subject(l_subj));
    epcohs_of_subject{l_subj}=subject_epochs_index(index,3);
end
c_max_feature = size(features_results.o_best_features_matrix,1);
% classification method
c_method = init_parameter.classification_method;
c_ranking_method = init_parameter.ranking_method;
% display : function beginning execution
disp(['You have selected the :  ' c_method '....'])
c_number_epoch = size(o_features_matrix,2);
% Output values
negative_score = nan(c_max_feature, c_number_epoch);
positive_score = nan(c_max_feature, c_number_epoch);
o_output.prediction = nan(c_max_feature, c_number_epoch);

index_selected=[];
prediction=[];
c_message=[ init_parameter.cross_validation_method ' & ' ...
    init_parameter.classification_method];
h = waitbar(0,[c_message '...'],'Name','SIGMA : Cross-Validation');


%% Section 2 - learning loop
for l_subj = 1 : nb_subject
    
    l_epoch=epcohs_of_subject{l_subj};
    bar_message = [c_message ' : subject ' num2str(l_subj)...
        '/' num2str(nb_subject) ' [1/3]'];
    waitbar(l_subj/nb_subject, h, bar_message)
    % Part of feature to remove and reserve for testing
    feat_out = o_features_matrix(:,l_epoch);
    label_out=label(:,l_epoch);
    if (size(feat_out,2)~=size(label_out,2))
        disp('The validation part is not correct');
    end
    % Part of the feature to train
    training = o_features_matrix;
    training(:,l_epoch) = [];
    % Part of the label to train
    train_label = label;
    train_label(l_epoch) = [];
    train_label;
    if (size(training,2)~=size(train_label,2))
        disp('The training part is not correct');
    end
    % Get the best features using the OFR or other
    if nargin == 2 %if feature list not provided
        c_number_feature = c_max_feature;
        % Running the OFR
        if strcmp(c_ranking_method, 'gram_schmidt_probe'),
            % On all the feature matrix
            best_feature = features_results.idx_best_features;
        else
            % On the leave one out feature matrix
            best_feature = Sigma_ranking_methods(init_parameter, ...
                training, train_label, c_number_feature, c_ranking_method);
        end
        index = best_feature;
        index= index(:);
    else
        if nargin==3, index = best_index(:); end
    end
    index_selected=[index_selected index(:)];
    
    
    % loop over the featues
    for l_feature = 1 : c_max_feature,
        %l_feature
        waitbar(l_subj/nb_subject, h, [bar_message ...
            ', feature : ' num2str(l_feature) '/' num2str(c_max_feature) ' [1/3]'])
        
        selected = training(index(1:l_feature), :);
        
        %% SVM optimisation
        %result{l_epoch, l_feature} = Sigma_fitcsvm2(selected',train_label');
        svm_parameter_in=init_parameter.svm_parameter;
        disp('IC LABEL')
        disp(train_label)
        
        result{l_subj, l_feature} = Sigma_fitcsvm_finale(selected',train_label',svm_parameter_in);
                
        %Sigma_fitcsvm
        result{l_subj, l_feature}.label = label_out;
    end
end

%% Section 3 - finding best model
svm_parameter=init_parameter.svm_parameter;
for l_feature = 1 : c_max_feature,
    waitbar(l_feature/c_max_feature, h, 'Test the hyper Parameters [2/3]')
    best_auc=0;
    best_hyperparameter{l_feature}.constraint = -1;
    best_hyperparameter{l_feature}.condition = -1;
     for l_constraint = 1 : length(svm_parameter.c_constraint)
        for l_condition = 1 : length(svm_parameter.condition)
            auc=0;
            predicted_lables=[];
            expected_lables =[];
            score_pos_class=[];
            for l_subj = 1 : nb_subject
                l_result = result{l_subj, l_feature};
                
                model=l_result.fitmodel{l_constraint, l_condition};

                l_epoch=epcohs_of_subject{l_subj};
                feat_out = o_features_matrix(index(1:l_feature),l_epoch);
                label_out=label(:,l_epoch);
                
                
                [label_predicted,score_prediction] = predict(model,feat_out');
                
                predicted = label_predicted;
                expected = label_out; % ok maintenant
                scored=score_prediction(:,2);% positive class score
                
                predicted_lables=[predicted_lables; predicted(:)];
                expected_lables =[expected_lables; expected(:)];
                score_pos_class=[score_pos_class; scored];             
            end
            % puis ici il faut calculer l'AUC
            %            disp('Compute the ROC')
            [~,~,~,auc] = perfcurve(expected_lables,score_pos_class,1);
            %            auc
            %             if (error < best_error)
            %                 best_error = error;
            %                 best_hyperparameter{l_feature}.constraint = l_constraint;
            %                 best_hyperparameter{l_feature}.condition = l_condition;
            %             end
            if (auc > best_auc)
                best_auc= auc;
                best_hyperparameter{l_feature}.nb_feat=l_feature;
                best_hyperparameter{l_feature}.auc=best_auc;
                best_hyperparameter{l_feature}.constraint = l_constraint;
                best_hyperparameter{l_feature}.condition = l_condition;
                disp(['nb feat = ' num2str(l_feature) '; best condition: ' num2str(l_condition)...
                    '; best constraint : ' num2str(l_constraint),...
                    '; best auc= ' num2str(best_auc)])
            end
        end
    end
end

%% Section 4 - returning best model
waitbar(l_feature/c_max_feature, h, 'Get the best parameters [3/3]')

for l_feature = 1 : c_max_feature,
    
    condition = best_hyperparameter{l_feature}.condition;
    constraint = best_hyperparameter{l_feature}.constraint;
    best_auc=best_hyperparameter{l_feature}.auc;
    auc=[];
    predicted_lables=[];
    expected_lables =[];
    score_pos_class=[];    
    
    for l_subj = 1 : nb_subject
        l_epoch=epcohs_of_subject{l_subj};
        l_result = result{l_subj, l_feature};
                
        model=l_result.fitmodel{constraint, condition};
%         model = fitSVMPosterior(model);
        
        % Part of feature to remove and reserve for testing
        feat_out = o_features_matrix(index(1:l_feature),l_epoch);
        label_out=label(:,l_epoch);
        
        [label_predicted,score_prediction] = predict(model,feat_out');
        
        predicted = label_predicted;
        expected = label_out; % ok maintenant
        scored=score_prediction(:,2);% positive class score
        
        negative_score(l_feature, l_epoch)=score_prediction(:,1);% positive class score
        positive_score(l_feature, l_epoch)=score_prediction(:,2);% positive class score
        
        
        predicted_lables=[predicted_lables; predicted(:)];
        expected_lables =[expected_lables; expected(:)];
        score_pos_class=[score_pos_class; scored];
    end
    [~,~,~,auc] = perfcurve(expected_lables,score_pos_class,1);
    
    auc_per_feature(l_feature)=auc
    classifier(l_feature).classObj = model;
    predicted_lables=predicted_lables(:);
    prediction=[prediction; predicted_lables'];
    % o_output.score = {negative_score, positive_score};
end
o_output.auc=auc;
o_output.prediction=prediction;
o_output.score = {negative_score, positive_score};
o_output.classifier = classifier;
o_output.index = index_selected;
o_output.best_hyperparameter=best_hyperparameter;

delete(h)


end