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
    
    [filename,pathname] = uigetfile ;
    % stop the process if no file selected
    if filename==0
        msgbox('No file selected','SIGMA Warning','warn')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
    [~,~,ext] = fileparts(filename);
    % check the format
    if ~strcmp(ext,'.mat')
        msgbox('This file has not the right format (*.mat)','SIGMA Error','error')
        varargout{1}=[];
        varargout{2}=[];
        return
    end
  
    % loading 
    wait_title = 'Load Custom Feature ';
    wait_message = 'Loading ...';
    h_wait = Sigma_waiting(wait_title, wait_message);
    
        FileData=load(fullfile(pathname,filename));
    
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
        else
            feature_result.used_method={init_method(method).method_name};
            feature_result.nb_epochs=size(feature_value,2);
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
    varargout{1}=init_parameter;
    varargout{2}=feature_result;
end

%% Independant use of this function
% use this function just to read the custom features independant from SIGMA
if nargout<2 && nargin<2
    [filename,pathname] = uigetfile ;
    % stop the process if no file selected
    if filename==0
        msgbox('No file selected','SIGMA Warning','warn')
        varargout{1}=[];
        return
    end
    [~,~,ext] = fileparts(filename);
    % check the format
    if ~strcmp(ext,'.mat')
        msgbox('This file has not the right format (*.mat)','SIGMA Error','error')
        varargout{1}=[];
        return
    end
    
    % loading 
    wait_title = 'Load Custom Feature ';
    wait_message = 'Loading ...';
    h_wait = Sigma_waiting(wait_title, wait_message);
    
    FileData=load(filename);
    
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
