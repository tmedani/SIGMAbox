function [ score, files, message] = DL_data_compatibility(handles)
%%%------------------------------------------------------------------------
%   [ score, files, message] = DL_data_compatibility(handles)
%
%   Function task:
%   Check if the data provided by user are compatible and suitable for
%   feature extraction and classification
%
%   Inputs :
%   handles : structure containing GUI informations
%   hObject : necessary for the GUI management
%
%   Outputs :
%   score : 1 = data compatible, elso not
%   files : location of data
%   message : string explaining the output of this function
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
%% If data path is not correct
if( isempty(handles.init_parameter.data_location) > 0.5)
    score = 0;
    message = 'no file path selected';
    files = [];
    disp('no file path selected')
    
    %% if data format is .mat
else
    % determination of file format
    files = dir( [ handles.init_parameter.data_location, '*.mat']);
    % Takfa modification
    cd([handles.init_parameter.data_location])
    %sigma_directory
    if( length(files) < 0.5 ) % if no file in .mat format
        score = 0;
        message = 'data are not in the .mat format';
        disp('data are not in the .mat format')
        msgbox('There is no Matlab data in this directory','SIGMA Message','error')
    else % if several .mat files
        % Select only the relevant files by loading and anaysing it
        h = waitbar(0,'Data loading...','Name','SIGMA : Data Loading');
        % modification Takfarinas
        nombre_channel = nan(length(files),1);
        nombre_epoch = nan(length(files),1);
        nombre_label = nan(length(files),1);
        nombre_channel_names = nan(length(files),1);
        nombre_custom_feature_value = nan(length(files),1);
        nombre_custom_feature_name = nan(length(files),1);
        for l_file = length(files):-1:1
            files(l_file).name
            data = load(files(l_file).name, 's_EEG');
            waitbar((length(files) - l_file)/length(files),h,...
                ['Data loading... subject ' num2str(length(files)-l_file)...
                '/' num2str(length(files))]);
            % If s_EEG exist
            if (numel(fieldnames(data)) < 0.5)
                files(l_file) = [];
            end
%             if ~isfield(data,'s_EEG')
%                 msgbox(['The file ' files(l_file).name ...
%                     ' does not contain the s_EEG field'],'SIGMA Error','error');
%                 files(l_file) = [];
%                 score = 0;
%                 return
%             end
            
            % Check the size of the content of the s_EEG
            % size of the label should be the same as the number of example
            nombre_channel(l_file) = size(data.s_EEG.data,1);
            nombre_epoch(l_file) = size(data.s_EEG.data,3);
            nombre_label(l_file) = length(data.s_EEG.labels);
            nombre_channel_names(l_file) = length(data.s_EEG.channel_names);
            if isfield(data.s_EEG,'custom_feature')
                nombre_custom_feature_value(l_file) = length(data.s_EEG.custom_feature.feature_value);
                nombre_custom_feature_name(l_file) = length(data.s_EEG.custom_feature.feature_name);
            end
        end
        close(h)
        % takfa modification
        cd([handles.init_parameter.sigma_directory])
        
        
        
        
        if(length(files) > 0.5)
            score = 1;
            message = 'Data are correct';
        else
            score = 0;
            message = 'Data doesn''t contain s_EEG';
        end
        
        %% check the data
        % Subject Should have the same number of electrods
        if size(unique(nombre_channel))>1
            msgbox(['SIGMA >> The number of channel is '...
                'not the same for your subjects '], 'SIGMA Error', 'error');
            score = 0;
            return
        end
        
        % Subject Should have the same number lables with example
        if sum(nombre_epoch) ~= sum(nombre_label)
            msgbox(['SIGMA >> The number of labels is '...
                'not the same as the number of epochs on'...
                ' your subjects '], 'SIGMA Error', 'error');
            score = 0;
            return
        end
        
        % Subject Should have the same number electrode as the name of channels
        if sum(nombre_channel) ~= sum(nombre_channel_names)
            msgbox(['SIGMA >> The number of channel is '...
                'not the same as the channel name on your subject ']...
                , 'SIGMA Error', 'error');
            score = 0;
            return
        end
        
        if isfield(data.s_EEG,'custom_feature')
            if sum(nombre_custom_feature_value) ~= ...
                    sum(nombre_custom_feature_name)
                msgbox(['SIGMA >> The number of custom feature is '...
                    'not the same as the feature name on your subject ']...
                    , 'SIGMA Error', 'error');
                score = 0;
                return
            end
            if sum(nombre_custom_feature_value) ~= sum(nombre_label)
                msgbox(['SIGMA >> The number of custom feature is '...
                    'not the same as the feature name on your subject ']...
                    , 'SIGMA Error', 'error');
                score = 0;
                return
            end
        end
        
        
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