function [o_model] = Sigma_fitcsvm2(ic_data, ic_label)

% 'ic_data' input features
% 'ic_label' classification label

%% initializations
% modifiable hyperparameters
c_kernel = {'linear'; 'polynomial'; 'rbf'}; % Type of kernels tested
c_gaussian_value = 0.5:0.5:4; % Gaussian kernel std range %% ONLY for the RBF kernel
c_polynomial_value = 2:5; % Polynomial kernel degree range %% ONLY for Polynomial kernel

c_constraint = [0.1:0.1:0.5 1 : 5]; % Soft margin hyperparameter range
c_cost1 = sum(ic_label == 1);
c_cost2 = sum(ic_label == -1);
c_classname = [-1 1];
c_cost = [0 (c_cost2 / (c_cost1 + c_cost2));...
    (c_cost1 / (c_cost1 + c_cost2)) 0];

% stability check variables
c_tolkkt = 5e-2; % KKT tolerance

% internal variables (not available for modification to the end user)
sample_class1 = sum(ic_label == 0);
sample_class2 = sum(ic_label == 1);
total_sample = sample_class1 + sample_class2;

%% learning loop
for l_constraint = 1 : length(c_constraint),
    disp([ 'Constraint = ', num2str( c_constraint(l_constraint) ) ]);
    for l_kernel = 1 : length(c_kernel),
        if (strcmp(c_kernel{l_kernel}, 'polynomial') == 1)
            condition = length(c_polynomial_value);
        else
            if (strcmp(c_kernel{l_kernel}, 'rbf') == 1)
                condition = length(c_gaussian_value);
            else
                condition = 1;
            end
        end
        kernel = c_kernel{l_kernel};
        for l_condition = 1 : condition,            
            if (strcmp(c_kernel{l_kernel}, 'polynomial') == 1)
                model = fitcsvm(ic_data, ic_label,...
                    'KernelFunction', 'polynomial',...
                    'PolynomialOrder', c_polynomial_value(l_condition),...
                    'BoxConstraint', c_constraint(l_constraint),...
                    'KKTTolerance', c_tolkkt, ...
                    'ClassNames', c_classname,...
                    'Cost', c_cost);
            else
                if (strcmp(c_kernel{l_kernel}, 'rbf') == 1)
                    model = fitcsvm(ic_data, ic_label,...
                        'KernelFunction', 'rbf',...
                        'KernelScale', c_gaussian_value(l_condition),...
                        'BoxConstraint', c_constraint(l_constraint),...
                        'KKTTolerance', c_tolkkt, ...
                        'ClassNames', c_classname,...
                        'Cost', c_cost);
                else
                    model = fitcsvm(ic_data, ic_label,...
                        'KernelFunction', c_kernel{l_kernel},...
                        'BoxConstraint', c_constraint(l_constraint),...
                        'KKTTolerance', c_tolkkt, ...
                        'ClassNames', c_classname,...
                        'Cost', c_cost);
                end
            end
            % outputs
            %[label, score] = predict(model, ic_newdata);
            %correct = sum(ic_newlabel == label) ./ length(label);
            o_model{l_constraint, l_kernel, l_condition} = model;
            %o_result{l_constraint, l_kernel, l_condition} = correct;
            %o_score{l_constraint, l_kernel, l_condition} = score;
        end;
    end
end