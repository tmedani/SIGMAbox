function feature_result = Sigma_feature_extraction(init_parameter,...
                                              init_method,feature_result)
%%%------------------------------------------------------------------------
%   feature_result = Sigma_feature_extraction(init_parameter,...
%                                             init_method,feature_result)
%
%   Function task:
%   Extract the feature from the EEG signals
%
%   Inputs :
%   init_parameter : structure containing the initial parameters of SIGMA
%   init_method : structure containing the initial parameters of the method
%   feature_result : optionel , structure the output
%
%
%   Outputs :%
%   feature_result : structure containing the results of the feature
%   extraction
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%
%   Dependencies

%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%%   Scripts task:
% This script extracts the features fromm EEG signals.
% The extracted fatures are stored in a matrix 'features matrix'
% Check the number of input argument




%% Check the input arguments
if nargin == 2
    feature_result = [];
end


%% SECTION 1 : Initialisation
% Get the numbre of the method
method=init_parameter.method;
% Check the method identification
if method==99 % m99 is for the loading feature from matlab file
    msgbox(['This method "' init_method(99).method_name ...
        '" is used to load data; '...
        'please use the Load Costum Feature button'],'SIGMA Message'...
        ,'warn');
    feature_result=[];
    return
end

% Get the option of sigma_show_comment ( = 1 : yes, = 0 : no)
sigma_show_comment = init_parameter.sigma_show_comment;
% Get the number of subject from the init_parameter
nb_subject = init_parameter.nb_subject;
nb_epoch = zeros(1,init_parameter.nb_subject); % vector of number of epochs
label = []; % vector of the labels
used_method=cell(length(init_parameter.method),1); % list of the method
subject_epoch = [];% indicator of the appartenance of the epoch to the exampel
epoch = zeros(1,nb_subject);
nb_channel = zeros(1,nb_subject);
nb_samples = zeros(1,nb_subject);


%% SECTION 2 : Features extractions
% Display the waitbar
h = waitbar(0,'FE...','Name','SIGMA : Feature extraction','CreateCancelBtn'...
    ,'setappdata(gcbf,''Cancel'',1)');
h.CloseRequestFcn='setappdata(gcbf,''Cancel'',1);delete(h);return ';
% Loops over all the subjects / epoch / methods
comment = '**************  SIGMA : Feature extraction   ****************';
if sigma_show_comment == 1;    disp(comment); end

for l_subject = 1 : nb_subject
    % Updat the waitbar
    waitbar(l_subject/nb_subject,h,['Feature extraction : Subject '...
        num2str(l_subject) '/' num2str(nb_subject) '  please wait...']);
    % Get the button cancel abnd stop the loop
    if getappdata(h,'Cancel')
        fprintf('SIGMA : You have cancled the process');
        break
    end
    
    actual_subject = num2str((init_parameter.subject(l_subject)),'%10.2d');
    if sigma_show_comment == 1
        disp(' == == == == ==     New Subject    == == == == == == ')
        disp(['Loading the EEG data : Subject N°:', actual_subject,'...']);
    end
    
    % load the data associated to selected subject
    load([init_parameter.data_location strcat('subject_',num2str(...
        init_parameter.subject(l_subject)), '.mat ')])
    
    if sigma_show_comment == 1
        disp(' == == == == ==  Features extraction   == == == == ==')
        disp(['The total number of epoch for the subject ' ...
            actual_subject ' is :', num2str(size(s_EEG.data,3),'%10.2d')])
    end
    
    %%%- Features extractions : preprocessing
    %%% The sampling rate (get it only one time), it's supposed to
    %%% be the same for all the subject from the same session
    if  l_subject == 1 % && init_parameter.sampling_rate_default == 0
        sampling_rate = s_EEG.sampling_rate;
        channel_name = s_EEG.channel_names;
        init_parameter.sampling_rate = sampling_rate;
        init_parameter.channel_name = channel_name;
    end
    % Test if the sampling rate is not the same
    sampling_rate_bis = s_EEG.sampling_rate;
    if sampling_rate_bis ~= sampling_rate
        warning('The Sampling rate is not the same in these data');
        feature_result.sampling_rate_warning = ...
            'data with different sampling rate !!';
    end
    
    
    %% The number of epoch
    nb_epoch((init_parameter.subject(l_subject))) = size(s_EEG.data,3);
    epoch(l_subject) = size(s_EEG.data,3);
    
    % The number of channels
    nb_channel((init_parameter.subject(l_subject))) = size(s_EEG.data,1);
    % Test if the subjects have the same number of channels
%     if length(unique(nb_channel))>1
%         warning('The Sampling rate is not the same in these data');
%         feature_result.number_channel_warning = ...
%             'data with different number of channel !!';
%     end
    
    % The number of samples (times point)
    nb_samples((init_parameter.subject(l_subject))) = size(s_EEG.data,2);
    %epoch_duration = nb_samples/init_parameter.sampling_rate
    
    % The label associated the the epoch
    label = [label s_EEG.labels];
    
    %% Resample the data
    % Save the downsampled data or not
    data = s_EEG.data;
    data_resampled = [];
    if init_parameter.resample_data == 1
        %%% resample the data
        sampling_rate_by_user = init_parameter.sampling_rate_by_user;
        if sampling_rate_by_user<sampling_rate
            disp('SIGMA>> Downsampling the data');
            resample_factor = sampling_rate/sampling_rate_by_user;
            %data_resampled = decimate(data(1,:,1),resample_factor);
            for chan = 1:size(s_EEG.data,1)
                for epo = 1:size(s_EEG.data,3)
                    data_resampled(chan,:,epo) = decimate(data(chan,:,epo),...
                        resample_factor);
                end
            end
            feature_result.resample_data_infos = 'data are decimated';
    %%% plot the data
    %             figure;
    %             time_step = 0:1/sampling_rate_by_user:...
    %           length(data_resampled)...
    %                       /sampling_rate_by_user-1/sampling_rate_by_user;
    %             plot(time_step,data_resampled(1,:,1),'b');
    %             hold on
    %             time_step = 0:1/sampling_rate:length(data)/...
    %           sampling_rate-1/sampling_rate;
    %             plot(time_step,data(1,:,1),'r');
    %             legend('Downsampled data','Original data')
        end
        
        if sampling_rate_by_user>sampling_rate
            disp('SIGMA>> Interpolating the data')
            resample_factor = sampling_rate_by_user/sampling_rate;
            % data_resampled = interp(data(1,:,1),resample_factor);
            for chan = 1:size(s_EEG.data,1)
                for epo = 1:size(s_EEG.data,3)
                    data_resampled(chan,:,epo) = interp(data(chan,:,epo),...
                        resample_factor);
                    %data_resampled(chan,:,epo) = temp0;
                end
            end
            feature_result.resample_data_infos = 'data are interpolated';
            %%% plot the data
            %             figure;
            %             time_step = 0:1/sampling_rate_by_user:length...
            %   (data_resampled)/sampling_rate_by_user-1/sampling_rate_by_user;
            %             plot(time_step,data_resampled(1,:,1),'b');
            %             hold on
            %             time_step = 0:1/sampling_rate:length(data)/...
            %       sampling_rate-1/sampling_rate;
            %             plot(time_step,data(1,:,1),'r');
            %             legend('Downsampled data','Original data')
        end
        
        if sampling_rate_by_user == sampling_rate
            disp(['SIGMA>> The frequency is same,'...
                'the data is kept as they are'])
            resample_factor = sampling_rate_by_user/sampling_rate;
            data_resampled = data;
            feature_result.resample_data_infos = 'No resampling';
        end
        
        s_EEG.data = data_resampled;
        s_EEG.sampling_rate = sampling_rate_by_user;
        init_parameter.sampling_rate = sampling_rate_by_user;
        %%% save the resampled data
        save_resample_data = init_parameter.save_resample_data;
        if save_resample_data == 1
            cd(init_parameter.data_location)
            dir_name = ['resampled_data_' num2str(sampling_rate_by_user)...
                '_Hz'];
            mkdir(dir_name)
            cd(dir_name)
            save(['subject_' num2str(l_subject)],'s_EEG')
            cd ..
            cd ..
        end
    end
    
    
    %%%- Features extractions : Extraction
    % Loop over all the epoch
    nb_epoch = size(s_EEG.data,3);
    for l_epoch = 1:size(s_EEG.data,3)
        waitbar(l_subject/nb_subject,h,['FE : Subject ' num2str(l_subject)...
            '/' num2str(nb_subject) ', Epoch : ' ...
            num2str(l_epoch) '/' num2str(size(s_EEG.data,3))]);
        % Cancel
        if getappdata(h,'Cancel')
            break
        end
        
        subject_epoch = [subject_epoch; init_parameter.subject(l_subject)...
            l_epoch];
        
        if sigma_show_comment == 1
            disp(' == == == == ==  Features extraction  == == == == == ')
            disp(['Subject N°: ' num2str((init_parameter.subject(l_subject)),...
                '%10.2d') '| [ subject ' num2str(l_subject,'%10.2d') '/' ...
                num2str(nb_subject,'%10.2d') ']'])
            disp(['Epochs N°: ' num2str(l_epoch,'%10.2d') '/' ...
                num2str(nb_epoch,'%10.2d')])
        end
        
        
        % Loop over the methods
        nb_method = length(init_parameter.method);
        for l_method = 1:length(init_parameter.method)
            waitbar(l_subject/nb_subject,h,['FE : Subject ' ...
            num2str(l_subject) '/' num2str(nb_subject) ...
            ', Epoch : '  num2str(l_epoch) '/' num2str(size(s_EEG.data,3))...
            ', Method : ' num2str(l_method) '/' num2str(nb_method)]);
            
            if getappdata(h,'Cancel')
                break
            end
            %%%
            method_number = (init_method(init_parameter.method...
                (l_method)).method_number);
            method_name = init_method(init_parameter.method...
                (l_method)).method_name ;
            
            if sigma_show_comment == 1
                disp(['Method N°: ' num2str(method_number,'%10.2d')...
                    ' | [ method : ' num2str(l_method,'%10.2d') ' / '...
                    num2str(nb_method,'%10.2d')  ']'])
                disp(['Method name: ' method_name ])
            end
            
            %% check if this method is part of the wavelet list
            if init_parameter.wavelet_transform == 1
                wt_method_list = init_method(25).wt_method_list;
                % method (wavlet is already executed)
                is_wt_method = find(wt_method_list == method_number);
                if  ~isempty(is_wt_method)
                    disp('This method is computed on the wavelet transform ...') ;
                    disp('Go to the next method...') ;
                    continue
                end
            end
            %% check if this method loads feature from subject
            if method_number==98
                disp(['This method has no function, the features will be'...
                    'loaded from subject'])
                if isfield(s_EEG,'custom_feature')
                    continue
                else
                    uiwait(msgbox(['There is no feature included on the'...
                        'subject(s) (one or more), please remove the " ' ...
                        method_name ' " item from the selected method'...
                        'or use homogenious subject(s) and restart'...
                        'the process'],'SIGMA Message','error'));
                    feature_result=[];
                    delete(h) %% close the wait bare
                    return
                end
            end
            %% check if this method loads feature from independant file
            if method_number==99
                disp(['This method has no function, the features will'...
                    'be loaded from file'])
                continue
            end
            
            %% Compute the features ...
            if sigma_show_comment == 1   ; ...
                    disp('Compute the feature of the current method...') ;
            end
            % Execute the associated method défined in the scrupt 
            % "init_method(l_method).method_name"
            execute_as = 2; % (1 for the script, 2 for the function)
            if execute_as == 1
                % Execute as a script
                if sigma_show_comment == 1
                    disp('execute as a script');
                end
                eval(init_method(init_parameter.method(l_method)...
                    ).method_name) ;
            else
                % Execute as a function
                if sigma_show_comment == 1 
                    disp('execute as a function');
                end
                feature_result = eval([init_method(...
                    init_parameter.method(l_method)).fc_method_name....
                    '(init_parameter,init_method,feature_result,'...
                    's_EEG,l_subject,l_epoch,l_method)']) ;
            end
            
            if sigma_show_comment == 1; disp('----------------------');end
        end
    end % en of the loop over the epochs/examples
    
    %% Load the (custom) feature from the subject
    % Load custom feature from subject
    if find(init_parameter.method==98)
        init_parameter.load_custom_feature_subject = 1; % 1 for yes and 0 for no
    else
        init_parameter.load_custom_feature_subject = 0;
        % method 98 is specifed for the custom feature loading from subject
    end
    
    if init_parameter.load_custom_feature_subject == 1
        disp(['Loading Custom feature from subject : ' actual_subject ])
        if isfield(s_EEG,'custom_feature')
            if l_subject == 1
                method = 98;
                subject_custom_feature = [];
                feature_value = [];
                feature_name = [];
                cpt_subject = 0;
            end
            custom_feature = s_EEG.custom_feature;
            feature_value = [feature_value custom_feature.feature_value];
            feature_name = [feature_name; custom_feature.feature_name];
            subject_custom_feature = [subject_custom_feature...
                s_EEG.subject_number];
            cpt_subject = cpt_subject+1;
        end
    end
    % $$$$ Up to this line
end

% Add the custom features
if init_parameter.load_custom_feature_subject == 1 && exist('method','var')
    if cpt_subject == l_subject
        feature_result.o_custom_feature_subject = feature_value;
        feature_result.o_custom_feature_subject_name = feature_name;
        
        feature_result.o_custom_feature_subject_band = ...
            repmat([method nan nan],size(feature_value,1),1);
        feature_result.o_custom_feature_subject_band(:,2) = ...
            1:size(feature_value,1);
        
        feature_result.subject_custom_feature = subject_custom_feature;
        init_parameter.method = sort(unique([init_parameter.method 98]));
    end
    % method 98 should be the method for custom feature from subject
    % you should check the size of the matrix in order to concatenate
    % it with the other methods
end

delete(h) %% close the wait bare

%% Set the labels to 1 and -1
[origin_label, new_label] = Sigma_set_label(label);
temp = unique(new_label);
if isempty(temp)
    %msgbox('SIGMA Error : There is no label, please check your data ...');
    msgbox('SIGMA Warning : There is no label, please check your data ...',...
    'SIGMA Warning','warn')
    return
end
if length(temp)>2
    promptMessage = sprintf(['There is more than 2 label, this version is'...
        'not addapted for your data,\n Do you want to Continue processing,'...
        '\nor Cancel to abort processing?']);
    button = questdlg(promptMessage, 'SIGMA Warning', 'Continue',...
        'Cancel', 'Continue');
    if strcmpi(button, 'Cancel')
        disp('aborted')
        return; % Or break or continue
    end
    disp('continue')
end

%% Compute the element of each classe
amount_classe_one = length(find(new_label == temp(1)));
amount_classe_two = length(find(new_label == temp(2)));

if amount_classe_one ~= amount_classe_two
    disp('SIGMA >> Your data is not equilbred')
    disp(['Class ' num2str(temp(1)) ', rate = ' ...
        num2str(100*amount_classe_one/length(new_label)) ' %'])
    disp(['Class ' num2str(temp(2)) ', rate = ' ...
        num2str(100*amount_classe_two/length(new_label)) ' %'])
end

%% Set the output of this function
feature_result.origin_label = origin_label;
feature_result.label = new_label;
feature_result.amount_classe_one = amount_classe_one;
feature_result.amount_classe_two = amount_classe_two;
feature_result.epoch = epoch;
feature_result.nb_epoch = nb_epoch;
feature_result.sampling_rate = sampling_rate;
feature_result.nb_channel = nb_channel;
feature_result.subject_epoch = subject_epoch;

%% Creat a list of the used method in this session
for l_method = 1:length(init_parameter.method)
    used_method(l_method) = {init_method(init_parameter.method(...
        l_method)).method_name};
end
feature_result.used_method = used_method;

% Used by all the methods
feature_result.method_band_infos = {'N° Method','N° Channel','N° band'};

clear l_subject s_EEG l_method i_EEG
if sigma_show_comment == 1
    disp(' == == == == =  End of Features extraction = == == == ==');
end
end

%%
% % %----------------------------------------------------------------------
% % %                  Brain Computer Interface team
% % %
% % %                            _--- ~ ~( ~ ~-_.
% % %                          _{        )   )
% % %                        ,   ) - ~ ~- ( ,-' )_
% % %                       (  `-,_..`., )-- '_,)
% % %                      ( ` _)  (  - ~( -_ `,  }
% % %                      (_-  _   ~_- ~ ~ ~ ~`,  ,' )
% % %                        ` ~ -^(    __;-,((()))
% % %                               ~ ~ ~ ~ {_ -_(())
% % %                                     `\  }
% % %                                       { }
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 10/10/2016
% % %   Updates and contributors :
% % %   29/01/2018, T. MEDANI : updating the format
% % %
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------