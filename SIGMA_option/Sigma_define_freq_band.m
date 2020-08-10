function [freq_bands, bands_list] = Sigma_define_freq_band(fmin,fmax)
%%%------------------------------------------------------------------------
%   [freq_bands, bands_list, filter_order] = Sigma_define_freq_band(fmin,fmax,filter_order)
%
%   Function task:
%   The interval of the frequecy is divided into the EEG bands
%   according to the litterature
%   https://en.wikipedia.org/wiki/Electroencephalography
%
%   Inputs :
%   fmin : minimal frequecency
%   fmax : maximal frequency
%
%   Outputs :
%   freq_bands: The value of the bands
%   bands_list: The name of the bands
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%   init_parameter
%
%
%   Dependencies
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%% 0- The frquency bounds (minimal and maximal)
% fmin=0.1; % The minimum frequency for the EEG data
% fmax=90; % The maximum frequency f the EEG data
% filter_order=5; % the default value

% Check the input
if nargin<2
    warning('SIGMA Error: The input args should be two (fmin and fmax) ')
    return
end

if(fmin>=fmax)
    warning('SIGMA Error: Fmin should be inferior to fmax ')
    return
end

%% default value for the EEG frequency bands
Wn_delta=[fmin 4];
Wn_theta=[4 7];
Wn_mu=[8 12];
Wn_alpha=[8 15];
Wn_beta=[16 31];
Wn_gamma=[32 45];
Wn_gamma_high=[45 fmax];
Wn_all_bands=[fmin fmax];
Wn_custom = [1 32];

% refers to : https://en.wikipedia.org/wiki/Electroencephalography

% User can specify here the value of the desired bands
%     Wn_delta=[1 4];     Wn_theta=[4 8];    Wn_mu=[8 12];...
% Wn_alpha=[12 20];    Wn_beta=[20 30];
%     Wn_gamma=[30 45];    Wn_gamma_high=[45 fmax];...
% Wn_all_bands=[fmin fmax];
% TODO : add an automatic way to choos the value of the frequency

freq_bands=[Wn_delta; Wn_theta; Wn_mu; Wn_alpha; Wn_beta; Wn_gamma;...
    Wn_gamma_high; Wn_all_bands; Wn_custom];

% Ordre of the filters for extracting the differents bands
bands_list=[
    {['Delta     : [' num2str(Wn_delta(1)) ' ' num2str(Wn_delta(2)) '] Hz']};
    {['Theta     : [' num2str(Wn_theta(1)) ' ' num2str(Wn_theta(2)) '] Hz']};
    {['Mu        : [' num2str(Wn_mu(1)) ' ' num2str(Wn_mu(2)) '] Hz']};
    {['Alpha     : [' num2str(Wn_alpha(1)) ' ' num2str(Wn_alpha(2)) '] Hz']};
    {['Beta      : [' num2str(Wn_beta(1)) ' ' num2str(Wn_beta(2)) '] Hz']};
    {['Gamma     : [' num2str(Wn_gamma(1)) ' ' num2str(Wn_gamma(2)) '] Hz']};
    {['Gamma_high: [' num2str(Wn_gamma_high(1)) ' ' num2str(Wn_gamma_high(2)) '] Hz']};
    {['All bands : [' num2str(Wn_all_bands(1)) ' ' num2str(Wn_all_bands(2)) '] Hz']};
    {['Custom    : [' num2str(Wn_custom(1)) ' ' num2str(Wn_custom(2)) '] Hz']};];

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