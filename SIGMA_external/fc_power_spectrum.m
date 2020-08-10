function [o_power, power_type] = fc_power_spectrum(i_EEG,init_method,sampling_rate)
%%%------------------------------------------------------------------------
%   Function task:
%   Computes the power at different bands using pwelch PSD estimate 
%
%   Inputs
%           i_EEG                   input EEG data, single channel, single epoch
%           init_method.band_start        vector specifying the beginning of each band
%           init_method.band_end          vector specifying the end of each band)
%           init_method.freq_jump         density of the PSD
%           init_method.relative          Whether we want to compute as well relative power
%           init_method.pwelch_window     parameter of the pwelch function
%           sampling_rate
%
%   Outputs
%           Vector containing the power associated for each band 
%
%   Used global variables
%       init_method
%
%--------------------------------------------------------------------------
%
%   Sections :
%      None
%
%   Main Variables
%       None
%
%   Dependencies
%       
%
%   NB: this code is copyrighted. 
%   Please refer to copyright info in the file footer.
%%------------------------------------------------------------------------

% Initialisation
number_of_bands = length(init_method.band_start);
c_window=sampling_rate/init_method.pwelch_width; % length of the Hamming Windows

if init_method.relative == 1; % allocates feature vector
o_power = NaN(1,2*number_of_bands); 
power_type= NaN(1,2*number_of_bands);
else
o_power = NaN(1,number_of_bands); 
power_type= NaN(1,2*number_of_bands);
end

%% Section 1 - Computes absolute power per band

%display('Compute the absolute power ...')
for l_band = 1:number_of_bands;
[spectra,fr] = pwelch(i_EEG,c_window,[],init_method.band_start(l_band):init_method.frequency_step:init_method.band_end(l_band),sampling_rate);
o_power(l_band) = trapz(fr,spectra);
power_type(l_band)=1;% absolute
end


%% Section 2 -  Computes relative power per band
%display('Compute the relative power ...')
if init_method.relative == 1;  
%computes total power in the range of interest

min_frequency = min(init_method.band_start); %the minimum frequency in the range of interest
max_frequency = max(init_method.band_end); %the maximum frequency in the range of interest


[spectra,fr] = pwelch(i_EEG,c_window,[],min_frequency:init_method.frequency_step:max_frequency,sampling_rate);
totalPower = trapz(fr,spectra);

% for online tests, the above code can be optimized computing only the
% total power and then integrating per band 

% computes relative power
o_power(number_of_bands + 1 : end) = o_power(1:number_of_bands)/totalPower;
power_type(number_of_bands + 1 : end)=2;

end
end

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
% % %   File added by Aldo MORA
% % %   Creation Date : 18/10/2016
% % %   Updates and contributors : 
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
