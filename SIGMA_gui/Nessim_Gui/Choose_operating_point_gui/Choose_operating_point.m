function varargout = Choose_operating_point(varargin)
% CHOOSE_OPERATING_POINT MATLAB code for Choose_operating_point.fig
%      CHOOSE_OPERATING_POINT, by itself, creates a new CHOOSE_OPERATING_POINT or raises the existing
%      singleton*.
%
%      H = CHOOSE_OPERATING_POINT returns the handle to a new CHOOSE_OPERATING_POINT or the handle to
%      the existing singleton*.
%
%      CHOOSE_OPERATING_POINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSE_OPERATING_POINT.M with the given input arguments.
%
%      CHOOSE_OPERATING_POINT('Property','Value',...) creates a new CHOOSE_OPERATING_POINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Choose_operating_point_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Choose_operating_point_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Choose_operating_point

% Last Modified by GUIDE v2.5 01-Mar-2019 14:08:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Choose_operating_point_OpeningFcn, ...
                   'gui_OutputFcn',  @Choose_operating_point_OutputFcn, ...
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

% --- Executes just before Choose_operating_point is made visible.
function Choose_operating_point_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Choose_operating_point (see VARARGIN)
% Choose default command line output for Choose_operating_point

handles.input = varargin{1};
% get the handles of main sigma

handles.sigma_handles = varargin{1};
handles.sigma_hObject = varargin{2};

%plot the AUC vs number of feature curve
handles = AUC_curve(handles);

%get the default number of feature
default_number_of_feature = getappdata(handles.manual_selection_gui,'Nb_of_features_display');

%extract the score corresponding to the default number of feature
label = handles.input.feature_result.label;
scores_matrix = handles.input.performance_result.scores(2);
scores = scores_matrix(1);
scores = cell2mat(scores(1));
scores = scores(default_number_of_feature,:);

%plot the ROC curve
handles = SIGMA_roc(label,scores,handles);

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Choose_operating_point.
if strcmp(get(hObject,'Visible'),'off')
    %plot(rand(5));
end



% --- Outputs from this function are returned to the command line.
function varargout = Choose_operating_point_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




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
printdlg(handles.manual_selection_gui)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.manual_selection_gui,'Name') '?'],...
                     ['Close ' get(handles.manual_selection_gui,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.manual_selection_gui)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))',...
    'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on mouse press over axes background.
function ROC_curve_axis_ButtonDownFcn(hObject, eventdata, handles)

% hObject    handle to ROC_curve_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function ROC_curve_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROC_curve_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ROC_curve_axis


% --- Executes on button press in Select_model.
function Select_model_Callback(hObject, eventdata, handles)
% hObject    handle to Select_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%get the chosen parameters stored in the GUI
Nb_of_feature_selected = getappdata(handles.manual_selection_gui,'Nb_of_features_display');
Threshold_selected = getappdata(handles.manual_selection_gui,'operating_threshold');

%store these parameters in the main GUI to be used by the rest of the
%SIGMA box
setappdata(handles.input.learning_panel,'nb_of_feature_selected',Nb_of_feature_selected);
setappdata(handles.input.learning_panel,'threshold_selected',Threshold_selected);

close



% --- Executes during object deletion, before destroying properties.
function manual_selection_gui_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_mc_figure.
function save_mc_figure_Callback(hObject, eventdata, handles)
% hObject    handle to save_mc_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = char(datetime); % creat the name of the output files
% creat the default session name
filename=['Confusion_Matrix' str(1:end-9) '_' str(end-7:end-6) str(end-4:end-3)...
    str(end-1:end) '.tif'];
imageData = screencapture(handles.cm_panel_figure);

%image(imageData);axis off
full_filename=fullfile(handles.input.init_parameter.full_session_name,filename);
imwrite(imageData,full_filename)
figure; imshow(full_filename)


% --- Executes on button press in extract_AucVSnbFea_figure.
function extract_AucVSnbFea_figure_Callback(hObject, eventdata, handles)
% hObject    handle to extract_AucVSnbFea_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = figure;
performance_result = handles.input.performance_result;
plot(performance_result.performance(:,8));
%Set the interactive function
hold on;
%Select and plot the default point according to the best AUC
[max_AUC, index]=max(handles.input.performance_result.performance(:,8));
default_number_of_feature = plot(index,max_AUC,'o', 'MarkerSize',10);

%Store the default point as the currently selected point
setappdata(h,'Nb_of_features_display',index);


YP = get(handles.auc_display,'String');
XP = get(handles.nb_of_features_display,'String');
hold on
plot(str2double(XP),str2double(YP),'k*')
%Add legend to the point and axes
legend(default_number_of_feature,'Default point','Location','southeast');
xlabel('Number of features');
ylabel('AUC');
grid on
grid minor
title('AUC vs Number of features')



% --- Executes on button press in extract_roc_figure.
function extract_roc_figure_Callback(hObject, eventdata, handles)
% hObject    handle to extract_roc_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the ROC curve
figure;
c_number_of_point = 1000;
label = handles.input.feature_result.label;
scores_matrix = handles.input.performance_result.scores(2);
scores = scores_matrix(1);
scores = cell2mat(scores(1));
default_number_of_feature = getappdata(handles.manual_selection_gui,'Nb_of_features_display');
scores = scores(default_number_of_feature,:);
[true_positive_rate false_positive_rate threshold_vector all_prediction] = ...
    ROC_from_scores(label,scores,c_number_of_point);
plot(false_positive_rate,true_positive_rate,'.','markersize',20);
hold on;
plot(false_positive_rate,true_positive_rate,'r');

grid on
grid minor
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC Curve')
%% Add the defaut operation point


% --- Executes on button press in save_screen_result.
function save_screen_result_Callback(hObject, eventdata, handles)
% hObject    handle to save_screen_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = char(datetime); % creat the name of the output files
% creat the default session name
filename=['Results_' str(1:end-9) '_' str(end-7:end-6) str(end-4:end-3)...
    str(end-1:end) '.tif'];
imageData = screencapture(handles.manual_selection_gui);
%image(imageData);axis off
full_filename=fullfile(handles.input.init_parameter.full_session_name,filename);
imwrite(imageData,full_filename)
figure; imshow(full_filename)


% --- Executes on button press in cancel_results.
function cancel_results_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.manual_selection_gui)


% --- Executes on button press in more_results.
function more_results_Callback(hObject, eventdata, handles)
% hObject    handle to more_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.sigma_handles = varargin{1};
% handles.sigma_hObject = varargin{2};
handles = Call_classification_display_result(handles.sigma_handles, handles.sigma_hObject);
guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

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
% % %   Creation Date : 27/06/2018
% % %   Updates and contributors :

% % %   Citation: [creator and contributor names], comprehensive BCI
% % %             toolbox, available online 2016.
% % %           
% % %   Contact info : francois.vialatte@espci.fr          
% % %   Copyright of the contributors, 2016
% % %   Creative Commons License, CC-BY-NC-SA
% % %----------------------------------------------------------------------

