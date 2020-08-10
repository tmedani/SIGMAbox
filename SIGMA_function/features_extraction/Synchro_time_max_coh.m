function features_results=Synchro_time_max_coh(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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
o_synchro_amp_max_coh_ch=[];
temp0=[];
if (Nepochs==1)
    o_synchro_amp_max_coh_epo=[];
    if Nsubj==1
        features_results.o_synchro_amp_max_coh=[];
    end
end

downsample_frequency=200;
downsampling=1;

new_Srate = downsample_frequency;
old_Srate=s_EEG.sampling_rate;

ratio =old_Srate/new_Srate;
Rratio=round(ratio);

% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);
%% Only for the synchronisation méthodes
cpt=1; % compteur de combinaison
indice_combinaison=1:size(s_EEG.data,1)*(size(s_EEG.data,1)-1)/2;
channels_combinaison=combnk(1:size(s_EEG.data,1),2);

for l_channel1=1:size(s_EEG.data,1)
    if downsampling==1; % 0-> no downsampling // 1-> downsampling
        i_EEG_1= downsample(s_EEG.data(l_channel1,:,Nepochs),Rratio);
    end
    for l_channel2 = l_channel1+1:size(s_EEG.data,1)
        
        if downsampling==1; % 0-> no downsampling // 1-> downsampling
            i_EEG_2=downsample(s_EEG.data(l_channel2,:,Nepochs),Rratio);
        end
        
        if (apply_filter==1)
            for l_band=1:init_parameter.nb_bands
                filt=init_parameter.filt_band_param;
                fdata_1 = filter(filt(l_band),i_EEG_1);
                fdata_2 = filter(filt(l_band),i_EEG_2);
                
                
                max_coh = max(mscohere(fdata_1, fdata_2,[],[],init_parameter.sampling_rate));
                % cpt
                o_synchro_amp_max_coh0=max_coh;
                o_synchro_amp_max_coh_ch=[o_synchro_amp_max_coh_ch; o_synchro_amp_max_coh0];
                
                % Track the identification of the band
                if((Nsubj==1)&&(Nepochs==1))
                    temp0=[temp0; init_parameter.method(Nmethode) indice_combinaison(cpt) init_parameter.selected_band(l_band) ];
                end
            end
        else
            max_coh = max(mscohere(i_EEG_1, i_EEG_2,[],[],init_parameter.sampling_rate));
            
            o_synchro_amp_max_coh0=max_coh;
            o_synchro_amp_max_coh_ch=[o_synchro_amp_max_coh_ch; o_synchro_amp_max_coh0];
            
            % Track the identification of the band
            if ((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0;init_parameter.method(Nmethode) indice_combinaison(cpt) nan];
                %cpt=cpt+1;
            end
        end
        cpt=cpt+1;
    end
end
o_synchro_amp_max_coh_epo = o_synchro_amp_max_coh_ch;

features_results.o_synchro_amp_max_coh=[features_results.o_synchro_amp_max_coh o_synchro_amp_max_coh_epo];

%features_results.o_synchro_amp_max_coh=o_synchro_amp_max_coh;

features_results.channels_combinaison=channels_combinaison;
if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_synchro_amp_max_coh_band=temp0;
end


%% Here

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
% % %   File modified by Joffrey THOMAS
% % %   Creation Date : 08/09/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : joffrey.thomas.18@eigsi.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------