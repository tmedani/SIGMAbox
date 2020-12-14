function init_parameter=Sigma_low_pass_filter_init(init_parameter,lowPass_freq,lowPass_order)
%%%------------------------------------------------------------------------
%   init_parameter=Sigma_low_pass_filter_init(init_parameter,lowPass_freq,lowPass_order)
%
%   Function task:
%   It initialize the value used for the low pass filter 
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
if init_parameter.low_pass_filter == 1
    lowPass_filter_info = {['LowPass Filter (freq,order) : ('...
        num2str(lowPass_freq) 'Hz,' num2str(lowPass_order) ')' ]};
    % Out put For the LowPassFilter
    init_parameter.lowPass_filter.lowPass_freq = lowPass_freq;
    init_parameter.lowPass_filter.lowPass_order = lowPass_order;
    init_parameter.lowPass_filter.lowPass_filter_info = lowPass_filter_info;
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