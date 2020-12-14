function varargout = Sigma_apply_model_aure_gui(varargin)
% SIGMA_APPLY_MODEL_AURE_GUI MATLAB code for Sigma_apply_model_aure_gui.fig
%      SIGMA_APPLY_MODEL_AURE_GUI, by itself, creates a new SIGMA_APPLY_MODEL_AURE_GUI or raises the existing
%      singleton*.
%
%      H = SIGMA_APPLY_MODEL_AURE_GUI returns the handle to a new SIGMA_APPLY_MODEL_AURE_GUI or the handle to
%      the existing singleton*.
%
%      SIGMA_APPLY_MODEL_AURE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGMA_APPLY_MODEL_AURE_GUI.M with the given input arguments.
%
%      SIGMA_APPLY_MODEL_AURE_GUI('Property','Value',...) creates a new SIGMA_APPLY_MODEL_AURE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sigma_apply_model_aure_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sigma_apply_model_aure_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sigma_apply_model_aure_gui

% Last Modified by GUIDE v2.5 21-Mar-2018 13:00:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sigma_apply_model_aure_gui_OpeningFcn, ...
    'gui_OutputFcn',  @Sigma_apply_model_aure_gui_OutputFcn, ...
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


% --- Executes just before Sigma_apply_model_aure_gui is made visible.
function Sigma_apply_model_aure_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sigma_apply_model_aure_gui (see VARARGIN)

% Choose default command line output for Sigma_apply_model_aure_gui
handles.output = hObject;

%handles=varargin{1};
%disp(nargin)
if(nargin == 0)
    handles.input = [];
elseif ~isempty(varargin)
    handles.input = varargin{1};   
    % initialisation
    set(handles.AM_validation,'Value',1)
    %set(handles.AM_validation_or_test,'String','Please choose')
    set(handles.AM_selected_model_to_apply_edit_text,'String',...
        [handles.input.init_parameter.data_output handles.input.init_parameter.session_name])
    
    % initialize the value of the data loadin by the user or not
    handles.user_load_his_data=0;
    
    % the default value of the data test location
    if isfield(handles.input.init_parameter,'test_data_location')
        filePath = handles.input.init_parameter.test_data_location;
        set(handles.AM_st_data_path,'String',filePath)
    end
    
    % add the image to the GUI
    %pwd_here=pwd;
%     sigma_dir = handles.input.init_parameter.sigma_directory;
%     if ispc
%         filename = fullfile(sigma_dir,'SIGMA_documents\logo\logo_p5.png');
%     end
%     if ismac
%         filename = fullfile(sigma_dir,'SIGMA_documents/logo/logo_p5.png');
%     end
    
    %cd(handles.input.init_parameter.sigma_directory)
    % myImage = imread(filename);
    % set(handles.AM_image_axis,'Units','pixels');
    % resizePos = get(handles.AM_image_axis,'Position');
    % myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
    % axes(handles.AM_image_axis);
    % imshow(myImage);
    % set(handles.AM_image_axis,'Units','normalized');
    % %cd(pwd_here);
    %
    % % Add contxt menu
    % handles.AM_image_axis
    
    
    % Update handles structure
end
guidata(hObject, handles);

% UIWAIT makes Sigma_apply_model_aure_gui wait for user response (see UIRESUME)
% uiwait(handles.Apply_model_panel);


% --- Outputs from this function are returned to the command line.
function varargout = Sigma_apply_model_aure_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AM_load_data_button.
function AM_load_data_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_load_data_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filePath = uigetdir();

if filePath==0
    msgbox('No path selected, the defaut path is kept','SIGMA warning','warn');
    return
end
%filePath=handles.AM_st_data_path.String

setappdata(0,'filePath',filePath) ;
set(handles.AM_st_data_path,'String',filePath)
% get what is inside the folder
disp(filePath)
if ispc
    Infolder = dir([ filePath, '\*.mat' ]);
end
if ismac
    Infolder = dir([ filePath, '/*.mat' ]);
end


disp('FOLDER')
disp(Infolder)
% get the files
MyListOfFiles = {Infolder(~[Infolder.isdir]).name};
% update the listbox with the result
set(handles.AM_available_data,'String',MyListOfFiles)

%update the location of the data to test
handles.AM_location_data_test = filePath;
% set this value to 1, the user select his own data
handles.user_load_his_data = 1;

handles.selected_subject = {};
handles.unselected_subject = MyListOfFiles;
handles.subject_list = MyListOfFiles;

% set to off the load custom feature
set(handles.AM_load_custom_feat_button,'Enable','off');
set(handles.AM_Load_custom_feature_menubar,'Enable','off');
set(handles.AM_Load_subject_menubar,'Checked','on');

% set the maximum value to select 
set(handles.AM_available_data,'Max',length(MyListOfFiles));
set(handles.AM_selected_data,'Max',length(MyListOfFiles));



guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function AM_st_data_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AM_st_data_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AM_available_data.
function AM_available_data_Callback(hObject, eventdata, handles)

if( strcmp(get(handles.Apply_model_panel,'SelectionType'), 'open'))
    handles = AM_subject2right(handles, hObject);
    % set_button_availability(handles, hObject)
    guidata(hObject, handles);
end

function AM_selected_data_Callback(hObject, eventdata, handles)

if( strcmp(get(handles.Apply_model_panel,'SelectionType'), 'open'))
    handles = AM_subject2left(handles, hObject);
    %set_button_availability(handles, hObject)
    guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function AM_available_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AM_available_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AM_validation.
function AM_validation_Callback(hObject, eventdata, handles)
% hObject    handle to AM_validation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(handles.AM_validation,'Value');
y=get(handles.AM_test,'Value');

if x
    message='You will validate the model';
end
if y
    message='You will test the model';
end
set(handles.AM_validation_or_test,'String',message)


% --- Executes on button press in AM_test.
function AM_test_Callback(hObject, eventdata, handles)
% hObject    handle to AM_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(handles.AM_validation,'Value');
y=get(handles.AM_test,'Value');

if x
    message='You will validate the model';
end
if y
    message='You will test the model';
end
set(handles.AM_validation_or_test,'String',message)


% --- Executes on button press in AM_apply_model_button.
function AM_apply_model_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_apply_model_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=get(handles.AM_validation,'Value');
y=get(handles.AM_test,'Value');
if x
    test_or_application='test';
end
if y % for the test or application
    test_or_application='Application';
end
handles.input.test_or_application=test_or_application;
handles.apply_model_in.test_or_application=handles.input.test_or_application;


%%%%%%%%%%%%%%%%%%%%%%
if isfield(handles,'AM_Load_custom_feature')
    AM_Load_custom_feature = handles.AM_Load_custom_feature;
else
    AM_Load_custom_feature = 0;
end

if AM_Load_custom_feature == 0
    if ~isfield(handles.input,'init_parameter')
       msgbox('Please load model & data before','SIGMA Error','warn');
       return
    end
    handles.apply_model_in.init_parameter=handles.input.init_parameter;
    handles.apply_model_in.init_method=handles.input.init_method;
    handles.apply_model_in.selected_model=handles.input.selected_model;
    handles.apply_model_in.feature_result=handles.input.feature_result;
    
    if handles.user_load_his_data==0
        msg=sprintf('You ar going to use the default path for the data!\n Are you sure?');
        choice = questdlg(msg, 'SIGMA : Application Model','Yes', 'No', 'No');
        % Handle response
        switch choice
            case 'Yes'
                % clean the texte
                set(handles.AM_st_data_path,'String','')
                set(handles.AM_st_data_path,'String',handles.input.init_parameter.test_data_location)
                % get the default path
                filePath=fullfile(handles.input.init_parameter.sigma_directory,...
                    handles.AM_st_data_path.String);
                setappdata(0,'filePath',filePath);
                %set the value
                set(handles.AM_st_data_path,'String',filePath)
                % get what is inside the folder
                Infolder = dir(filePath);
                % get the files
                MyListOfFiles = {Infolder(~[Infolder.isdir]).name};
                % update the listbox with the result
                %set(handles.AM_available_data,'String',MyListOfFiles)
                set(handles.AM_selected_data,'String',MyListOfFiles)
                
                handles.unselected_subject=get(handles.AM_available_data,'String');
                handles.selected_subject=get(handles.AM_selected_data,'String');
                
                % Run the function
                disp('USE THE APLY MODEL BUTTOn')
                
                handles = Sigma_apply_model_from_gui(handles);
                
                handles.apply_model_out.test_or_application=test_or_application;
                handles.apply_model_outputs=handles.apply_model_out;
                handles.apply_model_inputs=handles.apply_model_in;
            case 'No'
                msg=sprintf('Please select your data in the section 1');
                f=warndlg(msg,'SIGMA Warning !');
                % get the handal of the load data
                myh=handles.AM_load_data_button;
                set(myh,'tag','sliderGUI1')
                myh=findall(0,'tag','sliderGUI1');
                %uiFlash(myh, 'BackgroundColor', [1, 0, 0])
                % attend la fermeture de la box
                waitfor(f);
                uiFlash(myh, 'BackgroundColor', [1, 0, 0])
                %return
        end
    elseif handles.user_load_his_data==1
        % Run the function
        disp('USE THE APPLY MODEL BUTTON')
        handles = Sigma_apply_model_from_gui(handles);
        
        handles.apply_model_out.test_or_application=test_or_application;
        handles.apply_model_outputs=handles.apply_model_out;
        handles.apply_model_inputs=handles.apply_model_in;
    end
elseif AM_Load_custom_feature == 1;
    %     handles.apply_model_in.init_parameter = handles_in.init_parameter;
    %     handles.apply_model_in.init_method = handles_in.init_method;
    %     handles.apply_model_in.selected_model = handles_in.selected_model;
    %     handles.apply_model_in.init_method=handles.input.init_method;
    %     handles.AM_Load_custom_feature = AM_Load_custom_feature;
    
    disp('USE THE APPLY MODEL BUTTON')
    handles = Sigma_apply_model_from_gui(handles);
    
    handles.apply_model_out.test_or_application=test_or_application;
    handles.apply_model_outputs=handles.apply_model_out;
    handles.apply_model_inputs=handles.apply_model_in;
    
end
guidata(hObject, handles);


% --- Executes on button press in AM_display_results_button.
function AM_display_results_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_display_results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'apply_model_outputs')
    msgbox('Please run Apply model before','SIGMA Warning','warn');
    return
end
apply_model_outputs = handles.apply_model_outputs;
if strcmp(apply_model_outputs.test_or_application,'Application')
    selected_model=handles.input.selected_model;
    %f = figure('Position', [100 100 750 400],'Resize','off');
    f = figure('Color','w','Resize','off');
    title('Performance of the Model "Application" ','FontSize',15)
    axis off;
    f.Name='Performance Trainning Phase ';
    data=[selected_model.nb_feat_model selected_model.performance_model]';
    t = uitable('Parent', f, 'Data',data);
    t.RowName = ['Used feature(s)' selected_model.performance_model_infos]';
    t.ColumnName=' Performances Model : Trainning ';
    t.FontSize=12;
    t.FontWeight='bold';
    t.Position=[125 125 350 230];
    
    % Add annotation to the plot
    auc_max=selected_model.performance_model(end);
    nb_feat=selected_model.nb_feat_model;
    dim = [0.2 0.05 0.2 0.3];
    str =['Max AUC = ' num2str(auc_max*100) '% for Nb feat =   ' num2str(nb_feat)...
        ';  This is the results of the Training'];
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',15,'FitBoxToText','on','Tag' ,'somethingUnique');
    htxtbox.Units='pixels';
    htxtbox.Position=[110 60 390 60]; % manuelly added
    
elseif strcmp(apply_model_outputs.test_or_application,'test')
    f = figure('Color','w','Resize','off');
    title('Performance of the Model "test" ','FontSize',15)
    axis off;
    f.Name='Performances Training phase ';
    % nb_used feature
    nb_feat=size(apply_model_outputs.computed_feature_new_data,1);
    auc_max=apply_model_outputs.test_results.performance(end);
    
    data=[nb_feat apply_model_outputs.test_results.performance]';
    t = uitable('Parent', f, 'Data',data);
    t.RowName =['Used feature(s)'  apply_model_outputs.test_results.performance_infos]';
    t.ColumnName=' Performances Model : test ';
    t.FontSize=12;
    t.FontWeight='bold';
    t.Position=[125 125 350 230];
    
    % Add annotation to the plot
    %auc_max=selected_model.performance_model(end);
    %nb_feat=selected_model.nb_feat_model;
    dim = [0.2 0.05 0.2 0.3];
    str =['Max AUC = ' num2str(auc_max*100) '% for Nb feat =   ' num2str(nb_feat)...
        ';  This is the results of the test'];
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',15,'FitBoxToText','on','Tag' ,'somethingUnique');
    htxtbox.Units='pixels';
    htxtbox.Position=[110 60 390 60]; % manuelly added
end
guidata(hObject, handles);





% --- Executes on button press in AM_show_performances.
function AM_show_performances_Callback(hObject, eventdata, handles)
% hObject    handle to AM_show_performances (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'input')
    selected_model=handles.input.selected_model;
else
    msgbox('No Model selected, please select model','SIGMA Error','warn');
    return;
end
%f = figure('Position', [100 100 750 400],'Resize','off');
f = figure('Color','w','Resize','off');
title('Performance of the Model "Training Phase" ','FontSize',20)
axis off;
f.Name='Performances Training phase ';
data=[selected_model.nb_feat_model selected_model.performance_model]';
t = uitable('Parent', f, 'Data',data);
t.RowName = ['Used feature(s)' selected_model.performance_model_infos]';
t.ColumnName=' Performances Model : Training ';
t.FontSize=12;
t.FontWeight='bold';
t.Position=[125 125 350 230];
%t.Position=get(f,'Position')/2
%f.Position=[100 200 750 400]
% t.ColumnName = ['Nb feature' selected_model.performance_model_infos]';
% t.RowName=' Performances Model : Training ';

% --- Executes on button press in AM_load_model_button.
function AM_load_model_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_load_model_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% FINIR DE CODER
choice = questdlg('This will remplace the current model ! Are you sure?', 'SIGMA : Exit','Yes', 'No', 'No');
% Handle response
switch choice
    case 'Yes'
        %% start here
        data_ok=0; % check if the data are corectly loaded
        [FileName,PathName] = uigetfile();
        if( FileName == 0)
            disp('load cancelled')
        else
            filename=fullfile(PathName,FileName);
            [~,~,ext] =fileparts(filename)  ;
            if strcmp(ext,'.mat')
                variableInfo = who('-file',filename);
                if ismember('selected_model', variableInfo) % returns true
                    load(filename,'selected_model')
                    load(filename,'init_parameter')
                    handles.input.selected_model=selected_model;
                    handles.input.init_parameter=init_parameter;
                    model_ok=1;
                else
                    message=sprintf('The "selected_model" is not exists in this file!! \n please select the right file');
                    errordlg(message,'SIGMA error')
                    return
                end
            else
                message=sprintf('The selected file is not a *.mat file!! \n please select the right file');
                errordlg(message,'SIGMA error')
                return
            end
            
            if model_ok % updat the static text to inform the user about the model
                message=('You have selected your model');
                set(handles.AM_infos_about_model_static_text,'String',message)
                set(handles.AM_selected_model_to_apply_edit_text,'String',[init_parameter.data_output init_parameter.session_name]);
            end
            guidata(hObject, handles);
        end
        %% end here
    case 'No'
        return
end




% --- Executes on button press in AM_save_results_button.
function AM_save_results_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_save_results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%msgbox('This method is not already implemented for this version of SIGMA','SIGMA Warning !','warning');

%% Get the selected results accordin to the best AUC
init_parameter=handles.input.init_parameter;
feature_result=handles.input.feature_result;
init_method=handles.input.init_method;
performance_result=handles.input.performance_result;
selected_model=handles.input.selected_model;
if isfield(handles,'apply_model_out')
    apply_model_out=handles.apply_model_out;
else
    apply_model_out=[];
end

% save the modele in the outputFile of the session
%filename=[init_parameter.full_session_name '\' session_name];
filename=fullfile(init_parameter.full_session_name,init_parameter.session_name);
save(filename,'init_parameter','feature_result','init_method',...
    'performance_result','selected_model','apply_model_out')


% Construct a questdlg with three options
choice=questdlg('You session is correctly saved on current session folder'...
    ,'SIGMA save session','Ok', 'Open folder','Open folder');
% Handle response
switch choice
    case 'OK'
        display('Goood')
    case 'Open folder'
        winopen(init_parameter.full_session_name);
end
%



% --- Executes on button press in AM_clear_button.
function AM_clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.Apply_model_panel)
Sigma_apply_model_aure_gui();
%msgbox('This method is not already implemented for this version of SIGMA','SIGMA Warning !','warn');
guidata(hObject, handles);

% close(hObject)
% AM_main_gui_panel

% --- Executes on button press in AM_close_button.
function AM_close_button_Callback(hObject, eventdata, handles)
close(handles.Apply_model_panel)
% --- Executes on button press in AM_help_button.
function AM_help_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_help_gui


% --- Executes on button press in AM_export_to_matlab_button.
function AM_export_to_matlab_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_export_to_matlab_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp(handles.init_parameter)
% disp(handles.init_method(1))
% disp(handles.feature_result)
% disp(handles.performance_result)
assignin('base', 'init_parameter', handles.input.init_parameter )
assignin('base', 'init_method', handles.input.init_method )
assignin('base', 'feature_result', handles.input.feature_result )
assignin('base', 'performance_result', handles.input.performance_result )
assignin('base', 'selected_model', handles.input.selected_model )
if isfield(handles,'apply_model_out')
    assignin('base', 'apply_model_results', handles.apply_model_out)
else
    handles.apply_model_out=[];
    assignin('base', 'apply_model_results', handles.apply_model_out)
end
uiwait(msgbox('SIGMA >> Data are exported to matlab'));

%disp(handles.init_parameter.subject_name)


% --- Executes on button press in AM_roc_results_button.
function AM_roc_results_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_roc_results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'apply_model_outputs')
    msgbox('Please run Apply model before','SIGMA Warning','warn');
    return
end

apply_model_outputs=handles.apply_model_outputs;
if strcmp(apply_model_outputs.test_or_application,'Application')
    performance_result=handles.input.performance_result;
    feature_result=handles.input.feature_result;
    init_parameter=handles.input.init_parameter;
    
    [max_auc, index]=max(performance_result.performance(:,8));
    scores=performance_result.scores{2};
    
    figure
    grid on; grid minor; hold on
    [Xa,Ya,~,auc_temp,OPTROCPT] = perfcurve(feature_result.label,scores(index,:),1);
    if auc_temp==max_auc
        display('The ROC is correct Greaaaat :) ')
    end
    %plot(Xa,Ya,'r*',0:1,0:1,'g',1:-0.1:0,0:0.1:1,'y',OPTROCPT(1),OPTROCPT(2),'ks','markersize',15)
    plot(Xa,Ya,'r*','markersize',15);
    hold on;
    plot(OPTROCPT(1),OPTROCPT(2),'ko','markersize',15);
    hold on;
    plot(0:1,0:1,'g');
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(['ROC Curve Training : ' init_parameter.classification_method ' & ' init_parameter.cross_validation_method])
    %dim = [0.82 0.55 0.6 0.3];% out of the box
    dim = [0.6 0.05 0.6 0.3];
    
    str =['Max AUC = ' num2str(max_auc*100,4) '% for Nb feat =   ' num2str(index) ];
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',15,'FitBoxToText','on','Tag' ,'somethingUnique');
    legend({'ROC curve','Operating point'},'FontSize',12,'Location','bestoutside');
    box on
    % Warnning during the ROC computation, could be related to the LOSO
    if length(Xa)~=feature_result.nb_epoch+1
        warndlg('Something is strange in your simulation! please send this bug to the BCI Team','SIGMA Warning')
    end
    
    
elseif strcmp(apply_model_outputs.test_or_application,'test')
    init_parameter=handles.input.init_parameter;
    label=apply_model_outputs.origine_label;
    
    index=size(apply_model_outputs.computed_feature_new_data,1);
    nb_epoch=size(apply_model_outputs.computed_feature_new_data,2);
    
    scores=apply_model_outputs.predicted_scores(:,1);
    [Xa,Ya,~,AUC,OPTROCPT] = perfcurve(label,scores,-1);
    figure;
    plot(Xa,Ya,'r*','markersize',15);
    hold on;
    plot(OPTROCPT(1),OPTROCPT(2),'ko','markersize',15);
    hold on;
    plot(0:1,0:1,'g');
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(['ROC Curve Test : ' init_parameter.classification_method ' & ' init_parameter.cross_validation_method])
    %dim = [0.82 0.55 0.6 0.3];% out of the box
    dim = [0.6 0.05 0.6 0.3];
    
    str =['AUC = ' num2str(AUC*100,4) '% for Nb feat =   ' num2str(index) ];
    htxtbox =annotation('textbox',dim,'String',str,'FontSize',15,'FitBoxToText','on','Tag' ,'somethingUnique');
    legend({'ROC curve','Operating point'},'FontSize',12,'Location','bestoutside');
    box on
    % Warnning during the ROC computation, could be related to the LOSO
    %     if length(Xa)~=nb_epoch+1
    %         warndlg('Something is strange in your simulation! please send this bug to the BCI Team','SIGMA Warning')
    %     end
    
end
guidata(hObject, handles);


% --- Executes on button press in AM_prediction_button.
function AM_prediction_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_prediction_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'apply_model_outputs')
    msgbox('Please run Apply model before','SIGMA Warning','warn');
    return
end
apply_model_outputs=handles.apply_model_outputs;
if strcmp(apply_model_outputs.test_or_application,'Application')
    performance_result=handles.input.performance_result;
    feature_result=handles.input.feature_result;
    selected_model=handles.input.selected_model;
    apply_model_results=handles.apply_model_out;
    
    [max_auc, index]=max(performance_result.performance(:,8));
    f = figure('Position',  [500 500 750 160],'Resize','off');
    clear data
    data(1,:)=apply_model_results.predicted_label;
    %data(2,:)=performance_result.prediction(index,:);
    
    f.Name='Application : Prediction of the outputs';
    t=uitable('Parent', f, 'Position', [25 50 700 100], 'Data',data);
    t.ColumnName=[];
    for ind=1:length( data(1,:))
        t.ColumnName{ind}=['epoch_' num2str(ind)];
    end
    t.RowName=[];
    %t.RowName{1}=' Origine label ';
    t.RowName{1}=' Predicted label ';
    
elseif strcmp(apply_model_outputs.test_or_application,'test')
    
    f = figure('Position', [500 500 750 160],'Resize','off');
    data(1,:)=apply_model_outputs.origine_label;
    data(2,:)=apply_model_outputs.predicted_label;
    
    f.Name='Test : Prediction of the outputs';
    t=uitable('Parent', f, 'Position', [25 50 700 100], 'Data',data);
    t.ColumnName=[];
    for ind=1:length( data(1,:))
        t.ColumnName{ind}=['epoch_' num2str(ind)];
    end
    t.RowName=[];
    t.RowName{1}=' Origine label ';
    t.RowName{2}=' Predicted label ';
    
end


% --- Executes on button press in AM_tutoriel_button.
function AM_tutoriel_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_tutoriel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function AM_selected_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AM_selected_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in AM_load_custom_feat_button.
function AM_load_custom_feat_button_Callback(hObject, eventdata, handles)
% hObject    handle to AM_load_custom_feat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles_in=handles.input;
handles_in.AM_Load_custom_feature=1;

handles_in = Load_feature_Apply_model(handles_in, hObject);
%handles.apply_model_in

handles.apply_model_in.init_parameter = handles_in.init_parameter;
handles.apply_model_in.init_method = handles_in.init_method;
handles.apply_model_in.selected_model = handles_in.selected_model;
handles.apply_model_in.init_method=handles.input.init_method;
handles.AM_Load_custom_feature = handles_in.AM_Load_custom_feature;
handles.apply_model_in.feature_result = handles_in.feature_result;
disp('Loading Custom Feature OK')

set(handles.AM_st_custom_feature_path,'String',handles_in.init_parameter.custom_feature_full_name);

% set the button Load subject to off
set(handles.AM_load_data_button,'Enable','off');
set(handles.AM_Load_subject_menubar,'Enable','off');
set(handles.AM_Load_custom_feature_menubar,'Checked','on');
% enable the list box of subject
set(handles.AM_available_data,'Enable','off');
set(handles.AM_available_data,'BackgroundColor',[0.5 0.5 0.5]);

set(handles.AM_selected_data,'Enable','off');
set(handles.AM_selected_data,'BackgroundColor',[0.5 0.5 0.5]);

set(handles.AM_st_data_path,'String','You have selected Custom Feature');
set(handles.AM_st_data_path,'ForegroundColor',[0.5 0.5 0.5]);



% enable the selection button
set(handles.AM_push_select_subject,'Enable','off');
set(handles.AM_push_remove_subject,'Enable','off');

% enable the context menu
set(handles.AM_get_infos_subject_context_menu,'Enable','off');
set(handles.AM_open_folder_subject,'Enable','off');


guidata(hObject, handles);

%handles.input


% --------------------------------------------------------------------
function AM_load_subject_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_load_subject_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_load_data_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_load_custom_feature_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_load_custom_feature_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_load_custom_feat_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_load_model_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_load_model_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_load_model_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_close_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_close_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_close_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_apply_model_oolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_apply_model_oolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_apply_model_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_export_to_matlab_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_export_to_matlab_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_export_to_matlab_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_save_result_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_save_result_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_save_results_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_select_data_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to AM_select_data_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_Select_model_menubar_title_Callback(hObject, eventdata, handles)
% hObject    handle to AM_Select_model_menubar_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function AM_Select_model_menubar_Callback(hObject, eventdata, handles)
AM_load_model_button_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function AM_Load_subject_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to AM_Load_subject_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_load_data_button_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function AM_Load_custom_feature_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to AM_Load_custom_feature_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_load_custom_feat_button_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function AM_run_apply_model_menubar_title_Callback(hObject, eventdata, handles)
% hObject    handle to AM_run_apply_model_menubar_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function AM_run_apply_model_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to AM_run_apply_model_menubar_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_apply_model_button_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_get_infos_subject_context_menu_Callback(hObject, eventdata, handles)
% hObject    handle to AM_get_infos_subject_context_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'subject_list')
    disp('Subject selected');
else
    msgbox('No subject available. Please Load Subject Before','SIGMA Warning','warn');
    return;
end
subject_index=handles.subject_list;
nb_subject=length(handles.subject_list);
data=[];subject_rank=[];
for ind=1:nb_subject
    load(fullfile(handles.AM_location_data_test, subject_index{ind}))
    %load([handles.init_parameter.data_location subject_index{ind}])
    % get the information
    subject_number=s_EEG.subject_number;
    sampling_rate=s_EEG.sampling_rate;
    %channel_name=s_EEG.channel_names;
    class=unique(s_EEG.labels);
    if length(class)==2
        class_one=class(1);
        class_two=class(2);
    else
        class_one=class(1);
        class_two=nan;
    end
    
    temp=unique(class);
    if length(class)==2
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=length(find(s_EEG.labels==temp(2)));
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=100*amount_class_two/length(s_EEG.labels);
    else
        amount_class_one=length(find(s_EEG.labels==temp(1)));
        amount_class_two=nan;
        rate_class_one=100*amount_class_one/length(s_EEG.labels);
        rate_class_two=nan;
    end
    nb_channel=size(s_EEG.data,1);
    nb_sample=size(s_EEG.data,2);
    nb_epoch=size(s_EEG.data,3);
    time_duration=nb_sample/sampling_rate;
    
    data =[data; subject_number nb_channel nb_sample sampling_rate...
        time_duration nb_epoch class_one class_two...
        amount_class_one amount_class_two rate_class_one rate_class_two];
    
    % numérotaion rank subject
    temp_var = strcat( 'subject ',num2str(ind,2) );
    subject_rank=[subject_rank;{temp_var}];
end

% $TODO : find an inteligent wy to fit the table to the data
f = figure('Color','w');
f.Name='Loaded subject on SIGMA';
f.MenuBar='none';
f.NumberTitle='off';
title('Infos about the loaded subject(s)','fontsize',15);
axis off
d = data; % Make some random data to add
t = uitable(f);
set(t,'Data',d,'FontSize',12); % Use the set command to change the uitable properties.
columname={' Subject number ';' nb_channel ';' nb_sample ';...
    ' sampling_rate (Hz) ';' time_duration (s) ';' nb_epoch ';' class_one ';...
    ' class_two ';' amount_class_one ';' amount_class_two ';' rate_class_one ';...
    ' rate_class_two '};
set(t,'ColumnName',columname,'Fontsize',15);
set(t,'RowName',subject_rank,'fontsize',15);
set(t,'TooltipString','Loaded subject');

reformatTable(t,f)

% --------------------------------------------------------------------
function AM_select_subject_Callback(hObject, eventdata, handles)
% hObject    handle to AM_select_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_open_folder_subject_Callback(hObject, eventdata, handles)
% hObject    handle to AM_open_folder_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(handles.input.init_parameter.test_data_location);


% --------------------------------------------------------------------
function AM_open_matlab_apply_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_open_matlab_apply_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit('Sigma_apply_model_from_gui.m');


% --------------------------------------------------------------------
function AM_what_is_test_application_Callback(hObject, eventdata, handles)
% hObject    handle to AM_what_is_test_application (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_open_folder_select_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_open_folder_select_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[PATHSTR,~,~] = fileparts(handles.input.init_parameter.full_session_name);
winopen(PATHSTR);

% --------------------------------------------------------------------
function AM_what_is_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_what_is_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_open_the_folder_custom_feature_Callback(hObject, eventdata, handles)
% hObject    handle to AM_open_the_folder_custom_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'AM_st_custom_feature_path')
    [PATHSTR,~,~] = fileparts(handles.input.init_parameter.custom_feature_full_name);
    winopen(PATHSTR);
else
    set(handles.AM_open_the_folder_custom_feature,'Enable','off');
end


% --------------------------------------------------------------------
function AM_what_is_custom_feature_Callback(hObject, eventdata, handles)
% hObject    handle to AM_what_is_custom_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_load_custom_feature_Callback(hObject, eventdata, handles)
% hObject    handle to AM_load_custom_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_select_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_select_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_test_application_Callback(hObject, eventdata, handles)
% hObject    handle to AM_test_application (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_use_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_use_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AM_what_is_apply_model_Callback(hObject, eventdata, handles)
% hObject    handle to AM_what_is_apply_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in AM_push_select_subject.
function AM_push_select_subject_Callback(hObject, eventdata, handles)
% hObject    handle to AM_push_select_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'selected_subject')%unselected_subject
    disp('Subject selected');
else
    msgbox('No subject available. Please Load Subject Before','SIGMA Warning','warn');
    return;
end

handles = AM_subject2right(handles, hObject);
% set_button_availability(handles, hObject)
guidata(hObject, handles);

% --- Executes on button press in AM_push_remove_subject.
function AM_push_remove_subject_Callback(hObject, eventdata, handles)
% hObject    handle to AM_push_remove_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'unselected_subject')%unselected_subject
    disp('Subject selected');
else
    msgbox('No subject available. Please Load Subject Before','SIGMA Warning','warn');
    return;
end

handles = AM_subject2left(handles, hObject);
%set_button_availability(handles, hObject)
guidata(hObject, handles);


% --------------------------------------------------------------------
function AM_show_performance_menubar_Callback(hObject, eventdata, handles)
% hObject    handle to AM_show_performance_menubar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AM_show_performances_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function AM_close_wait_bar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_close_wait_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);


% --------------------------------------------------------------------
function AM_screen_shoot_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to AM_screen_shoot_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = char(datetime); % creat the name of the output files
% creat the default session name
filename=['SIGMA_apply_model_' str(1:end-9) '_' str(end-7:end-6) str(end-4:end-3)...
                                                    str(end-1:end) '.tif'];
imageData = screencapture(handles.Apply_model_panel);

%image(imageData);axis off
full_filename=fullfile(handles.input.init_parameter.full_session_name,filename);
imwrite(imageData,full_filename)
figure; imshow(full_filename)
