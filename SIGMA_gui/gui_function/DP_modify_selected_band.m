function selected_band = DP_modify_selected_band(selected_band, band_id, check_value)
%%%------------------------------------------------------------------------
%   selected_band = DP_modify_selected_band(selected_band, band_id, check_value)
%
%   Function task:
%   Add or remove a frequency band 
%
%   Inputs :
%   selected_band : the currently selected frequency bands
%   band_id : the band to add or remove
%   check_value : 1 == add, 0 == remove
%
%   Outputs :
%   selected_band : the output selected bands
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%
%   Dependencies
%
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------
% add or remove selected band "band_id" acording to button state "check value"

if( check_value == 1)
    selected_band = sort( unique( [ selected_band,  band_id  ])); % refers to the sigma_frequency_initialisation
else
    band_to_remove = find(selected_band == band_id);
    selected_band(band_to_remove) = [];
end

%% END OF FILE
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
% % %   File created by A. BAELDE
% % %   Creation Date : 13/01/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------