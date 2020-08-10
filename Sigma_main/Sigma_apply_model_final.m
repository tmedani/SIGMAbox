function apply_model_out=Sigma_apply_model_final(apply_model_in)
% last update 07/12/2017 17h55
% This function is the last part of the SIGMA toolbox, it compute the
% performance of the selected model for new data or classify just new data.
% INPUTS:
%    new_data : structures containig the path of the new data to lassify
%           it should contain the following field:
%           new_data.data_location : the path of the data
%           new_data.subject : the list of the subjects for the classification
%   init_parameter :          the output of the Sigma_parameter_initialisation
%    init_method    :          the output of the Sigma_method_initialisation
%   selected_model :          the output of the Sigma_get_best_model
%   test_or_application : string containig the word  'test' or 'Application'
%       test: the function will comput the performance of the model on
%           new data with known label (test data), the output
%       Application : classyfy the new data according to the best model
%           selected by 'selected_model'
% OUPUTS:
%   computed_feature_new_data : the matrix of the features computed according
%       to the selected methods, channels and bands from the 'selected_model'
%   predicted_label : the prediction obtained from the
%       computed_feature_new_data with the best classifier defined in the selected_model
%   predicted_scores : the associated score for the prediction
%   test_results : structures containing the results only for the
%   test case : test_or_application,'test'





%% GET the input from the GUIDE (handles structures)
% handles input
init_parameter=apply_model_in.init_parameter;
init_method=apply_model_in.init_method;
selected_model=apply_model_in.selected_model;
test_or_application=apply_model_in.test_or_application;
% Initilisation of the output for new simulation
apply_model_out=[];
%% Apply model or test model
% in the case of the user specify data for the test

% List of the subject for the test : % Extract the subject numbers

list_subject = dir(fullfile(init_parameter.sigma_directory,init_parameter.test_data_location, '\*.mat'));

if isempty(list_subject)
    errordlg ('Please select path with available SIGMA data','SIGMA Error')
    return
end

% Get the number of the subject to test
% /!\ Warnng the name of the subject should be respected as the SIGMA
% format
for ind=1:length(list_subject)
    sub=list_subject(ind).name;
    str=sub;
    [~,name,~] =fileparts(str);
    C = strsplit(name,'_'); C=C(2);C=C{:};
    num(ind)=str2num(C);
end

% Get the new subject to test:

init_parameter.subject_for_test=num;
init_parameter.test_data_location=fullfile(init_parameter.sigma_directory,init_parameter.test_data_location);


%% Initialise the parameters for Tests or Application
% test or TEST : in this case the output of the data are known
if strcmp(test_or_application,'Test')
    % check if the subject_for_test are specified on init_parameters
    if isfield(init_parameter,'subject_for_test')
        test_data=1; % used to get the test results
        new_data.data_location=init_parameter.test_data_location;
        new_data.subject=init_parameter.subject_for_test; % list of the new subjects/data
        new_data.nb_subject=length(new_data.subject);
        test_results_infos='The Results are from the test/test data';
    else
        warning('SIGMA>> Tests data are not specified in init_parameter')
    end
    % APPLICATION : in this case the output of the data are unknown
elseif strcmp(test_or_application,'Application') %% TODO
    test_data=0;
    new_data.data_location=init_parameter.test_data_location; %%!! Implement the path of the new data
    new_data.subject=init_parameter.subject_for_test; % list of the new subjects/data
    new_data.nb_subject=length(new_data.subject);
    test_results=selected_model.performance_model;
    test_results_infos='The results are those of the training model, see selected_model structure ';
else
    warning('SIGMA>> oups... something is wrong....')
    error('SIGMA>> You must specify test or Application on the Appy_model function')
end

%% Extract the feature designed in the selected model from the new data
% Location of the new data
data_location=new_data.data_location;
% the data
subject=new_data.subject; % list of the subject
nb_subject=new_data.nb_subject;

%% Initialisation of the local vectors
% ftom here we have the same structure as the one on the
% Sigma_features_extraction.m
%%% As the number of the feature selected coincide with the number of method
%%% to use, and also with the number of channel,
%%% each method wil give one feature, the algoritm will iterate in this way

% the number of features
nb_feat_model=selected_model.nb_feat_model;
method_number=nan(nb_feat_model,1);
channel_number=nan(nb_feat_model,2);
freq_band_number=nan(nb_feat_model,1);
power_type=nan(nb_feat_model,1);
epochs=[];
model_results =[];
computed_feature_all=[];
label=[];
% method type will contain an index
% 1 : single channel, 2 : synchronisation channel
method_type=zeros(1,nb_feat_model);
%% Fullfile the vectore with information from the selected model
% Extract the list of the methods/channels and bands used in the trainig phase
for ind_feat=1:nb_feat_model
    %list of methods
    method_number(ind_feat)=selected_model.best_organisation_ofr_model{ind_feat,2};
    %list of channels
    if size(selected_model.best_organisation_ofr_model{ind_feat,3},2)==1
        method_type(ind_feat)=1;
        channel_number(ind_feat,:)=selected_model.best_organisation_ofr_model{ind_feat,3};
        %channel_number=channel_number(:,1);
    end
    if size(selected_model.best_organisation_ofr_model{ind_feat,3},2)==2
        method_type(ind_feat)=2;
        channel_number(ind_feat,:)=selected_model.best_organisation_ofr_model{ind_feat,3};
    end
    %list of the bands
    freq_band_number(ind_feat)=selected_model.best_organisation_ofr_model{ind_feat,4};
    %list of power type
    power_type(ind_feat)=selected_model.best_organisation_ofr_model{ind_feat,5};
end
%%% set the default parameters
% apply_filter : in order to extract the associated band
init_param_apply_model.apply_filter=ones(size(freq_band_number));
% nb_bands : the number of band in which the feature will be extracted,
init_param_apply_model.nb_bands=1; % only one time
% method : the list of the method to extract
init_param_apply_model.method=method_number;
% for the fourrier Power (set always to 1)
init_method(1).all_fourier_power=1;

%% Strating from here to EXTRACT The new features
% Extract the features from the OFR according to the training phase
h = waitbar(0,'Apply moded','Name','SIGMA : Apply model','CreateCancelBtn','setappdata(gcbf,''Cancel'',1)');
for Nsubj=1:nb_subject;
    waitbar(Nsubj/nb_subject,h,['Apply model : Subject ' num2str(Nsubj) '/' num2str(nb_subject) '  please wait...']);
    if getappdata(h,'Cancel')
        fprintf('That was taking too long!');
        break
    end
    
    % load the data associated to selected subject
    if ispc
        load([data_location '\' 'subject_'  num2str(subject(Nsubj)) '.mat ']);
    end
    if ismac
        load([data_location '/' 'subject_'  num2str(subject(Nsubj)) '.mat ']);
    end
    
    display(['AM : The subject ' num2str(s_EEG.subject_number) ' is loaded' ])
    
    % Update the samlig rate
    init_param_apply_model.sampling_rate=s_EEG.sampling_rate;
    
    %%% Save a copy of the s_EEG for the next loop,
    %%% keep the data safe befor the transformation
    original_data=s_EEG;
    
    % The number of epochs
    nb_epochs=size(s_EEG.data,3);
    epochs=[epochs size(s_EEG.data,3)]; % it's seems to be the same
    
    % The number of channels
    nb_channel((subject(Nsubj)))=size(s_EEG.data,1);
    
    % The label
    label=[label s_EEG.labels];
    
    %%% initialisation of the memory fo the computed features
    computed_feature_all0=[];
    pw_results=[]; % to store the fourrier power
    used_parameters=[];
    used_parameters_name=[];
    for Nmethode=1:nb_feat_model
        %%% New parameter for the apply model
        %%% select the associated band for the actual feature
        % get the number of frequency used in the model
%         %nb_bands=length(init_parameter.filt_band_param); % nombre de bandes selectionné dans init parameters
%         selecte_band=init_parameter.selected_band;
%         nb_bands=init_parameter.nb_bands;
%         % get the used band for the feature
%         ind=unique(freq_band_number);
%         % select wich band will be applied for this feature
%         index_band=find(freq_band_number(Nmethode)==ind);
        
        
        init_selected_band=init_parameter.selected_band;
        best_band=freq_band_number(Nmethode);
        index_band=find(init_selected_band==best_band);

        
        init_param_apply_model.filt_band_param=init_parameter.filt_band_param((index_band));
        % select the associated channel numbers and names for the actual feature
        if method_type(Nmethode)==1
            used_channels=channel_number(Nmethode,1);
        end
        if method_type(Nmethode)==2
            used_channels=channel_number(Nmethode,:);
        end
        s_EEG.data=s_EEG.data(used_channels,:,:);
        s_EEG.channel_names=s_EEG.channel_names(used_channels);
        % select the actual band
        init_param_apply_model.selected_band=freq_band_number(Nmethode);
        
       
        %In the case of wavelet 
        if isfield(init_parameter,'wavelet_transform_param')
            init_param_apply_model.wavelet_transform_param=init_parameter.wavelet_transform_param;
            init_param_apply_model.selected_freq_bands=init_parameter.selected_freq_bands(index_band,:);
        end
        
        
        %% Extract the associated feature
         if method_number(Nmethode)==1
            init_method(1).index_band=index_band;
         end
         
         % clear athe variable
          eval(['model_results.' (init_method(init_param_apply_model.method(Nmethode)).method_out) '=[];'])
            
        for Nepochs=1:nb_epochs
            waitbar(Nsubj/nb_subject,h,['AM : Subject ' num2str(Nsubj) '/' num2str(nb_subject) ...
                ', Epoch : '  num2str(Nepochs) '/' num2str(size(s_EEG.data,3))...
                ', Method : ' num2str(Nmethode) '/' num2str(nb_feat_model)]);
            
            
            
            model_results=eval([init_method(init_param_apply_model....
                .method(Nmethode)).fc_method_name ...
                '(init_param_apply_model,init_method,model_results,s_EEG,Nsubj,Nepochs,Nmethode);']) ;
           
            % The output of the extraction
            % xxxx_band=[method channel band]
            % xxxx = the value
            
            %%% extract the value of the feature
            results=eval(['model_results.' (init_method(init_param_apply_model.method(Nmethode)).method_out) ';']);
            %% only for the fourrier power (for now, later other methods will be included in the exception)
            if method_number(Nmethode)==1;
                index=init_method(1).index_band;
                pw_results=[model_results.o_fourier_power_type model_results.o_fourier_power];
                power_type_infos=model_results.o_fourier_power_type_infos;
            end
            % When it's finished all tha feature are computed for the current subjecct and method and they are stored in the
            % variable results
        end
        %%% clean the variable
        eval(['model_results.' (init_method(init_param_apply_model.method(Nmethode)).method_out) '=[];'])  ;       %%% In the case of the Fourier Power method=1;
        
        % if the method is the fourrier power
        % select from absolute, relative power
        used_power_type=nan;
        index_to_select=nan;
        if method_number(Nmethode)==1;
            index_to_select=find(pw_results(:,1)==power_type(Nmethode));
            used_power_type=power_type_infos(index_to_select);
            power_selected=pw_results(index_to_select,2:end);
            computed_feature_all0=[computed_feature_all0; power_selected];
        else
            computed_feature_all0=[computed_feature_all0; results];
        end
        
        %% methods
        method_used=method_number(Nmethode);
        band_used=freq_band_number(Nmethode);
        % save the informations of the extracted features
        used_parameters=[used_parameters;{method_used}   {used_channels} {band_used} {index_to_select}];
        used_parameters_infos={'method','channels','band','power type'};
        power_type_info={'0 : all bands';'1 : absolute ';'2 : relative ';'NaN : not power method '};
        
        used_method_name=init_method(method_used).method_name;
        used_channel_name=s_EEG.channel_names;
        used_band_name=init_parameter.bands_list(band_used);
        used_power_type_name=used_power_type;
        temp1=[used_method_name   used_channel_name used_band_name used_power_type_name];
        
        display('------------------------------------------')
        display(['    feature : ' temp1{1} '; (N° ' num2str(method_used) ')']);
        display(['    channel(s) : ' temp1{2} '; (N° ' num2str(used_channels) ')']);
        display(['    freq band : ' temp1{3} '; (N° ' num2str(band_used) ')']);
        display(['    power type : ' temp1{4} '; (N° ' num2str(band_used) ')']);
        
%         concat=[used_parameters_name;temp1];
%         used_parameters_name = concat;
        used_parameters_name{Nmethode} = temp1;

        % initialisation for the next feature
        pw_results=[];
        s_EEG=original_data;
    end    
    
    computed_feature_all=[computed_feature_all computed_feature_all0];
    size(computed_feature_all);
end
delete(h) %% close the wait bare

% Check the feature in the case of the same data
% Put break point here to check
same_data=0;
if same_data
    nfeat=1;
    figure;
    plot(computed_feature_all(nfeat,:),'*')
    hold on
    plot(selected_model.best_feature_training_ofr(nfeat,:),'ro')
    legend('test','train')
    title('Not Normalized data')
end
% Todo User can choose between bagging or simple ofr on all data
%% Normalize the data according to the training phase
feature_selection='ofr';
if strcmp(feature_selection,'ofr')
    feature_mean=selected_model.best_feature_mean_ofr_model;
    feature_std=selected_model.best_feature_std_ofr_model;
elseif strcmp(feature_selection,'bag')
    feature_mean=selected_model.best_feature_mean_bag_model;
    feature_std=selected_model.best_feature_std_bag_model;
end

% % normalization acording to the training set
% computed_feature_all_normalize=(computed_feature_all-feature_mean)./feature_std;

% françois' version

computed_feature_all_normalize = ( computed_feature_all - ...
    repmat( feature_mean,1,size(computed_feature_all,2) ) ) ./ ...
    repmat( feature_std,1,size(computed_feature_all,2) );


% Check the feature in the case of the same data
% Put break point here to check
same_data=0;
if same_data
    nfeat=1;
    figure;
    plot(computed_feature_all_normalize(nfeat,:),'*')
    hold on
    plot(selected_model.best_feature_training_normalize_ofr(nfeat,:),'ro')
    legend('test','train')
    title('Normalized data')
end


% The Final feature matrix computed from the new data
computed_feature_new_data=computed_feature_all_normalize;

if size(computed_feature_new_data,2)~=sum(epochs)
    msgbox('There is an error in the Features matrix,#examples, please check the data')
    return
end

if size(computed_feature_new_data,1)~=nb_feat_model
    msgbox('There is an error in the Features matrix,#Feat, please check the data')
    return
end

% Prediction for the new subjects
classObj=selected_model.classObj;
[YP, sc]=predict(classObj,computed_feature_new_data');
if size(YP,1)~=sum(epochs)
    msgbox('There is an error in the prediction computation, please check the model')
    return
end
predicted_label=YP;
predicted_scores=sc;

% Comput the performances if the user ask for test/tests
if test_data==1
    predicted_groups=YP;
    %%% Compute the score in the case of test
    [~, adapted_label]=Sigma_set_label(label);
    actual_groups=adapted_label';
    %[X,Y,T,AUC,OPTROCPT] = perfcurve(actual_groups,predicted_scores(:,1),1)
    
    [confusion_matrix overall_pcc group_stats groups_list] = confusionMatrix3d(predicted_groups,actual_groups,[]);
    [performance,performance_infos]=Sigma_compute_performance(actual_groups',YP',sc(:,2)');
    % outputs
    test_results.confusion_matrix=confusion_matrix;
    test_results.performance=performance;
    test_results.performance_infos=performance_infos;
    test_results.overall_pcc=overall_pcc;
    test_results.group_stats=group_stats;
    apply_model_out.origine_label=actual_groups;
end

% handles output
apply_model_out.used_parameters_name=used_parameters_name;
apply_model_out.used_parameters=used_parameters;
apply_model_out.computed_feature_new_data=computed_feature_new_data;
apply_model_out.predicted_label=predicted_label;
apply_model_out.predicted_scores=predicted_scores;
apply_model_out.test_results_infos=test_results_infos;
apply_model_out.test_results=test_results;
end
