function init_parameter=Sigma_band_pass_filter_init(init_parameter,bandPass_freq,bandPass_order)
%%%------------------------------------------------------------------------
%   init_parameter=Sigma_band_pass_filter_init(init_parameter,lowPass_freq,lowPass_order)
%
%   Function task:
%   It initialize the value used for the band-pass filter 
%   This function is used by the function 'Sigma_frequency_initialisation
%   It includ on the structure init_parameter the information related to
%   the choice of the user regarding the  frequency bands to study
%
%   Inputs :
%   
%
%   Outputs :
%   i
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------



%% 2: Definition of the LowPass filter default value
if init_parameter.band_pass_filter==1
     bandPass_filter_info={['Band Pass Filter (freq,order) : (' num2str(bandPass_freq) 'Hz,' num2str(bandPass_order) ')' ]};
%     % Out put For the High PassFilter
     init_parameter.bandPass_filter.bandPass_freq=bandPass_freq;
     init_parameter.bandPass_filter.bandPass_order=bandPass_order;
     init_parameter.bandPass_filter.bandPass_filter_info=bandPass_filter_info;
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