function [ score, files, message] = AM_data_compatibility(handles)

% If data path is not correct
if( isempty(handles.init_parameter.application_data_location) > 0.5)
    score = 0;
    message = 'no file path selected';
    files = [];
    disp('no file path selected')
    
    % if data format is .mat
else
    % determination of file format
    files = dir( [handles.init_parameter.application_data_location, '*.mat']);
    % Takfa modification
    cd([handles.init_parameter.sigma_directory])
    cd([handles.init_parameter.application_data_location])
    %sigma_directory
    if( length(files) < 0.5 ) % if no file in .mat format
        score = 0;
        message = 'data are not in the .mat format';
        disp('data are not in the .mat format')
    else
        % Select only the relevant files
        h = waitbar(0,'Data loading...','Name','SIGMA : Data Loading');
        for cF = length(files):-1:1            
            files(cF).name
            data = load(files(cF).name, 's_EEG');
            waitbar((length(files) - cF)/length(files),h,['Data loading... subject ' num2str(length(files)-cF) '/' num2str(length(files))])
            if (numel(fieldnames(data)) < 0.5)
                files(cF) = [];
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
    end
    
end