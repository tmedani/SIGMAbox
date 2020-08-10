function varargout = Sigma_main_gui(varargin)
% SIGMA_MAIN_GUI MATLAB code for gui_aure_v0.fig
%      sigma_main_gui, by itself, creates a new sigma_main_gui or raises the existing
%      singleton*.
%
%      H = sigma_main_gui returns the handle to a new sigma_main_gui or the handle to
%      the existing singleton*.
%
%      sigma_main_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in sigma_main_gui.M with the given input arguments.
%
%      sigma_main_gui('Property','Value',...) creates a new sigma_main_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sigma_main_gui_openingfcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sigma_main_gui_openingfcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sigma_main_gui

% Last Modified by GUIDE v2.5 24-Oct-2018 18:57:25

% Begin initialization code - Do not EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sigma_main_gui_OpeningFcn, ...
    'gui_OutputFcn',  @Sigma_main_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - Do not EDIT


% --- Executes just before sigma_main_gui is made visible.
function Sigma_main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Start_SIGMA (see VARARGIN)

%% 1 - Get the screen position


set(handles.main_gui_sigma,'units', 'normalized');  %
gui_position=get(handles.main_gui_sigma,'position'); % position du panel

% set(handles.learning_panel,'units', 'normalized');  % position de l'ensemble incluant le panel
% gui_position=get(handles.learning_panel,'position');  % position de l'ensemble incluant le panel

set(gcf, 'units', 'normalized')
%figure_position=get(gcf, 'position');
%set(gcf, 'units', 'normalized', 'position', [0.2 0.2 0.7 0.6]) % postion [x y w h]
set(handles.main_gui_sigma,'position', [0 0 gui_position(3) gui_position(4)]) % postion [x y w h]

% Choose default command line output for Start_SIGMA
handles.output = hObject;

% Create initial init_parameter values to initialize the GUI
handles = Set_initial_init_parameter(handles, hObject);
if handles.session_canceled==1
    handles.output = hObject;
    guidata(hObject, handles);
    return;
end

[handles.init_parameter, session_state] = Sigma_create_session(handles.init_parameter);
disp(session_state)

% set initial method list
FEM_unselected_initial_generation(hObject, eventdata, handles)

% set gui according to init_parameter values
handles = Init_GUI(handles, hObject);
% generate GUI according to parameters
handles = Init_parameter2gui(handles, hObject);

%disp(handles.init_parameter.adv_ranking_method)

% [handles.init_parameter, session_state] = Sigma_create_session(handles.init_parameter);
% disp(session_state)

% TAKFARINAS the input argument, from the start GUI
if ~isempty(varargin)
    handles.location=varargin{1};
end

%% Load from start 
if isfield(handles,'load_session_from_start')
    if handles.load_session_from_start == 1
        Sigma_load_session_from_gui(hObject, [], handles)
    end
end

guidata(hObject, handles);


% disp(handles)
% UIWAIT makes sigma_main_gui wait for user response (see UIRESUME)
% uiwait(handles.learning_panel);

% --- Outputs from this function are returned to the command line.
function varargout = Sigma_main_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

% if button cancel is pushed sigma will stop
if  isfield(handles,'session_canceled')
    %hObject.Visible='off';
    if handles.session_canceled == 1
        h=msgbox('Session creation is canceled, SIGMA will stop','SIGMA message','warn');
        uiwait(h);
        %h.CloseRequestFcn='delete(hObject);return';
        clear handles
        delete(hObject)
        return;
    end
end



%% Data Loading

% Allow to select the path of subject data
function DL_path_push_Callback(hObject, eventdata, handles)
% Get data path for .mat filesa and add it to data location
FilePath = uigetdir();
if( FilePath == 0 )
    disp('No path selected')
else
    if ispc
        handles.init_parameter.data_location = [ FilePath, '\' ];
    end
    if ismac
        handles.init_parameter.data_location = [ FilePath, '/' ];
    end
    
    % Load subject data and update all
    handles = DL_load_subjects(handles, hObject);
    %Set button availability
    Set_button_availability(handles, hObject)
    
    % Set the toolstip
    handles.DL_st_data_path.TooltipString=handles.init_parameter.data_location;
    % activate the context menu
    handles.DL_open_data_folder.Enable='on';
    guidata(hObject, handles);
end

% SELECT SUBJECT TO BE CLASSIFIED
function DL_pb_subject_select_Callback(hObject, eventdata, handles)

handles = DP_subject2right(handles, hObject);

Set_button_availability(handles, hObject)
guidata(hObject, handles);





function DL_list_subject_available_Callback(hObject, eventdata, handles)
% if the list is double clicked
if( strcmp(get(handles.learning_panel,'SelectionType'), 'open'))
    % move subject to the selected list
    handles = DP_subject2right(handles, hObject);
    Set_button_availability(handles, hObject)
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function DL_list_subject_available_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function DL_pb_data_viz_Callback(hObject, eventdata, handles)
% Load visualization GUI
Sigma_visualisating_data(handles);


%% Data Processing
% SELECT SUBJECT TO BE REMOVED FROM CLASSIFICATION
function DP_pb_subject_remove_Callback(hObject, eventdata, handles)
handles = DP_subject2left(handles, hObject);

Set_button_availability(handles, hObject);
guidata(hObject, handles);

function DP_cb_resampling_enable_Callback(hObject, eventdata, handles)
Update_sampling_rate(handles, hObject)


% function DP_sampling_edit_Callback(hObject, eventdata, handles)
% Update_sampling_rate(handles, hObject)
%
%
% function DP_sampling_edit_CreateFcn(hObject, eventdata, handles)
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

% --- Executes on button press in DP_delta.
function DP_delta_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);

% update methods
handles = Update_method_from_principal_gui(handles, hObject);

guidata(hObject, handles);

% --- Executes on button press in DP_theta.
function DP_theta_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_mu.
function DP_mu_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_alpha.
function DP_alpha_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_beta.
function DP_beta_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_gamma.
function DP_gamma_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_gamma_high.
function DP_gamma_high_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

function DP_custom_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_total_bandwidth.
function DP_total_bandwidth_Callback(hObject, eventdata, handles)
% update selected band list
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DP_all.
function DP_all_Callback(hObject, eventdata, handles)
% set all buttons on the value of "all"
Set_all_frequency_button_on(handles, hObject)
% update init parameter
handles = DP_update_frequency_band(handles, hObject);
% update methods
handles = Update_method_from_principal_gui(handles, hObject);
guidata(hObject, handles);


% --- Executes on button press in DP_pb_freq_band_edit.
function DP_pb_freq_band_edit_Callback(hObject, eventdata, handles)
%Allow to edit frequency bandwidth
handles = Call_frequency_band_editGUI(handles, hObject);
guidata(hObject, handles);

% --- Executes on selection change in DP_list_subject_selected.
function DP_list_subject_selected_Callback(hObject, eventdata, handles)
% if double click
if( strcmp(get(handles.learning_panel,'SelectionType'), 'open'))
    % move subject to the unselected list
    handles = DP_subject2left(handles, hObject);
    Set_button_availability(handles, hObject);
    guidata(hObject, handles);
end

%--- Executes during object creation, after setting all properties.
function DP_list_subject_selected_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Feature extraction Method

% Generate the list of method and display it in the GUI
function FEM_unselected_initial_generation(hObject, eventdata, handles)
% generate methods and display in lists

handles = Set_method_GUI(handles, hObject);
guidata(hObject, handles);


% --- Executes on selection change in FEM_unselected.
function FEM_unselected_Callback(hObject, eventdata, handles)
% If double click on the unselected list -> move subject to the selected
% list
% set button availability of ediatable method
Set_button_availability(handles, hObject)
if( strcmp(get(handles.learning_panel,'SelectionType'), 'open')) % double click
    % move method to the selected method panel
    handles = FEM_method2right(handles, hObject);
    %%% Modification Takfarinas
    if isfield(handles,'wt_method_selected')
        wt_method_selected = handles.wt_method_selected;
        if ~isempty(wt_method_selected)
            if  handles.test_wavelet == 1
                warndlg(['You have selected one of the Wavelet methods, please,'...
                    'ensure that the method "wavelet transform"'...
                    'is selected with at least one of the wt_xxx method(s)'],'SIGMA','warning');
                handles.test_wavelet = 0;
            end
        end
    end
    
    guidata(hObject, handles);
    if handles.selected_method==99
        uiwait(msgbox(['This method "' handles.init_method(99).method_name '" is used to load data; '...
            'please use the Load Costum Feature button'],'SIGMA Message','warn'));
        % load costum feature
        handles = Load_features(handles, hObject);
    end
    
    %%%% fin modification takfarinas
    guidata(hObject, handles);
    
end
% --- Executes during object creation, after setting all properties.
function FEM_unselected_CreateFcn(hObject, eventdata, handles)

% --- Executes on selection change in FEM_selected.
function FEM_selected_Callback(hObject, eventdata, handles)
% If double click on the selected list -> move subject to the unselected
% list
% set button availability of ediatable method
Set_button_availability(handles, hObject)
if( strcmp(get(handles.learning_panel,'SelectionType'), 'open'))
    % move method to the unselected method panel
    handles = FEM_method2left(handles, hObject);
    %%% Modification Takfarinas
    if isfield(handles,'wt_method_selected')
        wt_method_unselected = handles.wt_method_unselected;
        if length(wt_method_unselected) == length(handles.init_parameter.wt_method_list)
            handles.test_wavelet = 1;
        end
    end
    %%%% fin modification takfarinas
    guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.
function FEM_selected_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in FEM_to_right.
function FEM_to_right_Callback(hObject, eventdata, handles)
% move method to the selected method panel
handles = FEM_method2right(handles, hObject);
guidata(hObject, handles);

function FEM_to_left_Callback(hObject, eventdata, handles)
% move method to the unselected method panel
handles = FEM_method2left(handles, hObject);
guidata(hObject, handles);

function FEM_pb_method_edit_Callback(hObject, eventdata, handles)
% edit the selected method parameter
handles = Call_method_edit_gui(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in FEM_pb_compute.
function FEM_pb_compute_Callback(hObject, eventdata, handles)
% compute the selected features
handles = Compute_features(handles, hObject);

guidata(hObject, handles);
%disp(handles.feature_result)

% --- Executes on button press in FEM_pb_load_feature.
function FEM_pb_load_feature_Callback(hObject, eventdata, handles)
% display('This function will be added soon!!')
% msgbox('This method is not already implemented for this version of SIGMA','SIGMA Warning !','warning');
handles = Load_features(handles, hObject);



% --- Executes on button press in FEM_help_button.
function FEM_help_button_Callback(hObject, eventdata, handles)
FE_menubar_quick_help_Callback(hObject, eventdata, handles)

%% Feature Ranking

% Call back of number of feature button
function FR_edit_nb_feature_Callback(hObject, eventdata, handles)
handles = Update_feature_ranking(handles, hObject);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FR_edit_nb_feature_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FR_edit_probability_probe_Callback(hObject, eventdata, handles)
% Edit the probe variable probability
handles = Update_feature_ranking(handles, hObject);
guidata(hObject, handles);

function FR_edit_probability_probe_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FR_pb_compute_FR.
function FR_pb_compute_FR_Callback(hObject, eventdata, handles)
% Compute the feature ranking
wait_title = 'Feature Ranking ';
wait_message = 'Selection in process...';
h_wait = Sigma_waiting(wait_title, wait_message);
% compute ranking
handles = Feature_ranking_gui(handles, hObject);
delete(h_wait)

guidata(hObject, handles);

% --- Executes on button press in FR_pb_display_FR.
function FR_pb_display_FR_Callback(hObject, eventdata, handles)
% Call the feature ranking result display GUI
handles = Call_feature_ranking_display_results(handles, hObject);
% % J'ai rajouté ça ici pour l'instant
% Sigma_3DScatterPlot(handles.init_parameter,handles.init_method,handles.feature_result)
guidata(hObject, handles);

% Do not delete
function FR_rb_nb_feature_Callback(hObject, eventdata, handles)
function FR_pb_display_FR_CreateFcn(hObject, eventdata, handles)
%**********////!!!   Do not remove   !!!\\\\**************

% MODIFICATION TAKFARINAS
% Affiche les informations sur une info bules lorsque on clique dessus
% --- Executes on button press in FR_rb_probe_variable.
function FR_rb_probe_variable_Callback(hObject, eventdata, handles)

% Modification Takfarinas
s = sprintf(['With this option, the number of selected features is determined using random probe variables.\n' ...
    'We work with the assumption that features contain a combination of information and noise.\n' ...
    'We draw a set of random features (termed as probe variables) whose ranking is compared with the real features.\n' ...
    'We run the feature ranking method, and stop when "probe probability" (box on the right, between 0 and 1 for 0-100%).\n' ...
    'probes have been ranked higher than real variables.\n' ...
    'In other words, we stop the ranking when our features have a risk of "probe probability".\n' ...
    'to contain no more information than random noise.']);
set(hObject, 'TooltipString', s)



% --- Executes when selected object is changed in FR_bg_ranking_method.
function FR_bg_ranking_method_SelectionChangedFcn(hObject, eventdata, handles)
% change the ranking method : OFR or advanced method
handles = Update_feature_ranking(handles, hObject);
guidata(hObject, handles);

% --- Executes when selected object is changed in FR_bg_nb_feature.
function FR_bg_nb_feature_SelectionChangedFcn(hObject, eventdata, handles)
% change the feature ranking methodology (number of feature ou probe
% variable
handles = Update_feature_ranking(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in FR_pb_edit_advanced_method.
function FR_pb_edit_advanced_method_Callback(hObject, eventdata, handles)
% Allow the selection of advanced FR methods
handles = Call_advanced_ranking_methodGUI(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in FR_pb_3D_FR.
function FR_pb_3D_FR_Callback(hObject, eventdata, handles)

% Call a GUI to visualize the 3D distribution of features
%% J'ai rajouté ça ici pour l'instant
tf = isfield(handles.feature_result, 'o_best_features_matrix');
if tf==1
    %h=figure;
    Sigma_3DScatterPlot(handles.init_parameter,handles.init_method,handles.feature_result);
else
    msgbox('You should run the OFR before','SIGMA Error','error');
    return;
end

% --- Executes on button press in FR_help_probe_button.
function FR_help_probe_button_Callback(hObject, eventdata, handles)
text = fileread('help_feature_selection.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Feature Selection';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

%% Data Classification

% --- Executes when selected object is changed in DC_bg_classification_method.
function DC_bg_classification_method_SelectionChangedFcn(hObject, eventdata, handles)
% change classification method
handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

% --- Executes on button press in DC_pb_edit_classification_method.
function DC_pb_edit_classification_method_Callback(hObject, eventdata, handles)
% change the SVM parameters
svm_message=sprintf('This method may take a long time to get the results \n Do you want to continue');
choice = questdlg(svm_message, 'SIGMA : SVM ','Yes', 'No', 'No');
% Handle response
switch choice
    case 'Yes'
        handles = Call_edit_classification_method_GUI(handles, hObject);
    case 'No'
        return
end
%handles = call_edit_classification_method_GUI(handles, hObject);
guidata(hObject, handles);


% --- Executes on button press in DC_rb_LDA.
function DC_rb_LDA_Callback(hObject, eventdata, handles)
% --- Executes on button press in DC_rb_QDA.
function DC_rb_QDA_Callback(hObject, eventdata, handles)
% --- Executes on button press in DC_rb_SVM.
function DC_rb_SVM_Callback(hObject, eventdata, handles)
%
% %warndlg('This method is not already adapted for this version of SIGMA, please change','SIGMA Error','error');
% message=sprintf('This method is not already adapted for this version of SIGMA, please change \n .... But you can do it \n Hint : export the results to matlab and use the doc of "svmclassify"');
% msgbox(message,'SIGMA message');
% handles.DC_rb_SVM.Value=0;
% handles.DC_rb_LDA.Value=1;
% Hint: get(hObject,'Value') returns toggle state of DC_rb_SVM

% --- Executes on button press in DC_rb_DTC.
function DC_rb_DTC_Callback(hObject, eventdata, handles)
% hObject    handle to DC_rb_DTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('This method is not already adapted for this version of SIGMA')
msgbox('This method is not already adapted for this version of SIGMA, please change','SIGMA Error','error');
% Hint: get(hObject,'Value') returns toggle state of DC_rb_DTC


% --- Executes when selected object is changed in DC_bg_cross_validation.
function DC_bg_cross_validation_SelectionChangedFcn(hObject, eventdata, handles)
% Update cross validation method
handles = Update_classification_settings(handles, hObject);
guidata(hObject, handles);

function DC_cb_LOSO_Callback(hObject, eventdata, handles)
% Select LOSO
handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);


function DC_cb_LOEO_Callback(hObject, eventdata, handles)
% Select LOEO
handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

% --- Executes on button press in DC_pb_help_LOO.
function DC_pb_help_LOO_Callback(hObject, eventdata, handles)
%DC_LOO_help_gui
text = fileread('help_cross_validation.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Cross-Validation';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

% --- Executes on button press in DC_pb_compute.
function DC_pb_compute_Callback(hObject, eventdata, handles)
% compute the classification
handles = Compute_classification(handles, hObject);
% % 
%  Set_button_availability(handles, hObject);
%  handles = Update_feature_ranking(handles, hObject);

guidata(hObject, handles);

% --- Executes on button press in DC_pb_display.
function DC_pb_display_Callback(hObject, eventdata, handles)
% call a result display gui and displays classification results
handles = Call_classification_display_result(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in DC_select_best_model.
function DC_select_best_model_Callback(hObject, eventdata, handles)
% Select the best model available after classification
init_parameter = handles.init_parameter;
feature_result = handles.feature_result;
init_method = handles.init_method;
performance_result = handles.performance_result;
%% Modification by Nessim
%check if the number of feature was selected manually
if isappdata(handles.learning_panel,'nb_of_feature_selected')
    feature_result.nb_of_feature_selected = getappdata(handles.learning_panel,'nb_of_feature_selected')
end

%check if the threshold was selected manually
if isappdata(handles.learning_panel,'threshold_selected')
    feature_result.threshold_selected = getappdata(handles.learning_panel,'threshold_selected')
end
%%
% use the best model selection function
handles.selected_model = Sigma_get_best_model(init_parameter,feature_result,performance_result);
%selected_model
% msg=['The best model is selected according to the best AUC = ' num2str(100*handles.selected_model.auc_model) '%'];
% msgbox(msg,'SIGMA : select best model')
%set_button_availability
set(handles.DC_pb_apply_model, 'Enable', 'on')
guidata(hObject, handles);


% --- Executes on button press in DC_pb_apply_model.
function DC_pb_apply_model_Callback(hObject, eventdata, handles)
% Call a GUI to apply the model on new data
handles = Call_sigma_apply_model_gui(handles, hObject);
%
guidata(hObject, handles);


% --- Executes on button press in A_pb_reset_parameter.
function A_pb_reset_parameter_Callback(hObject, eventdata, handles)
toolbar_close_wb_ClickedCallback(hObject, eventdata, handles)
%Reset init_parameter
handles.init_parameter.sigma_creat_session=0;
if isfield(handles,'sigma_load_session')
    handles = rmfield(handles,'sigma_load_session');
end
handles = Set_initial_init_parameter(handles, hObject);
% set gui according to init_parameter values
handles = Init_GUI(handles, hObject);
handles = Init_parameter2gui(handles, hObject);
guidata(hObject, handles);


% --- Executes on button press in DC_save_session.
function DC_save_session_Callback(hObject, eventdata, handles)

% aurélien's version
%Save_session_gui(handles)
%
Sigma_save_session_for_GUI(handles,hObject)

guidata(hObject, handles);



% --- Executes on button press in Exit_sigma.
function Exit_sigma_Callback(hObject, eventdata, handles)
choice = questdlg('Exit SIGMA : Are you sure?', 'SIGMA : Exit','Yes', 'No', 'No');
toolbar_close_wb_ClickedCallback(hObject, eventdata, handles)
% Handle response
switch choice
    case 'Yes'
        close(handles.learning_panel)
        % close all force
    case 'No'
        return
end



%% Other


% --- Executes on button press in A_pb_load_session.
function A_pb_load_session_Callback(hObject, eventdata, handles)



% --- Executes on button press in A_pb_see_workspace.
function A_pb_see_workspace_Callback(hObject, eventdata, handles)
% sprintf(['There is more than 2 labels, this version is'...
%         'not addapted for your data,\n Do you want to Continue processing,'...
%         '\nor Cancel to abort processing?']);
message=[];
if isfield(handles,'init_parameter')
    assignin('base', 'init_parameter', handles.init_parameter )
    message=[message;{'init_parameter'}];
end
if isfield(handles,'init_method')
    assignin('base', 'init_method', handles.init_method )
    message=[message;{'init_method'}];
end
if isfield(handles,'feature_result')
    assignin('base', 'feature_result', handles.feature_result )
    message=[message;{'feature_result'}];
end
if isfield(handles,'performance_result')
    assignin('base', 'performance_result', handles.performance_result )
    message=[message;{'performance_result'}];
end
if isfield(handles,'selected_model')
    assignin('base', 'selected_model', handles.selected_model )
    message=[message;{'selected_model'}];
end

%display(sprintf (['exporting to matlab workspace...: \n  \t      '  sprintf('%s\n  \t      ', message{:})]));
fprintf (['exporting to Matlab workspace...: \n  \t      '  sprintf('%s\n  \t      ', message{:})]);
disp('----------------------------------');
uiwait(msgbox('The session results are exported to Matlab','SIGMA message'));
disp('Greaaat !')


% --- Executes on button press in test_classif_method.
function test_classif_method_Callback(hObject, eventdata, handles)

handles = Call_edit_classification_method_GUI(handles, hObject);





% --- Executes on button press in Close_wait_barre.
function Close_wait_barre_Callback(hObject, eventdata, handles)
% hObject    handle to Close_wait_barre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);


% --- Executes on button press in DC_pb_help_CVM.
function DC_pb_help_CVM_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function pushtool_new_session_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pushtool_new_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Reset init_parameter
handles = Set_initial_init_parameter(handles, hObject);
% set gui according to init_parameter values
handles = Init_parameter2gui(handles, hObject);
guidata(hObject, handles);



% --------------------------------------------------------------------
function help_context_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_context_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





%% Upper Menu

%% File
function menu_files_Callback(hObject, eventdata, handles)
display('Click on the Menu Files')
% --------------------------------------------------------------------
function menu_files_new_session_Callback(hObject, eventdata, handles)

%keep init_method in memory in case of no creation of new session
init_method_temp=handles.init_method;
% remove init_method from handles to creat new session from Set_initial_init_parameter
handles=rmfield(handles,'init_method');
%Reset init_parameter
handles = Set_initial_init_parameter(handles, hObject);
if handles.session_canceled==1
    disp('New session is not created')
    handles.init_method=init_method_temp;
    return
end
% create new session
[handles.init_parameter, ~] = Sigma_create_session(handles.init_parameter);
% set gui according to init_parameter values
handles = Init_parameter2gui(handles, hObject);
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_files_load_session_Callback(hObject, eventdata, handles)
Sigma_load_session_from_gui(hObject, eventdata, handles)


function menu_files_save_session_Callback(hObject, eventdata, handles)
% add SAVE GUI when function is modified
% call session save gui
% Save_session_gui(handles)
Sigma_save_session_for_GUI(handles,hObject)


function menu_files_quit_Callback(hObject, eventdata, handles)
%call close function
close all force



% --------------------------------------------------------------------
function menu_close_waitbar_Callback(hObject, eventdata, handles)
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);


%% Associatd windows
function menu_op_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function FRRV_Callback(hObject, eventdata, handles)

handles = Call_feature_ranking_display_results(handles, hObject);
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_op_display_results_Callback(hObject, eventdata, handles)

handles = Call_classification_display_result(handles, hObject);
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_op_apply_model_Callback(hObject, eventdata, handles)

handles = Call_apply_model_GUI(handles, hObject);
guidata(hObject, handles);

%% Edit
% --------------------------------------------------------------------
function menubar_edit_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menubar_edit_freq_band_Callback(hObject, eventdata, handles)
DP_pb_freq_band_edit_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function menubar_edit_extraction_method_Callback(hObject, eventdata, handles)
FEM_pb_method_edit_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function menubar_edit_ranking_method_Callback(hObject, eventdata, handles)
FR_pb_edit_advanced_method_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function menubar_edit_classification_method_Callback(hObject, eventdata, handles)


%% Help

function menu_help_Callback(hObject, eventdata, handles)
% Diplay a GUI with the HELP
%

% --------------------------------------------------------------------
function sigma_help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma_help_gui
% --------------------------------------------------------------------
function tutorial_of_sigma_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function manual_of_sigma_Callback(hObject, eventdata, handles)


%% Quick help
% --------------------------------------------------------------------
function Quick_Help_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function DL_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_data_loading.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Data Loading';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)
% --------------------------------------------------------------------
function DP_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_data_processing.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Data Processing';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

% --------------------------------------------------------------------
function FE_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_feature_extraction.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Feature Extraction';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

% --------------------------------------------------------------------
function FR_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_feature_ranking.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Feature Ranking & Selection';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)
% --------------------------------------------------------------------
function DC_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_data_classification.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Data Classification';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)
% --------------------------------------------------------------------
function AM_menubar_quick_help_Callback(hObject, eventdata, handles)
text = fileread('quick_help_apply_model.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Apply Model';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)
% --------------------------------------------------------------------
function menubar_about_sigma_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function about_sigma_Callback(hObject, eventdata, handles)

text = fileread('quick_about_sigma.txt') ;
text_to_display = text;
name_of_gui = 'About SIGMA';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

%% Unknown usabiity, delete only if it doesnt disturbate the GUI

function Settings_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function learning_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function apply_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function results_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)


% --- Executes on button press in FEM_save_feature.
function pushbutton58_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton67.
function pushbutton67_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton66.
function pushbutton66_Callback(hObject, eventdata, handles)

% --- Executes on button press in DL_data_compatibility_pb_help.
function DL_data_compatibility_pb_help_Callback(hObject, eventdata, handles)
text = fileread('help_data_compatibility.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Data Compatibility';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)


% --- Executes on button press in DP_help_button.
function DP_help_button_Callback(hObject, eventdata, handles)
text = fileread('help_frequency_band.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Frequency band';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)



% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton64.
function pushbutton64_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton68.
function pushbutton68_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)



function DP_sampling_edit_Callback(hObject, eventdata, handles)
% hObject    handle to DP_sampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DP_sampling_edit as text
%        str2double(get(hObject,'String')) returns contents of DP_sampling_edit as a double


% --- Executes during object creation, after setting all properties.
function DP_sampling_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DP_sampling_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FR_rb_GS.
function FR_rb_GS_Callback(hObject, eventdata, handles)
% hObject    handle to FR_rb_GS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FR_rb_GS


% --- Executes during object creation, after setting all properties.
function DC_pb_apply_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DC_pb_apply_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function DL_how_to_use_Callback(hObject, eventdata, handles)
% hObject    handle to DL_how_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
backg_color=[rand rand rand];
set(gco, 'BackgroundColor', backg_color);

% --------------------------------------------------------------------
function DL_help_Callback(hObject, eventdata, handles)
% hObject    handle to DL_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************
display('toto')

% --------------------------------------------------------------------
function Untitled_20_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function DL_list_subject_available_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to DL_list_subject_available (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DL_get_infos_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DL_get_infos_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('toto')
subject_index=handles.init_parameter.subject_index;
nb_subject=length(subject_index);
data=[];subject_rank=[];
for ind = 1:nb_subject
    if isfield(handles,'sigma_load_session')
        if handles.sigma_load_session == 1
            msgbox('These subject(s) are not available on this computer')
            return
        end
    end
    load([handles.init_parameter.data_location 'subject_' num2str(subject_index(ind))])
    % get the information
    subject_number=s_EEG.subject_number;
    sampling_rate=s_EEG.sampling_rate;
    %channel_name=s_EEG.channel_names;
    class=unique(s_EEG.labels);
    if length(class)==2
        class_one=class(1);
        class_two=class(2);
    else
        class_one=class(1);
        class_two=nan;
    end
    
    temp=unique(class);
    if length(class)==2
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=length(find(s_EEG.labels==temp(2)));
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=100*amount_class_two/length(s_EEG.labels);
    else
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=nan;
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=nan;
    end
    nb_channel=size(s_EEG.data,1);
    nb_sample=size(s_EEG.data,2);
    nb_epoch=size(s_EEG.data,3);
    time_duration=nb_sample/sampling_rate;
    
    data =[data; subject_number nb_channel nb_sample sampling_rate...
        time_duration nb_epoch class_one class_two...
        amount_class_one amount_class_two rate_class_one rate_class_two];
    
    % numérotaion rank subject
    temp_var = strcat( 'subject ',num2str(ind,2) );
    subject_rank=[subject_rank;{temp_var}];
end

% $TODO : find an inteligent wy to fit the table to the data
f = figure('Color','w');
f.Name='Loaded subject on SIGMA';
f.MenuBar='none';
f.NumberTitle='off';
title('Infos about the loaded subject(s)','fontsize',15);
axis off
d = data; % Make some random data to add
t = uitable(f);
set(t,'Data',d,'FontSize',12); % Use the set command to change the uitable properties.
columname={' Subject number ';' nb_channel ';' nb_sample ';...
    ' sampling_rate (Hz) ';' time_duration (s) ';' nb_epoch ';' class_one ';...
    ' class_two ';' amount_class_one ';' amount_class_two ';' rate_class_one ';...
    ' rate_class_two '};
set(t,'ColumnName',columname,'Fontsize',15);
set(t,'RowName',subject_rank,'fontsize',15);
set(t,'TooltipString','Loaded subject');

reformatTable(t,f)


% --------------------------------------------------------------------
function DL_available_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DL_available_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test=handles.init_parameter;
if ~isfield(test,'subject_index')
    set(handles.DL_get_infos_subject,'Enable','off')
    set(handles.DL_show_subject_explorer,'Enable','off')
else
    set(handles.DL_get_infos_subject,'Enable','on')
    set(handles.DL_show_subject_explorer,'Enable','on')
end
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function DP_get_infos_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DP_get_infos_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('toto')
subject_index=handles.init_parameter.subject;
nb_subject=length(subject_index);
data=[];subject_rank=[];
for ind=1:nb_subject
    load([handles.init_parameter.data_location 'subject_' num2str(subject_index(ind))])
    % get the information
    subject_number=s_EEG.subject_number;
    sampling_rate=s_EEG.sampling_rate;
    %channel_name=s_EEG.channel_names;
    class=unique(s_EEG.labels);
    if length(class)==2
        class_one=class(1);
        class_two=class(2);
    else
        class_one=class(1);
        class_two=nan;
    end
    
    temp=unique(class);
    if length(class)==2
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=length(find(s_EEG.labels==temp(2)));
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=100*amount_class_two/length(s_EEG.labels);
    else
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=nan;
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=nan;
    end
    nb_channel=size(s_EEG.data,1);
    nb_sample=size(s_EEG.data,2);
    nb_epoch=size(s_EEG.data,3);
    time_duration=nb_sample/sampling_rate;
    
    data =[data; subject_number nb_channel nb_sample sampling_rate...
        time_duration nb_epoch class_one class_two...
        amount_class_one amount_class_two rate_class_one rate_class_two];
    
    % numérotaion rank subject
    temp_var = strcat( 'subject ',num2str(ind,2) );
    subject_rank=[subject_rank;{temp_var}];
end

% $TODO : find an inteligent way to fit the table to the data
f = figure('Color','w');
title('Infos about the selected subject(s)','fontsize',15);
axis off
f.Name='Selected subject on SIGMA';
f.MenuBar='none';
f.NumberTitle='off';
d = data; % Make some random data to add
t = uitable(f);
set(t,'Data',d,'FontSize',12); % Use the set command to change the uitable properties.
columname={' Subject number ';' nb_channel ';' nb_sample ';...
    ' sampling_rate (Hz) ';' time_duration (s) ';' nb_epoch ';' class_one ';...
    ' class_two ';' amount_class_one ';' amount_class_two ';' rate_class_one ';...
    ' rate_class_two '};
set(t,'ColumnName',columname,'Fontsize',15);
set(t,'RowName',subject_rank,'fontsize',15);
set(t,'TooltipString','Loaded subject');

reformatTable(t,f)
% --------------------------------------------------------------------
function DP_available_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DP_available_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'selected_subject')
    set(handles.DP_get_infos_subject,'Enable','off')
end
if isfield(handles,'selected_subject')
    if isempty(handles.selected_subject)
        set(handles.DP_get_infos_subject,'Enable','off')
    else
        set(handles.DP_get_infos_subject,'Enable','on')
    end
end
%**********////!!!   Do not remove   !!!\\\\**************

% --------------------------------------------------------------------
function what_data_wisualisation_Callback(hObject, eventdata, handles)
% hObject    handle to what_data_wisualisation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('what_is_this_data_visualisation.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA What is this : Data Visualisation';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

% --------------------------------------------------------------------
function DL_data_visualisation_Callback(hObject, eventdata, handles)
% hObject    handle to DL_data_visualisation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function FEM_available_method_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_available_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************

function FEM_compute_feature_Callback(hObject, eventdata, handles)
%**********////!!!   Do not remove   !!!\\\\**************

% --------------------------------------------------------------------
function FEM_selected_method_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_selected_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function FEM_load_feature_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_load_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function FEM_save_feature_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_save_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Extracte the features and the names of the features
if isempty(handles.feature_result)
    msgbox('SIGMA >> Please Compute Feature Before' ,'SIGMA Message','warn');
    return
end
feature_result = handles.feature_result;
init_parameter = handles.init_parameter;
label=feature_result.label;

if isempty(feature_result)
    msgbox('There is no feature to save, please compute feature before','SIGMA Error','error');
    return;
end

o_feature_matrix = handles.feature_result.o_features_matrix;
%label=handles.feature_result.label;

[ best_organisation, best_organisation_infos]=Sigma_feature_identification...
    (handles.init_parameter,handles.init_method,handles.feature_result);
org=best_organisation;
org_infos=best_organisation_infos;
% save the feature as costum feature format
filename=['costum_feature_' handles.init_parameter.session_name];
feature_value=o_feature_matrix;
feature_name=cell(length(best_organisation),1);
for ind=1:length(best_organisation)
    if ~strcmp(handles.init_method(org{ind,2}).method_name,'custom_feature_subject')
        feature_name=[feature_name;{strcat('feature N°:', num2str(org{ind,1}), ...
            ',  method :', handles.init_method(org{ind,2}).method_name,...
            ', channel : ', handles.init_parameter.channel_name(org{ind,3}), ...
            ', band : ', handles.init_parameter.bands_list(org{ind,4}),...
            ', power_type : ', num2str(org{ind,5}), ', (', org_infos{5}, ')')}];
    elseif strcmp(handles.init_method(org{ind,2}).method_name,'custom_feature_subject')
        feature_name=[feature_name;{strcat('feature N°:', num2str(org{ind,1}), ...
            ',  method :', handles.init_method(org{ind,2}).method_name,...
            ', channel : ', handles.init_parameter.channel_name(org{ind,3}))}];
    end
end

cd(init_parameter.full_session_name)
save(filename,'feature_value','feature_name','label','init_parameter','feature_result');
cd(init_parameter.sigma_directory);
choice = questdlg('Your feature are correctly saved on current session folder'...
    ,'SIGMA save session','Ok', 'Open folder','Open folder');
% Handle response
switch choice
    case 'OK'
        disp('Goood')
    case 'Open folder'
        if ispc
            winopen(init_parameter.full_session_name);
        end
        if ismac
            macopen(init_parameter.full_session_name);
        end
        
end

% --------------------------------------------------------------------
function FEM_feature_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_feature_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function FR_rank_feature_Callback(hObject, eventdata, handles)
% hObject    handle to FR_rank_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********////!!!   Do not remove   !!!\\\\**************


% --------------------------------------------------------------------
function DL_show_subject_explorer_Callback(hObject, eventdata, handles)
% hObject    handle to DL_show_subject_explorer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ispc
    winopen(handles.init_parameter.data_location);
end
if ismac
    macopen(handles.init_parameter.data_location);
end

function DL_data_path_Callback(hObject, eventdata, handles)
%**********////!!!   Do not remove   !!!\\\\**************
% --------------------------------------------------------------------
function DL_open_data_folder_Callback(hObject, eventdata, handles)
% hObject    handle to DL_open_data_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%winopen(handles.init_parameter.data_location);
if ispc
    winopen(handles.init_parameter.data_location);
end
if ismac
    macopen(handles.init_parameter.data_location);
end


% --------------------------------------------------------------------
function change_font_data_path1_Callback(hObject, eventdata, handles)
% hObject    handle to change_font_data_path1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = uisetfont();
handles.DL_st_data_path.FontName=S.FontName;
handles.DL_st_data_path.FontWeight=S.FontWeight;
handles.DL_st_data_path.FontAngle=S.FontAngle;
handles.DL_st_data_path.FontUnits=S.FontUnits;
handles.DL_st_data_path.FontSize=S.FontSize;
%handles.DL_st_data_path.String
guidata(hObject, handles);


% --------------------------------------------------------------------
function DL_change_font_available_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DL_change_font_available_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = uisetfont();
handles.DL_list_subject_available.FontName=S.FontName;
handles.DL_list_subject_available.FontWeight=S.FontWeight;
handles.DL_list_subject_available.FontAngle=S.FontAngle;
handles.DL_list_subject_available.FontUnits=S.FontUnits;
handles.DL_list_subject_available.FontSize=S.FontSize;
guidata(hObject, handles);


% --------------------------------------------------------------------
function DL_change_font_selected_subject_Callback(hObject, eventdata, handles)
% hObject    handle to DL_change_font_selected_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = uisetfont();
handles.DP_list_subject_selected.FontName=S.FontName;
handles.DP_list_subject_selected.FontWeight=S.FontWeight;
handles.DP_list_subject_selected.FontAngle=S.FontAngle;
handles.DP_list_subject_selected.FontUnits=S.FontUnits;
handles.DP_list_subject_selected.FontSize=S.FontSize;
guidata(hObject, handles);


% --------------------------------------------------------------------
function FEM_change_font_selected_method_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_change_font_selected_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = uisetfont();
handles.FEM_selected.FontName=S.FontName;
handles.FEM_selected.FontWeight=S.FontWeight;
handles.FEM_selected.FontAngle=S.FontAngle;
handles.FEM_selected.FontUnits=S.FontUnits;
handles.FEM_selected.FontSize=S.FontSize;

guidata(hObject, handles);




function FEM_change_font_available_method_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_change_font_selected_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = uisetfont();
handles.FEM_unselected.FontName=S.FontName;
handles.FEM_unselected.FontWeight=S.FontWeight;
handles.FEM_unselected.FontAngle=S.FontAngle;
handles.FEM_unselected.FontUnits=S.FontUnits;
handles.FEM_unselected.FontSize=S.FontSize;
guidata(hObject, handles);


% --------------------------------------------------------------------
function FEM_open_init_method_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to  (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit('Sigma_method_initialisation.m');

guidata(hObject, handles);


% --------------------------------------------------------------------
function FEM_open_load_feature_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_open_load_feature_mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit('Sigma_load_custom_feature.m');

guidata(hObject, handles);


% --------------------------------------------------------------------
function FEM_open_compute_feature_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_open_compute_feature_mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit('Sigma_feature_extraction.m');

guidata(hObject, handles);


% --------------------------------------------------------------------
function FR_open_ranking_feature_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to FR_open_ranking_feature_mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit('Sigma_feature_ranking3.m');

guidata(hObject, handles);


% --------------------------------------------------------------------
function FEM_export_feature_to_matlab_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_export_feature_to_matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'feature_result', handles.feature_result )
assignin('base','feature_matrix', handles.feature_result.o_features_matrix)

uiwait(msgbox('The Feature results are exported to Matlab','SIGMA message'))
guidata(hObject, handles);


% --- Executes on button press in FEM_add_cross_term.
function FEM_add_cross_term_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_add_cross_term (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FEM_add_cross_term
% Wainting bar

if strcmp(hObject.Tag,'add_cross_term_menubar')
    hObject = handles.add_cross_term_menubar;
    cross_term_checked = get(hObject,'Checked');
    if strcmp(cross_term_checked,'on')
        add_cross_term = 1;
    elseif strcmp(cross_term_checked,'off')
        add_cross_term = 0;
    end
end

if strcmp(hObject.Tag,'FEM_add_cross_term')
    hObject = handles.FEM_add_cross_term;
    add_cross_term = get(hObject,'Value');
    if add_cross_term == 1
        cross_term_checked = 'on';
    elseif add_cross_term == 0
        cross_term_checked = 'off';
    end
    set(handles.add_cross_term_menubar,'Checked',cross_term_checked);
end


handles.init_parameter.compute_cross_term_feature = add_cross_term;

if add_cross_term
    message=sprintf(['This method is advised for the QDA and SVM classification.\n',...
        'The Cross terms will be computed and added to the Feature Matrix. \n' ...
        'The size of the new matrix is n(n+1)']);
    uiwait(msgbox(message,'SIGMA Message'));
    % waiting bar
    wait_title = 'Cross Terms';
    wait_message = 'Computing...   ';
    h_wait = Sigma_waiting(wait_title, wait_message);
    
    handles.feature_result=Sigma_feature_assembling(handles.init_method,...
        handles.init_parameter,handles.feature_result);
    handles.FEM_add_cross_term.BackgroundColor	='g';
    handles.FEM_add_cross_term.String ='Cross term(s) added';
    
    % Display results
    if isfield(handles.feature_result,'nb_features')
        set(handles.FEM_st_nb_features_computed, 'String', handles.feature_result.nb_features);
        set(handles.FEM_st_nb_epoch_computed, 'String', handles.feature_result.nb_epoch);
        set(handles.FR_edit_nb_feature, 'String', handles.feature_result.nb_features);
    end
    % close the wainting bar
    delete(h_wait)
else
    handles.FEM_add_cross_term.BackgroundColor	=[0.94 0.94 0.94];
    handles.FEM_add_cross_term.String ='Add cross term(s)';
    if isempty(handles.feature_result)
        %msgbox('SIGMA >> Please Compute Feature Before' ,'SIGMA Message','warn');
        return
    end
    handles.feature_result.o_features_matrix=...
        handles.feature_result.o_features_matrix_original;
    
    handles.feature_result=Sigma_feature_assembling(handles.init_method,...
        handles.init_parameter,handles.feature_result);
    % Display results
    if isfield(handles.feature_result,'nb_features')
        set(handles.FEM_st_nb_features_computed, 'String', handles.feature_result.nb_features);
        set(handles.FEM_st_nb_epoch_computed, 'String', handles.feature_result.nb_epoch);
        set(handles.FR_edit_nb_feature, 'String', handles.feature_result.nb_features);
    end
end
% Display results Linear separability
if isempty(handles.feature_result)
    %msgbox('SIGMA >> Please Compute Feature Before' ,'SIGMA Message','warn');
    return
end
tf=handles.feature_result.linear_Separability+1;
yes_or_no={'No','Yes'};
set(handles.FEM_st_linear_separability, 'String', yes_or_no(tf));


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FR_pb_compute_FR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FR_pb_compute_FR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function DC_cross_validation_Callback(hObject, eventdata, handles)
% hObject    handle to DC_cross_validation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function DC_open_cross_validation_Callback(hObject, eventdata, handles)

edit('Sigma_cross_validation.m');


function DC_help_classification_method_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function DC_help_lda_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_lda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_LDA.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)

% --------------------------------------------------------------------
function DC_help_qda_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_qda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_QDA.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)

% --------------------------------------------------------------------
function DC_help_svm_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_svm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_SVM.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)

% --------------------------------------------------------------------
function DC_help_dtc_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_dtc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
% --------------------------------------------------------------------
function DC_help_cross_validation_method_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function DC_help_loso_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_loso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_LOSO.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)


% --------------------------------------------------------------------
function DC_help_loeo_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_loeo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_LOEO.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)

% --------------------------------------------------------------------
function DC_help_lhso_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help_lhso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text = fileread('quick_help_LHSO.txt') ;
text_to_display = text;
Sigma_help_adaptive_gui(text_to_display)




% --------------------------------------------------------------------
function option_export_to_matlab_Callback(hObject, eventdata, handles)
% hObject    handle to option_export_to_matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A_pb_see_workspace_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function option_save_session_Callback(hObject, eventdata, handles)
% hObject    handle to option_save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DC_save_session_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function option_reset_all_Callback(hObject, eventdata, handles)
% hObject    handle to option_reset_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A_pb_reset_parameter_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function option_exit_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to option_exit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Exit_sigma_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Panel_Option_Callback(hObject, eventdata, handles)
% hObject    handle to Panel_Option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DC_how_to_use_Callback(hObject, eventdata, handles)
% hObject    handle to DC_how_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FR_how_to_use_Callback(hObject, eventdata, handles)
% hObject    handle to FR_how_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FEM_how_to_use_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_how_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DP_how_to_use_Callback(hObject, eventdata, handles)
% hObject    handle to DP_how_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DP_help_Callback(hObject, eventdata, handles)
% hObject    handle to DP_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FEM_help_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FR_help_Callback(hObject, eventdata, handles)
% hObject    handle to FR_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DC_help_Callback(hObject, eventdata, handles)
% hObject    handle to DC_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function option_how_to_use_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to option_how_to_use_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma_help_gui


% --------------------------------------------------------------------
function toolbar_new_session_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_new_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_files_new_session_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_load_session_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_load_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_files_load_session_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_save_session_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma_save_session_for_GUI(handles,hObject)


% --------------------------------------------------------------------
function toolbar_close_wb_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_close_wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);


% --------------------------------------------------------------------
function toolbar_help_sigma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_help_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma_help_gui


% --------------------------------------------------------------------
function toolbar_exit_sigma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_exit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Exit_sigma_Callback


% --------------------------------------------------------------------
function toolbar_manual_sigma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_manual_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manual_of_sigma_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_tutorial_sigma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_tutorial_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tutorial_of_sigma_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_about_sigma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_about_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about_sigma_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_web_page_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_web_page (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
url = 'https://www.bio.espci.fr/-Francois-Vialatte-Brain-Computer-Interfaces-';
web(url,'-browser')


% --------------------------------------------------------------------
function toolbar_contact_us_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_contact_us (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
email = 'takfarinas.medani@espci.fr';
url = ['mailto:',email];
web(url)


% --------------------------------------------------------------------
function toolbar_screen_shot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_screen_shot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = char(datetime); % creat the name of the output files
% creat the default session name
filename=['SIGMA_main_' str(1:end-9) '_' str(end-7:end-6) str(end-4:end-3)...
    str(end-1:end) '.tif'];
imageData = screencapture(handles.learning_panel);

%image(imageData);axis off
full_filename=fullfile(handles.init_parameter.full_session_name,filename);
imwrite(imageData,full_filename)
figure; imshow(full_filename)


% --------------------------------------------------------------------
function FEM_open_folder_function_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_open_folder_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FEM_folder=fullfile(handles.init_parameter.sigma_directory,...
    'SIGMA_functions','features_extraction');
% winopen(FEM_folder);
if ispc
    winopen(FEM_folder);
end
if ismac
    macopen(FEM_folder);
end

% --------------------------------------------------------------------
function FR_open_ranking_method_mfile_Callback(hObject, eventdata, handles)
% hObject    handle to FR_open_ranking_method_mfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit('Sigma_ranking_methods.m');


% --------------------------------------------------------------------
function FR_rank_methods_Callback(hObject, eventdata, handles)
% hObject    handle to FR_rank_methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FR_open_document_other_method_Callback(hObject, eventdata, handles)
% hObject    handle to FR_open_document_other_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('add here the pdf file describing the FSL library')


% --------------------------------------------------------------------
function toolbar_export_to_matlab_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_export_to_matlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A_pb_see_workspace_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_load_EEG_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_load_EEG_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DL_path_push_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_load_custom_feature_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_load_custom_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FEM_pb_load_feature_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function toolbar_clear_session_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbar_clear_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A_pb_reset_parameter_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function menu_data_visualization_Callback(hObject, eventdata, handles)
% hObject    handle to menu_data_visualization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma_visualisating_data(handles);

function DP_suject_text_CreateFcn % do not delette, or corret the error if deleted


% --- Executes on button press in DC_pb_help_classification_method.
function DC_pb_help_classification_method_Callback(hObject, eventdata, handles)
% hObject    handle to DC_pb_help_classification_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%DC_CV_help_gui
text = fileread('help_data_classification.txt') ;
text_to_display = text;
name_of_gui = 'SIGMA Help : Data Classification';
data.text_to_display = text_to_display;
data.name_of_gui = name_of_gui;
Sigma_help_adaptive_gui(data)

% --- Executes on button press in FR_help_other_method_fsl.
function FR_help_other_method_fsl_Callback(hObject, eventdata, handles)
% hObject    handle to FR_help_other_method_fsl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('Readme_fslIB_11-2017.pdf');


% --------------------------------------------------------------------
function sigma_option_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_option_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function feature_ranking_menubar_main_Callback(hObject, eventdata, handles)
% hObject    handle to feature_ranking_menubar_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FR_pb_compute_FR_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function compute_ranking_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to compute_ranking_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FR_pb_compute_FR_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ranking_list_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to ranking_list_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FR_pb_display_FR_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function data_loading_menubar_main_Callback(hObject, eventdata, handles)
% hObject    handle to data_loading_menubar_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function run_classification_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DC_pb_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DC_pb_compute_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function display_result_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DC_pb_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DC_pb_display_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function select_model_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DC_select_best_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DC_select_best_model_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function apply_model_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DC_pb_apply_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DC_pb_apply_model_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function classification_method_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to classification_method_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function data_processing_menubar_main_Callback(hObject, eventdata, handles)
% hObject    handle to data_processing_menubar_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function feature_extraction_menubar_main_Callback(hObject, eventdata, handles)
% hObject    handle to feature_extraction_menubar_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_eeg_data_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to load_eeg_data_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DL_path_push_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function data_visualisation_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DL_pb_data_viz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DL_pb_data_viz_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function edit_frequency_band_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_frequency_band_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DP_pb_freq_band_edit_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function compute_feature_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to FEM_pb_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FEM_pb_compute_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function loead_feature_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to loead_feature_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FEM_pb_load_feature_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function add_cross_term_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to add_cross_term_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(hObject.Checked,'on')
    hObject.Checked = 'off';
else
    hObject.Checked = 'on';
end
guidata(hObject, handles);
FEM_add_cross_term_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function save_feature_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to save_feature_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FEM_save_feature_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function feature_distribution_3d_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to feature_distribution_3d_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FR_pb_3D_FR_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function select_subject_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to DL_pb_subject_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DL_pb_subject_select_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function remove_subject_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to remove_subject_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DP_pb_subject_remove_Callback(hObject, eventdata, handles)

function data_classification_menubar_main_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function cross_validation_method_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to cross_validation_method_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------




function lda_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to lda_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% set the menu bar
set(handles.lda_menubar,'Checked','on');
set(handles.qda_menubar,'Checked','off');
set(handles.svm_menubar,'Checked','off');

%% set the push button
set(handles.DC_rb_LDA,'Value',1);
set(handles.DC_rb_QDA,'Value',0);
set(handles.DC_rb_SVM,'Value',0);

handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);
% --------------------------------------------------------------------
function qda_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to qda_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set the menu bar
set(handles.lda_menubar,'Checked','off');
set(handles.qda_menubar,'Checked','on');
set(handles.svm_menubar,'Checked','off');

%% set the push button
set(handles.DC_rb_LDA,'Value',0);
set(handles.DC_rb_QDA,'Value',1);
set(handles.DC_rb_SVM,'Value',0);

handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);
% --------------------------------------------------------------------
function svm_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to svm_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set the menu bar
set(handles.lda_menubar,'Checked','off');
set(handles.qda_menubar,'Checked','off');
set(handles.svm_menubar,'Checked','on');

%% set the push button
set(handles.DC_rb_LDA,'Value',0);
set(handles.DC_rb_QDA,'Value',0);
set(handles.DC_rb_SVM,'Value',1);

handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);


% --------------------------------------------------------------------
function loso_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to loeo_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loso_menubar,'Checked','on');
set(handles.loeo_menubar,'Checked','off');

%% set the push button
set(handles.DC_cb_LOSO,'Value',1);
set(handles.DC_cb_LOEO,'Value',0);

handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

% --------------------------------------------------------------------
function loeo_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to loeo_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loso_menubar,'Checked','off');
set(handles.loeo_menubar,'Checked','on');

%% set the push button
set(handles.DC_cb_LOSO,'Value',0);
set(handles.DC_cb_LOEO,'Value',1);

handles = Update_classification_settings(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);


% --------------------------------------------------------------------
function ranking_results_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to ranking_results_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function feature_selection_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to feature_selection_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function set_number_feature_to_rank_Callback(hObject, eventdata, handles)
% hObject    handle to set_number_feature_to_rank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set the menu bar
set(handles.set_number_feature_to_rank,'Checked','on');
set(handles.set_probe_feature_to_rank,'Checked','off');

%% set the push button
set(handles.FR_rb_nb_feature,'Value',1);
set(handles.FR_rb_probe_variable,'Value',0);


% the value should be set from sub gui
%FR_edit_nb_feature


% Call the  edit gui
uiwait(input_number_feature);
nb_feature = getappdata(0,'nb_feature');
set(handles.FR_edit_nb_feature,'String', nb_feature);

handles = Update_feature_ranking(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

% --------------------------------------------------------------------
function set_probe_feature_to_rank_Callback(hObject, eventdata, handles)
% hObject    handle to set_probe_feature_to_rank (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set the menu bar
set(handles.set_number_feature_to_rank,'Checked','off');
set(handles.set_probe_feature_to_rank,'Checked','on');

%% set the push button
set(handles.FR_rb_nb_feature,'Value',0);
set(handles.FR_rb_probe_variable,'Value',1);

% the value should be set from sub gui
%
% Call the  edit gui
uiwait(input_probe_feature);
probe_feature = getappdata(0,'probe_feature');
set(handles.FR_edit_probability_probe,'String', probe_feature);

handles = Update_feature_ranking(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);


% --------------------------------------------------------------------
function ranking_method_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to ranking_method_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ofr_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to ofr_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ofr_menubar,'Checked','on');
set(handles.other_method_menubar,'Checked','off');

%% set the push button
set(handles.FR_rb_GS,'Value',1);
set(handles.FR_rb_other_adv_method,'Value',0);

handles = Update_feature_ranking(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

% --------------------------------------------------------------------
function other_method_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to other_method_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to ofr_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ofr_menubar,'Checked','off');
set(handles.other_method_menubar,'Checked','on');

%% set the push button
set(handles.FR_rb_GS,'Value',0);
set(handles.FR_rb_other_adv_method,'Value',1);

handles = Update_feature_ranking(handles, hObject);
Set_button_availability(handles, hObject)
guidata(hObject, handles);

%% Rajouter par Nessim le 28/06/2018
% --- Executes on button press in manual_selection.
function manual_selection_Callback(hObject, eventdata, handles)
% hObject    handle to manual_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Choose_operating_point(handles,hObject);
