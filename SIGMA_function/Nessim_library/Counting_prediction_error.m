function [os_prediction_error] = Counting_prediction_error(i_actual_label,i_predicted_label)
%This funtion compare the actual label and the predicted label and count
%the four different types of success and errors.
%
% i_actual_label and i_predicted_label must be vector of the same size
%
%The output of this function can be used as an input for 
%the function Analyze_prediction_error
%
%      INPUT 
%           i_actual_label  = the known labels of every epochs
%           i_predicted_label = the predicted labels of every epochs
%      
%      OUTPUT
%           os_prediction_error = structure with the following fields:
%
%               number_of_epochs = total number of epochs
%
%               positive_epochs = number of epochs labeled +1
%               negative_epochs = number of epochs labeled -1
%   
%               positive_prediction = number of epochs predicted +1
%               negative_prediction = number of epochs predicted -1
%
%               true_positive = number of true positive result
%               true_negative = number of true negative result
%               false_positive = number of false positive error
%               false_negative = number of false negative error
%               
%
%here is a table of the different types of success and errors
%......................Label +1    Label -1
%                    _______________________
%                   |   True    |  False    |
%Predicted label +1 | positives | positives |
%                   |___________|___________|
%                   |  False    |   True    |
%Predicted label -1 | negatives | negatives |
%                   |___________|___________|
%
%for more info : https://en.wikipedia.org/wiki/Confusion_matrix


%% Section 1: Initialization
% Initialize the variable we are going to compute

v_positive_epochs = 0;
v_negative_epochs = 0;

v_positive_prediction = 0;
v_negative_prediction = 0;

v_true_positive = 0;
v_true_negative = 0;

v_false_positive = 0;
v_false_negative = 0;

c_number_of_epochs = length(i_actual_label);

%% Section 2 : Counting 
%Count the occurence of the different types of error

for l_epochs_number = 1:c_number_of_epochs % iterate through every epochs
    
    if i_actual_label(l_epochs_number) == 1 % positive label
        v_positive_epochs = v_positive_epochs + 1;
        
        if i_predicted_label(l_epochs_number) == 1 % positive prediction
            v_positive_prediction = v_positive_prediction + 1;
            v_true_positive = v_true_positive + 1; % true positive
        else % negative prediction
            v_negative_prediction = v_negative_prediction + 1;
            v_false_negative = v_false_negative +1; % false negative
        end
        
    else % negative label
        v_negative_epochs = v_negative_epochs + 1;
        
        if i_predicted_label(l_epochs_number) == 1 % positive prediction
            v_positive_prediction = v_positive_prediction + 1;
            v_false_positive = v_false_positive + 1; % false positive
        else % negative prediction
            v_negative_prediction = v_negative_prediction + 1;
            v_true_negative = v_true_negative +1; % true positive
        end  
    end   
end

%% Section 3 : Output 
%Create the output structure

os_prediction_error.number_of_epochs = c_number_of_epochs;

os_prediction_error.positive_epochs = v_positive_epochs;
os_prediction_error.negative_epochs = v_negative_epochs;

os_prediction_error.positive_prediction = v_positive_prediction;
os_prediction_error.negative_prediction = v_negative_prediction;

os_prediction_error.true_positive = v_true_positive;
os_prediction_error.true_negative = v_true_negative;

os_prediction_error.false_positive = v_false_positive;
os_prediction_error.false_negative = v_false_negative;


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
% % %   Creation Date : 13/06/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------
