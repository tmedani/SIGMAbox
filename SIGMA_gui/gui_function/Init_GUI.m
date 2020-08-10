function handles = Init_GUI(handles, hObject)


% if not canceled
if handles.session_canceled==1
    disp('Session will be closed')
else
    %Set unitis to normalized
    % set(handles.main_gui_sigma,'units', 'normalized');
    % get gui position
    % gui_position = get(handles.main_gui_sigma,'position');
    
    % set(handles.learning_panel,'units', 'normalized');  % position de l'ensemble incluant le panel
    % gui_position=get(handles.learning_panel,'position');  % position de l'ensemble incluant le panel
    
    %set(gcf, 'units', 'normalized')
    %figure_position=get(gcf, 'position');
    %set(gcf, 'units', 'normalized', 'position', [0.2 0.2 0.7 0.6]) % postion [x y w h]
    %set(handles.main_gui_sigma,'position', [0 0 gui_position(3) gui_position(4)]) % postion [x y w h]
    
    
    %handles.color = { [255, 230, 230 ]/255, [ 255, 204, 153]/255, [204, 255, 229]/255 };
    %handles.method_color = { 'Beige', 'GreenYellow', 'LightCyan', 'Pink', 'PeachPuff' };
    % test wavelet methods

    %Add frequency band button name list
    frequency_button_name = {'DP_delta', 'DP_theta', 'DP_mu', 'DP_alpha', 'DP_beta', 'DP_gamma', 'DP_gamma_high', 'DP_total_bandwidth', 'DP_custom', 'DP_all'};
    handles.frequency_button_name = frequency_button_name;
    handles.init_parameter.frequency_button_name = frequency_button_name;
    
    
    % Launch the fequency script
    handles.init_parameter = Sigma_frequency_initialisation(handles.init_parameter);
    
    
    % Set frequency band values in GUI from init_parameter values
    handles = DP_set_frequency_band_GUI(handles, hObject);
    
    % initialize methods
    handles.selected_method = [];
    % initialize the button cross term to zeros
    handles.init_parameter.compute_cross_term_feature=0;

    % initialise classification and feature ranking method
    handles.init_parameter.adv_ranking_method = 'relieff';
    % Takfarinas modification
    %handles.init_parameter.adv_ranking_method = 'Not selected';
    
    handles = Update_feature_ranking(handles, hObject);
    handles.selected_model = [];
    
    % set the reference structure of the decision of recomputing features after
    % classification
    handles.computed.subject = handles.init_parameter.subject;
    handles.computed.freq_band = handles.init_parameter.selected_band;
    handles.computed.init_method = handles.init_method;
    handles.computed.threshold_probe = handles.init_parameter.threshold_probe;
    handles.computed.nb_features = handles.init_parameter.nb_features;
    
    % initialize button state
    Initialize_buttons(handles, hObject)
    Set_button_availability(handles, hObject)
    
   
guidata(hObject, handles);


end