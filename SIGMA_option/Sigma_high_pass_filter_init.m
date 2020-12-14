function init_parameter=Sigma_high_pass_filter_init(init_parameter,highPass_freq,highPass_order)
%%%------------------------------------------------------------------------
%   init_parameter=Sigma_high_pass_filter_init(init_parameter,highPass_freq,highPass_order)
%
%   Function task:
%   It initialize the value used for the high pass filter 

% This function is used by the function 'Sigma_frequency_initialisation
% It includ on the structure init_parameter the information related to 
% the choice of the user regarding the  frequency bands to study
%
%   Inputs :
%   
%
%   Outputs :
%   
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


%% 2: Definition of the LowPass filter default value
if init_parameter.high_pass_filter==1
    highPass_filter_info={['High Pass Filter (freq,order) : (' num2str(highPass_freq) 'Hz,' num2str(highPass_order) ')' ]};
    % Out put For the LowPassFilter
    init_parameter.highPass_filter.highPass_freq=highPass_freq;
    init_parameter.highPass_filter.highPass_order=highPass_order;
    init_parameter.highPass_filter.highPass_filter_info=highPass_filter_info;
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