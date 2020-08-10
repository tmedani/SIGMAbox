function [handles] = AUC_curve(handles)
%This function plot the AUC vs the number of features in the
%Choose_operating_point GUI

%get the performance result from the handles
performance_result = handles.input.performance_result;

%Plot the AUC vs number of feature in the bottom right figure
axes(handles.AUC_curve_axis);
aH = handles.AUC_curve_axis;
AUC = plot(performance_result.performance(:,8),'r.','markersize',20);
hold on 
AUC = plot(performance_result.performance(:,8),'b');

%Set the interactive function
set(AUC,'hittest','off'); % so you can click on the Markers
hold on;
set(aH,'ButtonDownFcn',{@getNbFeatures,handles}); % Defining what happens when clicking
hold on;

%Select and plot the default point according to the best AUC
[max_AUC, index]=max(handles.input.performance_result.performance(:,8));
default_number_of_feature = plot(index,max_AUC,'o', 'MarkerSize',10);

%Store the default point as the currently selected point
setappdata(handles.manual_selection_gui,'Nb_of_features_display',index);

%Add legend to the point and axes
legend([default_number_of_feature],'Default point','Location','southeast');
xlabel('Number of features');
ylabel('AUC');

%Display the AUC and the number of feature of the default point
set(handles.auc_display,'String',num2str(max_AUC));
set(handles.nb_of_features_display,'String',num2str(index));

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
