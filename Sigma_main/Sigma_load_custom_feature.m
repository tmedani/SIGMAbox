function varargout=Sigma_load_custom_feature(init_parameter,init_method,feature_result)
%
% function [init_parameter,feature_result]=Sigma_load_custom_feature(init_parameter,init_method)
% or
% function [init_parameter,feature_result]=Sigma_load_custom_feature(init_parameter,init_method,feature_result)
% or
% dataout= Sigma_load_custom_feature
% in the last version the output is
%   dataout.feature_value
%   dataout.feature_name
%   dataout.labels
% the first version could be used for a standlone use
% the seconde version is used in the case of concatenation between features
% computed inside SIGMA toolbox.
% Sigma function to load the costum feature computed outside of SIGMA
% toolbox.
% Inputs : init_parameter & init_method and feature_result (in the case of concatenation)
% Outputs : init_parameter,feature_result
% Refers to the main functions for more details
% This function load costum feature observed or computed outside of the
% main sigma toolbox.
% The loaded feature must be stored in a mat file containing t leats these
% fields
% 'feature_value' : matrix containing the feature withe size of NxM
% where N is the number of feature
%       M the number of examples (epochs)
% 'feature_name' : cells containin the name of the features with the size of
% 1xN
% 'labels' : the labels or the expected otput of the features with the same
% size of the examples (1xM)
% By default, the number 99 is chosen to the method in the SIGMA structure,
% so this number is reserved for this method (it considered as a feature extraction method number 99)

% TODO : % This function could be simplified by reducing the input and
% output arguments

if nargout==2
    % in the case feature_result is not fournished,
    if nargin==2
        feature_result=[];
    end
    
    %[filename,pathname] = uigetfile ;
    [filename,pathname] = uigetfile({'*.mat';'*.xlsx';'*.*'},'Select custom feature file');
    % stop the process if no file selected
    if filename==0
        msgbox('No file selected','SIGMA Warning','warn')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    %% Select file
    [~,~,ext] = fileparts(filename);
    % check the format
    if ~(strcmp(ext,'.mat') || strcmp(ext,'.xls') || strcmp(ext,'.xlsx')|| strcmp(ext,'.csv'))
        msgbox('This file has not the right format (*.mat)','SIGMA Error','error')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    
    % loading
    wait_title = 'Load Custom Feature ';
    wait_message = 'Loading ...';
    h_wait = Sigma_waiting(wait_title, wait_message);
    % matlab mat file
    if strcmp(ext,'.mat')
        FileData=load(fullfile(pathname,filename));
    end
    % add here csv and text files
    if strcmp(ext,'.csv')
        %M = csvread(filename);
        % it much better to read table
        data = readtable(filename,'ReadVariableNames',false);
        %x0 = data{2:end,2:end-1};
        C = table2cell(data);
        %A = table2array(data);
        example_name = C(2:end,1);
        feature_name = C(1,2:end-1);
        feature_value = C(2:end,2:end-1)';
        feature_value = str2double(feature_value);
        label = C(2:end,end)';
        label = str2double(label);
        FileData.feature_value = feature_value;
        FileData.feature_name = feature_name;
        FileData.example_name = example_name;
        FileData.label = label;
    end
    % excel or other format here
    if strcmp(ext,'.xlsx') || strcmp(ext,'.xls')
        % Get the info about the exel file
        [~,sheets] = xlsfinfo(filename);
        % select the sheet that the user want to read
        if length(sheets)>1
            [sheet_id,ok_load] = listdlg('PromptString','Select one excel sheet:',...
                'SelectionMode','single',...
                'InitialValue',1,...
                'Name', 'Select file',...
                'ListString',sheets,...
                'OKString','Load this sheet');
                 
            % check if the data loading is canceled
            if ok_load == 0
                msgbox('No data loaded','SIGMA Cancel','warn')
                varargout{1}=[];
                varargout{2}=[];
                delete(h_wait)
                cd(init_parameter.sigma_directory)
                return
            end
        else
            sheet_id = 1;
        end
        
        T  = readtable(filename,'Sheet',sheets{sheet_id},'ReadVariableNames',false);
        data = T ;
        %x0 = data{2:end,2:end-1};
        C = table2cell(data);
        %A = table2array(data);
        example_name = C(2:end,1);
        feature_name = C(1,2:end-1);
        feature_value = C(2:end,2:end-1)';
        feature_value = str2double(feature_value);
        label = C(2:end,end)';
        label = str2double(label);
        FileData.feature_value = feature_value;
        FileData.feature_name = feature_name;
        FileData.example_name = example_name;
        FileData.label = label;
%                 
%         % find the value of nana in num
%         [row, col] = find(isnan(num));
%         
%         feature_value = raw(2:end,2:end-1)';
%         feature_value = str2double(feature_value);
%         
%         feature_value = num(:,1:end-1)';
%         feature_name = txt(1,2:end-1);
%         example_name = txt(2:end,1);
%         label = num(:,end)';
%         FileData.feature_value = feature_value;
%         FileData.feature_name = feature_name;
%         FileData.example_name = example_name;
%         FileData.label = label;
    end
    delete(h_wait)
    %guidata(hObject, handles);
    cd(init_parameter.sigma_directory)
    % check the data
    if ~(isfield(FileData,'feature_name') && isfield(FileData,...
            'feature_value') && isfield(FileData,'label'))
        msgbox('This file does not contain the required data','SIGMA Error','error')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    
    
    % Get the data
    feature_value=FileData.feature_value;
    feature_name=FileData.feature_name;
    label=FileData.label;
    
    if isfield(FileData,'feature_result')
        feature_result=FileData.feature_result;
        
    else
        method=99; % the affilied value for the custom method
        feature_result.o_custom_feature_data = feature_value;
        feature_result.o_custom_feature_data_band = ...
            repmat([method nan nan],size(feature_value,1),1);
        %feature_result.o_custom_feature_band(:,2) = ...
        %feature_result.o_time_energy_band(:,2);
        feature_result.o_custom_feature_data_band(:,2) = ...
            1:size(feature_value,1);
        feature_result.o_custom_feature_data_name = feature_name;
    end
    
    if isfield(FileData,'init_parameter')
        init_parameter=FileData.init_parameter;
        % add the loaded method
    else
        method=99; % the affilied value for the custom method
        init_parameter.method=sort(unique([init_parameter.method method]));
        
        if isfield(feature_result,'used_method')
            feature_result.used_method=[feature_result.used_method; ...
                {init_method(method).method_name}];
            feature_result.nb_epochs=size(feature_value,2);
            feature_result.nb_epoch=size(feature_value,2);
            feature_result.label=label;
        else
            feature_result.used_method={init_method(method).method_name};
            feature_result.nb_epochs=size(feature_value,2);
            feature_result.nb_epoch=size(feature_value,2);
            feature_result.label=label;
        end
    end
    
    % check the size of the feature
    if isfield(feature_result,'label')
        if ~isfield(feature_result,'AM_Load_custom_feature')
            if length(label)~=size(feature_result.label,2)
                msgbox(['The size of the loaded data (' num2str(length(label)) ...
                    ') does not match with your session''s' ' data (size ' ...
                    num2str(length(feature_result.label)) ')' ],'SIGMA Error','error');
                varargout{1}=[];
                varargout{2}=[];
                return
            end
        end
    end
    
    init_parameter.custom_feature_full_name = fullfile(pathname,filename);
    
    % adaptation de feature results  25/05/2018
    %     feature_result.nb_epochs = size(feature_result.o_custom_feature_data,2);
    %     feature_result.nb_epoch = feature_result.nb_epochs;
    %     feature_result.label = label;
    %     feature_result.o_features_matrix =  feature_result.o_custom_feature_data;
    %% a verifier avec apply model load custom matrix
    varargout{1}=init_parameter;
    varargout{2}=feature_result;
end

%% Independant use of this function
% use this function just to read the custom features independant from SIGMA
if nargout<2 && nargin<2
    
    %     [filename,pathname] = uigetfile ;
    [filename,pathname] = uigetfile({'*.mat';'*.xlsx';'*.*'},'Select custom feature file');
    
    % stop the process if no file selected
    if filename==0
        msgbox('No file selected','SIGMA Warning','warn')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    %% Select file
    [~,~,ext] = fileparts(filename);
    % check the format
    if ~(strcmp(ext,'.mat') || strcmp(ext,'.xls') || strcmp(ext,'.xlsx'))
        msgbox('This file has not the right format (*.mat)','SIGMA Error','error')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    
    % loading
    wait_title = 'Load Custom Feature ';
    wait_message = 'Loading ...';
    h_wait = Sigma_waiting(wait_title, wait_message);
    % matlab mat file
    if strcmp(ext,'.mat')
        FileData=load(fullfile(pathname,filename));
    end
    % excel or other format here
    if strcmp(ext,'.xlsx') || strcmp(ext,'.xls')
        filename = 'observation_custom.xlsx';
        [num,txt,~]  = xlsread(filename);
        feature_value = num(:,1:end-1)';
        feature_name = txt(1,2:end-1);
        example_name = txt(2:end,1);
        label = num(:,end)';
        FileData.feature_value = feature_value;
        FileData.feature_name = feature_name;
        FileData.example_name = example_name;
        FileData.label = label;
    end
    delete(h_wait)
    %guidata(hObject, handles);
    
    % check the data
    if ~(isfield(FileData,'feature_name') && isfield(FileData,'feature_value') && isfield(FileData,'label'))
        msgbox('This file does not contain the required data','SIGMA Error','error')
        varargout{1}=[];
        return
    end
    
    % Get the data
    feature_value=FileData.feature_value;
    feature_name=FileData.feature_name;
    label=FileData.label;
    varargout{1}.feature_value=feature_value;
    varargout{1}.feature_name=feature_name;
    varargout{1}.label=label;
    varargout{1}.custom_feature_full_name = fullfile(pathname,filename);
end


end

% % numérotation of the features
%     feature_name=[];
%         for k=1:size(feature_result.o_features_matrix,2)
%         temp_var = strcat( 'feat_',num2str(k,2) );
%         feature_name=[feature_name;{temp_var}];
%         end
