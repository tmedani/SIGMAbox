function handles = FE_update_frequency_bands(handles, hObject)
%%%------------------------------------------------------------------------
%    handles = FE_update_frequency_bands(handles, hObject)
%
%   Function task:
%   Update the frequency bands value in init_parameter accoring to values
%   provided by user
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
% Update init_parameter using values provided by edit fields
nb_button = length(handles.init_parameter.frequency_button_name);
for cB = 1:(nb_button-1) % minimum frequency values
    % read value
    freq_value_str = get( eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_mf' ] ) , 'String');
    % Check if this value is correct
    [ freq_value, status ] = str2num(freq_value_str);
    
    if(( status == 1) && (freq_value <= handles.init_parameter.freq_bands(cB, 2)))
        handles.init_parameter.freq_bands(cB, 1) = freq_value;
         % si la valeur maximale est inférieure à la valeur minimale
    elseif(( status == 1) && (freq_value > handles.init_parameter.freq_bands(cB, 2)) )
        set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_mf' ] ), 'String', 'Value > to frequency max');
    else % if bad format but relevant field
        
        set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_mf' ] ), 'String', 'Bad format')
    end
end

for cB = 1:(nb_button-1) % maximum frequency values
    % read value
    freq_value_str = get( eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_maf' ] ), 'String' );
    
    % Check if this value is correct
    [ freq_value, status ] = str2num(freq_value_str);
    if(status == 1 && (freq_value >= handles.init_parameter.freq_bands(cB, 1)))
        handles.init_parameter.freq_bands(cB, 2) = freq_value;
        % si la valeur maximale est inférieure à la valeur minimale
         elseif(( status == 1) && (freq_value < handles.init_parameter.freq_bands(cB, 1)) )
        set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_maf' ] ), 'String', 'Value < to frequency min');
    else % if bad format but relevant field
        disp('min freq')
        freq_value
        status
        set(eval([ 'handles.FE_ed_', handles.init_parameter.frequency_button_name{cB}(4:end)  , '_maf' ] ), 'String', 'Bad format')
    end
end

% update init parameter
handles.init_parameter.selected_freq_bands = handles.init_parameter.freq_bands;
% recreate the bands list in form of string
handles.init_parameter.bands_list = Print_freq_band_list(handles.init_parameter.freq_bands);

% set the output
handles.output = handles.init_parameter;

guidata(hObject, handles);
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

