function handles = Sigma_load_sessionGUI(session_name, handles, hObject)
%function [varargout]=Sigma_load_session(session_name)
%%%------------------------------------------------------------------------
% session_name : contain all the path and the name of the file to load
% example :
% session_name='C:\Users\Takfarinas\Documents\Session_21-Jun-2017_dataTests\dataTests.mat';

%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------
[pathstr,name,ext] = fileparts(session_name);

if strcmp(ext,'.mat')
    path_data = fullfile(pathstr,[name '.mat']);
    session_data = load(path_data,'init_parameter');
    stack = dbstack('-completenames');
    mfile_location = stack(1).file;
    sigma_directory = mfile_location(1:end-47);   
    
    if isdir(session_data.init_parameter.sigma_directory)
        %cd(session_data.init_parameter.sigma_directory)
        data_location = session_data.init_parameter.data_location;
    else % adapter le nom de la session au nouveau PC
        msg = sprintf(['This session is not processed in your computer.\n'...
            'Data may be missing in your computer for this session.\n'...
            'Would you specify path for the data of this session? ']);
        answer = questdlg(msg, ...
            'Data of your Session', ...
            'Without data','With data','Without data');
        % Handle response
        switch answer
            case 'Without data' % adapt it to the current computer
                
                if ispc
                    data_location = fullfile(sigma_directory,...
                        'SIGMA_data\');
                end
                if ismac
                    data_location = fullfile(sigma_directory,...
                        'SIGMA_data/');
                end;
            case 'With data'
                %sigma_directory = handles.init_parameter.sigma_directory;
                data_location = uigetdir();
        end
    end
    %% Loading the data
    wait_title = 'Loading Session';
    wait_message = 'Session is loading...';
    h_wait = Sigma_waiting(wait_title, wait_message);
        session_data = load(path_data);    
    delete(h_wait)    
    disp(session_data)
    names = fieldnames(session_data);
    disp('SIGMA>> The loaded session contains the following data : ' )
    for ind=1:length(names)
        display(['         >> ' names{ind}])
    end
        
    handles.init_parameter = session_data.init_parameter;
    handles.init_method = session_data.init_method;
    handles.feature_result = session_data.feature_result;
    handles.performance_result = session_data.performance_result;
    handles.selected_model = session_data.selected_model;
    
    full_session_name = fullfile(sigma_directory, ...
        handles.init_parameter.data_output,...
        handles.init_parameter.session_name);
    handles.init_parameter.data_location = data_location;
    handles.init_parameter.full_session_name = full_session_name;
    handles.init_parameter.sigma_directory = sigma_directory;
    
    cd(handles.init_parameter.sigma_directory)
    handles.sigma_load_session = 1;
    guidata(hObject, handles);
else
    warning('SIGMA>> The selected data is not a mat File ... ');
    handles.sigma_load_session = 0;
    return
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
% % %   File created by T. MEDANI
% % %   Creation Date : 22/06/2017
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], SigmaBOX, available
% % %   online 2017.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2017
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
