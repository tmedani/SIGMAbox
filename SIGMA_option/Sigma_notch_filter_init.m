function init_parameter=Sigma_notch_filter_init(init_parameter,notch_freq,notch_band_width,notch_order)
%%%------------------------------------------------------------------------
%   init_parameter = Sigma_notch_filter_init(init_parameter,lowPass_freq,lowPass_order)
%
%   Function task:
%   It initialize the value used for the Notch filter 
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



%% 5: Definition of the Notch filter default value
notch_filter_info = {['Notch Filter (freq,order,band width) : (' num2str(notch_freq) 'Hz,' num2str(notch_order) ',' num2str(notch_band_width) 'Hz)' ]};
%Output For the Notch Filter
init_parameter.notch_filter.notch_freq = notch_freq;
init_parameter.notch_filter.notch_order = notch_order;
init_parameter.notch_filter.notch_band_width = notch_band_width;
init_parameter.notch_filter.notch_filter_info = notch_filter_info;

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