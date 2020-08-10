function varargout = Sigma_result_visualisation_gui(varargin)
% SIGMA_RESULT_VISUALISATION_GUI MATLAB code for Sigma_result_visualisation_gui.fig
%      SIGMA_RESULT_VISUALISATION_GUI, by itself, creates a new SIGMA_RESULT_VISUALISATION_GUI or raises the existing
%      singleton*.
%
%      H = SIGMA_RESULT_VISUALISATION_GUI returns the handle to a new SIGMA_RESULT_VISUALISATION_GUI or the handle to
%      the existing singleton*.
%
%      SIGMA_RESULT_VISUALISATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGMA_RESULT_VISUALISATION_GUI.M with the given input arguments.
%
%      SIGMA_RESULT_VISUALISATION_GUI('Property','Value',...) creates a new SIGMA_RESULT_VISUALISATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sigma_result_visualisation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sigma_result_visualisation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sigma_result_visualisation_gui

% Last Modified by GUIDE v2.5 19-Feb-2018 11:32:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sigma_result_visualisation_gui_OpeningFcn, ...
    'gui_OutputFcn',  @Sigma_result_visualisation_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Sigma_result_visualisation_gui is made visible.
function Sigma_result_visualisation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sigma_result_visualisation_gui (see VARARGIN)

% Choose default command line output for Sigma_result_visualisation_gui
handles.output = hObject;

% define drawing names
handles.draw_method_names = {'Best ROC','Confusion Matrix', 'Performance',...
    'Prediction', 'Best Organisation Voted',...
    '3D Confusion Matrix', 'Circular Confusion Matrix',...
    'Rectangular Confusion Matrix', 'Text', 'Prediction indicator',...
    'Scatter plot','AUC vs Nb Feat' };
handles.draw_method_indexes = 1 : length(handles.draw_method_names);



% if no input argument
if( (length(varargin) < 0.5) )
    
    handles.init_parameter = [];
    handles.feature_result = [];
    handles.init_method = [];
    handles.performance_result = [];
    handles.selected_model = [];
    
else
    
    handles.input = varargin{1};
    
    if(isempty(handles.input.feature_result) > 0.5)
        
        handles.init_parameter = [];
        handles.feature_result = [];
        handles.init_method = [];
        handles.performance_result = [];
        handles.selected_model = [];
        
    else
        selected_model=handles.input.selected_model;
        performance_result=handles.input.performance_result;
        feature_result=handles.input.feature_result;
        init_method=handles.input.init_method;
        init_parameter=handles.input.init_parameter;
        
        handles.init_parameter = init_parameter;
        handles.feature_result = feature_result;
        handles.init_method = init_method;
        handles.performance_result = performance_result;
        handles.selected_model = selected_model;
        
        % plot 4 representations of results : ROC, confusion matrix, performances,
        % rectangular confusion
        draw(hObject, eventdata, handles, 1, 1);
        draw(hObject, eventdata, handles, 2, 2);
        draw(hObject, eventdata, handles, 8, 3);
%         draw(hObject, eventdata, handles, 3, 4);
        draw(hObject, eventdata, handles, 3, 4);

    end
end

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Sigma_result_visualisation_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

init_parameter = handles.init_parameter;
allItems = get(handles.popupmenu1,'string');
selectedIndex = get(handles.popupmenu1,'Value');
selectedItem = allItems{selectedIndex};

handles.init_parameter = init_parameter;

if find( handles.draw_method_indexes,selectedIndex)
    if strcmp(handles.draw_method_names{selectedIndex},selectedItem)
        draw(hObject, eventdata, handles, selectedIndex, 10);
    end
end



function varargout = draw(hObject, eventdata, handles, selectedIndex,source)

init_parameter = handles.init_parameter;
feature_result = handles.feature_result;
init_method = handles.init_method;
performance_result = handles.performance_result;
selected_model = handles.selected_model;
delete(findall(gcf,'Tag','somethingUnique'))

method = cellstr(handles.draw_method_names{selectedIndex});

% Choixe of the figure displaying the result
%figure;
if source == 1
    set(gcf,'CurrentAxes',handles.axes1)
    cla(handles.axes1,'reset')
elseif source == 2
    set(gcf,'CurrentAxes',handles.axes2)
    cla(handles.axes2,'reset')
elseif source == 3
    set(gcf,'CurrentAxes',handles.axes3)
    cla(handles.axes3,'reset')
elseif source == 4
    
else
    f = figure('Position', [100 100 1000 400],'Resize','off');
    f.Name=method{1};
    f.Color='w';
end


if strcmp(method,'Best ROC')
    [max_auc, index]=max(performance_result.performance(:,8));
    scores=performance_result.scores{2};
    %figure
    grid on; grid minor; hold on
    [Xa,Ya,~,auc_temp,OPTROCPT] = perfcurve(feature_result.label,scores(index,:),1);
    if auc_temp == max_auc
        display(['The max AUC is ' num2str(max_auc)])
    end
    plot(Xa,Ya,'r*','markersize',15);
    hold on;
    plot(OPTROCPT(1),OPTROCPT(2),'ko','markersize',15);
    hold on;
    plot(0:1,0:1,'g');
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(['ROC Curve : ' init_parameter.classification_method ' & ' init_parameter.cross_validation_method])
    %dim = [0.82 0.55 0.6 0.3];% out of the box
    dim = [0.6 0.05 0.6 0.3];
    
    str =['Max AUC = ' num2str(max_auc*100,4) '% for Nb feat =   ' num2str(index) ];
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',15,'FitBoxToText','on','Tag' ,'somethingUnique');
    legend({'ROC curve','Operating point'},'FontSize',12,'Location','bestoutside');
    box on
    % Warnning during the ROC computation, could be related to the LOSO
    %     if length(Xa)~=feature_result.nb_epoch+1
    %         message=sprintf('Something strange in your simulation (ROC curves)!\n Please change something and repeat the simulation ');
    %         warndlg(message,'SIGMA Warning')
    %     end
    
elseif strcmp(method,'Confusion Matrix')
    [~, index_max_auc]=max(performance_result.performance(:,8));
    [confusion_matrix,~] = confusionmat(feature_result.label,performance_result.prediction(index_max_auc,:));
    opt=confMatPlot('defaultOpt');
    opt.className={'High', 'Low'};
    opt.mode='both';
    opt.mode='percentage';
    opt.format='8.2f';
    confMatPlot(confusion_matrix, opt);
    
elseif strcmp(method,'Performance')
    data = performance_result.performance;
    if(source == 4) % if plotted on the current window
        set(handles.result_uitable, 'Data', data );
        set(handles.result_uitable, 'ColumnName', performance_result.performance_infos );
    else % if plotted on a separated window
        t = uitable('Parent', f, 'Position', [25 50 700 350], 'Data',data);
        t.ColumnName = performance_result.performance_infos;
    end
    
    
elseif strcmp(method,'Prediction')
    data=performance_result.prediction;
    t = uitable('Parent', f, 'Position', [25 50 950 350], 'Data',data);
    
elseif strcmp(method,'Best Organisation Voted')
    
    data=cell2mat(performance_result.best_organisation_voted);
    t = uitable('Parent', f, 'Position', [25 50 950 350], 'Data',data);
    t.ColumnName = performance_result.best_organisation_infos;
    
    
elseif strcmp(method,'3D Confusion Matrix')
    [~, index_max_auc]=max(performance_result.performance(:,8));
    %[confusion_matrix,~] = confusionmat(feature_result.label,performance_result.prediction(index_max_auc,:));
    predicted_groups=performance_result.prediction(index_max_auc,:);
    actual_groups=feature_result.label;
    %[confusion_matrix, overall_pcc, group_stats, groups_list] = confusionMatrix3d(predicted_groups,actual_groups);
    plot_title='3D Confusion Matrix';
    [~, ~, ~, ~] =confusionMatrix3d(predicted_groups,actual_groups,plot_title,1);
    
elseif strcmp(method,'Circular Confusion Matrix')
    [~, index_max_auc]=max(performance_result.performance(:,8));
    [confusion_matrix,~] = confusionmat(feature_result.label,performance_result.prediction(index_max_auc,:));
    predicted_groups=performance_result.prediction(index_max_auc,:);
    actual_groups=feature_result.label;
    partest(confusion_matrix,1);
    
elseif strcmp(method,'Rectangular Confusion Matrix')
    [~, index_max_auc]=max(performance_result.performance(:,8));
    [confusion_matrix,~] = confusionmat(feature_result.label,performance_result.prediction(index_max_auc,:));
    predicted_groups=performance_result.prediction(index_max_auc,:);
    actual_groups=feature_result.label;
    partest(confusion_matrix,2);
    
elseif strcmp(method,'Text')
    
    
    [~, index_max_auc]=max(performance_result.performance(:,8));
    [confusion_matrix,~] = confusionmat(feature_result.label,performance_result.prediction(index_max_auc,:));
    predicted_groups=performance_result.prediction(index_max_auc,:);
    actual_groups=feature_result.label;
    %partest(confusion_matrix,2);
    output = partest_with_output(confusion_matrix,2);
    data=nan(length(output.sizes),2);
    
    
    
    for i=1:length(output.sizes)
        
        if output.sizes(i)>1
            v1=output.value(i);
            v2=output.value(i+1);
            i=i+1;
            data(i,1)=v1;
            data(i,2)=v2;
        else
            v1=output.value(i);
            data(i,1)=v1;
            
        end
        %data(i,1)=cellstr(String);
        %             data(i,1)=v1;
        %             data(i,2)=v2;
    end
    str = strsplit(output.string,' ');
    f = figure('Position', [100 100 750 400],'Resize','off');
    f.Name=method{1};
    %data={'Prevalence',num2str(pr);'Sensitivity',num2str(SS(1))};
    t = uitable('Parent', f, 'Position', [25 50 700 350], 'Data',data);
    t.RowName = str;
elseif strcmp(method,'Scatter plot')
    %      if source ==1
    %             axis(handles.axes1);
    %             cla(handles.axes1,'reset')
    %      else
    %             f=figure;
    %            f.Name=method{1};
    %      end
    
    Sigma_gscatter_plot(init_parameter,feature_result,init_parameter.feature_index)
    
elseif strcmp(method,'Prediction indicator')
    f = figure('Position', [100 100 1000 400],'Resize','off');
    f.Name=method{1};
    data=performance_result.prediction;
    
    for i=1:length(data(:,1))
        prediction=zeros(1,length(data(1,:)));
        positive = find(data(i,:)==feature_result.label);
        prediction(positive)=1;
        data(i,:)= prediction;
    end
    
    imagesc(data);
    colormap;
    ax = gca;
    load('MyColormaps','mycmap')
    colormap(ax,mycmap);
    caxis([0 1]);
elseif strcmp(method,'AUC vs Nb Feat')
    %figure;
    auc_out=performance_result.performance(:,8);
    nb_feat=1:length(auc_out);
    [max_auc, index]=max(auc_out);
    %figure
    grid on; grid minor; hold on
    plot(nb_feat,auc_out,'k');
    set(gca,'xtick',nb_feat);
    set(gca,'xlim',[nb_feat(1),nb_feat(end)])
    plot(nb_feat,auc_out,'r*','markersize',10);
    hold on;
    plot(index,max_auc,'ko','markersize',10);
    hold on;
    xlabel('Number of used feature')
    ylabel('The AUC')
    title(['AUC vs NbFeat : ' init_parameter.classification_method ' & ' init_parameter.cross_validation_method])
    dim = [0.8 0.05 0.6 0.3];
    
    %   str =['Max AUC = ' num2str(max_auc*100,4) '% for Nb feat =   ' num2str(index) ];
    str{1} =['Max AUC = ' num2str(max_auc*100,4) ' %'];
    str{2} =['Nb feat used =   ' num2str(index) ];
    
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',10,'FitBoxToText','on','Tag','somethingUnique');
    legend({'AUC curve','AUC','AUC max'},'FontSize',12,'Location','bestoutside');
    box on
    
else
    warndlg(sprintf('This méthod is not existant  \n Or may not be coded yet.'))
    
end




% --- Executes on button press in results_pb_load.
function results_pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to results_pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Takfarinas
[FileName,PathName] = uigetfile();
if( FileName == 0)
    disp('load cancelled')
    return
else
    opening_session_name = [ PathName, FileName ];
    handles = Sigma_load_sessionGUI( opening_session_name, handles, hObject );
    
    
    % plot 4 representations of results : ROC, confusion matrix, performances,
    % rectangular confusion
    draw(hObject, eventdata, handles, 1, 1);
    draw(hObject, eventdata, handles, 2, 2);
    draw(hObject, eventdata, handles, 8, 3);
    draw(hObject, eventdata, handles, 3, 4);     
    
end





% --- Executes on button press in DR_pb_roc.
function DR_pb_roc_Callback(hObject, eventdata, handles)

draw(hObject, eventdata, handles, 1, 99);


% --- Executes on button press in DR_pb_confusion_matrix.
function DR_pb_confusion_matrix_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 2, 99);


% --- Executes on button press in DR_pb_performances.
function DR_pb_performances_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 3, 99);


% --- Executes on button press in DR_pb_prediction.
function DR_pb_prediction_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 4, 99);


% --- Executes on button press in DR_pb_BOV.
function DR_pb_BOV_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 5, 99);


% --- Executes on button press in DR_pb_3dCF.
function DR_pb_3dCF_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 6, 99);


% --- Executes on button press in DR_pb_CCM.
function DR_pb_CCM_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 7, 99);


% --- Executes on button press in DR_pb_RCM.
function DR_pb_RCM_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 8, 99);


% --- Executes on button press in DR_pb_text.
function DR_pb_text_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 9, 99);


% --- Executes on button press in DR_pb_PI.
function DR_pb_PI_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 10, 99);


% --- Executes on button press in DR_pb_SP.
function DR_pb_SP_Callback(hObject, eventdata, handles)
draw(hObject, eventdata, handles, 11, 99);


% --- Executes on button press in DR_pb_AUC.
function DR_pb_AUC_Callback(hObject, eventdata, handles)
% hObject    handle to DR_pb_AUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
draw(hObject, eventdata, handles, 12, 99);


% --- Executes on button press in results_pb_clear.
function results_pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to results_pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in results_pb_close.
function results_pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to results_pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('figure closed')
close(gcf)
