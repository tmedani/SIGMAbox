function handles = set_initial_init_parameter(handles, hObject)


% create init_parameter

% Aurélien
% handles.init_parameter = Sigma_parameter_initialisation();

% Takfarinas 01/12/2017
% Construct a questdlg with three options
% just to do not repeat the creation of the path
%%% DANGER cette premiére condition est temporaire, juts pour bloquer reset
%%% button 
init_parameter=[];
if ~isfield(handles,'init_method')
    
    init_parameter=[];
    choice = questdlg('Do you want to specify the name of the session?', ...
        'SIGMA Creat Session', ...
        'Specify Name','Default Name','Default Name');
    % Handle response
    switch choice
        case 'Specify Name'
            default_name=0;
            init_parameter.default_name=default_name;
        case 'Default Name'
            default_name=1;
            init_parameter.default_name=default_name;
    end
    
end


init_parameter= Sigma_parameter_initialisation(init_parameter);
handles.init_parameter=init_parameter;

%Set initial data location
handles.init_parameter.data_location = [];

% Deal wtih directory
handles.init_parameter.sigma_directory = pwd;

%initialize data compatibility
handles.init_parameter.data_compatibility = 0;

% don't write in the diary
handles.init_parameter.sigma_write_diaryFile = 0;

%Empty suject field of structure
handles.init_parameter.subject = [];
handles.init_parameter.nb_subject = length(handles.init_parameter.subject);
handles.init_parameter.subject_number = [];
handles.init_parameter.subject_name = {};
handles.init_parameter.subject_number = [];

%remove last band from pre-selected bands
handles.init_parameter.selected_band(end) = [];

%set filter to 1
handles.init_parameter.apply_filter = 1;

% set defaut selected band
handles.init_parameter.selected_band = 8;
handles.init_parameter.nb_bands = length(handles.init_parameter.selected_band);

% create initial samling rate
handles.init_parameter.sampling_rate_by_data = 0;
handles.init_parameter.sampling_rate_default = 1; % use a pre defined sampling rate

% initialize feature results
handles.features_results = [];

% initialize classification results
handles.performances_results = [];

% initialize feature ranking parameter and method
handles.init_parameter.threshold_probe = 0.8;
handles.init_parameter.nb_features = 1;
handles.init_parameter.adv_ranking_method = 'Not selected';


        %%% Takfarians 
        % set the wavelet transform to 1; 
        handles.init_parameter.wavelet_transform=1;
% call init_parameter frequency definition function
handles.init_parameter = Sigma_frequency_initialisation(handles.init_parameter);

% Initialize methods
handles.init_method = Sigma_method_initialisation(handles.init_parameter);

% set number of initial feature extraction methods
handles.init_parameter.method = [];
handles.init_parameter.nb_method = length(handles.init_parameter.method);




% set initial svm parameters
handles.init_parameter.svm_parameter.c_kernel = {'linear'};
handles.init_parameter.svm_parameter.c_gaussian_value = 0.5:0.5:4;
handles.init_parameter.svm_parameter.c_polynomial_value = 2:5;
handles.init_parameter.svm_parameter.c_constraint =  [0.1:0.1:0.5 1 : 5];
handles.init_parameter.svm_parameter.c_tolkkt = 5e-2;
handles.init_parameter.svm_parameter.c_violation = 0.1;
handles.init_parameter.svm_parameter.c_retest = 1;
handles.init_parameter.svm_parameter.c_stability_test = 30;

% modification takfa 06:01:2018; rajouter INITIALISATION condition
c_kernel=handles.init_parameter.svm_parameter.c_kernel;
c_polynomial_value=handles.init_parameter.svm_parameter.c_polynomial_value;
c_gaussian_value=handles.init_parameter.svm_parameter.c_gaussian_value;
if (strcmp(c_kernel, 'polynomial') == 1)
    condition = length(c_polynomial_value);
else
    if (strcmp(c_kernel, 'rbf') == 1)
        condition = length(c_gaussian_value);
    else % the case of the 'linear'
        condition = 1;
    end
end


% set the new svm parameters
handles.init_parameter.svm_parameter.condition=condition;


%  Update handles structure
guidata(hObject, handles);




end