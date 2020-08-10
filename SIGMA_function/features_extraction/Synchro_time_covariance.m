function features_results=Synchro_time_covariance(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%   features_results=Synchro_time_covariance(varargin)
%
%  Function task:
%  This script comput the covariance between two signal normalized
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
o_synchro_time_covariance_ch=[];
temp0=[];
if (Nepochs==1)
    o_synchro_time_covariance_epo=[];
    if Nsubj==1
        features_results.o_synchro_time_covariance=[];
    end
end

% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);
%% Only for the synchronisation méthodes
cpt=1; % compteur de combinaison
indice_combinaison=1:size(s_EEG.data,1)*(size(s_EEG.data,1)-1)/2;
channels_combinaison=combnk(1:size(s_EEG.data,1),2);

for l_channel1=1:size(s_EEG.data,1)
    i_EEG_1=s_EEG.data(l_channel1,:,Nepochs);
    % Normalisation
    i_EEG_1 = zscore(i_EEG_1);
    for l_channel2 = l_channel1+1:size(s_EEG.data,1)
        i_EEG_2=s_EEG.data(l_channel2,:,Nepochs);

        % Normalisation
        i_EEG_2 = zscore(i_EEG_2);
        if (apply_filter==1)
            for l_band=1:init_parameter.nb_bands
                filt=init_parameter.filt_band_param;
                fdata_1 = filter(filt(l_band),i_EEG_1);
                fdata_2 = filter(filt(l_band),i_EEG_2);
                
                o_synchro_time_covariance0 = (sum((fdata_1-mean(fdata_1)).*(fdata_2-mean(fdata_2))))/length(fdata_1);
                %o_synchro_time_covariance0 =(max(fdata_2-fdata_1))/((max(fdata_2))-(min(fdata_1)));
                o_synchro_time_covariance_ch=[o_synchro_time_covariance_ch; o_synchro_time_covariance0];
                
                % Track the identification of the band
                if((Nsubj==1)&&(Nepochs==1))
                    temp0=[temp0; init_parameter.method(Nmethode) indice_combinaison(cpt) init_parameter.selected_band(l_band) ];
                end
            end
        else
            %o_synchro_time_covariance0=(max(i_EEG_2-i_EEG_1))/((max(i_EEG_2))-(min(i_EEG_1)));
            o_synchro_time_covariance0 = (sum((i_EEG_1-mean(i_EEG_1)).*(i_EEG_2-mean(i_EEG_2))))/length(i_EEG_1);
            o_synchro_time_covariance_ch=[o_synchro_time_covariance_ch; o_synchro_time_covariance0];
            % Track the identification of the band
            if ((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0;init_parameter.method(Nmethode) indice_combinaison(cpt) nan];
                %cpt=cpt+1;
            end
        end
        cpt=cpt+1;
    end
end
o_synchro_time_covariance_epo=o_synchro_time_covariance_ch;

features_results.o_synchro_time_covariance=[features_results.o_synchro_time_covariance o_synchro_time_covariance_epo];

%features_results.o_synchro_time_covariance=o_synchro_time_covariance;

features_results.channels_combinaison=channels_combinaison;
if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_synchro_time_covariance_band=temp0;
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
