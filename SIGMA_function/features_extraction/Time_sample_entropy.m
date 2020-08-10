function features_results=Time_sample_entropy(init_parameter,init_method,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
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

o_time_sample_entropy_ch=[];
temp0=[];
if (Nepochs==1)
    o_time_sample_entropy_epo=[];
    if Nsubj==1
        features_results.o_time_sample_entropy=[];
    end
end

% Initialisation of the method
dim=init_method(3).dimension;
tau=init_method(3).tau;
r=init_method(3).tolerance;


% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);

for l_channel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(l_channel,:,Nepochs);
    
    if (apply_filter==1)
        for l_band=1:init_parameter.nb_bands
            filt=init_parameter.filt_band_param;
            fdata = filter(filt(l_band),i_EEG);
            
            o_time_sample_entropy0 = fc_sample_entropy( dim, r*std(fdata), fdata, tau );
            o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        o_time_sample_entropy0 = fc_sample_entropy( dim, r*std(i_EEG), i_EEG, tau );;
        o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    
    % o_time_sample_entropy0 = fc_sample_entropy( dim, r*std(i_EEG), i_EEG, tau );
    % o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
    clear o_time_sample_entropy0
end
o_time_sample_entropy_epo=o_time_sample_entropy_ch';
features_results.o_time_sample_entropy=[features_results.o_time_sample_entropy o_time_sample_entropy_epo];

%features_results.o_time_sample_entropy=o_time_sample_entropy;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_sample_entropy_band=temp0;
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
% % %   File created by
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
