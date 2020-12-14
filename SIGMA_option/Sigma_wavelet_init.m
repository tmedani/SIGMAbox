function init_parameter=Sigma_wavelet_init(init_parameter,fmin,fmax,step)
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
% This function is used by the function 'Sigma_frequency_initialisation
% It includ on the structure init_parameter the information related to 
% the choice of the user regarding the  frequency bands to study

%% 2: Definition of the LowPass filter default value

  % This is part of the code of François : [ascwt, s] = wavelet_trans(Signal,Cwt, Min, Max, FreqEch, frqsmp)
    % This function calls the matlab wavelet toolbox to transform signals into 
    % wavelets. If you do not have wavelet toolbox, you must change calls to 
    % ctrfrq and cwt and call a free toolbox such as Yawtb, or wait for the
    % next release of SUMO toolbox where complex Morlet will be implemented
    %
    % Signal = signal to be transformed
    % Cwt = wavelet type
    %     'haar' : Haar, 'meyr' : Meyer, 'mexh' : Mexican hat, 'morl' : Morlet
    % Min = minimal frequency
    % Max = maximal frequency
    % FreqEch = sampling rate
    % frqsmp = step in frequencies between Min and Max 
    %          (use 1 for linear spacing)
    %
    % output: ascwt = wavelet transform, s = transform scales
    %
    % Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
    % Please cite related papers when publishing results obtained with this
    % toolbox

    %%% Cwt = 'cmor2.0558-0.5874';
    
    
     wavelet_type='cmor2.0558-0.5874';
     minimal_frequency=fmin;
     maximal_frequency=fmax;
     %step=1;
     step_frequency=step; % or scale
    
    % For the Wavellet transform
    init_parameter.wavelet_transform_param.wavelet_type=wavelet_type;
    init_parameter.wavelet_transform_param.minimal_frequency=minimal_frequency;
    init_parameter.wavelet_transform_param.maximal_frequency=maximal_frequency;
    init_parameter.wavelet_transform_param.step_frequency=step_frequency;

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