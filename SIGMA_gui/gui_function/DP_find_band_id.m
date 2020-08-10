function band_id = DP_find_band_id(hObject)
%%%------------------------------------------------------------------------
%   band_id = DP_find_band_id(hObject)
%
%   Function task:
%   Determine the frequency band and assign a number to it
%
%   Inputs :
%   handles : structure containing GUI informations
%   hObject : necessary for the GUI management
%
%   Outputs :
%
%   handles : structure containing GUI informations
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
switch get(hObject, 'tag')
    case 'DP_delta'
        band_id = 1;
    case 'DP_theta'
        band_id = 2;
    case 'DP_mu'
        band_id = 3;
    case 'DP_alpha'
        band_id = 4;
    case 'DP_beta'
        band_id = 5;
    case 'DP_gamma'
        band_id = 6;
    case 'DP_gamma_high'
        band_id = 7;
    case 'DP_all'
        band_id = 8;
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