function [xp,yp] = getThreshold(aH,evnt,handles)
%This function get the selected point on the ROC curve and update the 
%performance and the confusion matrix in the Choose_operating_point GUI

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
    %get the performances from the handles
    true_positive_rate = handles.operating_point.true_positive_rate;
    false_positive_rate = handles.operating_point.false_positive_rate;
    threshold_vector = handles.operating_point.threshold;
    
    %determine the threshold selected from the TPR and FPR
    index = intersect(find(true_positive_rate==Yp),find(false_positive_rate==Xp));
    index = index(1);
    choosen_threshold = threshold_vector(index);
    
    %update the performance table and the confusion matrix
    handles = Display_performance_operating_point(choosen_threshold,handles);
    
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