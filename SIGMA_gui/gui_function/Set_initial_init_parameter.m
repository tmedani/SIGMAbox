function handles = Set_initial_init_parameter(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Set_initial_init_parameter(handles, hObject)
%
%   Function task:
%   Set the initial values and init_parameter
%
%   Inputs :
%   handles : structure containing GUI informations
%   hObject : necessary for the GUI management
%
%   Outputs :
%
%   handles : structure containing GUI informations
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%
%   Dependencies
%
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

% create init_parameter

% Aurélien
% handles.init_parameter = Sigma_parameter_initialisation();

% Takfarinas 01/12/2017
% Construct a questdlg with three options
% just to do not repeat the creation of the path
%%% DANGER cette premiére condition est temporaire, juts pour bloquer reset
%%% button
if ~isfield(handles,'init_method')
    init_parameter = [];
    %handles.init_parameter.sigma_creat_session=1;
    session = questdlg('Wellcome to Sigma, Please choose : ', ...
        'SIGMA Start', ...
        'New Session','Load Session','Cancel','New Session');
    switch session
        case 'New Session'            
            choice = questdlg('Do you want to specify the name of the session?', ...
                'SIGMA Creat Session', ...
                'Specify Name','Default Name','Cancel','Cancel');
            % Handle response
            switch choice
                case 'Specify Name'
                    default_name = 0;
                    init_parameter.default_name = default_name;
                    handles.session_canceled=0;
                    
                case 'Default Name'
                    default_name = 1;
                    init_parameter.default_name = default_name;
                    handles.session_canceled=0;
                    
                case 'Cancel'
                    handles.session_canceled=1;
                    guidata(hObject, handles);
                    return
                    
                case '' % handle is closed
                    %display('toto')
                    handles.session_canceled=1;
                    guidata(hObject, handles);
                    return
            end
        case 'Load Session'
                handles.load_session_from_start = 1;
                handles.session_canceled = 0;
                %Sigma_load_session_from_gui(hObject, [], handles)
        case 'Cancel'            
            handles.session_canceled=1;
            guidata(hObject, handles);
            return            
        case '' % handle is closed
            handles.session_canceled=1;
            guidata(hObject, handles);
            return
    end
else
    init_parameter=handles.init_parameter;
    %handles.init_parameter.sigma_creat_session=1;
end


init_parameter = Sigma_parameter_initialisation(init_parameter);
if isfield(init_parameter,'session_canceled')
    if init_parameter.session_canceled==1
        handles.session_canceled=1;
        return
    end
end

handles.init_parameter = init_parameter;

%Set initial data location
handles.init_parameter.data_location = [];

% set the initial value
handles.test_wavelet = 1;
% initilize the verification
handles.load_custom_feature=0;

% initialize cross term button

handles.FEM_add_cross_term.Value=0;
handles.FEM_add_cross_term.BackgroundColor	= [0.94 0.94 0.94];
handles.FEM_add_cross_term.String ='Add cross term(s)';


% Deal wtih directory
%%% Specify the sigma work directory
stack = dbstack('-completenames');
mfile_location = stack(1).file;
sigma_directory = mfile_location(1:end-52);
handles.init_parameter.sigma_directory = sigma_directory;
%handles.init_parameter.sigma_directory = pwd;

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

set(handles.DP_suject_text,'String',0);
set(handles.DL_st_data_path,'String','No path selected');

%remove last band from pre-selected bands
handles.init_parameter.selected_band(end) = [];

%set filter to 1
% handles.init_parameter.apply_filter = 1;
handles.init_parameter.apply_filter = ones(size(handles.init_parameter.method));
% set defaut selected band
handles.init_parameter.selected_band = 1;
handles.init_parameter.nb_bands = length(handles.init_parameter.selected_band);

% create initial samling rate
handles.init_parameter.sampling_rate_by_data = 0;
handles.init_parameter.sampling_rate_default = 1; % use a pre defined sampling rate

% initialize feature results
handles.feature_result  = [];

% initialize classification results
handles.performance_result = [];

% initialize feature ranking parameter and method
handles.init_parameter.threshold_probe = 0.2;
handles.init_parameter.nb_features = 1;
handles.init_parameter.adv_ranking_method = 'gram_schmidt';


%%% Takfarians
% set the wavelet transform to 1;
handles.init_parameter.wavelet_transform = 1;
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

c_kernel=handles.init_parameter.svm_parameter.c_kernel;
c_polynomial_value=handles.init_parameter.svm_parameter.c_polynomial_value;
c_gaussian_value=handles.init_parameter.svm_parameter.c_gaussian_value;
if (strcmp(c_kernel, 'polynomial')  ==  1)
    condition = length(c_polynomial_value);
else
    if (strcmp(c_kernel, 'rbf')  ==  1)
        condition = length(c_gaussian_value);
    else % the case of the 'linear'
        condition = 1;
    end
end
handles.init_parameter.svm_parameter.condition = condition;


%  Update handles structure
guidata(hObject, handles);

end

%% END OF FILE
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
% % %   File created by A. BAELDE
% % %   Creation Date : 13/01/2018
% % %   Updates and contributors :
% % %   Takfarinas Medani : Add the option to load session

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------