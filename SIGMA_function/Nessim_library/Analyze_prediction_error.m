function [os_analysed_prediction_error] = Analyze_prediction_error(is_prediction_error)
%This function computes performance indicators based on the counting of
%error
%   
%The input of this function can be compute by the function
%Counting_prediction_error
%
%
%      INPUT
%           is_prediction_error = structure with the following fields:
%
%               number_of_epochs = total number of epochs
%
%               positive_epochs = number of epochs labeled "+1"
%               negative_epochs = number of epochs labeled "-1"
%   
%               positive_prediction = number of epochs predicted "+1"
%               negative_prediction = number of epochs predicted "-1"
%
%               true_positive = number of true positive result
%               true_negative = number of true negative result
%               false_positive = number of false positive error
%               false_negative = number of false negative error
%
%       OUTPUT
%           os_analysed_prediction_error = structure with the following
%           fields
%
%               prevalence = the proportion of epochs labeled "+1"

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

%               false_positive_rate = the proportion of wrongly
%                   identified epochs among those labeled as "-1" (also
%                   called fall-out)

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
%for more info : https://en.wikipedia.org/wiki/Confusion_matrix

%% Section 1: Data extraction
% Extract the data from the input structure

v_number_of_epochs = is_prediction_error.number_of_epochs;

v_positive_epochs = is_prediction_error.positive_epochs;
v_negative_epochs = is_prediction_error.negative_epochs;

v_positive_prediction = is_prediction_error.positive_prediction;
v_negative_prediction = is_prediction_error.negative_prediction;

v_true_positive = is_prediction_error.true_positive;
v_true_negative = is_prediction_error.true_negative;

v_false_positive = is_prediction_error.false_positive;
v_false_negative = is_prediction_error.false_negative;

%% Section 2 : Computation 
%Compute the different performance indicators

prevalence = v_positive_epochs/v_number_of_epochs;
accuracy = (v_true_positive + v_true_negative)/v_number_of_epochs;

positive_predictive_value = v_true_positive/v_positive_prediction;
false_discovery_rate = v_false_positive/v_positive_prediction;
false_omission_rate = v_false_negative/v_negative_prediction;
negative_predictive_value = v_true_negative/v_negative_prediction;

true_positive_rate = v_true_positive/v_positive_epochs;
false_positive_rate = v_false_positive/v_negative_epochs;
false_negative_rate = v_false_negative/v_positive_epochs;
true_negative_rate = v_true_negative/v_negative_epochs;

positive_likelihood_ratio = true_positive_rate/false_positive_rate;
negative_likelihood_ratio = false_negative_rate/true_negative_rate;

diagnostic_odds_ratio = positive_likelihood_ratio/negative_likelihood_ratio;
f1_score = 2/((1/true_positive_rate)+(1/positive_predictive_value));


%% Section 3 : Output
%Create the output structure

os_analysed_prediction_error.prevalence = prevalence;
os_analysed_prediction_error.accuracy = accuracy;

os_analysed_prediction_error.positive_predictive_value = ...
                                                 positive_predictive_value;
os_analysed_prediction_error.false_discovery_rate = ...
                                                      false_discovery_rate;
os_analysed_prediction_error.false_omission_rate = ...
                                                       false_omission_rate;
os_analysed_prediction_error.negative_predictive_value = ...
                                                 negative_predictive_value;

os_analysed_prediction_error.true_positive_rate = true_positive_rate;
os_analysed_prediction_error.false_positive_rate = false_positive_rate;
os_analysed_prediction_error.false_negative_rate = false_negative_rate;
os_analysed_prediction_error.true_negative_rate = true_negative_rate;

os_analysed_prediction_error.positive_likelihood_ratio = ...
                                                positive_likelihood_ratio;
os_analysed_prediction_error.negative_likelihood_ratio = ...
                                                negative_likelihood_ratio;

os_analysed_prediction_error.diagnostic_odds_ratio = diagnostic_odds_ratio;
os_analysed_prediction_error.f1_score = f1_score;

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
% % %   File created by Nessim RICHARD
% % %   Creation Date : 19/06/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
