function features_results=Time_msav(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%  features_results=Time_msav(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%
%  Function task:
%
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
temp0=[];
o_msav_ch=[];
if (Nepochs==1)
    o_msav_epo=[];
    if Nsubj==1
        features_results.o_time_msav=[];
    end
end

% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);

for l_channel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(l_channel,:,Nepochs);
    
    if (apply_filter==1)
        for l_band=1:init_parameter.nb_bands
            filt=init_parameter.filt_band_param;
            fdata = filter(filt(l_band),i_EEG);
            
            o_time_msav0 = (1/(length(diff((fdata)))))*sum(abs(diff((fdata))));;
            o_msav_ch =[o_msav_ch,o_time_msav0];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        o_time_msav0 = (1/(length(diff(i_EEG))))*sum(abs(diff(i_EEG)));
        o_msav_ch =[o_msav_ch,o_time_msav0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    
    
    % old version
    % for index=1:length(i_EEG)-1
    % o_time_msav0 = (1/(length(i_EEG)-1))*sum(abs(i_EEG(index+1)-i_EEG(index)));
    % o_msav_ch =[o_msav_ch,o_time_msav0];
    % end
    
    clear o_time_msav0
end
% o_msav_epo(:,Nepochs)=o_msav_ch';
% o_time_msav=[o_time_msav o_msav_epo];

o_msav_epo=o_msav_ch';
features_results.o_time_msav=[features_results.o_time_msav o_msav_epo];

%features_results.o_time_msav=o_time_msav;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_msav_band=temp0;
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

%skewness(X)
