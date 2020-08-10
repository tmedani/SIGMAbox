function band_list = Print_freq_band_list(numeric_band_list)
%%%------------------------------------------------------------------------
%   band_list = Print_freq_band_list(numeric_band_list)
%
%   Function task:
%   % Generate the frequency band string list
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

% Number of bands
nb_bands = size(numeric_band_list, 1);
% Name of bands
 band_name = {'Delta     : ', 'Theta     : ', 'Mu        : ', 'Alpha     : ', 'Beta      : ', 'Gamma     : ', 'Gamma_high: ', 'All bands : ', 'Custom bands: '};

 % creat a string for all band names using the values provided
band_list = cell(nb_bands, 1);
for cB = 1:nb_bands
    
    band_list{cB} = [ band_name{cB}, '[ ', num2str(numeric_band_list(cB, 1)), ' ', num2str(numeric_band_list(cB, 2)), ' ] Hz' ];
    disp(band_list{cB})
 
end


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