%function pointCloudIndex=callbackClickA3DPoint(src, eventData, pointCloud,h)
function pointCloudIndex=callbackClickA3DPoint(src, eventData, data_in,h)
%%%------------------------------------------------------------------------
%  pointCloudIndex=callbackClickA3DPoint(src, eventData, data_in,h)
%
%  Function task:
% CALLBACKCLICK3DPOINT mouse click callback function for CLICKA3DPOINT
%
%   The transformation between the viewing frame and the point cloud frame
%   is calculated using the camera viewing direction and the 'up' vector.
%   Then, the point cloud is transformed into the viewing frame. Finally,
%   the z coordinate in this frame is ignored and the x and y coordinates
%   of all the points are compared with the mouse click location and the
%   closest point is selected.
%
%   Babak Taati - May 4, 2005
%   revised Oct 31, 2007
%   revised Jun 3, 2008
%   revised May 19, 2009
%
%   Modified & Adapted for SIGAM toolbox
%   Takfarinas MEDANI, Novembre 2017,
%


%  Inputs :
%
%  Outputs :
%%
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

% Get the data from here
feature_result=data_in.feature_result;
init_parameter=data_in.init_parameter;
init_method=data_in.init_method;

%subject_epoch=feature_result.subject_epoch;
o_best_features_matrix=feature_result.o_best_features_matrix;
%labels=feature_result.labels;
feat_3D=o_best_features_matrix(1:3,:);
pointCloud=feat_3D;


%% Check the kind of the clik
drawnow
f = ancestor(h,'figure');
click_type = get(f,'SelectionType');
%trouver le point selectionné
selectedPoint = getappdata(h,'CurrentPoint');
%le suupprimer
delete(selectedPoint)

% Construct the menu :
%%%%
textbox_handle = uicontrol('Style','text','String','Hover mouse here for help',...
    'Position', [0 0 500 50],'TooltipString',...
    'Right-click to get a context menu to select the example/epoch property under the mouse cursor.');

% we will create a simple cursor to show us what point the printed property
% corresponds too

% cursor_handle = plot3(0,0,0,'r+');
cursor_handle = plot3(0,0,0);

% Creat the context menu
hcmenu = uicontextmenu;
% creat the item in the meny
item1 = uimenu(hcmenu, 'Label', 'Index of this example/epoch ', 'Callback', @hcb2);
item2 = uimenu(hcmenu, 'Label', 'Feature value of this example/epoch ', 'Callback', @hcb1);
item3 = uimenu(hcmenu, 'Label', 'Index of this subject ', 'Callback', @hcb3);
item4 = uimenu(hcmenu, 'Label', 'Name of the FE method(s)  ', 'Callback', @hcb4);
item5 = uimenu(hcmenu, 'Label', 'Plot this example : raw signal', 'Callback', @hcb5);
item6 = uimenu(hcmenu, 'Label', 'Plot this example : filtred signal', 'Callback', @hcb6);
item7 = uimenu(hcmenu, 'Label', 'Plot this example : raw and filtred signal', 'Callback', @hcb7);

% Enable to off the button oh the no signal method or synchronisation
% methods
methods=feature_result.best_organisation(1:3,2);
% Check the methods for The data display
meth_indx=[methods{1} methods{2} methods{3}];
if ~isempty(find(meth_indx>50))
    item3.Enable='off';
    item5.Enable='off';
    item6.Enable='off';
    item7.Enable='off';
end

%%%%
% Todo : add the name of the electrodes as a menu to display
% Todo : add the display of the synchronisation methods

if strcmp(click_type,'normal') % button droit
    point = get(gca, 'CurrentPoint'); % mouse click position
    camPos = get(gca, 'CameraPosition'); % camera position
    camTgt = get(gca, 'CameraTarget'); % where the camera is pointing to
    camDir = camPos - camTgt; % camera direction
    camUpVect = get(gca, 'CameraUpVector'); % camera 'up' vector
    % build an orthonormal frame based on the viewing direction and the
    % up vector (the "view frame")
    zAxis = camDir/norm(camDir);
    upAxis = camUpVect/norm(camUpVect);
    xAxis = cross(upAxis, zAxis);
    yAxis = cross(zAxis, xAxis);
    rot = [xAxis; yAxis; zAxis]; % view rotation
    % the point cloud represented in the view frame
    rotatedPointCloud = rot * pointCloud;
    % the clicked point represented in the view frame
    rotatedPointFront = rot * point' ;
    % find the nearest neighbour to the clicked point
    pointCloudIndex = dsearchn(rotatedPointCloud(1:2,:)', ...
        rotatedPointFront(1:2));
    h = findobj(gca,'Tag','pt'); % try to find the old point
    selectedPoint = pointCloud(:, pointCloudIndex);
    if isempty(h) % if it's the first click (i.e. no previous point to delete)
        % highlight the selected point
        h = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
            selectedPoint(3,:), 'k*', 'MarkerSize', 20);
        set(h,'Tag','pt'); % set its Tag property for later use
    else % if it is not the first click
        delete(h); % delete the previously selected point
        % highlight the newly selected point
        h = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
            selectedPoint(3,:), 'k*', 'MarkerSize', 20);
        set(h,'Tag','pt');  % set its Tag property for later use
    end
    fprintf('you clicked on example number %d\n', pointCloudIndex);
    fprintf('\t\t The associated label is %d\n',  feature_result.label(pointCloudIndex));
    
    %fprintf('you Selected the features: %d %d %d\n', pointCloud(:,pointCloudIndex));
    % Assigne the selected valu in the workspace
    assignin('base','selected_feature_from_plot',pointCloudIndex);
    
    % fprintf('Add here the identification of the feature and on the figure...\n');
    
    
elseif strcmp(click_type,'alt')
    %do your stuff once your point is selected
    % disp('Done clicking!');
    % HERE IS WHERE YOU CAN PUT YOUR STUFF
    %% Same thing as the left button
    point = get(gca, 'CurrentPoint'); % mouse click position
    camPos = get(gca, 'CameraPosition'); % camera position
    camTgt = get(gca, 'CameraTarget'); % where the camera is pointing to
    camDir = camPos - camTgt; % camera direction
    camUpVect = get(gca, 'CameraUpVector'); % camera 'up' vector
    % build an orthonormal frame based on the viewing direction and the
    % up vector (the "view frame")
    zAxis = camDir/norm(camDir);
    upAxis = camUpVect/norm(camUpVect);
    xAxis = cross(upAxis, zAxis);
    yAxis = cross(zAxis, xAxis);
    rot = [xAxis; yAxis; zAxis]; % view rotation
    % the point cloud represented in the view frame
    rotatedPointCloud = rot * pointCloud;
    % the clicked point represented in the view frame
    rotatedPointFront = rot * point' ;
    % find the nearest neighbour to the clicked point
    pointCloudIndex = dsearchn(rotatedPointCloud(1:2,:)', ...
        rotatedPointFront(1:2));
    h = findobj(gca,'Tag','pt'); % try to find the old point
    selectedPoint = pointCloud(:, pointCloudIndex);
    if isempty(h) % if it's the first click (i.e. no previous point to delete)
        % highlight the selected point
        h = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
            selectedPoint(3,:), 'k*', 'MarkerSize', 20);
        set(h,'Tag','pt'); % set its Tag property for later use
    else % if it is not the first click
        delete(h); % delete the previously selected point
        % highlight the newly selected point
        h = plot3(selectedPoint(1,:), selectedPoint(2,:), ...
            selectedPoint(3,:), 'k*', 'MarkerSize', 20);
        set(h,'Tag','pt');  % set its Tag property for later use
    end
    %fprintf('you Selected the features: %d %d %d\n', pointCloud(:,pointCloudIndex));
    fprintf('you clicked on example number %d\n', pointCloudIndex )%, 'The associated label is %d\n',  feature_result.labels(pointCloudIndex));
    fprintf('\t\t The associated label is %d\n',  feature_result.label(pointCloudIndex));
    
    %fprintf('you clicked on example number %d\n', pointCloudIndex );
    
    %feature_result.label(selected_feature_from_plot)
    %% end of the same thing
    %%%
    %% Display the menu
    % set the context menu on the current axes and lines
    set(gca,'uicontextmenu',hcmenu)
    
    hlines = findall(gca,'Type','line');
    % Attach the context menu to each line
    for line = 1:length(hlines)
        set(hlines(line),'uicontextmenu',hcmenu)
    end
    %%%
    
    uiresume(f);
end


%%% The subfunction
    function hcb1(~,~)
        % called when H is selected from the menu
        %current_point = get(gca,'Currentpoint');
        feat1 = pointCloud(1,pointCloudIndex);
        feat2 = pointCloud(2,pointCloudIndex);
        feat3 = pointCloud(3,pointCloudIndex);
        set(cursor_handle,'Xdata',feat1,'Ydata',feat2,'Zdata',feat3);
        % We read H directly from the graph
        str = sprintf(['Value of the features for this example/epochs : \n ',...
            'F1= ', num2str(feat1),', F2= ', num2str(feat2), ', F3= ',num2str(feat3)]);
        set(textbox_handle, 'String',str,'FontWeight','bold','FontSize',12)
        delete(cursor_handle)
    end

    function hcb2(~,~)
        % called when S is selected from the menu
        %current_point = get(gca,'Currentpoint');
        %H = current_point(1,1);
        %P = current_point(1,2);
        index_of_the_feature=pointCloudIndex;
        %index_of_subject=subject_epoch(pointCloudIndex,1)
        %set(cursor_handle,'Xdata',H,'Ydata',P)
        
        % To get S, we first need the temperature at the point
        % selected
        %T = 800;%fzero(@(T) H - XSteam('h_PT',P,T),[1 800]);
        % then we compute the entropy from XSteam
        str = sprintf(['The index of the epoch/example is    = ',...
            num2str(index_of_the_feature)]);
        set(textbox_handle, 'String',str,'FontWeight','bold','FontSize',12)
    end

    function hcb3(~,~)
        subject_epoch=feature_result.subject_epoch;
        % called when S is selected from the menu
        %current_point = get(gca,'Currentpoint');
        %H = current_point(1,1);
        %P = current_point(1,2);
        index_of_the_feature=pointCloudIndex;
        index_of_subject=subject_epoch(pointCloudIndex,1);
        %set(cursor_handle,'Xdata',H,'Ydata',P)
        
        % To get S, we first need the temperature at the point
        % selected
        %T = 800;%fzero(@(T) H - XSteam('h_PT',P,T),[1 800]);
        % then we compute the entropy from XSteam
        str = sprintf(['The number of the subject is    = ',...
            num2str(index_of_subject)]);
        set(textbox_handle, 'String',str,'FontWeight','bold','FontSize',12)
    end


    function hcb4(~,~)
        %index_of_the_method=pointCloudIndex;
        methods=feature_result.best_organisation(1:3,2);
        methods_name={init_method(methods{1}).method_name;
            init_method(methods{2}).method_name;
            init_method(methods{3}).method_name};
        
        str = sprintf(['The FE methods are : 1- ',methods_name{1},', 2-',...
            methods_name{2},', 3-',methods_name{3} ]);
        set(textbox_handle, 'String',str,'FontWeight','bold','FontSize',12)
    end




    function hcb5(~,~) %% Plot the raw signal for the 3 best features
        subject_epoch=feature_result.subject_epoch;
        h11=figure;
        methods=feature_result.best_organisation(1:3,2);
        % Check the methods for The data display
        meth_indx=[methods{1} methods{2} methods{3}];
        if ~isempty(find(meth_indx>50))
            sigma_message=sprintf('SIGMA>> The data display for this method is not supported for this version');
            uiwait(msgbox(sigma_message,'SIGMA Error !','Error'));
            close(gcf)
            return
        end
        % Load the data
        index_of_subject=subject_epoch(pointCloudIndex,1);
        x=load([init_parameter.data_location, 'subject_' ...
            num2str(index_of_subject) '.mat']);
        data=x.s_EEG.data;
        channels=feature_result.best_organisation(1:3,3);
        channel_name=init_parameter.channel_name;
        
        
        
        methods_name={init_method(methods{1}).method_name;
            init_method(methods{2}).method_name;
            init_method(methods{3}).method_name};
        
        index_of_epoch=subject_epoch(pointCloudIndex,2);
        data_to_plot=[data(channels{1},:,index_of_epoch);
            data(channels{2},:,index_of_epoch);
            data(channels{3},:,index_of_epoch)];
        channels_to_plot=[channel_name(channels{1});
            channel_name(channels{2});
            channel_name(channels{3})];
        subplot(3,1,1)
        Sigma_suptitle(['raw signal, example n°: ' num2str(pointCloudIndex) ...
            ', from subject n°: ' num2str(index_of_subject)...
            ' and epoch n°: ' num2str(index_of_epoch)],10)
        
        plot(data_to_plot(1,:),'r');
        grid on;grid minor
        title(['Feature value: F1= ', num2str(pointCloud(1,pointCloudIndex)),...
            ' ,method : ' methods_name{1}, ', all bands'],'Interpreter',...
            'none');
        legend(channels_to_plot(1),'fontsize',15)
        
        subplot(3,1,2)
        plot(data_to_plot(2,:),'g');
        grid on;grid minor
        title(['Feature value: F2= ', num2str(pointCloud(2,pointCloudIndex)),...
            ' ,method : ' methods_name{2}, ', all bands'],'Interpreter',...
            'none');
        legend(channels_to_plot(2),'fontsize',15)
        
        subplot(3,1,3)
        plot(data_to_plot(3,:),'k');
        grid on;grid minor
        title(['Feature value: F3= ', num2str(pointCloud(3,pointCloudIndex)),...
            ' ,method : ' methods_name{3}, ', all bands'],'Interpreter', 'none');
        legend(channels_to_plot(3),'fontsize',15)
        
        
        str = sprintf(['Plot the raw signal of this example, N° ' ...
            num2str(pointCloudIndex)]);
        set(textbox_handle, 'String',str,...
            'FontWeight','bold','FontSize',12)
    end

    function hcb6(~,~) %% Plot the treated signal for the three signal
        h12=figure;
        % Check the methods for The data display
        methods=feature_result.best_organisation(1:3,2);
        % Check the methods for The data display
        meth_indx=[methods{1} methods{2} methods{3}];
        if ~isempty(find(meth_indx>50))
            sigma_message=sprintf('SIGMA>> The data display for the this method is not supported for this version');
            uiwait(msgbox(sigma_message,'SIGMA Error !','Error'));
            close(gcf)
            return
        end
        % Load the data
        subject_epoch=feature_result.subject_epoch;
        index_of_subject=subject_epoch(pointCloudIndex,1);
        x=load([init_parameter.data_location, 'subject_' ...
            num2str(index_of_subject) '.mat']);
        data=x.s_EEG.data;
        
        channels=feature_result.best_organisation(1:3,3);
        channel_name=init_parameter.channel_name;
        
        
        index_of_epoch=subject_epoch(pointCloudIndex,2);
        data_to_plot=[data(channels{1},:,index_of_epoch);
            data(channels{2},:,index_of_epoch);
            data(channels{3},:,index_of_epoch)];
        channels_to_plot=[channel_name(channels{1});
            channel_name(channels{2});
            channel_name(channels{3})];
        methods=feature_result.best_organisation(1:3,2);
        methods_name={init_method(methods{1}).method_name;
            init_method(methods{2}).method_name;
            init_method(methods{3}).method_name};
        
        
        
        
        % filter the data and plot the treated signal
        index_of_ranked_band= feature_result.best_organisation(1:3,4);
        %name_of_all_the_band=init_parameter.selected_freq_list;
        name_of_all_band=init_parameter.bands_list;
        name_of_the_ranked_band=[];
        for ind=1:length(index_of_ranked_band)
            name_of_the_ranked_band=[name_of_the_ranked_band; ...
                name_of_all_band(index_of_ranked_band{ind})];
            %index_of_the_ranked_band=
        end
        
        filt=init_parameter.filt_band_param;
        index_of_selected_filter=init_parameter.selected_band; % selected by the user
        
        % find the approriate index of the band
        
        i_EEG_1=data_to_plot(1,:);
        indx_1=find(index_of_ranked_band{1}==index_of_selected_filter);
        %fdata_1 = filter(filt(index_of_ranked_band{1}),i_EEG_1);
        fdata_1 = filter(filt(indx_1),i_EEG_1);
        
        
        i_EEG_2=data_to_plot(2,:);
        indx_2=find(index_of_ranked_band{2}==index_of_selected_filter);
        %fdata_2 = filter(filt(index_of_ranked_band{2}),i_EEG_2);
        fdata_2 = filter(filt(indx_2),i_EEG_2);
        
        i_EEG_3=data_to_plot(3,:);
        indx_3=find(index_of_ranked_band{3}==index_of_selected_filter);
        fdata_3 = filter(filt(indx_3),i_EEG_3);
        
        %% Plotting
        subplot(3,1,1)
        Sigma_suptitle(['Filtred signal, example n°: ' ...
            num2str(pointCloudIndex) ...
            ', from subject n°: ' num2str(index_of_subject)...
            ' and epoch n°: ' num2str(index_of_epoch)],10)
        
        plot(fdata_1,'r');
        grid on;grid minor
        title(['Feat: F1= ' num2str(pointCloud(1,pointCloudIndex))...
            ' ,method : ' methods_name{1} ', band : '...
            name_of_the_ranked_band{1}], 'Interpreter', 'none');
        legend(channels_to_plot(1),'fontsize',15)
        
        subplot(3,1,2)
        plot(fdata_2,'g');
        grid on;grid minor
        title(['Feat: F2= ', num2str(pointCloud(2,pointCloudIndex))...
            ,' ,method : ' methods_name{2},', band : ' ...
            name_of_the_ranked_band{2}],'Interpreter', 'none');
        legend(channels_to_plot(2),'fontsize',15)
        
        subplot(3,1,3)
        plot(fdata_3,'k');
        grid on;grid minor
        title(['Feat: F3= ', num2str(pointCloud(3,pointCloudIndex)) ...
            ' ,method : ' methods_name{3},', band : '...
            name_of_the_ranked_band{3}],'Interpreter', 'none');
        legend(channels_to_plot(3),'fontsize',15)
        
        
        str = sprintf(['Plot the treated signal of this example, N° '...
            num2str(pointCloudIndex)]);
        set(textbox_handle, 'String',str,...
            'FontWeight','bold','FontSize',12)
    end

    function hcb7(~,~) %% Plot the treated signal for the three signal
        subject_epoch=feature_result.subject_epoch;
        
        h12=figure;
        methods=feature_result.best_organisation(1:3,2);
        
        % Check the methods for The data display
        meth_indx=[methods{1} methods{2} methods{3}];
        if ~isempty(find(meth_indx>50))
            sigma_message=sprintf('SIGMA>> The data display for this method is not supported for this version');
            uiwait(msgbox(sigma_message,'SIGMA Error !','Error'));
            close(gcf);
            return
        end
        % Load the data
        index_of_subject=subject_epoch(pointCloudIndex,1);
        x=load([init_parameter.data_location, 'subject_' num2str(index_of_subject) '.mat']);
        data=x.s_EEG.data;
        
        
        channels=feature_result.best_organisation(1:3,3);
        channel_name=init_parameter.channel_name;
        
        
        
        index_of_epoch=subject_epoch(pointCloudIndex,2);
        data_to_plot=[data(channels{1},:,index_of_epoch);
            data(channels{2},:,index_of_epoch);
            data(channels{3},:,index_of_epoch)];
        channels_to_plot=[channel_name(channels{1});
            channel_name(channels{2});
            channel_name(channels{3})];
        methods=feature_result.best_organisation(1:3,2);
        methods_name={init_method(methods{1}).method_name;
            init_method(methods{2}).method_name;
            init_method(methods{3}).method_name};
        
        
        index_of_ranked_band= feature_result.best_organisation(1:3,4);
        %name_of_all_the_band=init_parameter.selected_freq_list;
        name_of_all_band=init_parameter.bands_list;
        name_of_the_ranked_band=[];
        for ind=1:length(index_of_ranked_band)
            name_of_the_ranked_band=[name_of_the_ranked_band; ...
                name_of_all_band(index_of_ranked_band{ind})];
            %index_of_the_ranked_band=
        end
        
        filt=init_parameter.filt_band_param;
        index_of_selected_filter=init_parameter.selected_band; % selected by the user
        
        i_EEG_1=data_to_plot(1,:);
        indx_1=find(index_of_ranked_band{1}==index_of_selected_filter);
        %fdata_1 = filter(filt(index_of_ranked_band{1}),i_EEG_1);
        fdata_1 = filter(filt(indx_1),i_EEG_1);
        
        
        i_EEG_2=data_to_plot(2,:);
        indx_2=find(index_of_ranked_band{2}==index_of_selected_filter);
        %fdata_2 = filter(filt(index_of_ranked_band{2}),i_EEG_2);
        fdata_2 = filter(filt(indx_2),i_EEG_2);
        
        i_EEG_3=data_to_plot(3,:);
        indx_3=find(index_of_ranked_band{3}==index_of_selected_filter);
        fdata_3 = filter(filt(indx_3),i_EEG_3);
        
        %%
        AxesHandle(1)=subplot(3,2,1);
        Sigma_suptitle(['Filtred signal, example n°: ' num2str(pointCloudIndex) ...
            ', from subject n°: ' num2str(index_of_subject)...
            ' and epoch n°: ' num2str(index_of_epoch)],10)
        plot(data_to_plot(1,:),'r');
        grid on;grid minor
        title(['Feature value: F1= ', num2str(pointCloud(1,pointCloudIndex)),...
            ' ,method : ' methods_name{1}, ', all bands'],'Interpreter', 'none');
        legend(channels_to_plot(1),'fontsize',15)
        
        AxesHandle(2)=subplot(3,2,2)   ;
        plot(fdata_1,'r');
        grid on;grid minor
        title(['Feat: F1= ' num2str(pointCloud(1,pointCloudIndex))...
            ' ,method : ' methods_name{1} ', band : '...
            name_of_the_ranked_band{1}], 'Interpreter', 'none');
        legend(channels_to_plot(1),'fontsize',15)
        
        %%
        AxesHandle(3)=subplot(3,2,3);
        plot(data_to_plot(2,:),'g');
        grid on;grid minor
        title(['Feature value: F2= ', num2str(pointCloud(2,pointCloudIndex))...
            ,' ,method : ' methods_name{2}, ', all bands']...
            ,'Interpreter', 'none');
        legend(channels_to_plot(2),'fontsize',15)
        
        AxesHandle(4)=subplot(3,2,4)  ;
        plot(fdata_2,'g');
        grid on;grid minor
        title(['Feat: F2= ', num2str(pointCloud(2,pointCloudIndex))...
            ,' ,method : ' methods_name{2},', band : ' ...
            name_of_the_ranked_band{2}],'Interpreter', 'none');
        legend(channels_to_plot(2),'fontsize',15)
        
        %%
        AxesHandle(5)=subplot(3,2,5);
        plot(data_to_plot(3,:),'k');
        grid on;grid minor
        title(['Feat: F3= ', num2str(pointCloud(3,pointCloudIndex)),...
            ' ,method : ' methods_name{3}, ', all bands'],...
            'Interpreter', 'none');
        legend(channels_to_plot(3),'fontsize',15)
        
        AxesHandle(6)=subplot(3,2,6)      ;
        plot(fdata_3,'k');
        grid on;grid minor
        title(['Feat: F3= ', num2str(pointCloud(3,pointCloudIndex)) ...
            ' ,method : ' methods_name{3},', band : '...
            name_of_the_ranked_band{3}],'Interpreter', 'none');
        legend(channels_to_plot(3),'fontsize',15)
        
    end
end
%%
% % %----------------------------------------------------------------------
% % %         Brain Computer Interface team
% % %
% % %              _---~~(~~-_.
% % %             _{    )  )
% % %            ,  ) -~~- ( ,-' )_
% % %            ( `-,_..`., )-- '_,)
% % %           ( ` _) ( -~( -_ `, }
% % %           (_- _ ~_-~~~~`, ,' )
% % %            `~ -^(  __;-,((()))
% % %               ~~~~ {_ -_(())
% % %                   `\ }
% % %                    { }
% % %  File created by Takfarinas MEDANI
% % %  Creation Date : 30/05/2017
% % %  Updates and contributors :
% % %  30/01/2017, T MEDANI : Updating and adding options
% % %
% % %  Citation: [creator and contributor names], comprehensive BCI
% % %       toolbox, available online 2016.
% % %
% % %  Contact info : francois.vialatte@espci.fr
% % %  Copyright of the contributors, 2016
% % %  Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------

