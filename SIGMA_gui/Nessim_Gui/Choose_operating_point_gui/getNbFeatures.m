function [xp,yp] = getNbFeatures(aH,evnt,handles)
%This function get the selected point on the AUC vs nb of features and 
%update the ROC curve in the Choose_operating_point GUI

%% detect the selected point
f = ancestor(aH,'figure');
click_type = get(f,'SelectionType');
ptH = getappdata(aH,'CurrentPoint');
delete(ptH)
if strcmp(click_type,'normal')
    %Finding the closest point and highlighting it
    lH = findobj(aH,'Type','line');
    minDist = realmax;
    finalIdx = NaN;
    finalH = NaN;
    pt = get(aH,'CurrentPoint'); %Getting click position
    for ii = lH'
        xp=get(ii,'Xdata'); %Getting coordinates of line object
        yp=get(ii,'Ydata');
        dx=daspect(aH);      %Aspect ratio is needed to compensate for uneven axis when calculating the distance
        [newDist idx] = min( ((pt(1,1)-xp).*dx(2)).^2 + ((pt(1,2)-yp).*dx(1)).^2 );
        if (newDist < minDist)
            finalH = ii;
            finalIdx = idx;
            minDist = newDist;
        end
    end
    xp=get(finalH,'Xdata'); %Getting coordinates of line object
    yp=get(finalH,'Ydata');
    ptH = plot(aH,xp(finalIdx),yp(finalIdx),'k*','MarkerSize',20);
    setappdata(aH,'CurrentPoint',ptH);
    Xp = xp(finalIdx);
    Yp = yp(finalIdx);
    % eval in base
    
    %% Modification by Nessim, to adapt it to the Choose_operating_point GUI
    
    %store the number of feature in the gui
    setappdata(handles.manual_selection_gui,'Nb_of_features_display',Xp);
    
    %update the display of AUC and number of feature
    set(handles.auc_display,'String',num2str(Yp));
    set(handles.nb_of_features_display,'String',num2str(Xp));
    
    %extract the scores corresponding to the number of feature selected
    label = handles.input.feature_result.label;
    scores_matrix = handles.input.performance_result.scores(2);
    scores = scores_matrix(1);
    scores = cell2mat(scores(1));
    scores = scores(Xp,:);
    
    %update the ROC curve
    handles = SIGMA_roc(label,scores,handles);
    


elseif strcmp(click_type,'alt')
    %do your stuff once your point is selected   
    disp('Done clicking!');
    % HERE IS WHERE YOU CAN PUT YOUR STUFF
    uiresume(f);
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
% % %   File created by Takfarinas MEDANI
% % %   Creation Date : 27/06/2018
% % %   Updates and contributors : Nessim RICHARD, to adapt the function to
% % %   the Choose_operating_point GUI
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------