function estimate = Platt_scaling(ic_model)
  
% platt_logistic = @(platt_a, platt_b)...
%     1 ./ (1 + exp(platt_a * ic_model.Y + platt_b));
% estimate = mle(ic_label,'pdf',platt_logistic,'start',[1 0]);

normalized = ic_model.Y;
n_plus = sum(normalized == 1);
n_minus = sum(normalized == -1);
t_plus = (n_plus + 1) / (n_plus + 2);
t_minus = 1 / (n_minus + 2);
normalized(find(normalized == 1)) = t_plus;
normalized(find(normalized == -1)) = t_minus;
out_class = predict(ic_model, ic_model.X);
out_class(find(out_class == -1)) = 0;
coeff = glmfit(out_class, normalized, 'binomial', 'link', 'logit');
platt_a = -coeff(2);
platt_b = -coeff(1);
transformation.Type = 'sigmoid';
transformation.Slope = platt_a;
transformation.Intercept = platt_b;
estimate = eval(sprintf('@(S)sigmoid(S,%e,%e)',platt_a, platt_b));
end

function out = sigmoid(in,a,b) %#ok<DEFNU>
out = zeros(size(in));
out(:,2) = 1./(1+exp(a*in(:,2)+b));
out(:,1) = 1 - out(:,2);
end