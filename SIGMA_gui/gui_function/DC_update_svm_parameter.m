function handles = DC_update_svm_parameter(handles, hObject)
%%%------------------------------------------------------------------------
%   handles = DC_update_svm_parameter(handles, hObject)
%
%   Function task:
%   Update the SVM method parameters in init_parameter structure according
%   to user choice
%   
%   Inputs :
%   handles : structure containing GUI informations
%   hObject : necessary for the GUI management
%
%   Outputs : 
%       
%   handles : structure containing GUI informations
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
%% Kernel selection
% get the selected kernels
kernel_button(1) = get(handles.SVME_cb_linear, 'Value');
kernel_button(2) = get(handles.SVME_cb_quadratic, 'Value');
kernel_button(3) = get(handles.SVME_cb_polynomial, 'Value');
kernel_button(4) = get(handles.SVME_cb_rbf, 'Value');

% initialize the selected kernel list
kernel_selected = cell(1, length(kernel_button));
% Determine if kernels are selected or not
for cK = 1:length(kernel_selected)
    if(kernel_button(cK) == 1)
        kernel_selected{cK} = handles.kernel_list{cK};
    else
        kernel_selected{cK} = [];
    end
end
% remove empty cell of array ( kenel not selected)
kernel_selected = kernel_selected(~cellfun('isempty',kernel_selected));
% Assign kernel result
handles.input.c_kernel = kernel_selected;

%% Set the condition value (Rajouter Takfarinas)
% 
% if (strcmp(kernel_selected, 'polynomial')  ==  1)
%     condition = length(c_polynomial_value);
% else
%     if (strcmp(kernel_selected, 'rbf')  ==  1)
%         condition = length(c_gaussian_value);
%     else % the case of the 'linear'
%         condition = 1;
%     end
% end


%% Gaussian value
% get the edit box values
handles.input.c_gaussian_value = str2num(get(handles.SVME_edit_GV_low, 'String')):str2num(get(handles.SVME_edit_GV_step, 'String')):str2num(get(handles.SVME_edit_GV_high, 'String'));
%% polynomial value
% get the edit box values
handles.input.c_polynomial_value = str2num(get(handles.SVME_edit_PV_low, 'String')):str2num(get(handles.SVME_edit_PV_step, 'String')):str2num(get(handles.SVME_edit_PV_high, 'String'));
%% hyper parameter
% get the edit box values
handles.input.c_constraint = str2num(get(handles.SVME_edit_cons_low, 'String')):str2num(get(handles.SVME_edit_cons_step, 'String')):str2num(get(handles.SVME_edit_cons_high, 'String'));

%% KKT
% get tolkkt value
tolkkt = str2num(get(handles.SVME_edit_kkttol, 'String'));
% set the value of tolkkt at 0.05 of the input is negative
if(tolkkt <= 0)
    handles.input.c_tolkkt = 0.05;
    set(handles.SVME_edit_kkttol, 'String', '0.05');
else % set the value
    handles.input.c_tolkkt = tolkkt;
end

% get violation value
violation = str2num(get(handles.SVME_edit_violation, 'String'));
if(violation <= 0) % set the value of vilation at 0.01 of the input is negative
    handles.input.c_violation = 0.01;
    set(handles.SVME_edit_violation, 'String', '0.01');
else % set the value
    handles.input.c_violation = violation;
end

%% Optimization
% get the value
retest = str2num(get(handles.SVME_edit_retest, 'String'));
if(retest < 0.5)
    handles.input.c_retest = 1;
    set(handles.SVME_edit_retest, 'String', '1');
else % set the value
    handles.input.c_retest = retest;
end

% get the value
stability = str2num(get(handles.SVME_edit_stability, 'String'));
if(stability < 0.5)
    handles.input.c_stability = 30;
    set(handles.SVME_edit_stability, 'String', '30')
else % set the value
    handles.input.c_stability_test =  stability;
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










