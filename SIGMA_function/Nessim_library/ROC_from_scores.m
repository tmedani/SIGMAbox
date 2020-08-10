function [o_true_positive_rate,o_false_positive_rate,o_threshold_vector,...
        o_prediction] = ROC_from_scores(i_label,i_scores,i_number_of_point)
%This function compute the true positive rate and the false positive rate 
%for multiple threshold so the user can plot the ROC curve
%
%to plot the ROC curve, use plot(false_positive_rate,true_positive_rate)
%      INPUT 
%           i_label  = the known label of each epochs
%           i_scores = the POSITIVE scores given by a classifier
%           i_number_of_point = the number of point on the ROC curve
%
%NB: the number of point doesn't have to be very high. For small variation
%of the threshold, the prediction will stay the same and points will be
%superimposed.
%
%      OUTPUT
%           o_threshold_vector = the vector of all the thresholds for which
%               performance was computed
%
%           o_true_positive_rate = the vector of true positive rate
%               computed for each threshold
%
%           o_false_positive_rate = the vector of false positive rate
%               computed for each threshold
%
%           o_prediction = the matrix of the predicted label for each
%               epoch and for each threshold; each row is related to a
%               different threshold
%
%


%% Section 1: Initialization
% Create arrays with the correct dimensions

true_positive_rate = zeros(i_number_of_point,1);
false_positive_rate = zeros(i_number_of_point,1);
analysed_prediction_error = zeros(i_number_of_point,1);
all_prediction = zeros(i_number_of_point,size(i_label,2));

%Create the threshold_vector for iteration
threshold_vector = 0:1/i_number_of_point:1;

%% Section 2 : Iteration
% for each threshold, this section computes the prediction, then uses the
% prediction to compute performances

for l_threshold = threshold_vector
    
    %compute prediction
    prediction = Predict_from_scores(i_scores,l_threshold);
    
    %compute performances
    prediction_error = Counting_prediction_error(i_label,prediction);
    analysed_prediction_error = Analyze_prediction_error(prediction_error);
    
    %store the TPR, FPR and prediction in the arrays
    threshold_index = int64((i_number_of_point*l_threshold)+1);
    true_positive_rate(threshold_index) = analysed_prediction_error.true_positive_rate;
    false_positive_rate(threshold_index) = analysed_prediction_error.false_positive_rate;
    all_prediction(threshold_index,:) = prediction;
    
end

%% Section 3 : Output 
%Assign the output
o_true_positive_rate = true_positive_rate;
o_false_positive_rate = false_positive_rate;
o_threshold_vector = threshold_vector;
o_prediction = all_prediction;
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
% % %   Creation Date : 26/06/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------