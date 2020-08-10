function features_results=Time_mean_time_bo(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%  init_parameter = Sigma_parameter_initialisation(varargin)
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

o_mean_time_between_oscillation_ch=[];
temp0=[];
if (Nepochs==1)
    o_mean_time_between_oscillation_epo=[];
    if Nsubj==1
        features_results.o_time_mean_time_bo=[]; %o_time_mean_time_between_oscillation
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
            
            instant_of_changes = length(find(diff(sign(diff(fdata)))~=0));
            o_mean_time_between_oscillation_ch =[o_mean_time_between_oscillation_ch,instant_of_changes];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        instant_of_changes=length(find(diff(sign(diff(i_EEG)))~=0));
        o_mean_time_between_oscillation_ch =[o_mean_time_between_oscillation_ch,instant_of_changes];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    
    % % instant_of_changes=find(diff(sign(diff(i_EEG)))~=0);
    % o_mean_time_between_oscillation0=mean(abs(diff((instant_of_changes))));
    % o_mean_time_between_oscillation_ch =[o_mean_time_between_oscillation_ch,o_mean_time_between_oscillation0];
    clear o_mean_time_between_oscillation0
end
o_mean_time_between_oscillation_epo=o_mean_time_between_oscillation_ch';
features_results.o_time_mean_time_bo=[features_results.o_time_mean_time_bo o_mean_time_between_oscillation_epo];

%features_results.o_time_mean_time_bo=o_time_mean_time_bo;


if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_mean_time_bo_band=temp0;
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
