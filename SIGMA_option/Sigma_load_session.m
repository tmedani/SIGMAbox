function Sigma_load_session(varargin)
%%%------------------------------------------------------------------------
% function  Sigma_load_session(varargin)
%  Function task:
%  Load the SIGMA session specified on the input arguement 
%-------------------------------------------------------------------------%
%    Inputs :
%     varargin
%     if nargin = 1 varargin{1} is a string, 
%     in this case varargin{1} is the full path to the name of the session
%     the session will be loaded on the current worksapce 
%     varargin{2} = base    
%     if nargin = 1 varargin{1} is a structure,  
%     in this case varargin{1} is the cs_init_parameter and it contains the
%     nemae of the session to load 
%     the session will be loaded on the current worksapce 
%     varargin{2}='base';
%     nargin = 2 
%     varargin{2} should be the name of the caller (name of the worksapce 
%     caller <==> the name of the function);
%    Outputs :
% 
%    Main Variables
% 
%    Dependencies
% 
%     NB: this code is copyrighted.
%     Please refer to copyright info in the file footer.
%--------------------------------------------------------------------------

%% SECTION 1 : check the input argument


%varargin{1},varargin{2}


if nargin==1 && isstring(varargin{1})
    varargin{2}='base';
end

if nargin==1 && isstruct(varargin{1})
    varargin{1}=fullfile(varargin{1}.full_session_name,...
        [varargin{1}.session_name '.mat']);
    varargin{2}='base';
end


%% Section 2 : Get and check the session & path name
[pathstr,name,ext] = fileparts(varargin{1});

if strcmp(ext,'.mat')
    matlab_file=1;
else
    warning('SIGMA>> The selected data is not a mat File ... ');
    return
end

%% SECTION 3 : Get and assigne the data to the workspace
if  matlab_file == 1
    this_path=pwd;
    if ~isempty(pathstr)
        cd(pathstr)
    end
    session_data=load([name '.mat']);
    field_name = fieldnames(session_data);
    disp('SIGMA>> The loaded session contains the following data : ' )
    for l_name=1:length(field_name)
        display(['         >> ' field_name{l_name}])
        % Get init_parameter
        if strcmp(field_name{l_name},'init_parameter')
            assignin(varargin{2},'init_parameter',...
                session_data.init_parameter')
        end
        % Get init_method
        if strcmp(field_name{l_name},'init_method')
            assignin(varargin{2},'init_method',...
                session_data.init_method')
        end
        % Get features_results
        if strcmp(field_name{l_name},'features_results')
            assignin(varargin{2},'features_results',...
                session_data.features_results')
        end
        % Get performances_results
        if strcmp(field_name{l_name},'performances_results')
            assignin(varargin{2},'performances_results',...
                session_data.performances_results')
        end
        % selected_model
        if strcmp(field_name{l_name},'selected_model')
            assignin(varargin{2},'selected_model',...
                session_data.selected_model')
        end
    end
    
    disp(['SIGMA>> The data are loaded to the : ',...
        varargin{2}, ' Workspace' ])
    cd(this_path)
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