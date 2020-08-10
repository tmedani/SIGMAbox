%function h = clickA3DPoint(pointCloud,labels)
function h = clickA3DPoint(data_in)
%%%------------------------------------------------------------------------
%  function h = clickA3DPoint(data_in)
%
%  Function task:
%   CLICKA3DPOINT
%   H = CLICKA3DPOINT(POINTCLOUD) shows a 3D point cloud and lets the user
%   select points by clicking on them. The selected point is highlighted
%   and its index in the point cloud will is printed on the screen.
%   POINTCLOUD should be a 3*N matrix, represending N 3D points.
%   Handle to the figure is returned.
%
%   other functions required:
%       CALLBACKCLICK3DPOINT  mouse click callback function
%       ROWNORM returns norms of each row of a matrix
%
%   To test this function ...
%       pointCloud = rand(3,100)*100;
%       h = clickA3DPoint(pointCloud);
%
%       now rotate or move the point cloud and try it again.
%       (on the figure View menu, turn the Camera Toolbar on, ...)
%
%   To turn off the callback ...
%       set(h, 'WindowButtonDownFcn','');
%
%   by Babak Taati
%   http://rcvlab.ece.queensu.ca/~taatib
%   Robotics and Computer Vision Laboratory (RCVLab)
%   Queen's University
%   May 4, 2005
%   revised Oct 30, 2007
%   revised May 19, 2009%
%   Addapted fot SIGMA toolbox : T/MEDANI
%
%  Inputs :
%
%  Outputs :
%
%
%--------------------------------------------------------------------------
%
%
%  Main Variables
%
%  Dependencies
%
%%  NB: this code is copyrighted.
%  Please refer to copyright info in the file footer.
%%%------------------------------------------------------------------------

%% Specify which feature to display : 
% Construct a questdlg with three options
choice = questdlg('Which features do you want to display?', ...
	'3D display','Three best features', 'Specify the features',...
    'Cancel','Three best features');
% Handle response
switch choice
    case 'Three best features'
        disp([choice 'Three best features'])
        feature_to_display = [1:3];
    case 'Specify the features'
        disp([choice 'Specify the features'])
        x = inputdlg({'Enter 1st feature:','Enter 2nd feature:','Enter 3rd feature:'},...
              '3 features', [1 30; 1 30; 1 30]);  
        
        if isempty(x)
            return
        else
        input_feature = x;
        end
        feature_to_display = [str2num(input_feature{1}(1)) ...
                              str2num(input_feature{2}(1)) ...
                              str2num(input_feature{3}(1))];
    case 'Cancel'
        disp('I''ll bring you your check.')
    return
end

if max(feature_to_display) > size(data_in.feature_result.best_organisation,1)
    msgbox('Error, the value is higher thant the number of feature');
    return
end
% Get the data from here
if isfield(data_in.feature_result, 'feature_matrix_cross_term_id')
    msg = ('Which features do you want to display ?');
    options.Default = 'Simple-term';
    options.Interpreter = 'tex';
    choice = questdlg(msg,'Feature to display','Simple-term','Cross-term','Annuler',options);
    % Handle response
    switch choice
        case 'Simple-term'
            feature_result=data_in.feature_result;
            best_method=feature_result.best_organisation(feature_to_display,2);
            best_channel=feature_result.best_organisation(feature_to_display,3);
            best_band=feature_result.best_organisation(feature_to_display,4);
            
            channels=data_in.init_parameter.channel_name;
            if ~iscell(channels)
                if isnan(channels)
                    channels = cell(max([best_channel{1},best_channel{2},best_channel{3}]),1);
                    channels{best_channel{1}} = ['obs : ' num2str(best_channel{1})];
                    channels{best_channel{2}} = ['obs : ' num2str(best_channel{2})];
                    channels{best_channel{3}} = ['obs : ' num2str(best_channel{3})];
                end
            end
            bands=data_in.init_parameter.bands_list;
            if isnan(best_band{1})
                bands = repmat({'No band'},size(bands));
                clear best_band
                best_band{1} = 1;
                best_band{2} = 2;
                best_band{3} = 3;
            end
            
        case 'Cross-term'
            data_in.feature_result.o_best_features_matrix = data_in.feature_result.o_features_matrix...
                (data_in.feature_result.idx_best_features_cross_terms,:);
            data_in.feature_result.idx_best_features = data_in.feature_result.idx_best_features_cross_terms;
            
            feature_result=data_in.feature_result;
            
            cross_term_identification
            data;
            
            best_combinaison = data(feature_to_display,end-1:end);
            %best_channel=feature_result.best_organisation(1:3,3);
            %best_band=feature_result.best_organisation(1:3,4);
            
        case 'Cancel'
            disp('OK on abondonne!')
            return
    end
else % as simple terme
    choice = 'Simple-term';
    feature_result=data_in.feature_result;
    best_method=feature_result.best_organisation(feature_to_display,2);
    best_channel=feature_result.best_organisation(feature_to_display,3);
    best_band=feature_result.best_organisation(feature_to_display,4);
    
    % remplace la methode 42 (theta_beta) 
    index_42 = find([best_method{:}] == 42);
    best_band{index_42} = 2; % remplace by theta
    
    channels=data_in.init_parameter.channel_name;
    if ~iscell(channels)
        if isnan(channels)
            channels = cell(max([best_channel{1},best_channel{2},best_channel{3}]),1);
            channels{best_channel{1}} = ['obs : ' num2str(best_channel{1})];
            channels{best_channel{2}} = ['obs : ' num2str(best_channel{2})];
            channels{best_channel{3}} = ['obs : ' num2str(best_channel{3})];
        end
    end
    bands=data_in.init_parameter.bands_list;
    if isnan(best_band{1})
        bands = repmat({'No band'},size(bands));
        clear best_band
        best_band{1} = 1;
        best_band{2} = 2;
        best_band{3} = 3;
    end    
end




feature_result=data_in.feature_result;

o_best_features_matrix=feature_result.o_best_features_matrix;
label=feature_result.label;

index_best_feature = feature_result.idx_best_features(feature_to_display);
%%
% Check the size of the best matrix!
if size(o_best_features_matrix,1)<3
    msgbox('The Best feature matrix contain less then 3 features, 3D presentation is impossible ...',...
        'SIGMA Error','error','modal');
    return;
end

feat_3D=o_best_features_matrix(feature_to_display,:);
pointCloud=feat_3D;


if nargin ~= 1
    error('Requires 1 input arguments.')
end

if size(pointCloud, 1)~=3
    error('Input point cloud must be a 3*N matrix.');
end

% show the point cloud
h = figure('Color','w','units','normalized','outerposition',[0 0 1 1]);
%h = figure('Color','w','units','normalized');
h.Name='3D visualisation of the 3 best features distribution';
h.NumberTitle='off';
%pointCloud;
f1 = pointCloud(1,:);
f2 = pointCloud(2,:);
f3 = pointCloud(3,:);


two_lables=unique(label);
index_un=find(label==two_lables(1));
index_deux=find(label==two_lables(2));

%plot3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), 'ro');
plot3(f1(1,index_un), f2(index_un), f3(index_un), 'ro','MarkerSize', 10);
hold on;
plot3(f1(index_deux), f2(index_deux), f3(index_deux), 'bs','MarkerSize', 10);
init_method=data_in.init_method;

if  strcmp(choice, 'Simple-term')
xlabel(['Feat N°: ' num2str(feature_to_display(1)),', '...
        init_method(best_method{1}).method_name...
        ' / Ch : ' channels{best_channel{1}} ...
        ' / Band :  ' bands{best_band{1}}],'FontSize',10,'Interpreter', 'none');
ylabel(['Feat N°: ' num2str(feature_to_display(2)),', '...
     init_method(best_method{2}).method_name...
        ' / Ch ' channels{best_channel{2}} ...
        ' / Band :  ' bands{best_band{2}}],'FontSize',10,'Interpreter', 'none');
zlabel(['Feat N°: ' num2str(feature_to_display(3)),', '...
        init_method(best_method{3}).method_name...
        ' / Ch : ' channels{best_channel{3}} ...
        ' / Band :  ' bands{best_band{3}}],'FontSize',10,'Interpreter', 'none');
title('3D Distribution Plot using the 3 best simple-features')
else
    xlabel(['Cross Feat N°: ,' num2str(feature_to_display(1)), ' : ',...
                               num2str(best_combinaison{1,1}), ' X ',...
                               num2str(best_combinaison{1,2})],...
                                'FontSize',10,'Interpreter', 'none');
    ylabel(['Cross Feat N°: ,' num2str(feature_to_display(2)), ' : ',...
                              num2str(best_combinaison{2,1}), ' X ',...
                              num2str(best_combinaison{2,2})],...
                              'FontSize',10,'Interpreter', 'none');
    zlabel(['Cross Feat N°: ,' num2str(feature_to_display(3)), ' : ',...
                               num2str(best_combinaison{3,1}), ' X ',...
                               num2str(best_combinaison{3,2})],...
                            'FontSize',10,'Interpreter', 'none');
      title('3D Distribution Plot using the 3 best cross-features')
end
grid on; grid minor;
%axis equal; axesLabelsAlign3D
%check the version of Matlab for a correct display of Legend
s1=version('-release');
s2='2017';
%tf = strncmp(s1,s2,4);
tf = (str2num(s1(1:4))>=2017);
if tf
    hl=legend({['class 1 (' num2str(two_lables(1)) ')' ],['class 2 (' num2str(two_lables(2)) ')']},'FontSize',20,'AutoUpdate','off' );
else
    hl=legend({['class 1 (' num2str(two_lables(1)) ')' ],['class 2 (' num2str(two_lables(2)) ')']},'FontSize',20);
end
%cameratoolbar('Show'); % show the camera toolbar
hold on; % so we can highlight clicked points without clearing the figure

% set the callback, pass pointCloud to the callback function
%set(h, 'WindowButtonDownFcn', {@callbackClickA3DPoint, pointCloud,h})
set(h, 'WindowButtonDownFcn', {@callbackClickA3DPoint, data_in,h})
%legend({['class 1 (' num2str(two_lables(1)) ')' ],['class 2 (' num2str(two_lables(2)) ')']},'FontSize',20);


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
% % %   Creation Date : 03/11/2016
% % %   Updates and contributors :
% % %
% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %
% % %   Contact info : francois.vialatte@espci.fr
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------


