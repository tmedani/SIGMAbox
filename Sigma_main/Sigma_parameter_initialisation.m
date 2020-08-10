function os_init_parameter = Sigma_parameter_initialisation(varargin)
%%%------------------------------------------------------------------------
%  os_init_parameter = Sigma_parameter_initialisation(varargin)
%
%  Function task:
%  Initialize the envirenement to use SIGMA 
%  Initialize the option and the parameters 
%  %  This file contains the description of the parametres of SIGMA
%  This function initializes the SIGMA toolbox parameters
%  User can add/modify the data in this file
%  User can choos the parameters for the simulation/computation
%  This file contains the description of the parametres which are used to
%  extract and classify the data


%  Inputs :
%  varargin : structure containing the initial parameters of SIGMA
%
%  Outputs :
%
%  init_parameter : structure containing the initial parameters of SIGMA
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%  init_parameter 
%
%  Dependencies
%  
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%% Section I
% check the input argument(s)
if nargin == 1
  os_init_parameter = varargin{1};
end

%% The main input to change from the USER
subject = [1 3];
selected_band = [1 3]; % refers to the sigma_frequency_initialisation
method = [5 6]; % refers to the Sigma_method_initialisation

nb_features = 5; % nimbre of feature to use on the OFR
cross_validation_method = 'LOSO'; % for Leave One Subject Out
classification_method = 'LDA'; % the classification method 

% Ask user if he want to use the custom feature included in the subject
% TODO : Aurélien : add this to the GUI as a check box
if find(method==98)
load_custom_feature_subject = 1; % 1 for yes and 0 for no
else
  load_custom_feature_subject = 0;
  % method 98 is specifed for the custom feature loading from subject
end
os_init_parameter.load_custom_feature_subject = load_custom_feature_subject;

os_init_parameter.compute_cross_term_feature=1;

%%% The features axtractions' methodes are listed following this order:
% please refer to the Sigma_method_initialisation.m for the details
% $$ TODO : this list is not updated, please check and updat this liste...

%%% User : User must fixe the name of the eeg data as fixed by the BCI toolbox
% the name of the data should be subject_xx wher xx is the number of the
% subject
%$ TODO : use the global parameters ... if necessary check with françois...

%% Section II : Parameters
%%% Specify the sigma work directory
stack = dbstack('-completenames');
mfile_location = stack(1).file;
sigma_directory = mfile_location(1:end-43);
os_init_parameter.sigma_directory = sigma_directory;

%%% Specify the output file for the results for the session depending on
%%% the machine being a PC or a MAC
data_output = 'SIGMA_output';
if ispc
  data_output = [data_output '\'];
  this_machine = 'PC';
end
if ismac
  data_output = [data_output '/'];
  this_machine = 'MAC';
end
os_init_parameter.this_machine = this_machine;

% creat the output directory
os_init_parameter.data_output = data_output;
cd(sigma_directory)
if ~isdir(data_output)
  mkdir(data_output)
else
  %warning('SIGMA >> The output directory is already created')
end

%%% Create/Specify the name of the session/the Log File and the diary File
% User can either choose the name of the current session by defining
% the name /or the name was created by default according to the date and
% the time of creation

% %% Create session from the GUI
% if nargin > 0
%   if isfield(init_parameter,'default_name')
%     default_name = init_parameter.default_name;
%   else
%     default_name = 1;
%   end
% else
%   default_name = 1;
% end
% 
% 
% 
% if default_name  ==  1 
%   session_name = 'default';
%   init_parameter.session_name=session_name;
%   init_parameter.session_canceled = 0;
% else
%   prompt = sprintf('Please tape the name of your session (without space) : ');
%   [answer, cancel] = inputsdlg(prompt,'SIGMA Create New Session');
% 
%   if isempty(answer{:})
%      % In this case the session creation will be canceled from the gui
%      init_parameter.session_canceled = 1;
%      session_name=[];
%      init_parameter.session_name=session_name;
%   elseif cancel==1
%      init_parameter.session_canceled = 1;
%      session_name=[];
%      init_parameter.session_name=session_name;
%   else
%       % get the name of the session
%      session_name = answer{:};
%      init_parameter.session_canceled = 0;
%      init_parameter.session_name=session_name;
%   end
% end

% Creat the session name
%init_parameter = Sigma_create_session_name(init_parameter);


%%% Choose the option
sigma_show_comment = 1; % to display or not the comment on the terminal
sigma_write_logFile = 0; % to write the log file (specified by the toolbox)
sigma_write_diaryFile = 0; % to write the diary file (all thing that is displayed on the terminal)
% The comment, diary and logfile
os_init_parameter.sigma_show_comment = sigma_show_comment;
os_init_parameter.sigma_write_logFile = sigma_write_logFile;
os_init_parameter.sigma_write_diaryFile = sigma_write_diaryFile;

%% Writ the Diary file
Sigma_diary_file(os_init_parameter)
sigma_comment = 'You should modify the parameters in this script "Sgma_parameter_initialisation" ';
Sigma_comment(os_init_parameter,sigma_comment)

%% display or not the panel during the process (used in the GUI)
os_init_parameter.gui_visible = 1; % 1 set visible, 0 : turn off,

%% Parameters from This Script
%% 0- Select the path of your data : The path of the EEG data
% training data
if ispc
  training_data_location = 'SIGMA_data\';
end
if ismac
  training_data_location = 'SIGMA_data/';
end

% test and validation data
test_data_location = fullfile(training_data_location,'subject_for_test');
os_init_parameter.data_location = training_data_location;
os_init_parameter.test_data_location = test_data_location;

% Just to teste the performance of the CrossValidation, available only
% for the power spectrum as a script
try_random_data = 0;
os_init_parameter.random_data = try_random_data;

%% 1- List of subjects to study
% list of the subject for the trainig phase
%subject = [1 3];
subject = sort(subject); % 
subject = unique(subject);
nb_subject = length(subject); %

% these parameters are used for the data-visualisation. Some of them
% will be initialised from the GUI visualisation data
sigma_display_data = 1;
if ~isempty(subject)
  subject_to_display = subject(1);%% temporary, to be implemented from the gui
else
  subject_to_display = nan;
end
epoch_to_display = 1;%% temporary, to be implemented from the gui
if sigma_display_data == 1
  os_init_parameter.sigma_display_data = sigma_display_data;
  os_init_parameter.epoch_to_display = epoch_to_display;
  os_init_parameter.subject_to_display = subject_to_display;
end

% in the case of the user specify data for the test
% read the list of the subject insid the path
try
  %if exist((fullfile(sigma_directory,test_data_location)),'dir')
  if isdir((fullfile(sigma_directory,test_data_location)))
    cd(fullfile(sigma_directory,test_data_location))
    % Get the subject to tests available on the default paths
    list_subject = dir('subject*.mat');
    if ~isempty(list_subject)
      num = nan(size(list_subject));
      for ind = 1:length(list_subject)
        sub = list_subject(ind);
        str = sub.name;
        %str = sub{:};
        [~,name,~] = fileparts(str);
        C = strsplit(name,'_'); C = C(2);C = C{:};
        num(ind) = str2double(C);
      end
      subject_for_test = num';
      subject_for_test = sort(unique(subject_for_test));
    else
      subject_for_test = [];
    end
  else
    mkdir((fullfile(sigma_directory,test_data_location)))
    subject_for_test = [];
  end
  os_init_parameter.subject_for_test = subject_for_test;
  cd(sigma_directory)
catch message
  message = sprintf(['You are not in the right directory, please go to SIGMA'...
    '\n or \n' , 'The SIGMA_data does not exist in the SIGMA directory, please check']);
  warndlg(message,'SIGMA Warning !!')
  return
end

os_init_parameter.subject = subject;
os_init_parameter.nb_subject = nb_subject;

%% 2- Fréquency initialisation
% List of bands to study (pleae refers to the 'Sigma_frequency_initialisation.m' for the details)
%selected_band = [1 3]; % refers to the sigma_frequency_initialisation

selected_band = unique(selected_band);
selected_band = sort(selected_band);
nb_selected_bands = length(selected_band);
os_init_parameter.selected_band = selected_band;
os_init_parameter.nb_selected_bands = nb_selected_bands;
os_init_parameter.nb_bands = nb_selected_bands;

%$TODO : specify here the bounds of the frequency bands and the order of
%the filters for the bands exrtaction

%% 3- Apply the low/high pass filter for you data
%$ TODO : implement the high and the band pass filter on the frequency initialisation
% IMPLEMENTED BUT NOT USED IN THIS VERSION
low_pass_filter = 0; % 0 no, 1 Yes
high_pass_filter = 0; % 0 no, 1 Yes
band_pass_filter = 0; % 0 no, 1 Yes
notch_filter = 0; % 0 no, 1 Yes

%$ TODO implement the notch filter
os_init_parameter.low_pass_filter = low_pass_filter;
os_init_parameter.high_pass_filter = high_pass_filter;
os_init_parameter.band_pass_filter = band_pass_filter;
os_init_parameter.notch_filter = notch_filter;

%% 6- List of methods to use for the features extraction
% $ NOTE:The methods 25 to 35 are reserved to the wavelet transformation, if you
% want to use theses methods you need to set the "wavelet_transform = 1"

%method = [4 5 6];

% Add the computation of the wavelet transformation
% test if wt_method are included
wt_method_list = 25:35;% these methods are reserved fot the wavelet and will be completed
os_init_parameter.wt_method_list = wt_method_list;
wt_method_used = method(method >= wt_method_list(1) & method <= wt_method_list(end));
if isempty(wt_method_used)
  % 6b- Compute the wavlette transform parameters (if you use the methods from 25 to 35)
  wavelet_transform = 0; % 0 no, 1 Yes
else
  wavelet_transform = 1; % 0 no, 1 Yes
  method = [method,25]; % 25 is added to comput the wavlet transform
  method = sort(method);
end
% please refers to the wavlet methods , further methods will be added
os_init_parameter.wavelet_transform = wavelet_transform;

method = sort(method);
method = unique(method);
nb_method = length(method);

os_init_parameter.method = method;
os_init_parameter.nb_method = nb_method;

%% 7- Apply filters for the selected method method : 
% Is used in order to define the bands to study
% '0' not apply : on the associated rank in the vector
% '1' apply   : //            //
% apply_filter = zeros(size(method)); %% TODO : the name should be
% changed
% By default the filter will be applied for alla the methods
apply_filter = ones(size(method));
% apply_filter = [1 0 1];
if length(apply_filter)~= length(method)
  sigma_comment = ('The size of "apply_filter" is different from the size of "method"');
  Sigma_comment(os_init_parameter,sigma_comment)
  warning('The size of apply_filter is different from the size of method')
  error(' ERROR : The size of "apply_filter" is different from the size of "method"')
end
% if isempty(apply_filter)
%   apply_filter = 1;
% end
os_init_parameter.apply_filter = apply_filter;

% define the parameter of the filters
filter_order = 5; % the default value
fmin = 0.1;
fmax = 90;

filter_parameter.fmin = fmin;
filter_parameter.fmax = fmax;
filter_parameter.filter_order = filter_order;
os_init_parameter.filter_parameter = filter_parameter;

% TO BE SIMPLIFIED : version trop comliqué,
%% Three options are possibel for the sampling rate,
% 1- sampling_rate_default* = 0 The sampling rate will be charged for the data (best option)
% 2- sampling_rate_default** = 1 The sampling rate is fixed at 200 Hz
% 3- resample_data = 1 : In this case user choose his own sampling rate
% an the data will be resampled according to the original sampling rate
% (could be * or **)
sampling_rate_default = 0; % the default value is fixed to 200 Hz
resample_data = 0; % choose if you want to resample the data, in this case you should fixe the frequency sampling
os_init_parameter.sampling_rate_default = sampling_rate_default;
os_init_parameter.resample_data = resample_data;

%$ TODO : downsample the data, add here the parameters for downsimpling the data
if resample_data == 1
  sampling_rate_by_user = 200;
  save_resample_data = 1; % if you want to save the resampled data
  
  os_init_parameter.sampling_rate_by_user = sampling_rate_by_user;
  os_init_parameter.save_resample_data = save_resample_data;
end



%% The Machine learning and Classification part :

%% 8- Number of the best features to use from the OFR
%nb_features = 30;
os_init_parameter.nb_features = nb_features;

% index of the best feature to display on the scatter plot in 2D
feature_index = [1 2];
os_init_parameter.feature_index = feature_index;

threshold_probe = 0.2; % threshold_probe, risk of selecting probes
os_init_parameter.threshold_probe = threshold_probe;

%% 9 - Choice of the ranking Method for the features reduction
% $ TODO: ADD the probe code of François and PCA implementation +
% optimisation choice
% TODO : check the library FS_LIB for the various feature selection and add it here
ranking_method_liste = {'gram_schmidt','gram_schmidt_probe','relieff',...
  'fsv','llcfs','Inf-FS','LaplacianScore','MCFS','udfs','cfs'};
ranking_method_choice = 1;
ranking_method = ranking_method_liste{ranking_method_choice};
os_init_parameter.ranking_method = ranking_method;



%% 10 - Method to use for the Crosse Validation

%cross_validation_method = 'LOSO'; % for Leave One Subject Out
% cross_validation_method = 'LHSO'; % for Leave Half Subject Out
%cross_validation_method = 'LOEO'; % for Leave One Epoch Out

%$ TODO : other method will be implemented soon
os_init_parameter.cross_validation_method = cross_validation_method;

%% 11- Method of the Classification : LDA, QDA, SVM, (DTC , MLP ...to be added)
% TODO : add the others methods

%classification_method = 'LDA';
%classification_method = 'QDA';
%classification_method = 'SVM';
%classification_method = 'DTC'; % TODO : for the decision tree classification
os_init_parameter.classification_method = classification_method;


% If the SVM method is selectd : 
if strcmp(classification_method,'SVM')
%% initializations from the GUI ot from init parameters
% modifiable hyperparameters, getting from the GUI
% c_kernel = {'linear'};%{'linear'; 'polynomial'; 'rbf'}; % Type of kernels tested
c_kernel = {'linear'};%{'linear'; 'polynomial'; 'gauss'}; % Type of kernels tested
% change the name to the adapted one
if (strcmp(c_kernel, 'gauss')  ==  1)
  c_kernel = {'rbf'};
end

svm_parameter.c_kernel = c_kernel;

c_gaussian_value = 0.5:0.5:4; % Gaussian kernel std range %% ONLY for the RBF kernel
svm_parameter.c_gaussian_value = c_gaussian_value;

c_polynomial_value = 2:5; % Polynomial kernel degree range %% ONLY for Polynomial kernel
svm_parameter.c_polynomial_value = c_polynomial_value;

c_constraint = [0.1:0.1:0.5 1 : 5]; % Soft margin hyperparameter range
svm_parameter.c_constraint = c_constraint;
% stability check variables
c_tolkkt = 5e-2; % KKT tolerance
svm_parameter.c_tolkkt = c_tolkkt;

if (strcmp(c_kernel, 'polynomial')  ==  1)
  condition = length(c_polynomial_value);
else
  if (strcmp(c_kernel, 'rbf')  ==  1)
    condition = length(c_gaussian_value);
  else % the case of the 'linear'
    condition = 1;
  end
end
svm_parameter.condition = condition;

os_init_parameter.svm_parameter = svm_parameter;
end

% if the user want to remove the feature computed afer the assembling
os_init_parameter.remove_individual_features = 'N';

%% Displaying the initializing parameters
if sigma_show_comment == 1;
  display(' ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  =  Informations : Initialisations   ==  ==  ==  ==  ==  ==  ==  ==  == ')
  display([' 0- Your data are located at the following path : ' training_data_location])
  display([' 1- You have selected the ' num2str(nb_subject) ' folowing subjects : ' num2str(subject)])
  display([' 2- You have selected the ' num2str(nb_selected_bands) ' folowing bands : ' num2str(selected_band)])
  display([' 3- You have selected ' num2str(low_pass_filter) ' for the low pass filter' ])
  display([' 4- You have selected ' num2str(notch_filter) ' for the notch filter' ])
  display([' 5- You have selected ' num2str(wavelet_transform) ' for the wavelet transform (reserved for the methods ' ...
    num2str(wt_method_list(1)) ' to ' num2str(wt_method_list(end)) ') )' ])
  display([' 6- You have selected the ' num2str(nb_method) ' folowing methods : ' num2str(method)])
  display([' 7- You have selected the ' num2str(apply_filter) ' for applying filters for the methods : ' num2str(method)])
  display([' 8- You have selected ' num2str(nb_features) ' feature(s) to rank with the OFR' ])
  display([' 9- You have selected the ' classification_method ' for the classification method' ])
  display([' You are running SIGMA under ' this_machine ' machine' ])
  
  display(' ==  ==  == > Next Step : If you keep the default value You should run this "init_parameter = sigma_frequency_initialisation(init_parameter)" ')
end


%% Creat session path
% sigma_creat_session = 1;
% init_parameter.sigma_creat_session = sigma_creat_session;
% if sigma_creat_session == 1
%   cd(init_parameter.sigma_directory)
%   cd(init_parameter.data_output)
%   if ~isdir((init_parameter.session_name))
%     mkdir(init_parameter.session_name)
%   end
%   %cd(init_parameter.session_name)
%   cd(init_parameter.sigma_directory)
% end



%% Wrinting the message on the Log file
if sigma_write_logFile == 1;
  cd(os_init_parameter.sigma_directory)
  cd(os_init_parameter.data_output)
  if ~isdir((os_init_parameter.session_name))
    mkdir(os_init_parameter.session_name)
  end
  cd(os_init_parameter.session_name)
  logFilename = os_init_parameter.logFilename;
  fid = fopen(logFilename,'a');
  fprintf(fid,'\n\n %s',['This is the LogFile for the session of : ' str]);
  fprintf(fid,'\n  ==  ==  Information : sigma_parameter_initialisation   ==  = ');
  fprintf(fid,'\n %s',['0- Your data are located at the following path : ' training_data_location]);
  fprintf(fid,'\n %s',['1- You have selected the ' num2str(nb_subject) ' folowing subjects : ' num2str(subject)]);
  fprintf(fid,'\n %s',['2- You have selected the ' num2str(nb_selected_bands) ' folowing bands : ' num2str(selected_band)]);
  fprintf(fid,'\n %s',['3- You have selected ' num2str(low_pass_filter) ' for the low pass filter' ]);
  fprintf(fid,'\n %s',['4- You have selected ' num2str(notch_filter) ' for the notch filter' ]);
  fprintf(fid,'\n %s',['5- You have selected ' num2str(wavelet_transform) ' for the wavelet transform (reserved for the methods 25 to XX) )' ]) ;
  fprintf(fid,'\n %s',['6- You have selected the ' num2str(nb_method) ' folowing methods : ' num2str(method)]);
  fprintf(fid,'\n %s',['7- You have selected the ' num2str(apply_filter) ' for applying filters for the methods : ' num2str(method)]);
  fprintf(fid,'\n %s',['8- You have selected ' num2str(nb_features) ' feature(s) to rank with the OFR' ]);
  fprintf(fid,'\n %s',['9- You have selected the ' classification_method ' for the classification method' ]);
  fclose(fid);
  cd(os_init_parameter.sigma_directory)
end

%% Close the diary file
diary off
end
%%
% % %----------------------------------------------------------------------
% % %         Brain Computer Interface team
% % %
% % %              _---~~(~~-_.
% % %             _{    )  )
% % %            ,  ) -~~- ( ,-' )_
% % %            ( `-,_..`., )-- '_,)
% % %           ( ` _) ( -~( -_ `, }
% % %           (_- _ ~_-~~~~`, ,' )
% % %            `~ -^(  __;-,((()))
% % %               ~~~~ {_ -_(())
% % %                   `\ }
% % %                    { }
% % %  File created by Takfarinas MEDANI
% % %  Creation Date : 30/05/2017
% % %  Updates and contributors :
% % %  30/01/2017, T MEDANI : Updating and adding options 
% % %
% % %  Citation: [creator and contributor names], comprehensive BCI
% % %       toolbox, available online 2016.
% % %
% % %  Contact info : francois.vialatte@espci.fr
% % %  Copyright of the contributors, 2016
% % %  Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
