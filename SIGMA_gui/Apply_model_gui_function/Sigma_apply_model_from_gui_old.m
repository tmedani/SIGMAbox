function handles=Sigma_apply_model_from_gui(handles)
%%%------------------------------------------------------------------------
%  init_parameter = Sigma_parameter_initialisation(varargin)
%
% Scripts task:
% last update 07/12/2017 17h30
% This function is the last part of the SIGMA toolbox, it compute the
% performance of the selected model for new data or classify just new data.
% INPUTS:
%  new_data : structures containig the path of the new data to lassify
%      it should contain the following field:
%      new_data.data_location : the path of the data
%      new_data.subject : the list of the subjects for
%      the classification
%  init_parameter :     the output of the
%                    Sigma_parameter_initialisation
%  init_method  :     the output of the
%                      Sigma_method_initialisation
%  selected_model :     the output of the Sigma_get_best_model
%  test_or_application : string containig the word 'test'
%                            or 'Application'
%    test: the function will comput the performance of the model on
%      new data with known label (test data), the output
%    Application : classyfy the new data according to the best model
%      selected by 'selected_model'
% OUPUTS:
%  computed_feature_new_data : the matrix of the features
%                            computed according
%    to the selected methods, channels and bands from the
%                             'selected_model'
%  predicted_label : the prediction obtained from the
%    computed_feature_new_data with the best classifier defined
%                           in the selected_model
%  predicted_scores : the associated score for the prediction
%  test_results : structures containing the results only for the
%  test case : test_or_application,'test'
%
%
%--------------------------------------------------------------------------
%
%
% Main Variables
%
% Dependencies
%
%% NB: this code is copyrighted.
% Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


%% SECTION 1 : GET the input & Initialisaion
% handles input
init_parameter = handles.apply_model_in.init_parameter;
init_method = handles.apply_model_in.init_method;
selected_model = handles.apply_model_in.selected_model;

if isfield(handles,'AM_Load_custom_feature')
    if handles.AM_Load_custom_feature == 1
        feature_result = handles.apply_model_in.feature_result;
    end
else
    handles.AM_Load_custom_feature = 0;
    %AM_Load_custom_feature = 0;
end

% Apply model or test model
% in the case of the user specify data for the test
test_or_application = handles.apply_model_in.test_or_application;

% Initilisation of the output for new simulation
if isfield(handles,'apply_model_out')
    handles = rmfield(handles,'apply_model_out') ;%
end



% List of the subject for the test : % Extract the subject numbers

if handles.AM_Load_custom_feature == 0
    list_subject = handles.AM_selected_data.String ;
    if isempty(list_subject)
        errordlg ('Please select path with SIGMA Subject','SIGMA Error')
        return
    end
    % Get the number of the subject to test
    % /!\ Warning the name of the subject should be respected as the SIGMA
    % format
    c_num_of_subject = zeros(length(list_subject),1);
    for l_subject = 1:length(list_subject)
        sub = list_subject(l_subject);
        str = sub{:};
        [~,name,~] = fileparts(str);
        C = strsplit(name,'_'); C = C(2);C = C{:};
        c_num_of_subject(l_subject) = str2num(C);
    end
    
else
    c_num_of_subject = [];
end
% Get the new subject to test:
init_parameter.subject_for_test = c_num_of_subject;

init_parameter.test_data_location = handles.AM_st_data_path.String;


%% Initialise the parameters for Test or Application
% test or TEST : in this case the output of the data are known
if strcmpi((test_or_application),'test')
    % check if the subject_for_test are specified on init_parameters
    if isfield(init_parameter,'subject_for_test')
        test_data = 1; % used to get the test results
        new_data.data_location = init_parameter.test_data_location;
        % list of the new subjects/data
        new_data.subject = init_parameter.subject_for_test;
        new_data.nb_subject = length(new_data.subject);
        test_results_infos = 'The Results are from the test/test data';
    else
        warning('SIGMA>> Tests data are not specified in init_parameter')
    end
    % APPLICATION : in this case the output of the data are unknown
elseif strcmpi(test_or_application,'application') %% TODO
    test_data = 0;
    %%!! Implement the path of the new data
    new_data.data_location = init_parameter.test_data_location;
    % list of the new subjects/data
    new_data.subject = init_parameter.subject_for_test;
    new_data.nb_subject = length(new_data.subject);
    test_results = selected_model.performance_model;
    test_results_infos = ['The results are those of the training model,'...
        ' see selected_model structure '];
else
    warning('SIGMA>> oups... something is wrong....')
    error('SIGMA>> You must specify test or Application on the Appy_model');
end

%% Section 2 : Extract the feature designed in the selected model
%       from the new data


% ftom here we have the same structure as the one on the
% Sigma_features_extraction.m
%%% As the number of the feature selected coincide with the number of method
%%% to use, and also with the number of channel,
%%% each method wil give one feature, the algoritm will iterate in this way

% Location of the new data
data_location = new_data.data_location;
% list of the subject
subject = new_data.subject;
nb_subject = new_data.nb_subject;

%Initialisation of the local vectors


nb_feat_model = selected_model.nb_feat_model;
method_number = nan(nb_feat_model,1);
channel_number = nan(nb_feat_model,2);
freq_band_number = nan(nb_feat_model,1);
power_type = nan(nb_feat_model,1);
epochs = [];
model_results = [];
computed_feature_all = [];
label = [];

% method type will contain
% 1 : single channel, 2 : synchronisation channel
method_type = zeros(1,nb_feat_model);

% Extract the list of the methods/channels and bands used in
% the trainig phase
% Loop over all the subjects
for l_subject_feat = 1:nb_feat_model
    %list of methods
    method_number(l_subject_feat) = ...
        selected_model.best_organisation_ofr_model{l_subject_feat,2};
    %list of channels
    % Case of the method with single channel :
    if size(selected_model.best_organisation_ofr_model...
            {l_subject_feat,3},2) == 1
        method_type(l_subject_feat) = 1; % sigle channel method
        channel_number(l_subject_feat,:) = ...
            selected_model.best_organisation_ofr_model{l_subject_feat,3};
    end
    
    % Case of the method with two channels :
    if size(selected_model.best_organisation_ofr_model...
            {l_subject_feat,3},2) == 2
        method_type(l_subject_feat) = 2; % double channel method
        channel_number(l_subject_feat,:) = ...
            selected_model.best_organisation_ofr_model{l_subject_feat,3};
    end
    %list of the bands
    freq_band_number(l_subject_feat) = ...
        selected_model.best_organisation_ofr_model{l_subject_feat,4};
    %list of power type
    power_type(l_subject_feat) = ...
        selected_model.best_organisation_ofr_model{l_subject_feat,5};
end


%%% set the default parameters n order to use the Feature extraction
%%% methods
% apply_filter : in order to extract the associated band
% By default, all the filter will be applied,
init_param_apply_model.apply_filter = ones(size(freq_band_number));
% nb_bands : the number of band in which the feature will be extracted,
init_param_apply_model.nb_bands = 1; % only one time at each iteration
% method : the list of the method to extract
init_param_apply_model.method = method_number;
% for the fourrier Power (set always to 1)
init_method(1).all_fourier_power = 1;

%% Section 3 : Strating from here to EXTRACT The new features
% In the case of load custom feature from mat file
if (unique(method_number) == 99)
    % load feature from the subject
    disp('Loading Custom feature from data (m99)');
    index_method_99 = find(method_number == 99);
    % in this case there is no subject unique(method_number)== lonly method
    nb_subject = 0; % short cut the loop
end

% Extract the features from the OFR according to the training phase
h = waitbar(0,'Apply moded','Name','SIGMA : Apply model',...
    'CreateCancelBtn','setappdata(gcbf,''Cancel'',1)');
epochs=zeros(1,nb_subject);
if handles.AM_Load_custom_feature == 1
    nb_epochs = feature_result.nb_epoch;
    epochs = nb_epochs;
end

for l_subject = 1:nb_subject
    waitbar(l_subject/nb_subject,h,['Apply model : Subject ' ...
        num2str(l_subject) '/' num2str(nb_subject) ' please wait...']);
    if getappdata(h,'Cancel')
        fprintf('Process is cancled!');
        break
    end
    
    % load the data associated to selected subject
    if ispc
        load([data_location '\' 'subject_' ...
            num2str(subject(l_subject)) '.mat']);
    end
    if ismac
        load([data_location '/' 'subject_'...
            num2str(subject(l_subject)) '.mat']);
    end
    
    disp('--------------------------------------------------------------');
    disp(['AM : The subject ' num2str(s_EEG.subject_number) ' is loaded' ])
    
    % Update the samlig rate
    init_param_apply_model.sampling_rate = s_EEG.sampling_rate;
    
    %%% Save a copy of the s_EEG for the next loop,
    %%% keep the data safe befor the transformation
    original_data = s_EEG;
    
    % The number of epochs
    if handles.AM_Load_custom_feature == 0
        nb_epochs = size(s_EEG.data,3);
    else
        nb_epochs = feature_result.nb_epoch;
        epochs = nb_epochs;
    end
    %epochs = [epochs nb_epochs]; % it's seems to be the same
    epochs(l_subject) = nb_epochs;
    % The number of channels
    nb_channel((subject(l_subject))) = size(s_EEG.data,1);
    
    % The label
    label = [label s_EEG.labels];
    
    %%% initialisation of the memory fo the computed features
    computed_feature_all0 = [];
    power_feature = []; % to store the fourrier power
    used_parameters = [];
    used_parameters_name = [];
    index_method_99 = [];% vector containing the l_subjectex of the
    %                       method 99 (could be reached from the begening)
    
    % Loop over all the methods
    for l_method = 1 : nb_feat_model
        % identification of the used band
        init_selected_band = init_parameter.selected_band;
        best_band = freq_band_number(l_method);
        index_band = find(init_selected_band == best_band);
        % get the parameters of the filter
        if isfield(init_parameter,'filt_band_param')
            init_param_apply_model.filt_band_param = ...
                init_parameter.filt_band_param((index_band));
        end
        % select the associated channel numbers
        if method_type(l_method) == 1
            used_channels = channel_number(l_method,1);
        end
        if method_type(l_method) == 2
            used_channels = channel_number(l_method, : );
        end
        
        
        if method_number(l_method) ~= [98 99]
            %%% All methods exepct the 98 and 99
            %select the channel
            s_EEG.data = s_EEG.data(used_channels, : , : );
            s_EEG.channel_names = s_EEG.channel_names(used_channels);
            % select the actual band
            init_param_apply_model.selected_band = ...
                freq_band_number(l_method);
            %In the case of wavelet
            if isfield(init_parameter,'wavelet_transform_param')
                init_param_apply_model.wavelet_transform_param = ...
                    init_parameter.wavelet_transform_param;
                init_param_apply_model.selected_freq_bands = ...
                    init_parameter.selected_freq_bands(index_band, : );
            end
            %In the case of the fourrier Power
            if method_number(l_method) == 1
                % it used only in this case to find the right band
                init_method(1).index_band = index_band;
            end
            
            %%% Extract the associated feature
            % clear the outputs  variable
            eval(['model_results.' ...
                (init_method(init_param_apply_model.method...
                (l_method)).method_out) ' = [];']);
            % Loop over all epochs
            for l_epoch = 1 : nb_epochs
                waitbar(l_subject/nb_subject,h,['AM  :  Subject ' ...
                    num2str(l_subject) '/' num2str(nb_subject) ...
                    ', Epoch  :  ' num2str(l_epoch) '/' ...
                    num2str(size(s_EEG.data,3)) ', Method : '...
                    num2str(l_method) '/' num2str(nb_feat_model)]);
                
                % extract the feature
                model_results = eval([init_method(init_param_apply_model...
                    .method(l_method)).fc_method_name ...
                    '(init_param_apply_model,init_method,model_results'...
                    ',s_EEG,l_subject,l_epoch,l_method);']);
                % The output of the extraction
                % xxxx_band = [method channel band]
                % xxxx = the value
                % extract the value of the feature (xxxx)
                % on extracted_feature
                extracted_feature = eval(['model_results.' ...
                    (init_method(init_param_apply_model.method(...
                    l_method)).method_out) ';']);
                %%% only for the fourrier power (for now, later other
                %%% methods will be included in the exception)
                if method_number(l_method) == 1
                    %l_subjectex = init_method(1).index_band;
                    power_feature = [model_results.o_fourier_power_type...
                        model_results.o_fourier_power];
                    power_type_infos = ...
                        model_results.o_fourier_power_type_infos;
                end
                % When it's finished all tha feature are computed for
                % the current subjecct and method and they are stored in
                % the variable extracted_feature for the actual epoch
            end
            %%% clean the intermidiate variable in order to use it for the
            %%% next loop
            eval(['model_results.' ...
                (init_method(init_param_apply_model.method(...
                l_method)).method_out) ' = [];']);
            %%%% HERE modification added
            % in the case of the feature loaded from subject
        elseif method_number(l_method) == 98
            % load feature from the subject
            disp('Loading Custom feature from subject (m98)')
            if isfield(original_data,'custom_feature')
                custom_feature = original_data.custom_feature;
                extracted_feature = custom_feature.feature_value...
                    (used_channels, : );
            else
                uiwait(msgbox(['Custom feature are not included'...
                    ' in the subject'],'SIGMA Error'));
                return
            end
            % in the case of the feature loaded from data
        elseif method_number(l_method) == 99
            % load feature from the subject
            disp('Loading Custom feature from data (m99)')
            % nana value are put for now and will be remplaced later from
            % the loaded data
            extracted_feature = nan(1,nb_epochs);
            index_method_99 = [index_method_99;l_method];
        end
        %%%% TO HERE
        
        % if the method is the fourrier power
        % select from absolute, relative power
        used_power_type = 'not power';
        index_to_select = nan;
        % select between the aboslute or the relative power
        if method_number(l_method) == 1;
            index_to_select = find(power_feature( : ,1) == ...
                power_type(l_method));
            used_power_type = power_type_infos(index_to_select);
            power_selected = power_feature(index_to_select,2 : end);
            computed_feature_all0 = [computed_feature_all0; ...
                power_selected];
        else
            computed_feature_all0 = [computed_feature_all0;...
                extracted_feature];
        end
        
        %% Section 3 : summarize about the used method
        method_used = method_number(l_method);
        band_used = freq_band_number(l_method);
        % save the informations of the extracted features
        used_parameters = [used_parameters;{method_used}  ...
            {used_channels} {band_used} {index_to_select-1}];
        used_parameters_infos = {'method','channels','band','power type'};
        power_type_info = {'0  :  all bands';'1  :  absolute ';...
            '2  :  relative ';'NaN  :  not power method '};
        used_method_name = init_method(method_used).method_name;
        %%% HERE
        if method_number(l_method) == 98 % custom feature from subject
            used_channel_name = custom_feature.feature_name{3};
            used_band_name = {'Not specified'};
        elseif method_number(l_method) == 99 % custom feature from data
            used_channel_name = {num2str(used_channels)};
            used_band_name = {'Not specified'};
        else
            used_channel_name = s_EEG.channel_names;
            used_band_name = init_parameter.bands_list(band_used);
        end
        %%% To HERE
        used_power_type_name = used_power_type;
        temp1 = [used_method_name  used_channel_name used_band_name...
            used_power_type_name];
        
        disp('----------------------------------------------------------');
        disp(['Extract the feature N°  :  ' num2str(l_method)...
            ' using these parameters  : ']);
        disp(['  Method  :  ' temp1{1} ...
            ' ; (N° ' num2str(method_used) ')']);
        disp(['  Channel(s)  :  ' temp1{2}...
            ' ; (N° ' num2str(used_channels) ')']);
        disp(['  Freq Band  :  ' temp1{3} ...
            ' ; (N° ' num2str(band_used) ')']);
        disp(['  Power Type  :  ' temp1{4}...
            ' ; (N° ' num2str(index_to_select-1) ')']);
        
        used_parameters_name = [used_parameters_name;temp1];
        
        % initialisation for the next feature
        power_feature = [];
        s_EEG = original_data;
    end
    
    computed_feature_all = [computed_feature_all computed_feature_all0];
    size(computed_feature_all);
end

%%%% HERE
if sum(method_number == 99)>0
    %l_subject99 = find(method_number == 99)
    % load feature from the subject
    if handles.AM_Load_custom_feature == 0
        uiwait(msgbox(['Your model use custom feature,',...
            ' please load your data'],'SIGMA Message','warn'));
        disp('Loading Custom feature from data (m99)')
        dataout = Sigma_load_custom_feature;
        if isempty(dataout)
            return
        end
        feature = dataout.feature_value;
        %epochs_custom_feature = size(feature,2);
        if isempty(label)
            label = dataout.label;
        end
    elseif  handles.AM_Load_custom_feature == 1
         feature_result = handles.apply_model_in.feature_result;
         feature = feature_result.o_features_matrix;
            
         if test_data == 1 && isempty(label) 
            label = feature_result.label;
         end 
    end
    
    if ~isempty(computed_feature_all)
        if size(feature,2) == size(computed_feature_all,2)
            computed_feature_all(index_method_99, : ) = ...
                feature(channel_number(index_method_99), : );
        else
            % check the size of the feature
            msgbox(['The size of the loaded data (' ...
                num2str(size(feature,2)) ...
                ') does not match with your subject''s' ' data (size ' ...
                num2str(size(computed_feature_all,2))...
                ')' ],'SIGMA Error','error');
            return
        end
    else
        computed_feature_all = feature(channel_number(index_method_99), :);
        %% methods
        method_used = method_number;
        band_used = freq_band_number;
        % save the informations of the extracted features
        used_parameters = [{method_used}  {channel_number}...
            {band_used} {nan}];
        used_parameters_infos = {'method','channels','band','power type'};
        power_type_info = {'0  :  all bands';'1  :  absolute ';....
            '2  :  relative ';'NaN  :  not power method '};
        if handles.AM_Load_custom_feature == 0
            used_method_name = init_method(method_used).method_name;
            used_power_type_name = nan;
            used_channel_name = dataout.feature_name(channel_number);
            temp1 = [used_method_name  used_channel_name...
                nan used_power_type_name];
            disp('----------------------------------------------------------');
        disp(['Extract the feature N°  :  ' num2str(index_method_99)...
            ' using these parameters : ']);
        disp([' Method  :  ' temp1{1} ' ; (N° ' num2str(method_used) ')']);
        disp([' Channel(s)  :  ' temp1{2}]);
        disp([' Freq Band  :  ' temp1{3} ' ;(N° ' num2str(band_used) ')']);
        disp([' Power Type  :  ' temp1{4} ]);
        used_parameters_name = temp1;
        elseif handles.AM_Load_custom_feature == 1

        used_parameters_name = [];
        end        
    end
end


%%%% TO HERE
waitbar(1,h,' Apply Model');
delete(h) %% close the wait bare

% Check the feature in the case of the same data
% Put break point here to check
same_data = 0;
if same_data
    nfeat = 1;
    figure;
    plot(computed_feature_all(nfeat, : ),'*')
    hold on
    plot(selected_model.best_feature_training_ofr(nfeat, : ),'ro')
    legend('test','train')
    title('Not Normalized data')
end


% Todo User can choose between bagging or simple ofr on all data
%% Section 4 :  Normalize the data according to the training phase
feature_selection = 'ofr';
if strcmp(feature_selection,'ofr')
    feature_mean = selected_model.best_feature_mean_ofr_model;
    feature_std = selected_model.best_feature_std_ofr_model;
elseif strcmp(feature_selection,'bag')
    feature_mean = selected_model.best_feature_mean_bag_model;
    feature_std = selected_model.best_feature_std_bag_model;
end
% normalization acording to the training set
%computed_feature_all_normalize = ...
%                        (computed_feature_all-feature_mean)./feature_std;

%% Normalize the data according to the all matrix feature
%feature_result.o_features_matrix
computed_feature_all_normalize = ( computed_feature_all - ...
    repmat( feature_mean,1,size(computed_feature_all,2) ) ) ./ ...
    repmat( feature_std,1,size(computed_feature_all,2) );


% Check the feature in the case of the same data
% Put break point here to check
same_data = 0;
if same_data
    nfeat = 1;
    figure;
    plot(computed_feature_all_normalize(nfeat, : ),'*')
    hold on
    plot(selected_model.best_feature_training_normalize_ofr(nfeat,:),'ro');
    legend('test','train')
    title('Normalized data')
end


% The Final feature matrix computed from the new data
computed_feature_new_data = computed_feature_all_normalize;

if size(computed_feature_new_data,2)~= sum(epochs)
    uiwait(msgbox(['There is an error in the Features matrix,'...
        '#examples, please check the data']));
    return
end

if size(computed_feature_new_data,1)~= nb_feat_model
    uiwait(msgbox(['There is an error in the Features matrix,'...
        '#Feat, please check the data']));
    return
end

% Prediction for the new subjects
classObj = selected_model.classObj;
[YP, sc] = predict(classObj,computed_feature_new_data');

if size(YP,1)~= sum(epochs)
    uiwait(msgbox(['There is an error in the prediction computation,'...
        ' please check the model']));
    return
end

% Get the results
predicted_label = YP;
predicted_scores = sc;

% Comput the performances if the user ask for test/tests
if test_data == 1
    predicted_groups = YP;
    %%% Compute the score in the case of test
    [~, adapted_label] = Sigma_set_label(label);
    actual_groups = adapted_label';
    %[X,Y,T,AUC,OPTROCPT] = ...
    %                   perfcurve(actual_groups,predicted_scores( : ,1),1);
    
    %  [confusion_matrix overall_pcc group_stats groups_list] = ...
    %confusionMatrix3d(predicted_groups,actual_groups,[]);
    [confusion_matrix,overall_pcc, group_stats, ~] = ...
        confusionMatrix3d(predicted_groups,actual_groups,[]);
    [performance,performance_infos] = ...
        Sigma_compute_performance(actual_groups',YP',sc( : ,2)');
    % outputs
    test_results.confusion_matrix = confusion_matrix;
    test_results.performance = performance;
    test_results.performance_infos = performance_infos;
    test_results.overall_pcc = overall_pcc;
    test_results.group_stats = group_stats;
    handles.apply_model_out.origine_label = actual_groups;
end

% handles output

handles.apply_model_out.used_parameters_name = used_parameters_name;
handles.apply_model_out.used_parameters = used_parameters;
handles.apply_model_out.computed_feature_new_data = ...
    computed_feature_new_data;
handles.apply_model_out.predicted_label = predicted_label;
handles.apply_model_out.predicted_scores = predicted_scores;
handles.apply_model_out.test_results_infos = test_results_infos;
handles.apply_model_out.test_results = test_results;
end
%%
% % %----------------------------------------------------------------------
% % %     Brain Computer Interface team
% % %
% % %       _---~~(~~-_.
% % %       _{  ) )
% % %      , ) -~~- ( ,-' )_
% % %      ( `-,_..`., )-- '_,)
% % %      ( ` _) ( -~( -_ `, }
% % %      (_- _ ~_-~~~~`, ,' )
% % %      `~ -^( __;-,((()))
% % %        ~~~~ {_ -_(())
% % %          `\ }
% % %          { }
% % % File created by Takfarinas MEDANI
% % % Creation Date  :  30/05/2017
% % % Updates and contributors  :
% % % 30/01/2017, T MEDANI  :  Updating and adding options
% % %
% % % Citation :  [creator and contributor names], comprehensive BCI
% % %    toolbox, available online 2016.
% % %
% % % Contact info  :  francois.vialatte@espci.fr
% % % Copyright of the contributors, 2016
% % % Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
