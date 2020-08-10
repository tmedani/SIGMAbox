function [os_analysed_prediction_error] = Classification_performance(i_actual_label,i_predicted_label)
%       
%       INPUT 
%           i_actual_label  = the known labels of every epochs
%           i_predicted_label = the predicted labels of every epochs
%       
%
%        OUTPUT
%           os_analysed_prediction_error = structure with the following
%           fields
%
%               prevalence = the proportion of epochs labeled "+1"
%
%               accuracy = the proportion of epochs correctly classified
% 
%               positive_predictive_value = the proportion of correctly
%                   identified epochs among those classified as "+1" (also
%                   called precision)
%
%               negative_predictive_value = the proportion of correctly
%                   identified epochs among those classified as "-1
%
%               false_discovery_rate = the proportion of wrongly
%                   identified epochs among those classified as "+1"
%
%               false_omission_rate = the proportion of wrongly
%                   identified epochs among those classified as "-1"
%
%               true_positive_rate = the proportion of correctly
%                   identified epochs among those labeled as "+1" (also
%                   called recall or sensitivity)
%
%               true_negative_rate = the proportion of correctly
%                   identified epochs among those labeled as "-1" (also
%                   called specificity)
%
%               false_positive_rate = the proportion of wrongly
%                   identified epochs among those labeled as "-1" (also
%                   called fall-out)
%
%               false_negative_rate = the proportion of wrongly
%                   identified epochs among those labeled as "+1" (also
%                   called miss rate)
%
% 
%               positive_likelihood_ratio = the true positive rate divided
%                   by the false positive rate
%
%               negative_likelihood_ratio = the false negative rate divided
%                   by the true positive rate
% 
%               diagnostic_odds_ratio = the positive likelihood ratio
%                   divided by the negative likelihood ration (the bigger
%                   it is, the best our classification is)
%
%               f1_score = 2/(1/TPR + 1/Precision) (go from 0 to 1, and is
%                   equal to 1 for a perfect TPR and precision)
%
%
%for more info see: Counting_prediction_error and Analyze_prediction_error
%
prediction_error = Counting_prediction_error(i_actual_label,i_predicted_label);
os_analysed_prediction_error = Analyze_prediction_error(prediction_error);

end

