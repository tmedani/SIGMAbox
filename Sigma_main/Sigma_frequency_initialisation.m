function os_init_parameter=Sigma_frequency_initialisation(is_init_parameter)
%%%------------------------------------------------------------------------
%   os_init_parameter=Sigma_frequency_initialisation(is_init_parameter)
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
%   init_method : structure containing the methods informations necessary
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
%   Sigma_diary_file.m
%   Sigma_define_freq_band.m
%   Sigma_freq_band_selection.m
%   Sigma_low_pass_filter_init.m
%   Sigma_high_pass_filter_init.m
%   Sigma_band_pass_filter_init.m
%   Sigma_notch_filter_init.m
%   Sigma_wavelet_init.m
%   Sigma_get_sampling_rate.m
%   Sigma_resampling_init.m

%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%%   Scripts task:
% This function initilize all the variable related to the frequecy studies
% It define the EEG bands (rythmes) and compute the parameters of the
% filters (pass band)
% It also allow the definition of the parameter of the low/band/high and
% notch filter and the wavelet





%% Writ the Diary file
Sigma_diary_file(is_init_parameter)
% Get information from the user data : should have the right format

%% 0- The frquency bounds (minimal and maximal)

if ~isfield(is_init_parameter,'filter_parameter')
    fmin = 0.1; % The minimum frequency for the EEG data
    fmax = 90; % The maximum frequency f the EEG data
    filter_order = 5; % the default value
else
    filter_parameter = is_init_parameter.filter_parameter;
    fmin = filter_parameter.fmin;
    fmax = filter_parameter.fmax;
    filter_order = filter_parameter.filter_order;
end

if ~isfield(is_init_parameter,'freq_bands')
[freq_bands, bands_list]  =  Sigma_define_freq_band(fmin,fmax);
fmin = min(min(freq_bands)); % The minimum frequency for the EEG data
fmax = max(max(freq_bands)); % The maximum frequency f the EEG data

is_init_parameter.freq_bands  =  freq_bands;
is_init_parameter.bands_list  =  bands_list;
end


% Temporary argument for the function Sigma_freq_band_selection
temp_arg.freq_bands = is_init_parameter.freq_bands;
temp_arg.filter_order = filter_order;
temp_arg.bands_list = is_init_parameter.bands_list;

disp('apply filter')
disp(is_init_parameter.apply_filter)


%% 1- The definition of the fraquency bands for the study
%(for the features extraction)
is_init_parameter  =  Sigma_freq_band_selection(is_init_parameter,temp_arg);
clear temp_arg


%% 2: Definition of the LowPass filter default value
if is_init_parameter.low_pass_filter == 1
    lowPass_freq = 200; % in Hz
    lowPass_order = 5;
    is_init_parameter = Sigma_low_pass_filter_init(is_init_parameter,...
        lowPass_freq,lowPass_order);
end
%% 3 : definition of HighPass filter default value
if is_init_parameter.high_pass_filter == 1
    highPass_freq = 0.1; % in Hz
    highPass_order = 5;
    is_init_parameter = Sigma_high_pass_filter_init(is_init_parameter,...
        highPass_freq,highPass_order);
end
%% 4: Definitnion of  Band Pass filter default value %% TODO
if is_init_parameter.band_pass_filter == 1
    bandPass_freq = 0.05; % in Hz
    bandPass_order = 5;
    is_init_parameter = Sigma_band_pass_filter_init(is_init_parameter,...
        highPass_freq,highPass_order);
end

%% 5: Definition of the Notch filter default value
if is_init_parameter.notch_filter == 1
    notch_freq = 50;
    notch_order = 5;
    notch_band_width = 1;
    is_init_parameter = Sigma_notch_filter_init(is_init_parameter,notch_freq,...
        notch_band_width,notch_order);
end



%% 6: Definition of wavelet Transform's parameters default
%%% TODO : initialize th wavlet from the init_method and not the inverse
%%% way
if is_init_parameter.wavelet_transform == 1
    wavelet_type = 'cmor2.0558-0.5874';
    minimal_frequency = fmin;
    maximal_frequency = fmax;
    step_frequency = 1;
    is_init_parameter = Sigma_wavelet_init(is_init_parameter,minimal_frequency,...
        maximal_frequency,step_frequency);
end

%% 7 : Get the sampling rate (from data, from the
%user or the default value )
%% Choose the value for the sampling rate:
%% The sampling rate is needed in this script, if it's not defined in the
% is_init_parameter by the default value, the data file will be loaded in this
% script and pick the used value from the data file
is_init_parameter = Sigma_get_sampling_rate(is_init_parameter);

%% 8 : Resampling the Data
if is_init_parameter.resample_data == 1
    is_init_parameter = Sigma_resampling_init(is_init_parameter);
    %% Acording to the value interpolate_data/downsample_data the data
    %will be traited during the process of loading...
end




%% ****************

%% OutPut of this script

%% Displaying the initializing parameters
if is_init_parameter.sigma_show_comment == 1
    display('===== Information : sigma_frequency_initialisation ==========')
    display(['0- You have selected the frquency bounds between '...
        num2str([fmin fmax]) 'Hz'])
    if sum(is_init_parameter.apply_filter)>0
        display(['1a- You have selected the following frquency bands  : ' ]);
        for ind = 1:length(is_init_parameter.selected_band)
            %display([ num2str(freq_bands(ind,1)) '   ' ...
            %    num2str(freq_bands(ind,2)) ' Hz' ])
            %               display( is_init_parameter.bands_list(ind,:))
        end
        
        display(['1c- You have selected the order of  ' num2str(filter_order)...
            ' for the pass-band filters (band extraction)'])
    end
    if is_init_parameter.low_pass_filter == 1
        display(' 2- You have selected the Low Pass Filter for your data');
        display(['2a- The associated frequency is' num2str(lowPass_freq)...
            ' and an order of ' num2str(lowPass_order)  ])
    end
    if is_init_parameter.high_pass_filter == 1
        display(' 3- You have selected the High Pass Filter for your data');
        display(['3a- The associated frequency is ' num2str(highPass_freq)...
            ' and an order of ' num2str(highPass_order)  ])
    end
    
    if is_init_parameter.band_pass_filter == 1
        display(' 4- You have selected the band Pass Filter for your data');
        display(['4a- The associated frequency is ' num2str(bandPass_freq)...
            ' and an order of ' num2str(bandPass_order)  ])
    end
    
    if is_init_parameter.notch_filter == 1
        display(' 5- You have selected the Notch Filter for your data');
        display(['5a- The associated frequency is ' num2str(notch_freq)...
            ' order of ' num2str(notch_order) ' width of ' num2str...
            (notch_band_width)  ])
    end
    
    if is_init_parameter.wavelet_transform == 1
        display(' 6- You have selected the Wavelets method');
        display(['6a- The associated frequency is ' num2str([fmin fmax])...
            '; type ' wavelet_type '; step frequency of ' ...
            num2str(step_frequency) ' Hz' ])
    end
    
    display(['==> Next Step : Run the Script Sigma_filter_parameter to'...
        'compute the frequency filters ..." '])
end


if is_init_parameter.sigma_write_logFile == 1;
    cd(is_init_parameter.sigma_directory)
    cd(is_init_parameter.data_output)
    mkdir(is_init_parameter.session_name)
    cd(is_init_parameter.session_name)
    logFilename = is_init_parameter.logFilename;
    fid  =  fopen(logFilename,'a');
    
    fprintf(fid,'\n %s','==== Information : sigma_frequency_initialisation===');
    fprintf(fid,'\n %s',['0- You have selected the frquency bounds between '...
        num2str([fmin fmax]);]);
    if sum(is_init_parameter.apply_filter)>0
        fprintf(fid,'\n %s',['1a- You have selected the following frquency bands  : ' ]);
        for ind = 1:length(is_init_parameter.selected_band)
            fprintf(fid,'\n %s',[ num2str(freq_bands(ind,1)) '   ' ...
                num2str(freq_bands(ind,2)) ' Hz' ]);
            %fprintf(fid,'\n %s', bands_list(ind,:));
        end
        
    end
    if is_init_parameter.low_pass_filter == 1
        fprintf(fid,'\n %s',' 2- You have selected the Low Pass Filter for your data');
        fprintf(fid,'\n %s',['2a- The associated frequency is' num2str(lowPass_freq)...
            ' and an order of ' num2str(lowPass_order)  ]);
    end
    if is_init_parameter.high_pass_filter == 1
        fprintf(fid,'\n %s',' 3- You have selected the High Pass Filter for your data');
        fprintf(fid,'\n %s',['3a- The associated frequency is' num2str(highPass_freq)....
            ' and an order of ' num2str(highPass_order)  ]);
    end
    
    if is_init_parameter.band_pass_filter == 1
        fprintf(fid,'\n %s',' 4- You have selected the band Pass Filter for your data');
        fprintf(fid,'\n %s',['4a- The associated frequency is' num2str(bandPass_freq)...
            ' and an order of ' num2str(bandPass_order)  ]);
    end
    
    if is_init_parameter.notch_filter == 1
        fprintf(fid,'\n %s',' 5- You have selected the Notch Filter for your data');
        fprintf(fid,'\n %s',['5a- The associated frequency is' num2str(notch_freq)...
            ' order of ' num2str(notch_order) ' width of ' num2str(notch_band_width)  ]);
    end
    
    if is_init_parameter.wavelet_transform == 1
        fprintf(fid,'\n %s',' 6- You have selected the Wavelets method');
        fprintf(fid,'\n %s',['6a- The associated frequency is' num2str([fmin fmax])...
            '; type ' wavelet_type '; step frequency of ' num2str(step_frequency) ' Hz' ]);
    end
    
    fprintf(fid,'\n %s',[' ==> Next Step : Run the Script Sigma_filter_parameter' ...
        ' to compute the frequency filters ..." ']);
    
    fclose(fid);
    cd(is_init_parameter.sigma_directory)
end


os_init_parameter=is_init_parameter;
%% Close the diary file
diary off
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
% % %
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------