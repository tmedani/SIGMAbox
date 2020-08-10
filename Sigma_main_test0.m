%% Essai toolbox bci_test1 :
% clear all;close all;clc

%% 0000- Display the liste of the related toolbox used by this script
%%% To make sure that this line will run you should execut all the scipt
%%% and not only this line
if 0
    Sigma_related_toolbox_and_file(mfilename);
    
    %% 000- Add ISGMA box to the path
    
    %% 00- Load an existing session
    %% Load a specified session :
    Sigma_install
    c_session_name='C:\Users\Takfarinas\Dropbox\SIGMA\SIGMA_output\Session_21-Feb-2018_113734\Session_21-Feb-2018_113734.mat';
    Sigma_load_session(c_session_name)
    %Script_load_session
end

%% ************** Start from here for new session
% Run the "parameters_initialisation" to initialise all the user inputs
% clear all;close all;clc
%% 0- Parameters initialisation
Sigma_close_all_waitbar
%%******** BEFOR STARTING ENSURE THAT YOU ARE IN THE SIGMA PATH **********%%
init_parameter = Sigma_parameter_initialisation();
init_parameter  =  Sigma_create_session(init_parameter);
%% bis - Méthodes Initialisation
%% frequency initialisation
% define the frequency of the differents bands
init_parameter = Sigma_frequency_initialisation(init_parameter);

%% compute the parameters of the filters
init_parameter = Sigma_filter_parameter(init_parameter);

%% method initialisation
% define a get the parameters of the methods
init_method = Sigma_method_initialisation(init_parameter);

%these line is calling the data visualization GUI.
if 0
    Sigma_visualisating_data([],init_parameter);
end
%% Features extraction
% extract the features according to the methods
feature_result = Sigma_feature_extraction(init_parameter, init_method);

%% TODO : add here the loading of the custom features
load_custom_feat=0;
if load_custom_feat == 1
    [init_parameter,feature_result] = ...
        Sigma_load_custom_feature(init_parameter,init_method);
    [init_parameter,feature_result] = ...
        Sigma_load_custom_feature(init_parameter,init_method,feature_result);
    dataout = Sigma_load_custom_feature;
end

%% Features assembling & normalize
% assemble the features, get the BIG o_feature_matrix
init_parameter.compute_cross_term_feature = 0;
init_parameter.nb_features = 30;
feature_result = Sigma_feature_assembling(init_method,init_parameter,feature_result);
%
%
% [feature_matrix_all_term, feature_matrix_cross_term,...
%             feature_matrix_cross_term_id] = Sigma_creat_cross_term_feature...
%                                                 (feature_result.o_features_matrix);
%feature_result.o_features_matrix=feature_matrix_all_term;
%% 3- Features ranking
%init_parameter.nb_features=3;
%init_parameter.ranking_method='gram_schmidt';

[feature_result] = Sigma_feature_ranking3(init_parameter,init_method,feature_result);
%write a text file containning the identification of the features
%filename='toto'; % witout the extention, the file is created on the session directory
%Sigma_write_feature_identification(filename,init_parameter,init_method,feature_result)
%% Comput the RISK (ASK françois about the risk computational)


%% Plot the 3D features disctribution for the 3 best features
if 0
    Sigma_3DScatterPlot(init_parameter,init_method,feature_result);
end
%% Get the index of the best organisation from the OFR
% best_organisation=feature_result.best_organisation;
% best_index=cell2mat(best_organisation(:,1));


%% MACHINE LEARNING
%%% Teste the result using the Cross Validation methods based on the trainig data
[performance_result] = Sigma_cross_validation(feature_result,init_parameter,init_method);

%%% Display some results according to the process
if 0
    Sigma_display_results(init_parameter,performance_result,feature_result) % not already finished
    % 2d display with the separation    
    feature_index=[1 2];
    Sigma_gscatter_plot(init_parameter,feature_result,feature_index)
end
%%% Get the selected results accordin to the best AUC
selected_model = Sigma_get_best_model(init_parameter,feature_result,init_method,performance_result);


%% Apply the model
test_or_application='Application';
test_or_application='Test'; 

apply_model_in.init_parameter=init_parameter;
apply_model_in.init_method=init_method;
apply_model_in.selected_model=selected_model;
apply_model_in.test_or_application=test_or_application;

% Appdat the Sigma_apply_model_final according to the ones GUI
apply_model_out = Sigma_apply_model_final(apply_model_in);
apply_model_out = Sigma_apply_model_final(apply_model_in);


%% Display results
if 0
    %%% ROC curves
    if test_or_application == 'Validation'
        pos_score=apply_model_out.predicted_scores(:,2);
        labels=apply_model_out.origine_labels;
        nb_feature=size(apply_model_out.computed_feature_new_data,1);
        roc_title='ROC of the Test phase';
        % run the function
        Sigma_plot_roc(labels,pos_score,roc_title,nb_feature);
        clear labels pos_score nb_feature roc_title
    end
    if test_or_application == 'Application'
        nb_feature=size(apply_model_out.computed_feature_new_data,1);
        pos_score=performance_result.scores{2}(nb_feature,:);
        labels=feature_result.labels;
        roc_title='ROC of the Application (Training results)';
        % run the function
        Sigma_plot_roc(labels,pos_score,roc_title,nb_feature);
        clear labels pos_score nb_feature roc_title
    end
    %%% Confusion Matrix
    if test_or_application == 'Validation'
        labels=apply_model_out.origine_labels; labels=labels(:);labels=labels';
        prediction=apply_model_out.predicted_labels;prediction=prediction(:);prediction=prediction';
        confusion_title='Confusion Matrix: Test Phase';
        Sigma_plot_confusion_matrix(labels,prediction,confusion_title)
        [confusion_matrix, overall_pcc, group_stats, groups_list] = ...
            confusionMatrix3d(prediction,labels,confusion_title);
    end
    if test_or_application == 'Application'
        labels=selected_model.origine_labels; labels=labels(:);labels=labels';
        prediction=selected_model.predicted_labels;prediction=prediction(:);prediction=prediction';
        confusion_title='Confusion Matrix: Application Phase (Training results)';
        Sigma_plot_confusion_matrix(labels,prediction,confusion_title)
        [confusion_matrix, overall_pcc, group_stats, groups_list]...
            =confusionMatrix3d(prediction,labels,confusion_title);
    end
    
    
    [confusion_matrix,~] = confusionmat(labels,prediction)
    opt=confMatPlot('defaultOpt');
    opt.className={'High', 'Low'};
    opt.mode='both';
    opt.mode='percentage';
    opt.format='8.2f';
    figure; confMatPlot(confusion_matrix, opt);
    
    %% Save the result of the current session
    session_name = init_parameter.session_name;
    Sigma_save_session(session_name,init_parameter,init_method,feature_result,performance_result,selected_model);
    %Sigma_save_session(init_parameter,init_method,feature_result);
    
    %session_name=init_parameter.full_session_name;
    %session_name = 'ttest';
    Sigma_save_session(session_name,init_parameter,init_method,feature_result,performance_result);
    
    %% Load a specified session :
    session_name='C:\Users\Takfarinas\Dropbox\SIGMA\totototoXXt.mat';
    session_name='takffffaaa.mat';
end

%%%%%% ------------------------ USER STOPE HERE ---------------------------