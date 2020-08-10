function os_init_method = Sigma_method_initialisation(is_init_parameter)
%%%------------------------------------------------------------------------
%   os_init_method = Sigma_method_initialisation(is_init_parameter)
%
%   Function task:
%   Determine and set the the initial parameters of the method
%   used for the feature extraction
%
%   Inputs :
%   is_init_parameter : structure containing the initial parameters of SIGMA
%
%   Outputs :
%
%  os_init_method : structure containing the methods informations necessary
%   for SIGMA
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%   is_init_parameter
%
%
%   Dependencies 
%   
%
%
% Template for adding new methods 
%** specify the number of the method
% method_number = method_number; 
%%% specify the name of the method
%os_init_method(method_number).method_name = 'synchro_not_implemented'; 
%%% specify the name of the output varibale of the method
%os_init_method(method_number).method_out = 'synchro_not_implemented';
%%% specify the name of the associated function for this method
%os_init_method(method_number).fc_method_name = 'synchro_not_implemented';
%%% Specify the number of the method
%os_init_method(method_number).method_number = method_number;
%%% Specify the type of the method
%os_init_method(method_number).method_type = 'Synchro';
%%% Specification for the color on the list box (color on the list box)
% Index  =  find(strcmp(method_types,os_init_method(method_number).method_type));
%os_init_method(method_number).method_color = method_colors{Index};
% method_colored = ['<html><FONT color = ' ...
%    os_init_method(method_number).method_color '>' ...
%    os_init_method(method_number).method_name...
%     '</Font></html>'];
%os_init_method(method_number).method_color_html = method_colored;
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


%%   Scripts task:
%   User can add/modify the data in this file
%   This file contains the description of the parametres which are used in
%   the script "Compute_feature"





% The features axtractions' methodes are listed following this order:
%% LISTE OF METHODS
%TODO : Please  insert here the full list of functions
% refers to : 
%http://undocumentedmatlab.com/blog/html-support-in-matlab-uicomponents
% for the HTML code
% htm colors: https://html-color-codes.info/color-names/
% TODO : to add context menu to the listbox of method :
% refers to this : 
%https://undocumentedmatlab.com/blog/setting-listbox-mouse-actions
% TODO : specified contex menu for each method : refers to : 
%   https://undocumentedmatlab.com/blog/setting-listbox-mouse-actions
method_types = {'Time','Wavelet','Spect','Synchro','Custom','Random'};
method_colors = {'"blue"','"green"','"red"','"Maroon"','"gray"',...
                                '"orange"'};


%% 1  =  = > Method 1 : power_spectrum  =  = > 
% Compute the Fourrier Power in the frequency bands defined by the user
method_number = 1;
os_init_method(method_number).method_name = 'spect_fourier_power';
os_init_method(method_number).method_out = 'o_fourier_power';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
os_init_method(method_number).fc_method_name = 'Spectral_fourier_power';

Index  =  strcmp(method_types,os_init_method(method_number).method_type);

os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;
% left frequency point (left limit band)
%os_init_method(method_number).band_start = [1 4 8 12 20 30 55]; 
% right frequency point (right limit band)
%os_init_method(method_number).band_end = [4 8 12 20 30 45 90]; 
% left frequency point (left limit band)
%os_init_method(method_number).band_start = [1 4 8 12 20 30 55 105];
% right frequency point (right limit band)
%os_init_method(method_number).band_end = [4 8 12 20 30 45 95 145]; 
% left frequency point (left limit band)

os_init_method(method_number).band_start = ...
    is_init_parameter.selected_freq_bands(:,1); 
% right frequency point (right limit band)
os_init_method(method_number).band_end = ...
    is_init_parameter.selected_freq_bands(:,2); 
os_init_method(method_number).nb_of_bands = ...
    length(os_init_method(method_number).band_end);
% step of the power integration for the frequency
os_init_method(method_number).frequency_step  =  1;
% 1 for yes and 0 for no to compute the relative power
os_init_method(method_number).relative =  1;
% 1 for yes and 0 for no, iclude all power as a features
os_init_method(method_number).all_fourier_power = 0;
% the width of the widows will be defined by : 
%   c_window = sampling_rate/pwelch_width
os_init_method(method_number).pwelch_width  =  2; 


%% 2  ===> Method 2 : Fractal dimension  ===> 
%   Compute the fractale dimension for each EEG channel
method_number = 2;
os_init_method(method_number).method_name = 'time_fractal_katz';
os_init_method(method_number).method_out = 'o_time_fractal_katz';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
os_init_method(method_number).fc_method_name = 'Time_fd_katz';
Index  =  strcmp(method_types,os_init_method(method_number).method_type);
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 3  ===>Method 3 : Sample Entropy
method_number = 3;
os_init_method(method_number).method_name = 'time_sample_entropy';
os_init_method(method_number).method_out = 'o_time_sample_entropy';
os_init_method(method_number).fc_method_name = 'Time_sample_entropy';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
os_init_method(method_number).dimension = 3; % embedded dimension
% delay time for downsampling (user can omit this, 
%   in which case the default value is 1)
os_init_method(method_number).tau = 6; % tau : 
%  tolerance (typically 0.2 * std)
os_init_method(method_number).tolerance  =  0.2; 
%% 4  ===> Method 4 : mean value
method_number = 4;
os_init_method(method_number).method_name = 'time_mean';
os_init_method(method_number).method_out = 'o_time_mean';
os_init_method(method_number).fc_method_name = 'Time_mean';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';

Index  =  strcmp(method_types,os_init_method(method_number).method_type);
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 5  ===> Method 5 : energy time domain
method_number = 5;
os_init_method(method_number).method_name = 'time_energy';
os_init_method(method_number).method_out = 'o_time_energy';
os_init_method(method_number).fc_method_name = 'Time_energy';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index = find(strcmp(method_types,os_init_method(...
    method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 6  ===> Method 6 : Kurtisis
method_number = 6;
os_init_method(method_number).method_name = 'time_kurtosis';
os_init_method(method_number).method_out = 'o_time_kurtosis';
os_init_method(method_number).fc_method_name = 'Time_kurtosis';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 7  ===> Method 7 : Skewness
method_number = 7;
os_init_method(method_number).method_name = 'time_skewness';
os_init_method(method_number).method_out = 'o_time_skewness';
os_init_method(method_number).fc_method_name = 'Time_skewness';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types,os_init_method...
    (method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 8  ===> Method 8 : minmax : compteur de faible pente
method_number = 8;
os_init_method((method_number)).method_name = 'time_low_slope';
os_init_method((method_number)).method_out = 'o_time_low_slope';
os_init_method((method_number)).fc_method_name = 'Time_low_slope';
os_init_method((method_number)).method_number = (method_number);
os_init_method(method_number).method_type = 'Time';
% refers to the page 15 to the report of Fong NGO
os_init_method((method_number)).epsilon = 0.1; 
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 9  ===> Method 9 : slop signe change !!
method_number = 9;
os_init_method((method_number)).method_name = 'time_slope_change';
os_init_method((method_number)).method_out = 'o_time_slope_change';
os_init_method((method_number)).fc_method_name = 'Time_slope_change';
os_init_method((method_number)).method_number = (method_number);
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 10  ===> Method 10 : Wave length
method_number = 10;
os_init_method((method_number)).method_name = 'time_wavelength';
os_init_method((method_number)).method_out = 'o_time_wavelength';
os_init_method((method_number)).fc_method_name = 'Time_wavelength';
os_init_method((method_number)).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 11  ===> Method 11 : MASV
method_number = 11;
os_init_method((method_number)).method_name = 'time_msav';
os_init_method((method_number)).method_out = 'o_time_msav';
os_init_method((method_number)).fc_method_name = 'Time_msav';
os_init_method((method_number)).method_number = (method_number);
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% Hilbert Transform & Enveloppe features
%% 12  ===> Method 12 :  mean  enveleoppe
method_number = 12;
os_init_method(method_number).method_name = 'time_enveloppe_mean';
os_init_method(method_number).method_out = 'o_time_enveloppe_mean';
os_init_method(method_number).fc_method_name = 'Time_enveloppe_mean';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type)); 
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 13  ===> Method 13 :  standard devatiation enveleoppe
method_number = 13;
os_init_method((method_number)).method_name = 'time_enveloppe_std';
os_init_method((method_number)).fc_method_name = 'Time_enveloppe_std';
os_init_method((method_number)).method_out = 'o_time_enveloppe_std';
os_init_method((method_number)).method_number = (method_number);
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 14  ===> Method 14 :  kurtosis devatiation enveleoppe
method_number = 14;
os_init_method(method_number).method_name = 'time_enveloppe_kurtosis';
os_init_method(method_number).fc_method_name = 'Time_enveloppe_kurtosis';
os_init_method(method_number).method_out = 'o_time_enveloppe_kurtosis';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 15  ===> Method 15 :  variance enveleoppe
method_number = 15;
os_init_method(method_number).method_name = 'time_enveloppe_var';
os_init_method(method_number).fc_method_name = 'Time_enveloppe_var';
os_init_method(method_number).method_out = 'o_time_enveloppe_var';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 16  ===> Method 16 :  skewness devatiation enveleoppe
method_number = 16;
os_init_method(method_number).method_name = 'time_enveloppe_skewness';
os_init_method(method_number).fc_method_name = 'Time_enveloppe_skewness';
os_init_method(method_number).method_out = 'o_time_enveloppe_skewness';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;



%% 17  ===> Method 17 : Zero Crossing
method_number = 17;
os_init_method(method_number).method_name = 'time_zero_crossing';
os_init_method(method_number).method_out = 'o_time_zero_crossing';
os_init_method(method_number).fc_method_name = 'Time_zero_crossing';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 18  ===> Method 18 : slope_signe_change_cpt
method_number = 18;
os_init_method(method_number).method_name = 'time_slope_signe_change';
os_init_method(method_number).method_out = 'o_time_slope_signe_change';
os_init_method(method_number).fc_method_name = 'Time_slope_signe_change';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 19  ===> Method 19 : entropy time domaine
%Problème rencontrer lors de l'aplication de la méthode en données test
method_number = 19;
os_init_method(method_number).method_name = 'time_gonzalez_entropy';
os_init_method(method_number).method_out = 'o_time_gonzalez_entropy';
os_init_method(method_number).fc_method_name = 'Time_gonzalez_entropy';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 20  ===> Method 20 :
method_number = 20;
os_init_method(method_number).method_name = 'time_variance';
os_init_method(method_number).method_out = 'o_time_variance';
os_init_method(method_number).fc_method_name = 'Time_variance';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 21  ===> Method 21 : fractal_dimension
method_number = 21;
os_init_method(method_number).method_name = 'time_fractal_higuchi';
os_init_method(method_number).method_out = 'o_time_fractal_higuchi';
os_init_method(method_number).fc_method_name = 'Time_fd_higuchi';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 22  ===> Method 22 : 
%   fractal_dimension () pblem d execution faut verifier le code
method_number = 22;
os_init_method(method_number).method_name = 'time_fractal_haussdorf';
os_init_method(method_number).method_out = 'o_time_fractal_haussdorf';
os_init_method(method_number).fc_method_name = 'Time_fd_haussdorf';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 23  ===> Method 23 : mean_time_between_oscillation
method_number = 23;
os_init_method(method_number).method_name = 'time_mean_time_bo';
os_init_method(method_number).method_out = 'o_time_mean_time_bo';
os_init_method(method_number).fc_method_name = 'Time_mean_time_bo';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 24  ===> Method 24 : mean_apmlitude_between_oscillation
method_number = 24;
os_init_method(method_number).method_name = 'time_mean_amp_bo';
os_init_method(method_number).method_out = 'o_time_mean_amp_bo';
os_init_method(method_number).fc_method_name = 'Time_mean_amp_bo';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index  =  find(strcmp(method_types, ...
   os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% THE METHODS FROM 25 to 35 are reserved for the wavelet transform's methods
%% 25  ===> Method 25 : wavelet transform
% The wavelet methods methods should be added soon, the two availablees
% are running coorectly under Script, just add the correspendaing function
% à mettre ailleurs is_init_parameter.wavelet_transform = 1;
if is_init_parameter.wavelet_transform == 1
    method_number = 25;
   os_init_method(method_number).method_name = 'wavelet_transform';
   os_init_method(method_number).method_out = 'o_wavelet_transform';
   os_init_method(method_number).fc_method_name = 'Sigma_wavelet_transform';
   os_init_method(method_number).method_number = method_number;
   os_init_method(method_number).method_type = 'Wavelet';
    
   os_init_method(method_number).wavelet_type = ...
        is_init_parameter.wavelet_transform_param.wavelet_type ;
    % Cwt  =  'cmor2.0558-0.5874'; Best Value that françois get for EEG signal
    
    %os_init_method(method_number).minimal_frequency = ...
    %²²min(is_init_parameter.selectd_freq_bands(:,1));% Min  =  minimal frequency
    % Min  =  minimal frequency
   os_init_method(method_number).minimal_frequency =  ...
        is_init_parameter.wavelet_transform_param.minimal_frequency;
   
    % Max  =  maximal frequency
   os_init_method(method_number).maximal_frequency =  ...
        is_init_parameter.wavelet_transform_param.maximal_frequency;
    %FreqEch  =  sampling rate  ==  ====> This value will be getted from the data
   os_init_method(method_number).sampling_rate =  ...
        is_init_parameter.sampling_rate ; 
    % frqsmp  =  step in frequencies between Min and Max 
    % (use 1 for linear spacing as a recommandation of françois)
   os_init_method(method_number).step_frequency = ...
        is_init_parameter.wavelet_transform_param.step_frequency;
    % list of the reserved methods for the wavelet transform, 
    %if you add more methods you should specify it in this line
   os_init_method(method_number).wt_method_list = [26:35]; 
    
    Index = find(strcmp(method_types,os_init_method...
        (method_number).method_type));
   os_init_method(method_number).method_color = method_colors{Index};
    method_colored = ['<HTML><BODY bgcolor = "#FF00FF"><FONT size = "large">'...
       os_init_method(method_number).method_name...
        '</FONT></html>'];
   os_init_method(method_number).method_color_html = method_colored;
    
%     
%os_init_method(method_number).band_start = is_init_parameter.selected_freq_bands(:,1); % left frequency point (left limit band)
%os_init_method(method_number).band_end = is_init_parameter.selected_freq_bands(:,2); % right frequency point (right limit band)
%os_init_method(method_number).nb_of_bands = length(os_init_method(method_number).band_end);
%os_init_method(method_number).frequency_step  =  1; % step of the power integration for the frequency
%os_init_method(method_number).relative =  1;% 1 for yes and 0 for no to compute the relative power
%os_init_method(method_number).all_fourier_power = 0;% 1 for yes and 0 for no, iclude all power as a features
%os_init_method(method_number).pwelch_width  =  2; % the width of the widows will be defined by : c_window = sampling_rate/pwelch_width
% 
    
    
end
%% 26  == > Method 26 : wavelet kurtosis
method_number = 26;
os_init_method(method_number).method_name = 'wt_kurtosis';
os_init_method(method_number).method_out = 'o_wt_kurtosis';
os_init_method(method_number).fc_method_name = 'Sigma_wavelet_transform';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 27  == > Method 27 :  wavelet standard deviations
method_number = 27;
os_init_method(method_number).method_name = 'wt_std';
os_init_method(method_number).method_out = 'o_wt_std';
os_init_method(method_number).fc_method_name = 'Sigma_wavelet_transform';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

% methods will be added by François (bosses, ....)
%% 28  == > Method 28 :  wavelet standard deviations
method_number = 27;
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 29  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 30  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 31  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 32  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 33  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 34  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 35  == > Method 28 :  wavelet standard deviations
method_number = method_number+1;
os_init_method(method_number).method_name = 'wt_not_implemented';
os_init_method(method_number).method_out = 'wt_not_implemented';
os_init_method(method_number).fc_method_name = 'wt_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Wavelet';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% THE METHODS FROM 36 to 50 are reserved for the fourrier transform methods

%% 36  == > Method 36 : mean of norm fft
method_number = 35;
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_amp_mean';
os_init_method(method_number).method_out = 'o_spect_amp_mean';
os_init_method(method_number).fc_method_name = 'Spectral_amplitude_mean';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';

Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};

method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 37  == > Method 37 : std_deviation_fft
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_amp_std';
os_init_method(method_number).method_out = 'o_spect_amp_std';
os_init_method(method_number).fc_method_name = 'Spectral_amplitude_std';
os_init_method(method_number).method_number = 37;
os_init_method(method_number).method_type = 'Spect';

Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 38  == > Method 38 : variance spect
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_amp_var';
os_init_method(method_number).method_out = 'o_spect_amp_var';
os_init_method(method_number).fc_method_name = 'Spectral_amplitude_var';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 39  == > Method 39 : Spectral flatnaess ( Wiener entropy)
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_flatness';
os_init_method(method_number).method_out = 'o_spectral_flatness';
os_init_method(method_number).fc_method_name = 'Spectral_flatness_Wiener';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% new methods will be added here
method_number = 39;
%% 40  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_power_entropy';
os_init_method(method_number).method_out = 'o_spect_power_antropy';
os_init_method(method_number).fc_method_name = 'Spectral_power_entropy';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 41  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_pic_alpha';
os_init_method(method_number).method_out = 'o_spect_pic_alpha';
os_init_method(method_number).fc_method_name = 'Spectral_pic_alpha';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 42  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_ratio_theta_beta';
os_init_method(method_number).method_out = 'o_ratio_theta_beta';
os_init_method(method_number).fc_method_name = 'Spectral_ratio_theta_beta';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 43  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 44  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 45  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 46  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 47  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 48  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 49  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'spect_not_implemented';
os_init_method(method_number).method_out = 'spect_not_implemented';
os_init_method(method_number).fc_method_name = 'spect_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Spect';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 50  == > Method
method_number = 50;
os_init_method(method_number).method_name = 'time_zero_crossing_rate';
os_init_method(method_number).method_out = 'o_time_zero_crossing_rate';
os_init_method(method_number).fc_method_name = 'Time_zero_crossing_rate';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Time';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% THE METHODS FROM 51 to 70 are reserved for the synchronisation methods

%% 51  == > Method 51 : RDM % mesure de topographie
method_number = 50;
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_rdm';
os_init_method(method_number).method_out = 'o_synchro_time_rdm';
os_init_method(method_number).fc_method_name = 'Synchro_time_rdm';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 52  == > Method 52 : MAG
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_mag';
os_init_method(method_number).method_out = 'o_synchro_time_mag';
os_init_method(method_number).fc_method_name = 'Synchro_time_mag';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 53  == > Method 53 : Mean Difference between the amplitudes
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_diff';
os_init_method(method_number).method_out = 'o_synchro_time_diff';
os_init_method(method_number).fc_method_name = 'Synchro_time_diff';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 54  == > Method 54 : EMAX voir thèse T MEDANI
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_emax';
os_init_method(method_number).method_out = 'o_synchro_time_emax';
os_init_method(method_number).fc_method_name = 'Synchro_time_emax';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 55  == > Method 55 : Correlation voir thèse T MEDANI
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_corr';
os_init_method(method_number).method_out = 'o_synchro_time_corr';
os_init_method(method_number).fc_method_name = 'Synchro_time_corr';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 56  == > Method 56 : corr type spermann
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_corr_spearman';
os_init_method(method_number).method_out = 'o_synchro_time_corr_spearman';
os_init_method(method_number).fc_method_name = 'Synchro_time_corr_spearman';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;



%% 57  == > Method 57 : corr  kendall
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_corr_kendall';
os_init_method(method_number).method_out = 'o_synchro_time_corr_kendall';
os_init_method(method_number).fc_method_name = 'Synchro_time_corr_kendall';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 58  == > Method 58 : cross correlation valeur moyenne
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_cross_corr';
os_init_method(method_number).method_out = 'o_synchro_time_cross_corr';
os_init_method(method_number).fc_method_name = 'Synchro_time_cross_corr';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 59  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_covariance';
os_init_method(method_number).method_out = 'o_synchro_time_covariance';
os_init_method(method_number).fc_method_name = 'Synchro_time_covariance';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 60  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_time_cronbach_alpha';
os_init_method(method_number).method_out = 'o_synchro_time_cronbach_alpha';
os_init_method(method_number).fc_method_name = 'Synchro_time_cronbach_alpha';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 61  == > Method
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_not_implemented';
os_init_method(method_number).method_out = 'synchro_not_implemented';
os_init_method(method_number).fc_method_name = 'synchro_not_implemented';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;


%% 60  == > Method 60 : Synchro_phase_locking_value
method_number = method_number+1;
os_init_method(method_number).method_name = 'synchro_phase_locking';
os_init_method(method_number).method_out = 'o_synchro_phase_locking';
os_init_method(method_number).fc_method_name = 'Synchro_phase_locking_value';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

% 61  == > Method 61 : Synchro_phase_index_value
method_number = method_number+1;;
os_init_method(method_number).method_name = 'synchro_phase_index';
os_init_method(method_number).method_out = 'o_synchro_phase_index';
os_init_method(method_number).fc_method_name = 'Synchro_phase_index_value';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;
% 62  == > Method 62 : Synchro_phase_index_value
method_number = method_number+1;;
os_init_method(method_number).method_name = 'synchro_phase_index2';
os_init_method(method_number).method_out = 'o_synchro_phase_index2';
os_init_method(method_number).fc_method_name = 'Synchro_phase_index2_value';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Synchro';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;
%
for ind = method_number:100
    method_number = method_number+1;
   os_init_method(method_number).method_name = 'method_not_implemented';
   os_init_method(method_number).method_out = 'method_not_implemented';
   os_init_method(method_number).fc_method_name = 'method_not_implemented';
   os_init_method(method_number).method_number = method_number;
   os_init_method(method_number).method_type = 'Not_implemented';
   os_init_method(method_number).method_color = '"black"';
    method_colored = ['<html><FONT color = ' ...
       os_init_method(method_number).method_color '>' ...
       os_init_method(method_number).method_name...
        '</Font></html>'];
   os_init_method(method_number).method_color_html = method_colored;
    
end
%% ************** Method added by Joeffrey, should be valideted
%
% %% 62  == > Method 62 : Synchro_phase_index_value
%os_init_method(62).method_name = 'Synchro_amp_max_coh';
%os_init_method(62).method_out = 'o_synchro_amp_max_coh';
%os_init_method(62).fc_method_name = 'Synchro_amp_max_coh';
%os_init_method(62).method_number = 62;
%
%
% %% 63  == > Method 63 : Synchro_phase_index_value
%os_init_method(63).method_name = 'Synchro_amp_max_freq_coh';
%os_init_method(63).method_out = 'o_synchro_amp_max_freq_coh';
%os_init_method(63).fc_method_name = 'Synchro_amp_max_freq_coh';
%os_init_method(63).method_number = 63;
%% 98  == > Method 98 : cusom feature loaded from the subject s_EEG
method_number = 98;
os_init_method(method_number).method_name = 'custom_feature_subject';
os_init_method(method_number).method_out = 'o_custom_feature_subject';
os_init_method(method_number).fc_method_name = 'Custom_feature_subject';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Custom';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
% method_colored = ['<html><FONT color = ' ...
%                os_init_method(method_number).method_color '>' ...
%                os_init_method(method_number).method_name...
%                 '</Font></html>'];
method_colored = ['<HTML><BODY bgcolor = "#FF00FF"><FONT size = "medium">'...
   os_init_method(method_number).method_name...
    '</FONT> </html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 99  == > Method 99 : custom feature from data/independat file
method_number = 99;
os_init_method(method_number).method_name = 'custom_feature_data';
os_init_method(method_number).method_out = 'o_custom_feature_data';
os_init_method(method_number).fc_method_name = 'Custom_feature_data';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Custom';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
% method_colored = ['<html><FONT color = ' ...
%                os_init_method(method_number).method_color '>' ...
%                os_init_method(method_number).method_name...
%                 '</Font></html>'];
method_colored = ['<HTML><BODY bgcolor = "#FF00FF"><FONT size = "medium">'...
   os_init_method(method_number).method_name...
    '</FONT> </html>'];
os_init_method(method_number).method_color_html = method_colored;
%% 100  == > Method 100 : random_noise_features_1
method_number = 100;
os_init_method(method_number).method_name = 'random_noise_features_1';
os_init_method(method_number).method_out = 'o_random_noise_features_1';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Random';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index};
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

%% 200  == > Method 200 : random_noise_features_2
method_number = 101;
os_init_method(method_number).method_name = 'random_noise_features_2';
os_init_method(method_number).method_out = 'o_random_noise_features_2';
os_init_method(method_number).method_number = method_number;
os_init_method(method_number).method_type = 'Random';
Index = find(strcmp(method_types,os_init_method(method_number).method_type));
os_init_method(method_number).method_color = method_colors{Index}; %#ok<*FNDSB>
method_colored = ['<html><FONT color = ' ...
   os_init_method(method_number).method_color '>' ...
   os_init_method(method_number).method_name...
    '</Font></html>'];
os_init_method(method_number).method_color_html = method_colored;

end

%%
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
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 10/10/2016
% % %   Updates and contributors :
% % %   29/01/2018, T. MEDANI :
% % %   Update the content of theos_init_method in order to change the color
% % %   of method in the list box of the GUI
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
