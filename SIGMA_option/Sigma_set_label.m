function [origin_label, new_label]=Sigma_set_label(label)
%%%------------------------------------------------------------------------
%  [origin_label, new_label]=Sigma_set_label(label)
%
%   Function task:
%  This function transforms the lables of epochs to -1 and 1,
%
%   Inputs :
%  
%
%   Outputs :%
%   
%
%--------------------------------------------------------------------------
%
%
%   Main Variables
%
%
%   Dependencies

%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


%% Set the labels to "-1" and "1"
origin_label=label;%labels=origin_labels
temp=label;
temp=unique(temp);

if isempty(temp)
    disp('SIGMA Error : There is no labels, please check your data ...')
    new_label=temp;
    return
end
if length(temp)>2
    disp('SIGMA Error : There is more than 2 labels, this version is not addapted for your data ...')
    new_label=temp;
    return
end

if length(temp)==2
    %% TODO : use also labels as char not only numbers! DONE ?
    %class_label= class(temp)
    %      if strcmp(class_label,'cell')
    if iscell(temp)
        ind1=(find(strcmp(labels,temp(1))));
        ind2=(find(strcmp(labels,temp(2))));
        
        x(ind1)=-1;
        x(ind2)=1;
        label=x;
    else
        label(label==temp(1))=-1;
        label(label==temp(2))=1;
    end
    new_label=label;
end

end

%%
% % %----------------------------------------------------------------------
% % %                  Brain Computer Interface team
% % %
% % %                            _--- ~ ~( ~ ~-_.
% % %                          _{        )   )
% % %                        ,   ) - ~ ~- ( ,-' )_
% % %                       (  `-,_..`., )-- '_,)
% % %                      ( ` _)  (  - ~( -_ `,  }
% % %                      (_-  _   ~_- ~ ~ ~ ~`,  ,' )
% % %                        ` ~ -^(    __;-,((()))
% % %                               ~ ~ ~ ~ {_ -_(())
% % %                                     `\  }
% % %                                       { }
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 10/10/2016
% % %   Updates and contributors :
% % %   29/01/2018, T. MEDANI : updating the format
% % %
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------