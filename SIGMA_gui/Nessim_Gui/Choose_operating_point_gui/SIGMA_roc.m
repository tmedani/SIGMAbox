function handles = SIGMA_roc(i_label,i_scores,handles)
%This function plot the ROC curve in the Choose_operating_point GUI

%Set the number of point in the ROC curve
c_number_of_point = 1000;

%Compute the performances needed for the ROC curve
[true_positive_rate false_positive_rate threshold_vector all_prediction] = ...
    ROC_from_scores(i_label,i_scores,c_number_of_point);

%Store the informations in the handles
handles.operating_point.true_positive_rate = true_positive_rate;
handles.operating_point.false_positive_rate = false_positive_rate;
handles.operating_point.all_prediction = all_prediction;
handles.operating_point.threshold = threshold_vector;

%Plot the ROC curve in the top left figure
axes(handles.ROC_curve_axis);
aH = handles.ROC_curve_axis;
hold off %erase the previous ROC curve
%roc = plot(false_positive_rate,true_positive_rate,'+');
roc = plot(false_positive_rate,true_positive_rate,'.','markersize',20);
hold on;
roc = plot(false_positive_rate,true_positive_rate,'r');

%Set the interactive function
set(roc,'hittest','off'); % so you can click on the Markers
hold on;
set(aH,'ButtonDownFcn',{@getThreshold,handles}); % Defining what happens when clicking
hold on;


%Select and plot the default point corresponding to a 0.5 threshold
default_index = find(threshold_vector == 0.5);
default_FPR = false_positive_rate(default_index);
default_TPR = true_positive_rate(default_index);
default_point = plot(default_FPR,default_TPR,'ro', 'MarkerSize',15);
hold on 
default_point = plot(default_FPR,default_TPR,'r*', 'MarkerSize',15);



%Display performances table and confusion matrix
handles = Display_performance_operating_point(0.5,handles);


%Add legend to the point and axes
legend([default_point],'Default point','Location','southeast');
xlabel('False positive rate');
ylabel('True positive rate');

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