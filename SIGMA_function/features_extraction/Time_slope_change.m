function features_results=Time_slope_change(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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
%%%------------------------------------------------------------------==================================================================

o_time_slope_change_ch=[];
temp0=[];

if (Nepochs==1)
    o_time_slope_change_epo=[];
    if Nsubj==1
        features_results.o_time_slope_change=[];
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
            
            derivative_epoch = diff(fdata);
            amp_slope_change_cpt = 0;
            epoch_length_sample=length(derivative_epoch);
            
            for k_sample = 1 : epoch_length_sample - 1
                if sign(derivative_epoch(k_sample + 1)) ~= sign(derivative_epoch(k_sample))
                    amp_slope_change_cpt = amp_slope_change_cpt + 1;
                end
            end
            o_time_slope_change_ch =[o_time_slope_change_ch,amp_slope_change_cpt];
            
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        % Nop bands
        derivative_epoch = diff(i_EEG);
        amp_slope_change_cpt = 0;
        epoch_length_sample=length(derivative_epoch);
        
        for k_sample = 1 : epoch_length_sample - 1
            if sign(derivative_epoch(k_sample + 1)) ~= sign(derivative_epoch(k_sample))
                amp_slope_change_cpt = amp_slope_change_cpt + 1;
            end
        end
        o_time_slope_change_ch =[o_time_slope_change_ch,amp_slope_change_cpt];
        
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    
    clear amp_slope_change0
end
o_time_slope_change_epo=o_time_slope_change_ch';
features_results.o_time_slope_change=[features_results.o_time_slope_change o_time_slope_change_epo];
%features_results.o_time_slope_change=o_time_slope_change;


if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_slope_change_band=temp0;
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
