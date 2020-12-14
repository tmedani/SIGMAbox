function init_parameter=Sigma_freq_band_selection(init_parameter,temp_arg)
%%%------------------------------------------------------------------------
%   init_parameter=Sigma_freq_band_selection(init_parameter,temp_arg)
%
%   Function task:
%   This function is used by the function 'Sigma_frequency_initialisation
%   It includ on the structure init_parameter the information related to
%   the choice of the user regarding the  frequency bands to study
%
%   Inputs :
%   temp_arg : structure containing the selection of the bands  
%
%   Outputs :
%   init_parameter : main Sigam variable
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

freq_bands=temp_arg.freq_bands;
filter_order=temp_arg.filter_order;
bands_list=temp_arg.bands_list;


%% 1- The definition of the frequency bands for the study(for the features extraction)
if sum(init_parameter.apply_filter)>0
    selected_band=init_parameter.selected_band; % receive the desired list of frequecy chosen by the user
    
    %% For the bands
    init_parameter.selected_freq_bands = freq_bands(selected_band,:);
    init_parameter.selected_freq_list = bands_list(selected_band,:);
    init_parameter.band_filter_order = filter_order;
else
    init_parameter.selected_band = 8;% the all frequency bands
    selected_band = init_parameter.selected_band;
    %% For the bands
    init_parameter.selected_freq_bands=freq_bands(selected_band,:);
    init_parameter.selected_freq_list=bands_list(selected_band,:);
    init_parameter.band_filter_order=filter_order;
end

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
% % %   Creation Date : 10/10/2016
% % %   Updates and contributors :
% % %   29/01/2018, T. MEDANI :
% % %
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------