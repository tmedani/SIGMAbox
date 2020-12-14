function o_output = Sigma_fitcsvm_finale(ic_data, ic_label, svm_parameter_in)

% 'ic_data' input features for training
% 'ic_label' classification label for training
% 'parameter' : structure containing the hyper parameters

%% initializations from the GUI ot from init parameters
% modifiable hyperparameters, getting from the GUI
c_kernel = svm_parameter_in.c_kernel;
%c_kernel = {'rbf'};%{'linear'; 'polynomial'; 'rbf'}; % Type of kernels tested

c_gaussian_value=svm_parameter_in.c_gaussian_value;
%c_gaussian_value = 0.5:0.5:4; % Gaussian kernel std range %% ONLY for the RBF kernel

c_polynomial_value=svm_parameter_in.c_polynomial_value;
%c_polynomial_value = 2:5; % Polynomial kernel degree range %% ONLY for Polynomial kernel

c_constraint=svm_parameter_in.c_constraint;
%c_constraint = [0.1:0.1:0.5 1 : 5]; % Soft margin hyperparameter range

% stability check variables
c_tolkkt=svm_parameter_in.c_tolkkt;
%c_tolkkt = 5e-2; % KKT tolerance
c_cost1 = sum(ic_label == 1);
c_cost2 = sum(ic_label == -1);
%c_classname = [-1 1];
c_class=unique(ic_label);
c_classname = [c_class(1) c_class(2)];

c_cost = [0 (c_cost1 / (c_cost1 + c_cost2));...
    (c_cost2 / (c_cost1 + c_cost2)) 0];

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
for l_constraint = 1 : length(c_constraint)
    % loop over the kernels is not necessary here because
    length(c_kernel)
    for l_kernel = 1 : length(c_kernel)
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
        %display(['You have selected the "' c_kernel0 '" kernel for your SVM'])
        % loop over condition
        for l_condition = 1 : condition
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
%             % test pour le LOSO
%             if length(ic_newdata)>1
%                 % ref to https://fr.mathworks.com/help/stats/compactclassificationsvm.predict.html#bt79dhd-1
%                 model = fitSVMPosterior(model);
%                 [label,score] = predict(model,ic_newdata);     
%             end
%             if length(ic_newdata)==1              
%                  model = fitSVMPosterior(model);
%                 [label,score] = predict(model,ic_newdata);
%             end
            % Compute the performance of the model
            
             model_out{l_constraint, l_condition} = model;
             
             estimate = Platt_scaling(model);
             fitmodel = model;
             fitmodel.ScoreTransform = estimate;
             fitmodel.ScoreType = 'probability';
             
%              model_compact = compact(model);
%              fitmodel = Sigma_fitSVMPosterior(model_compact, ic_data, ic_label);
% % %              fitmodal = Sigma_fitSVMPosterior(model);
             fitmodel_out{l_constraint, l_condition} = fitmodel;
            % ********* Do it from external function            
% % %             model = fitSVMPosterior(model);
% % %             [label,score] = predict(model,ic_newdata);            
% % %             correct = sum(ic_newlabel(:) == label(:)) ./ length(label);
% % %             prediction{l_constraint, l_condition} = correct;
% % %             score_out{l_constraint, l_condition} = score;
% % %             label_predicted{l_constraint, l_condition}=label;
        end; % loop over the condition
    end % loop over the kernels
end % loop over the constraint

o_output.model = model_out;
o_output.fitmodel = fitmodel_out;
% o_output.prediction = prediction;
% o_output.score = score_out;
% o_output.label_predicted=label_predicted;
% 
% o_output.param_svm.c_kernel=c_kernel0;
% o_output.param_svm.c_gaussian_value=condition;
% o_output.param_svm.c_classname=c_classname;
% o_output.param_svm.c_cost=c_cost;
% o_output.param_svm.c_tolkkt=c_tolkkt;

end