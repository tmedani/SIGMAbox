function varargout = sigma_select_paths(varargin)
% SIGMA_SELECT_PATHS MATLAB code for sigma_select_paths.fig
%      SIGMA_SELECT_PATHS, by itself, creates a new SIGMA_SELECT_PATHS or raises the existing
%      singleton*.
%
%      H = SIGMA_SELECT_PATHS returns the handle to a new SIGMA_SELECT_PATHS or the handle to
%      the existing singleton*.
%
%      SIGMA_SELECT_PATHS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGMA_SELECT_PATHS.M with the given input arguments.
%
%      SIGMA_SELECT_PATHS('Property','Value',...) creates a new SIGMA_SELECT_PATHS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sigma_select_paths_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sigma_select_paths_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sigma_select_paths

% Last Modified by GUIDE v2.5 04-Dec-2017 00:58:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sigma_select_paths_OpeningFcn, ...
                   'gui_OutputFcn',  @sigma_select_paths_OutputFcn, ...
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


% --- Executes just before sigma_select_paths is made visible.
function sigma_select_paths_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sigma_select_paths (see VARARGIN)


set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')

set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')

% Choose default command line output for sigma_select_paths
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sigma_select_paths wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sigma_select_paths_OutputFcn(hObject, eventdata, handles) 
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

filePath = uigetdir();
%setappdata(0,'filePath',filePath) ;
set(handles.edit1,'String',filePath)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filePath = uigetdir();
%setappdata(0,'filePath',filePath) ;
set(handles.edit2,'String',filePath)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filePath = uigetdir();
%setappdata(0,'filePath',filePath) ;
set(handles.edit3,'String',filePath)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in default_path_radio_button.
function default_path_radio_button_Callback(hObject, eventdata, handles)
% hObject    handle to default_path_radio_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of default_path_radio_button
% hObject    handle to AM_validation (see GCBO)
x=get(handles.default_path_radio_button,'Value');
y=get(handles.select_path_radio_button,'Value');

if x
    message='You have selected the default locations';
end
if y
    message='You will select others locations';
end
set(handles.info_path,'String',message)
set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')

set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')



% --- Executes on button press in select_path_radio_button.
function select_path_radio_button_Callback(hObject, eventdata, handles)
% hObject    handle to select_path_radio_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_path_radio_button
% hObject    handle to AM_validation (see GCBO)
x=get(handles.default_path_radio_button,'Value');
y=get(handles.select_path_radio_button,'Value');

if x
    message='You have selected the default locations';
end
if y
    message='You will select others locations';
end
set(handles.info_path,'String',message)

set(handles.edit1,'Enable','on')
set(handles.edit2,'Enable','on')
set(handles.edit3,'Enable','on')
set(handles.pushbutton1,'Enable','on')
set(handles.pushbutton2,'Enable','on')
set(handles.pushbutton3,'Enable','on')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=gcf;% get the current figure,
hf=findobj(f,'Name',f.Name);% close the figure

% hf=findobj(gcf,'Name','sigma_select_paths');
close(hf)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% The defaut path is selected
% hObject    handle to AM_validation (see GCBO)
x=get(handles.default_path_radio_button,'Value');
y=get(handles.select_path_radio_button,'Value');

if x
    message='You have selected the default locations';
    edit1='SIGMA_data';
    edit2=fullfile('SIGMA_data','subject_for_test');
    edit3='SIGMA_output';
    handles.out.training_data_location=edit1;
    handles.out.test_data_location=edit2;
    handles.out.results_location=edit3;
end
if y
    %message='You will select others locations';
    handles.location.training_data_location=get(handles.edit1,'String');
    handles.location.test_data_location=get(handles.edit2,'String');
    handles.location.results_location=get(handles.edit3,'String');
end

f=gcf;% get the current figure,
hf=findobj(f,'Name',f.Name);% close the figure
close(hf)
% start SIGMA GUI 
gui_aure_v1(handles)
