function features_results=Spectral_fourier_power(init_parameter,init_method,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%  init_parameter = Sigma_parameter_initialisation(varargin)
%
%  Function task:
% This script comput the fractal dimension for each channels and epoches
%  Inputs :
%
%  Outputs :
%
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

Nmethode=1; % toujoue égale à 1 pour la méthdoe fourrier power

% Initialisation of the vectors
o_fourier_power_ch=[];
temp0=[];
%o_fourier_power_epo=nan(1*size(s_EEG.data,1)*length(init_method(1).band_start)*2,size(s_EEG.data,3)); % o_fourier_power_epo : matrice containing the fourier_power (absolute and relative) per channels size = 1*(Nb_Channel*Nb_Bandes*2)
if Nepochs==1
    o_fourier_power_epo=[]; % Initialisation of the vector
    if Nsubj==1
        features_results.o_fourier_power=[];
        fourier_power_type=[];
    end
end


sampling_rate=init_parameter.sampling_rate;
% s_EEG.data = rand(size(s_EEG.data)); %
% Comopute the fourier_power spectrum for each channel (over each epochs)

% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);
% Initialisation
%number_of_bands = length(init_method(Nmethode).band_start);
c_window=sampling_rate/init_method(Nmethode).pwelch_width; % length of the Hamming Windows
if (c_window > size(s_EEG.data,2)), 
    %if the signal length is below the window length
    c_window = size(s_EEG.data,2);
end

for l_channel=1:size(s_EEG.data,1)
    %display(['Channel N°: ' num2str(l_channel)])
    
    i_EEG=s_EEG.data(l_channel,:,Nepochs);
    
    %% Comput all the fourier_power on all bands
    min_frequency = min(init_method(Nmethode).band_start); %the minimum frequency in the range of interest
    max_frequency = max(init_method(Nmethode).band_end); %the maximum frequency in the range of interest
    frequency_step=init_method(Nmethode).frequency_step;
    
    [spectra,fr] = pwelch(i_EEG,c_window,[],min_frequency:frequency_step:max_frequency,sampling_rate);
    totalfourier_power = trapz(fr,spectra);
    
    %% Include the all fourier_power as a feature
    % this is used both to comput the total power in order to compute the relative power, and also used in the case of no specified band
    if (init_method(1).all_fourier_power==1) || (apply_filter==0)
        o_fourier_power_ch =[o_fourier_power_ch,totalfourier_power];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel 0];
            fourier_power_type=[fourier_power_type;0];
        end
    end
    %end
    %% Apply filter !
    if (apply_filter==1)
        for l_band=1:init_parameter.nb_bands
            % executed only from the Apply model
            if isfield(init_method(1),'index_band')
                index=init_method(1).index_band;
                l_band=index;
            end
            frequency_start=init_method(Nmethode).band_start(l_band);
            frequency_step=init_method(Nmethode).frequency_step;
            frequency_end=init_method(Nmethode).band_end(l_band);
            %display(['fourrier power in [' num2str(frequency_start) ' ' num2str(frequency_end) '] Hz' ])
            [spectra,fr] = pwelch(i_EEG,c_window,[],frequency_start:frequency_step:frequency_end,sampling_rate);
            
            
            o_fourier_power_abs = trapz(fr,spectra);
            o_fourier_power_ch =[o_fourier_power_ch,o_fourier_power_abs];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                if isfield(init_method(1),'index_band')
                    l_band=1;
                end
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band)];
                fourier_power_type=[fourier_power_type;1];
            end
            
            %% Computes relative fourier_power
            if init_method(Nmethode).relative == 1
                o_fourier_power_re = o_fourier_power_abs/totalfourier_power;
                o_fourier_power_ch =[o_fourier_power_ch,o_fourier_power_re];
                % Track the identification of the band
                if((Nsubj==1)&&(Nepochs==1))
                    temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band)];
                    fourier_power_type=[fourier_power_type;2];
                end
            end
        end
    else
        
        
        
        
    end
    
end

o_fourier_power_epo=o_fourier_power_ch';
features_results.o_fourier_power=[features_results.o_fourier_power o_fourier_power_epo];
%features_results.o_fourier_power=o_fourier_power;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_fourier_power_band=temp0;
    features_results.o_fourier_power_band_infos={'N° Method','N° Channel','N° band'};
    features_results.o_fourier_power_type=fourier_power_type;
    features_results.o_fourier_power_type_infos={'0 : all bands, ';'1 : absolute, ';'2 : relative, '};
    features_results.o_fourier_power_band;
end

end


%% this script stores the data as follow :
% Subjects : |---------------------Subject 1 -----------------------||---------------------Subject 2 ------------- ...
% channels : |   ch1    |   ch2    |   ch3    |   ...    |   chN    ||   ch1    |   ch2    |   ch3    |   ...    |   chN    |
% fourier_power    : |Abs   rela|Abs   rela|Abs   rela|   ...    |Abs   rela||Abs   rela|Abs   rela|Abs   rela|   ...    |Abs   rela|



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
% % %   Creation Date : 21/10/2016
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
