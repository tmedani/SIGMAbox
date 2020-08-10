function [nb_parameter_to_change, parameter_index] = Check_method_editable_parameter(method)
%%%------------------------------------------------------------------------
%   [nb_parameter_to_change, parameter_index] = Check_method_editable_parameter(method)
%
%   Function task:
%   Determine the edtitable parameters of a feature extraction method
%   
%   Inputs :
%   method : structure containing informations on a feature extraction
%   method
%
%   Outputs : 
%       
%   nb_parameter_to_change : number of parameter that can be modified by
%   the user
%   parameter_index : Index of editable parameters
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

% check the number of adjustable parameters
%p1 = isempty(handles.init_method(init_method_number).band_start);
%p2 = isempty(handles.init_method(init_method_number).band_end);
p3 = isempty(method.nb_of_bands);
p4 = isempty(method.frequency_step);
p5 = isempty(method.relative);
p6 = isempty(method.all_fourier_power);
p7 = isempty(method.pwelch_width);
p8 = isempty(method.dimension);
p9 = isempty(method.tau);
p10 = isempty(method.tolerance);
p11 = isempty(method.epsilon);

nb_parameter_to_change = 9 - (p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11);

parameter_index = [  0, 0, 1-p3, 1-p4, 1-p5, 1-p6, 1-p7, 1-p8, 1-p9, 1-p10, 1-p11];
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

