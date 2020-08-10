function handles = DL_load_subjects(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = DL_load_subjects(handles, hObject)
%
%   Function task:
%   Load the subjects in the GUI
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
% Display data quality
if isfield(handles,'sigma_load_session')
    if handles.sigma_load_session == 0
        [ score, files, message ] = DL_data_compatibility(handles);
        full_filename = fullfile(handles.init_parameter.data_location,files(1).name);
        load(full_filename);
        sampling_rate = s_EEG.sampling_rate;
    end
    
    if handles.sigma_load_session == 1
        score = 1;
        message = 'Data are correct' ;
        if ~handles.init_parameter.method == 99
            for l_sub = 1 : length(handles.init_parameter.subject_index)
                files(l_sub).name = ['subject_' ...
                    num2str(handles.init_parameter.subject_index(l_sub))...
                                                    '.mat'];
            end
        else
            files = [];  
            % modificatio Takfarinas 05/05/2019
            [ score, files, message ] = DL_data_compatibility(handles);

        end
        sampling_rate = handles.init_parameter.sampling_rate;
    end
else
    [ score, files, message ] = DL_data_compatibility(handles);
%     full_filename = fullfile(handles.init_parameter.data_location,files(1).name);
%     load(full_filename);
%     sampling_rate = s_EEG.sampling_rate;
end

% update init_parameter data compatibility
handles.init_parameter.data_compatibility = score;
set(handles.DL_Data_Compatibility_text, 'String', message);

if(score == 1)
    subject_number = zeros(1, length(files));
    % Get subject numbers
    for cF = 1:length(files)
        %% modification apporter ici (Takfarinas)
        test = sscanf(files(cF).name, 'subject_%d.mat');
        if isempty(test)
            msgbox('The selected path contain subject(s) with wrong name/format,please check and reload',...
                'SIGMA Error','error','modal');
            return;
        else % version originale sans teste
            subject_number(cF) =  sscanf(files(cF).name, 'subject_%d.mat');
        end
    end
    handles.init_parameter.subject_index = subject_number;
    % Display available subjects
    
    %     load(files(1).name)
    set(handles.DL_suject_text, 'String', length(files));
    
    % Display subject list
    handles.init_parameter.subject_name = DL_struct2cell(files);
    set(handles.DL_list_subject_available, 'String', handles.init_parameter.subject_name );
    
    
    handles.init_parameter.subject_number = 1:length(files);
    
    
    % Allow subject list go get multiple selection
    set(handles.DL_list_subject_available, 'Max', length(files))
    set(handles.DP_list_subject_selected, 'Max', length(files))
    
    % intialize subject lists
    handles.selected_subject = [];
    handles.unselected_subject = handles.init_parameter.subject_number;
    
    % set data sampling rate
    if ~isfield(handles,'sigma_load_session')
        full_filename = fullfile(handles.init_parameter.data_location,files(1).name);
        load(full_filename);
        sampling_rate = s_EEG.sampling_rate;
    end
    handles.init_parameter.sampling_rate_by_data = sampling_rate;
    
    % display sampling rate
    Update_sampling_rate(handles, hObject)
    % update init_parameter sampling rate
    handles.data_sampling_rate = sampling_rate;
    %update data path display
    disp(handles.init_parameter.data_location)
    set(handles.DL_st_data_path, 'String',  handles.init_parameter.data_location)
    
else
    
    % set number of subject
    set(handles.DL_Data_Compatibility_text, 'String', 'Data not Compatible');
    % display if data formatting is bad
    set(handles.DL_suject_text, 'String', 'Undefined');
    % empty the subject list
    set(handles.DL_list_subject_available, 'String', {});
    
end

guidata(hObject, handles);

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
