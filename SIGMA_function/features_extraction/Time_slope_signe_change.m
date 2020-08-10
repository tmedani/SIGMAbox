function features_results=Time_slope_signe_change(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%  init_parameter = Sigma_parameter_initialisation(varargin)
%
%  Function task:
%  Slope sign change MYOP, and WAMP features (e.g. Hudgins et al., 1993;
%  Philipson, 1987). It is another method to represent frequency
%  information of the signal. It is a number of times that slope of
%  the signal changes sign.
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
%%%------------------------------------------------------------------

o_time_slope_signe_change_ch=[];
temp0=[];
if (Nepochs==1)
    o_time_slope_signe_change_epo=[];
    if Nsubj==1
        features_results.o_time_slope_signe_change=[];
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
            
            o_time_slope_signe_change0 = length(find(diff(sign(diff(fdata)))~=0));
            o_time_slope_signe_change_ch =[o_time_slope_signe_change_ch,o_time_slope_signe_change0];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        o_time_slope_signe_change0 = length(find(diff(sign(diff(i_EEG)))~=0));
        o_time_slope_signe_change_ch =[o_time_slope_signe_change_ch,o_time_slope_signe_change0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    
    
    clear o_time_slope_signe_change0
end
o_time_slope_signe_change_epo=o_time_slope_signe_change_ch';
features_results.o_time_slope_signe_change=[features_results.o_time_slope_signe_change o_time_slope_signe_change_epo];

%features_results.o_time_slope_signe_change=o_time_slope_signe_change;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_slope_signe_change_band=temp0;
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
