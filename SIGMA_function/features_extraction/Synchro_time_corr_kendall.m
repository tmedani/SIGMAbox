function features_results=Synchro_time_corr_kendall(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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
o_synchro_time_corr_kendall_ch=[];
temp0=[];
if (Nepochs==1)
    o_synchro_time_corr_kendall_epo=[];
    if Nsubj==1
        features_results.o_synchro_time_corr_kendall=[];
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
    for l_channel2 = l_channel1+1:size(s_EEG.data,1)
        
        i_EEG_2=s_EEG.data(l_channel2,:,Nepochs);
        
        if (apply_filter==1)
            for l_band=1:init_parameter.nb_bands
                filt=init_parameter.filt_band_param;
                fdata_1 = filter(filt(l_band),i_EEG_1);
                fdata_2 = filter(filt(l_band),i_EEG_2);
                
                
                [corr_kendall, ~]=corr(fdata_1',fdata_2','type','Kendall');
                % cpt
                o_synchro_time_corr_kendall0=corr_kendall;
                o_synchro_time_corr_kendall_ch=[o_synchro_time_corr_kendall_ch; o_synchro_time_corr_kendall0];
                
                % Track the identification of the band
                if((Nsubj==1)&&(Nepochs==1))
                    temp0=[temp0; init_parameter.method(Nmethode) indice_combinaison(cpt) init_parameter.selected_band(l_band) ];
                end
            end
        else
            
            [corr_kendall, ~]=corr(i_EEG_1',i_EEG_2','type','Kendall');
            o_synchro_time_corr_kendall0=corr_kendall;
            o_synchro_time_corr_kendall_ch=[o_synchro_time_corr_kendall_ch; o_synchro_time_corr_kendall0];
            % Track the identification of the band
            if ((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0;init_parameter.method(Nmethode) indice_combinaison(cpt) nan];
                %cpt=cpt+1;
            end
        end
        cpt=cpt+1;
    end
end
o_synchro_time_corr_kendall_epo=o_synchro_time_corr_kendall_ch;

features_results.o_synchro_time_corr_kendall=[features_results.o_synchro_time_corr_kendall o_synchro_time_corr_kendall_epo];

%features_results.o_synchro_time_corr_kendall=o_synchro_time_corr_kendall;

features_results.channels_combinaison=channels_combinaison;
if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_synchro_time_corr_kendall_band=temp0;
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
