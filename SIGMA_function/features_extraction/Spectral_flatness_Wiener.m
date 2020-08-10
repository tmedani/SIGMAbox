function features_results=Spectral_flatness_Wiener(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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
% This script compute the sample_entropy for each channels and epoches
o_spectral_flatness_ch=[];
temp0=[];
if (Nepochs==1)
    o_spectral_flatness_epo=[];
    if Nsubj==1
        features_results.o_spectral_flatness=[];
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
            pxx = periodogram(fdata);
            num=geomean(pxx);
            den=mean(pxx);
            spf=num/den ;
            o_spectral_flatness0 = spf;
            o_spectral_flatness_ch =[o_spectral_flatness_ch,o_spectral_flatness0];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        
        pxx = periodogram(i_EEG);
        num=geomean(pxx);
        den=mean(pxx);
        spf=num/den ;
        o_spectral_flatness0 = spf;
        o_spectral_flatness_ch =[o_spectral_flatness_ch,o_spectral_flatness0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    clear o_spectral_flatness0
end
o_spectral_flatness_epo=o_spectral_flatness_ch';
features_results.o_spectral_flatness=[features_results.o_spectral_flatness o_spectral_flatness_epo];
%features_results.o_spectral_flatness=o_spectral_flatness;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_spectral_flatness_band=temp0;
end

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
