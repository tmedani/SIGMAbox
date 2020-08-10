function o_output = Sigma_fitcsvm_gui(ic_data, ic_label,ic_newdata,ic_newlabel)
%%%------------------------------------------------------------------------
%   o_output = Sigma_fitcsvm_gui(ic_data, ic_label,ic_newdata,ic_newlabel)
%
%   Function task:
%   
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
% 'ic_data' input features for training
% 'ic_label' classification label for training
% 'ic_newdata'  : data for validation
% 'ic_newlabel' : labels for validation
%% initializations
% modifiable hyperparameters, getting from the GUI
c_kernel = {'rbf'}%{'linear'; 'polynomial'; 'rbf'}; % Type of kernels tested
c_gaussian_value = 0.5:0.5:4; % Gaussian kernel std range %% ONLY for the RBF kernel
c_polynomial_value = 2:5; % Polynomial kernel degree range %% ONLY for Polynomial kernel

c_constraint = [0.1:0.1:0.5 1 : 5]; % Soft margin hyperparameter range

c_cost1 = sum(ic_label == 1);
c_cost2 = sum(ic_label == -1);
%c_classname = [-1 1];
c_class = unique(ic_label);
c_classname = [c_class(1) c_class(2)];

c_cost = [0 (c_cost2 / (c_cost1 + c_cost2));...
    (c_cost1 / (c_cost1 + c_cost2)) 0];

% stability check variables
c_tolkkt = 5e-2; % KKT tolerance


% internal variables (not available for modification to the end user)
% sample_class1 = sum(ic_label == 0);
% sample_class2 = sum(ic_label == 1);
sample_class1 = sum(ic_label == c_class(1));
sample_class2 = sum(ic_label == c_class(2));
total_sample = sample_class1 + sample_class2;
if total_sample~=length(ic_label)
    error('SIGMA>> There is an error in the classe definition')
end

%% learning loop
% loop over the constraint
for l_constraint = 1 : length(c_constraint),
    % loop over the kernels is not necessary here because
    % length(c_kernel)=1
    for l_kernel = 1 : length(c_kernel),
        if (strcmp(c_kernel{l_kernel}, 'polynomial') == 1)
            condition = length(c_polynomial_value);
        else
            if (strcmp(c_kernel{l_kernel}, 'rbf') == 1)
                condition = length(c_gaussian_value);
            else % the case of the 'linear'
                condition = 1;
            end
        end
        % the selected kernel is c_kernel0
        c_kernel0 = c_kernel{l_kernel};
        display(['You have selected the "' c_kernel0 '" kernel for your SVM'])
        % loop over condition
        for l_condition = 1 : condition,
           if (strcmp(c_kernel0, 'polynomial') == 1)
                model = fitcsvm(ic_data, ic_label,...
                    'KernelFunction', 'polynomial',...
                    'PolynomialOrder', c_polynomial_value(l_condition),...
                    'BoxConstraint', c_constraint(l_constraint),...
                    'KKTTolerance', c_tolkkt, ...
                    'ClassNames', c_classname,...
                    'Cost', c_cost);
            else
                if (strcmp(c_kernel0, 'rbf') == 1)
                    model = fitcsvm(ic_data, ic_label,...
                        'KernelFunction', 'rbf',...
                        'KernelScale', c_gaussian_value(l_condition),...
                        'BoxConstraint', c_constraint(l_constraint),...
                        'KKTTolerance', c_tolkkt, ...
                        'ClassNames', c_classname,...
                        'Cost', c_cost);
                else
                    model = fitcsvm(ic_data, ic_label,...
                        'KernelFunction', c_kernel0,...
                        'BoxConstraint', c_constraint(l_constraint),...
                        'KKTTolerance', c_tolkkt, ...
                        'ClassNames', c_classname,...
                        'Cost', c_cost);
                    
                end
            end
            % test pour le LOSO
            if length(ic_newdata)>1
                % ref to https://fr.mathworks.com/help/stats/compactclassificationsvm.predict.html#bt79dhd-1
                model = fitSVMPosterior(model);
                [label,score] = predict(model,ic_newdata);

%             model=compact(model);
%             model = fitPosterior(model, ic_data, ic_label);
%             [label, score] = predict(model, ic_newdata);            
            end
            if length(ic_newdata)==1
            %% marche pour loeo
            % compute the score refers to https://fr.mathworks.com/help/stats/perfcurve.html
%             model = fitPosterior(model);
%             [~,score] = resubPredict(model); % compre the resturned lables from resubPredict and predict
%             [label, ~] = predict(model, ic_newdata);            
                 model = fitSVMPosterior(model);
                [label,score] = predict(model,ic_newdata);
            end
            
            correct = sum(ic_newlabel(:) == label(:)) ./ length(label);
            model_out{l_constraint, l_condition} = model;
            prediction{l_constraint, l_condition} = correct;
            score_out{l_constraint, l_condition} = score;
            label_predicted{l_constraint, l_condition}=label;
        end; % loop over the condition
    end % loop over the kernels
end % loop over the constraint

o_output.model = model_out;
o_output.prediction = prediction;
o_output.score = score_out;
o_output.label_predicted = label_predicted;
% 
% o_output.param_svm.c_kernel=c_kernel0;
% o_output.param_svm.c_gaussian_value=condition;
% o_output.param_svm.c_classname=c_classname;
% o_output.param_svm.c_cost=c_cost;
% o_output.param_svm.c_tolkkt=c_tolkkt;

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