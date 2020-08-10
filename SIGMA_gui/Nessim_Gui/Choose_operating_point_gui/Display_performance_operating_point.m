function handles = Display_performance_operating_point(choosen_threshold,handles)
%This function update the performance table and the confusion matrix in the
%Choose_operating_point GUI

%get the informations stored in the handles
true_positive_rate = handles.operating_point.true_positive_rate;
false_positive_rate = handles.operating_point.false_positive_rate;
all_prediction = handles.operating_point.all_prediction;
threshold = handles.operating_point.threshold;
label = handles.input.feature_result.label;

%find the prediction corresponding to the chosen threshold
index = find(threshold == choosen_threshold);
operating_index = index(1);
operating_prediction = all_prediction(operating_index,:);

%compute the performances of the prediction
error = Counting_prediction_error(label,operating_prediction);
operating_performance = Analyze_prediction_error(error);

%convert the structure to an array
performance_table = struct2array(operating_performance);
%performance_name = fieldnames(operating_performance); %no need for this as
%the row name are set in the GUI
true_negative_rate = performance_table(10);
false_negative_rate = performance_table(9);

%get the table and label from the handles
table = handles.uitable1;
display_threshold = handles.text2;

%update the table
set(table,'Data',performance_table');

%update the threshold displayed
set(display_threshold,'String',choosen_threshold);

%update the confusion matrix
set(handles.TPR_text,'String',num2str(true_positive_rate(operating_index),2));
set(handles.FPR_text,'String',num2str(false_positive_rate(operating_index),2));
set(handles.TNR_text,'String',num2str(true_negative_rate,2));
set(handles.FNR_text,'String',num2str(false_negative_rate,2));

%store the currently chosen threshold
setappdata(handles.manual_selection_gui,'operating_threshold',choosen_threshold);

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
