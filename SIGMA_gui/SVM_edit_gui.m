function varargout = SVM_edit_gui(varargin)
% SVM_EDIT_GUI MATLAB code for SVM_edit_gui.fig
%      SVM_EDIT_GUI, by itself, creates a new SVM_EDIT_GUI or raises the existing
%      singleton*.
%
%      H = SVM_EDIT_GUI returns the handle to a new SVM_EDIT_GUI or the handle to
%      the existing singleton*.
%
%      SVM_EDIT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVM_EDIT_GUI.M with the given input arguments.
%
%      SVM_EDIT_GUI('Property','Value',...) creates a new SVM_EDIT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SVM_edit_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SVM_edit_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SVM_edit_gui

% Last Modified by GUIDE v2.5 05-Apr-2018 17:25:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SVM_edit_gui_OpeningFcn, ...
    'gui_OutputFcn',  @SVM_edit_gui_OutputFcn, ...
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

%% Opening and Output function
% --- Executes just before SVM_edit_gui is made visible.
function SVM_edit_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SVM_edit_gui (see VARARGIN)

% Choose default command line output for SVM_edit_gui
handles.output = hObject;

% get input data
handles.input = varargin{1};
handles.input_initial = varargin{1};
handles.save_change = 0;
% display svm parameter on gui


handles.kernel_list ={'linear', 'quadratic', 'polynomial', 'rbf'};
% intitialize kernel gui values
set(handles.SVME_cb_linear, 'Value', 0);
set(handles.SVME_cb_quadratic, 'Value', 0);
set(handles.SVME_cb_polynomial, 'Value', 0);
set(handles.SVME_cb_rbf, 'Value', 0);
for c_kernel_value = 1:length(handles.input.c_kernel)
    set(eval([ 'handles.SVME_cb_', handles.input.c_kernel{c_kernel_value} ]), 'Value', 1);
end

% Initialize Gaussian value
if( length(handles.input.c_gaussian_value) == 1)
set(handles.SVME_edit_GV_low, 'String',  handles.input.c_gaussian_value);
set(handles.SVME_edit_GV_step, 'String',  handles.input.c_gaussian_value);
set(handles.SVME_edit_GV_high, 'String',  handles.input.c_gaussian_value);
else
 set(handles.SVME_edit_GV_low, 'String',  handles.input.c_gaussian_value(1));
set(handles.SVME_edit_GV_step, 'String',  handles.input.c_gaussian_value(2) - handles.input.c_gaussian_value(1));
set(handles.SVME_edit_GV_high, 'String',  handles.input.c_gaussian_value(end));   
end
% Initialize polynomial value
if( length(handles.input.c_gaussian_value) == 1)
set(handles.SVME_edit_PV_low, 'String',  handles.input.c_polynomial_value);
set(handles.SVME_edit_PV_step, 'String',  handles.input.c_polynomial_value);
set(handles.SVME_edit_PV_high, 'String',  handles.input.c_polynomial_value);
else
 set(handles.SVME_edit_PV_low, 'String',  handles.input.c_polynomial_value(1));
set(handles.SVME_edit_PV_step, 'String',  handles.input.c_polynomial_value(2) - handles.input.c_polynomial_value(1));
set(handles.SVME_edit_PV_high, 'String',  handles.input.c_polynomial_value(end));   
end
% Initialize hyper parameter
if( length(handles.input.c_gaussian_value) == 1)
set(handles.SVME_edit_cons_low, 'String',  handles.input.c_constraint);
set(handles.SVME_edit_cons_step, 'String',  handles.input.c_constraint);
set(handles.SVME_edit_cons_high, 'String',  handles.input.c_constraint);
else
 set(handles.SVME_edit_cons_low, 'String',  handles.input.c_constraint(1));
set(handles.SVME_edit_cons_step, 'String',  handles.input.c_constraint(2) - handles.input.c_constraint(1));
set(handles.SVME_edit_cons_high, 'String',  handles.input.c_constraint(end));   
end
% Initialize other parameters
set(handles.SVME_edit_kkttol, 'String',  handles.input.c_tolkkt); 
set(handles.SVME_edit_violation, 'String',  handles.input.c_violation); 
set(handles.SVME_edit_retest, 'String',  handles.input.c_retest); 
set(handles.SVME_edit_stability, 'String',  handles.input.c_stability_test); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SVM_edit_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SVM_edit_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(handles.save_change == 0)
    varargout{1} = handles.input_initial;
else
    varargout{1} = handles.input;
end
% The figure can be deleted now
delete(handles.figure1);


% --- Executes on button press in SVME_pb_OK.
function SVME_pb_OK_Callback(hObject, eventdata, handles)

handles.save_change = 1;
guidata(hObject, handles);
close(handles.figure1)

% --- Executes on button press in SVME_pb_cancel.
function SVME_pb_cancel_Callback(hObject, eventdata, handles)

handles.save_change = 0;
guidata(hObject, handles);
close(handles.figure1)


%% Kernel choice
% --- Executes on button press in SVME_cb_linear.
function SVME_cb_linear_Callback(hObject, eventdata, handles)
handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

% --- Executes on button press in SVME_cb_quadratic.
function SVME_cb_quadratic_Callback(hObject, eventdata, handles)
handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);
% --- Executes on button press in SVME_cb_polynomial.
function SVME_cb_polynomial_Callback(hObject, eventdata, handles)
handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);
% --- Executes on button press in SVME_cb_rbf.
function SVME_cb_rbf_Callback(hObject, eventdata, handles)
handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

%% Kernel Parameters
function SVME_edit_GV_low_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_GV_step_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_GV_high_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_PV_low_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_PV_step_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_PV_high_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_cons_low_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_cons_step_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_cons_high_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);
%% Other parameters
function SVME_edit_kkttol_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_violation_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_retest_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

function SVME_edit_stability_Callback(hObject, eventdata, handles)

handles = DC_update_svm_parameter(handles, hObject);
guidata(hObject, handles);

%% Close function
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

%% Help section
% --- Executes on button press in SVM_help.
function SVM_help_Callback(hObject, eventdata, handles)
doc fitcsvm



%% Create functions ( no use but do not delete)
% --- Executes during object creation, after setting all properties.
function SVME_edit_kkttol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_kkttol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_violation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_violation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_retest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_retest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_stability_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_stability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_GV_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_GV_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_GV_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_GV_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_GV_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_GV_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_PV_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_PV_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_cons_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_cons_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_PV_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_PV_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_PV_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_PV_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_cons_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_cons_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function SVME_edit_cons_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SVME_edit_cons_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
