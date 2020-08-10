function features_results=Synchro_phase_index2_value(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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
o_synchro_phase_index2_ch=[];
temp0=[];
if (Nepochs==1)
    o_synchro_phase_index2_epo=[];
    if Nsubj==1
        features_results.o_synchro_phase_index2=[];
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
%                 
%                 h1=hilbert(fdata_1);
%                 h2=hilbert(fdata_2);
%                 [phase1]=unwrap(angle(h1));
%                 [phase2]=unwrap(angle(h2));
%                 
                %%%%%% Check phase synchronization index2
                synchroindex2 = Dory_filtdir(fdata_1, fdata_2);
                %synchroindex2=(mean(cos(phase1-phase2)))^2 + (mean(sin(phase1-phase2)))^2;
                %                                                         if synchroindex2 > 0.6
                %                                                               disp('WARNING: synchronization index2 is rather high!!!');
                %                                                               synchroindex2
                %                                                               disp('The results might be not significant!');
                %                                                               disp('Comparison of different algorithms is recommended');
                %                                                         end
                
                o_synchro_phase_index20=synchroindex2;
                o_synchro_phase_index2_ch=[o_synchro_phase_index2_ch; o_synchro_phase_index20];
                
                % Track the identification of the band
                if((Nsubj==1)&&(Nepochs==1))
                    temp0=[temp0; init_parameter.method(Nmethode) indice_combinaison(cpt) init_parameter.selected_band(l_band) ];
                end
            end
        else
%             h1=hilbert(i_EEG_1);
%             h2=hilbert(i_EEG_2);
%             [phase1]=unwrap(angle(h1));
%             [phase2]=unwrap(angle(h2));
            
            %%%%%% Check phase synchronization index2
            %synchroindex2=(mean(cos(phase1-phase2)))^2 + (mean(sin(phase1-phase2)))^2;
            synchroindex2 = Dory_filtdir(i_EEG_1, i_EEG_2);

            o_synchro_phase_index20=synchroindex2;
            o_synchro_phase_index2_ch=[o_synchro_phase_index2_ch; o_synchro_phase_index20];
            % Track the identification of the band
            if ((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0;init_parameter.method(Nmethode) indice_combinaison(cpt) nan];
                %cpt=cpt+1;
            end
        end
        cpt=cpt+1;
    end
end
o_synchro_phase_index2_epo=o_synchro_phase_index2_ch;

features_results.o_synchro_phase_index2=[features_results.o_synchro_phase_index2 o_synchro_phase_index2_epo];

%features_results.o_synchro_phase_index2=o_synchro_phase_index2;

features_results.channels_combinaison=channels_combinaison;
if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_synchro_phase_index2_band=temp0;
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
