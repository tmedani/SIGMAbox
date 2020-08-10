function handles = Update_method_parameter(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = Update_method_parameter(handles, hObject)
%
%   Function task:
%   %   Update init_parameter feature extraction method parameters using the user choice
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

% Validity index
parameter_validity = 0;
% nombre de param�tres
nbPar = length(handles.parameter_name);

% get parameter values
parameter_value_str = cell(1, nbPar);
parameter_value = cell(1, nbPar);
for cP = 1:nbPar
    
    parameter_value_str{cP} = get(eval([ 'handles.', handles.parameter_name{cP}]), 'String');
    
    [ param_val, status ] = str2num(parameter_value_str{cP});
    if(status == 1)
        parameter_value{cP} = param_val;
    elseif( (status == 0) && (handles.parameter_index(cP+3) > 0.5) ) % if bad format but relevant field
        set( eval([ 'handles.', handles.parameter_name{cP}]), 'String', 'badformat');
        parameter_validity = parameter_validity + 1;

    % if the format is bad and the field irrelevant
    elseif( (status == 0) && (handles.parameter_index(cP+3) < 0.5))
        parameter_value{cP} = [];
    end
end

disp('validity')
disp(parameter_validity)

% add values to method parameters
if(parameter_validity < 0.5)
    handles.method.frequency_step = parameter_value{1};
    handles.method.relative = parameter_value{2};
    handles.method.all_fourier_power = parameter_value{3};
    handles.method.pwelch_width = parameter_value{4};
    handles.method.dimension = parameter_value{5};
    handles.method.tau = parameter_value{6};
    handles.method.tolerance = parameter_value{7};
    handles.method.epsilon = parameter_value{8};
    
    % display parameters changes
    set(handles.ME_st_method_status, 'String', 'Parameters format is good');
else
    % display parameters changes
    set(handles.ME_st_method_status, 'String', 'Parameters will not be recorded');
end

handles.output = handles.method;

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

