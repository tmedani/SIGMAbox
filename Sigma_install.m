function varargout=Sigma_install()
%% This function add the SIGMA toolbox to the Matlab Path
%%%------------------------------------------------------------------------
% Before you run this function you should be in the SIGMA directory
% varargout=Sigma_install()
% varargout{1}= the current path of Sigma
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


this_path=pwd;
varargout{1}=this_path;
sigma_name=this_path(max(size(this_path))-8:max(size(this_path))); % this is refers to '\SIGMA'

disp('SIGMA>> Installation in progress ... ');

if ispc
    toolbox_name='\SIGMAbox';
    disp('SIGMA>> You are running SIGMA under PC machine ...' );
end
if ismac
    toolbox_name='/SIGMAbox';
    disp('SIGMA>> You are running SIGMA under MAC machine ...' );
end

if strfind(sigma_name, toolbox_name)
    p = path(); % list of all the Matlab paths
    % check the presence of SIGMA
    if isempty(strfind(p, this_path))
        addpath(genpath(this_path));
        disp(['SIGMA>> Adding SIGMA directory ' this_path ' to your Matlab path ...' ]);
        sigma_message=sprintf('SIGMA>> Installation Completed on your computer!');
        msgbox(sigma_message,'SIGMA !','modal');
    else
    %    warning('SIGMA>> SIGMA is already installed on your computer!');
        disp('SIGMA>> SIGMA is already installed on your computer!');
        sigma_message=sprintf('SIGMA>> SIGMA is already installed on your computer!');
        msgbox(sigma_message,'SIGMA Warning !','warn');
    end
else
    sigma_message=sprintf('SIGMA>> You are not in the right directory!!\n Please go to the SIGMA directory...');
    msgbox(sigma_message,'SIGMA Error !','Error');
    error('SIGMA>> You are not in the right directory!! To run this function you should be in the SIGMA directory...');
    
end


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
% % %   Creation Date : 28/04/2015
% % %   Updates and contributors :
% % %       dd/mm/yyyy Contributor description
% % %
% % %   Citation: [creator and contributor names], SigmaBOX, available
% % %   online 2017.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2017
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------