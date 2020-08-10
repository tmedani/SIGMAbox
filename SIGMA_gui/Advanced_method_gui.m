function varargout = Advanced_method_gui(varargin)
% ADVANCED_METHOD_GUI MATLAB code for advanced_method_gui.fig
%      ADVANCED_METHOD_GUI, by itself, creates a new ADVANCED_METHOD_GUI or raises the existing
%      singleton*.
%
%      H = ADVANCED_METHOD_GUI returns the handle to a new ADVANCED_METHOD_GUI or the handle to
%      the existing singleton*.
%
%      ADVANCED_METHOD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCED_METHOD_GUI.M with the given input arguments.
%
%      ADVANCED_METHOD_GUI('Property','Value',...) creates a new ADVANCED_METHOD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before advanced_method_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to advanced_method_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help advanced_method_gui

% Last Modified by GUIDE v2.5 12-Apr-2018 14:15:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Advanced_method_gui_OpeningFcn, ...
    'gui_OutputFcn',  @Advanced_method_gui_OutputFcn, ...
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

%% Opening and closing of the gui
% --- Executes just before advanced_method_gui is made visible.
function Advanced_method_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to advanced_method_gui (see VARARGIN)

% Choose default command line output for advanced_method_gui
handles.output = 'relieff';

% Detect the pre selected method 
aa = varargin{1};
adv_met = aa.adv_ranking_method;

% generate the GUI according to the preselected method
if strcmp( adv_met, 'relieff' )
    set(handles.ADV_relieff, 'Value', 1);
elseif( strcmp( adv_met, 'fsv' ) )
    set(handles.ADV_fsv, 'Value', 1);
elseif( strcmp( adv_met, 'llcfs' ) )
    set(handles.ADV_llcfs, 'Value', 1);
elseif( strcmp( adv_met, 'Inf-FS' ) )
    set(handles.ADV_inffs, 'Value', 1);
elseif( strcmp( adv_met, 'LaplacianScore' ) )
    set(handles.ADV_maplacian_score, 'Value', 1);
elseif( strcmp( adv_met, 'MCFS' ) )
    set(handles.ADV_mcfs, 'Value', 1);
elseif( strcmp( adv_met, 'udfs' ) )
    set(handles.ADV_udfs, 'Value', 1);
elseif( strcmp( adv_met, 'cfs' ) )
    set(handles.ADV_cfs, 'Value', 1);
end

% Give the initial method to the GUI
handles.initial_adv_met = adv_met;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes advanced_method_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Advanced_method_gui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;
% The figure can be deleted now
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end

%% Method choice
% --- Executes when selected object is changed in FR_ADV_bg_advanced_method_choice.
function FR_ADV_bg_advanced_method_choice_SelectionChangedFcn(hObject, eventdata, handles)

% get the method chosen by the user
c_but_sel = get( hObject, 'Tag' );
% Allocate the user choice to the output of the function
if strcmp( c_but_sel, 'ADV_relieff' )
    handles.output = 'relieff';
elseif( strcmp( c_but_sel, 'ADV_fsv' ) )
    handles.output = 'fsv';
elseif( strcmp( c_but_sel, 'ADV_llcfs' ) )
    handles.output = 'llcfs';
elseif( strcmp( c_but_sel, 'ADV_inffs' ) )
    handles.output = 'Inf-FS';
elseif( strcmp( c_but_sel, 'ADV_laplacian_score' ) )
    handles.output = 'LaplacianScore';
elseif( strcmp( c_but_sel, 'ADV_mcfs' ) )
    handles.output = 'MCFS';
elseif( strcmp( c_but_sel, 'ADV_udfs' ) )
    handles.output = 'udfs';
elseif( strcmp( c_but_sel, 'ADV_cfs' ) )
    handles.output = 'cfs';
end

guidata(hObject, handles);

%% Exit of the GUI
% --- Executes on button press in ADV_ok.
function ADV_ok_Callback(hObject, eventdata, handles)
close(handles.figure1)

% --- Executes on button press in ADV_cancel.
function ADV_cancel_Callback(hObject, eventdata, handles)
% 
handles.output = handles.initial_adv_met;
guidata(hObject, handles);
close(handles.figure1)

%% Use less - callback of button, behaviour is controler by the button_group



% --- Executes during object creation, after setting all properties.
function FR_ADV_bg_advanced_method_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FR_ADV_bg_advanced_method_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in ADV_relieff.
function ADV_relieff_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_relieff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_relieff


% --- Executes on button press in ADV_fsv.
function ADV_fsv_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_fsv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_fsv


% --- Executes on button press in ADV_llcfs.
function ADV_llcfs_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_llcfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_llcfs


% --- Executes on button press in ADV_inffs.
function ADV_inffs_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_inffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_inffs


% --- Executes on button press in ADV_laplacian_score.
function ADV_laplacian_score_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_laplacian_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_laplacian_score


% --- Executes on button press in ADV_mcfs.
function ADV_mcfs_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_mcfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_mcfs


% --- Executes on button press in ADV_udfs.
function ADV_udfs_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_udfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_udfs


% --- Executes on button press in ADV_cfs.
function ADV_cfs_Callback(hObject, eventdata, handles)
% hObject    handle to ADV_cfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ADV_cfs


% --- Executes on button press in FR_help_other_method.
function FR_help_other_method_Callback(hObject, eventdata, handles)
% hObject    handle to FR_help_other_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('Readme_fslIB_11-2017.pdf')
