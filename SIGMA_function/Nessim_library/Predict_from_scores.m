function [o_prediction] = Predict_from_scores(i_scores,i_threshold)

%This function compute the prediction from the scores. 
    %   INPUT 
    %       i_scores  = the POSITIVE scores given by a classifier
    %
    %   OUTPUT
    %       o_prediction = the prediction computed by comparing the score 
    %                      to the threshold
    
    o_prediction = i_scores>i_threshold; % compare the scores to the threshold
    o_prediction = 2*(o_prediction)-1; %change the classes from 0/1 to -1/1

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