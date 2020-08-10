function init_parameter=Sigma_create_session_name(init_parameter)
%%%------------------------------------------------------------------------
%  [init_parameter, session_state] = Sigma_create_session_name(init_parameter)
%
%  Function task:
%  Create the name of the current session for SIGMA,
%  the files generated during the us of SIGMA
%
%  Inputs :
%  init_parameter : structure containing the initial parameters of SIGMA
%
%  Outputs :
%  init_parameter : structure containing the initial parameters of SIGMA
%     init_parameter.session_name=session_name :  name of the session
%     init_parameter.logFilename=logFilename   :  name of the logfile.txt
%     init_parameter.diaryFilename=diaryFilename; name of the diaryfile.txt
%--------------------------------------------------------------------------
%
%
%  Main Variables
%  init_parameter
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


%% Create session from the GUI
if nargin > 0
    if isfield(init_parameter,'default_name')
        default_name = init_parameter.default_name;
    else
        default_name = 1;
    end
else
    default_name = 1;
end

if default_name  ==  1
    session_name = 'default';
    init_parameter.session_name=session_name;
    init_parameter.session_canceled = 0;
else
    prompt = sprintf('Please tape the name of your session (without space) : ');
    [answer, cancel] = inputsdlg(prompt,'SIGMA Create New Session');
    
    if isempty(answer{:})
        % In this case the session creation will be canceled from the gui
        init_parameter.session_canceled = 1;
        session_name=[];
        init_parameter.session_name=session_name;
    elseif cancel==1
        init_parameter.session_canceled = 1;
        session_name=[];
        init_parameter.session_name=session_name;
    else
        % get the name of the session
        session_name = answer{:};
        init_parameter.session_canceled = 0;
        init_parameter.session_name=session_name;
    end
end


% This function creat a session for SIGMA toolbox wit h a name of the
% session and a name of the output file

%% Create/Specify the name of the session/the Log File and the diary File
%     if strcmp(name_session,'default') || strcmp(name_session,'')
session_name=init_parameter.session_name;


if strcmp(session_name,'default')
    str = char(datetime); % creat the name of the output files
    % creat the default session name
    session_name=['Session_' str(1:end-9) '_' str(end-7:end-6) str(end-4:end-3) str(end-1:end)];
    init_parameter.session_name=session_name;
else
    init_parameter.session_name=init_parameter.session_name;
end


full_session_name = fullfile(init_parameter.sigma_directory, init_parameter.data_output,...
    init_parameter.session_name);
init_parameter.full_session_name = full_session_name;

% Create the name of the
% log file name
logFilename=['Sigma_logFile_' session_name '.txt'];
% diary file name
diaryFilename=['Sigma_diaryFile_' session_name '.txt'];
%% Save in the initialisation parameters
init_parameter.session_name=session_name;
init_parameter.logFilename=logFilename;
init_parameter.diaryFilename=diaryFilename;
end
%%
% % %----------------------------------------------------------------------
% % %         Brain Computer Interface team
% % %
% % %              _---~~(~~-_.
% % %             _{    )  )
% % %            ,  ) -~~- ( ,-' )_
% % %            ( `-,_..`., )-- '_,)
% % %           ( ` _) ( -~( -_ `, }
% % %           (_- _ ~_-~~~~`, ,' )
% % %            `~ -^(  __;-,((()))
% % %               ~~~~ {_ -_(())
% % %                   `\ }
% % %                    { }
% % %  File created by Takfarinas MEDANI
% % %  Creation Date : 30/05/2017
% % %  Updates and contributors :
% % %  30/01/2017, T MEDANI : Updating and adding options
% % %
% % %  Citation: [creator and contributor names], comprehensive BCI
% % %       toolbox, available online 2016.
% % %
% % %  Contact info : francois.vialatte@espci.fr
% % %  Copyright of the contributors, 2016
% % %  Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
