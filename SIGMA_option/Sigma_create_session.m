function [init_parameter, session_state] = Sigma_create_session(init_parameter)
%%%------------------------------------------------------------------------
%  [init_parameter, session_state] = Sigma_create_session(is_init_parameter)
%
%  Function task:
%  Create the folder for the current session for SIGMA,
%  the files generated during the us of SIGMA
%  Inputs :
%  init_parameter : structure containing the initial parameters of SIGMA
%
%  Outputs :
%  init_parameter : structure containing the initial parameters of SIGMA
%  session_state : string used as message to confirm or not the creation of
%  the folder
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


% Create the name of the session
init_parameter = Sigma_create_session_name(init_parameter);


cd(init_parameter.sigma_directory)
cd(init_parameter.data_output)
if ~isdir((init_parameter.session_name))
    mkdir(init_parameter.session_name)
    session_state = 'session folder is created';
else
    session_state = 'session folder already exists';
end
cd(init_parameter.sigma_directory)

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