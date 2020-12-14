function Sigma_display_cross_term_feature_ranking(feature_result)

%%%------------------------------------------------------------------------
%% Sigma_display_cross_term_feature_ranking(features_results)
%     Function task: Display a table with the identification between the
%     simple and the cross term feature during the ranking
%
%     This Function is part of SIGMAbox, It used to identify the features by finding the origin (method, chanel, band ...)
% Inputs
% features_results the Sigma structure
% Outputs
% Figure containig a table    
%--------------------------------------------------------------------------
%
%   Sections :
%     
%   Main Variables
%
%   Dependencies
%
%   NB: this code is copyrighted.
%   Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------


try
    test=0;
    idx_best_features = feature_result.idx_best_features;
    test=1;
    feature_matrix_cross_term_id = feature_result.feature_matrix_cross_term_id;
    test=2;
    channel_method = feature_result.channel_method;
catch
    switch test
        case 0
            warning('SIGMA : idx_best_features is not on the input structure')
        case 1
            warning('SIGMA : feature_matrix_cross_term_id is not on the input structure')
        case 2
            warning('SIGMA : feature_result is not on the input structure')
    end
    
    return
end

best_features_cross_term = feature_matrix_cross_term_id(idx_best_features,:);
data = [];feature_rank = [];
for ind = 1:length(idx_best_features)
    performance_ranking = feature_result.performance_ranking;
    id_index = idx_best_features(ind);
    if id_index<= length(channel_method)
        disp(['Feature ' num2str(id_index)...
            ' is ranked ' num2str(ind) ' with a score: ' ...
            num2str(performance_ranking(ind))])
        data = [data;{id_index ind performance_ranking(ind)...
            '  Simple-term  ' nan nan}];
    else
        disp(['Feature ' num2str(id_index)...
            ' is ranked ' num2str(ind) ' with a score: ' ...
            num2str(performance_ranking(ind)), ' ; cross term ' ...
            'between features: ' num2str(best_features_cross_term(ind,:))])
        data = [data;{id_index ind performance_ranking(ind)...
            '   Cross-term   ' best_features_cross_term(ind,1)...
            best_features_cross_term(ind,2)}];
    end
    
    % numérotaion rank
    temp_var  =  strcat( 'rank ',num2str(ind,2) );
    feature_rank = [feature_rank;{temp_var}];
    
end



% $TODO : find an inteligent wy to fit the table to the data
f  =  figure('Color','w');
f.Name = 'Cross term feature ranking';
f.MenuBar = 'none';
f.NumberTitle = 'off';
f.Resize = 'off';
title('Identification of the feature term ranking (simple and cross) ','fontsize',15);
axis off
d  =  data; % Make some random data to add
t  =  uitable(f);
set(t,'Data',d,'FontSize',12); % Use the set command to change the uitable properties.
columname = {' Index ';' Rank ';' Score ';...
    ' Computed term ';' term 1 ';' term 2 '};
set(t,'ColumnName',columname,'Fontsize',10);
set(t,'RowName',feature_rank,'fontsize',10);
set(t,'TooltipString','Cross term  identification');
set(t,'Position',[20 20 610 300])
figure_position = get(f,'Position');
set(f,'Position',[figure_position(1) figure_position(2) 650 420]);

str = sprintf(['The index corresponds to the line on the feature matrix \n'...
                'The rank is the result from the ranking method \n'...
                'If the computed term is simple the Index corresponds to the feature itself on the feature matrix  \n'...
                'term1 & term2 are the indexes of the feature used to compute the cross term ']);

t.TooltipString=str;
% dim = [.1 .62 .3 .3];
% ah=annotation('textbox',dim,'String',str,'FitBoxToText','on');
%reformatTable(t,f)

end

%%
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
% % %   Creation Date : 12/06/2017
% % %   Updates and contributors :
% % %       12/06/2017 Takfarinas MEDANI created the first version of this code
% % %
% % %   Citation: [creator and contributor names], SigmaBOX, available
% % %   online 2017.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2017
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------