function features_results=Spectral_pic_alpha(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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

o_spect_pic_alpha_ch=[];
temp0=[];

if (Nepochs==1)
    o_spect_pic_alpha_epo=[];
    if Nsubj==1
        features_results.o_spect_pic_alpha=[];
    end
end


apply_filter=init_parameter.apply_filter(Nmethode);


for l_channel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(l_channel,:,Nepochs);    
    if (apply_filter==1)
        for l_band=1:1
            %filt=init_parameter.filt_band_param;
            %fdata = filter(filt(l_band),i_EEG);            
            fdata = i_EEG;
            sampling_rate=s_EEG.sampling_rate;            
            
            c_welch_window = round(sampling_rate / 2);
            c_welch_recover = floor(sampling_rate / 4);
            alpha_freq = 7.5:0.05:12.5;
            [theta_alpha, frequency] = pwelch(fdata, ...
                c_welch_window, c_welch_recover, alpha_freq, sampling_rate);
            [peak_list, position_list] = findpeaks(theta_alpha);
            if ~isempty(position_list)
                alpha_frequency = frequency(position_list(1));
            else
                alpha_frequency = 0;
            end      
            
            o_spect_pic_alpha_value0 = alpha_frequency;            
            
            o_spect_pic_alpha_ch =[o_spect_pic_alpha_ch,o_spect_pic_alpha_value0];
            
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel 4] ;
            end
        end
    else
        sampling_rate=s_EEG.sampling_rate;
            c_welch_window = round(sampling_rate / 2);
            c_welch_recover = floor(sampling_rate / 4);
            alpha_freq = 7.5:0.05:12.5;
            [theta_alpha, frequency] = pwelch(i_EEG, ...
                c_welch_window, c_welch_recover, alpha_freq, sampling_rate);
            [peak_list, position_list] = findpeaks(theta_alpha);
            if ~isempty(position_list)
                alpha_frequency = frequency(position_list(1));
            else
                alpha_frequency = 0;
            end      
            
            o_spect_pic_alpha_value0 = alpha_frequency;         
        
        o_spect_pic_alpha_ch =[o_spect_pic_alpha_ch,o_spect_pic_alpha_value0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel  4] ;% 4 alpha band;
        end
    end
    
    clear o_spect_pic_alpha_value0
end
o_spect_pic_alpha_epo=o_spect_pic_alpha_ch';
features_results.o_spect_pic_alpha=[features_results.o_spect_pic_alpha o_spect_pic_alpha_epo];

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_spect_pic_alpha_band=temp0;
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
