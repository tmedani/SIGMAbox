function features_results=Time_zero_crossing(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%%%------------------------------------------------------------------------
%  features_results=Time_zero_crossing(init_parameter,~,features_results,s_EEG,Nsubj,Nepochs,Nmethode)
%
%  Function task:
%  A zero-crossing is a point where the sign of a mathematical function 
%  changes (e.g. from positive to negative), represented by a intercept 
%  of the axis (zero value) in the graph of the function
%  https://en.wikipedia.org/wiki/Zero_crossing
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

o_time_zero_crossing_ch=[];
temp0=[];

if (Nepochs==1)
    o_time_zero_crossing_epo=[];
    if Nsubj==1
        features_results.o_time_zero_crossing=[];
    end
end

%% défine the function zci (find on line and validated on small signal)
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
% with this function it's an approximation and not the exact value of the
% zero crossing. Ask françois for best code


% Apply a filter here according to the choice of the user
apply_filter=init_parameter.apply_filter(Nmethode);

for l_channel=1:size(s_EEG.data,1)
    i_EEG=s_EEG.data(l_channel,:,Nepochs);
    
    if (apply_filter==1)
        for l_band=1:init_parameter.nb_bands
            filt=init_parameter.filt_band_param;
            fdata = filter(filt(l_band),i_EEG);
            
            o_time_zero_crossing_value0 = length(zci(fdata));
            o_time_zero_crossing_ch =[o_time_zero_crossing_ch,o_time_zero_crossing_value0];
            % Track the identification of the band
            if((Nsubj==1)&&(Nepochs==1))
                temp0=[temp0; init_parameter.method(Nmethode) l_channel init_parameter.selected_band(l_band) ];
            end
        end
    else
        o_time_zero_crossing_value0 = length(zci(i_EEG));
        o_time_zero_crossing_ch =[o_time_zero_crossing_ch,o_time_zero_crossing_value0];
        % Track the identification of the band
        if ((Nsubj==1)&&(Nepochs==1))
            temp0=[temp0;init_parameter.method(Nmethode) l_channel nan];
        end
    end
    clear o_mean_value0
    % zx=(zci(i_EEG))
    % o_time_zero_crossing_value0 =length(zci(i_EEG));
    % o_time_zero_crossing_ch =[o_time_zero_crossing_ch,o_time_zero_crossing_value0];
    
    %% checking the results and check it with François
    % t = 1:length(i_EEG);
    % figure(1)
    % plot(t, i_EEG, '-r')
    % hold on
    % plot(t(zx), i_EEG(zx), 'bp')
    % hold off
    % grid
    % legend('Signal', 'Approximate Zero-Crossings')
    
    
    clear o_time_zero_crossing_value0
end
o_time_zero_crossing_epo=o_time_zero_crossing_ch';
features_results.o_time_zero_crossing=[features_results.o_time_zero_crossing o_time_zero_crossing_epo];

%features_results.o_time_zero_crossing=o_time_zero_crossing;

if ((Nsubj==1)&&(Nepochs==1))
    features_results.o_time_zero_crossing_band=temp0;
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