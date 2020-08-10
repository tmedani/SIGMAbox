function features_results=Spectral_amplitude_mean(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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

o_spect_amp_mean_ch=[];
temp0=[];

if (Nepochs==1)
    o_spect_amp_mean_epo=[];
    if Nsubj==1
        features_results.o_spect_amp_mean=[];
    end
end


apply_filter=init_parameter.apply_filter(Nmethode);


for l_channel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(l_channel,:,Nepochs);
    
    if (apply_filter==1)
        for l_band=1:init_parameter.nb_bands
            filt=init_parameter.filt_band_param;
            fdata = filter(filt(l_band),i_EEG);
            
            o_spect_amp_mean_value0 = mean(abs(fft(fdata)));
            o_spect_amp_mean_ch =[o_spect_amp_mean_ch,o_spect_amp_mean_value0];
            
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        o_spect_amp_mean_value0 = mean(abs(fft(i_EEG)));
        o_spect_amp_mean_ch =[o_spect_amp_mean_ch,o_spect_amp_mean_value0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    % o_spect_amp_mean_value0=mean(abs(spect(i_EEG)));
    % o_spect_amp_mean_ch =[o_spect_amp_mean_ch,o_spect_amp_mean_value0];
    
    clear o_spect_amp_mean_value0
end
o_spect_amp_mean_epo=o_spect_amp_mean_ch';
features_results.o_spect_amp_mean=[features_results.o_spect_amp_mean o_spect_amp_mean_epo];

%features_results.o_spect_amp_mean=o_spect_amp_mean;


if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_spect_amp_mean_band=temp0;
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
% % %   Creation Date : 03/11/2016
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
