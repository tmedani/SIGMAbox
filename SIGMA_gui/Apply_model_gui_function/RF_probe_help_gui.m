function varargout = RF_probe_help_gui(varargin)
% RF_PROBE_HELP_GUI MATLAB code for RF_probe_help_gui.fig
%      RF_PROBE_HELP_GUI, by itself, creates a new RF_PROBE_HELP_GUI or raises the existing
%      singleton*.
%
%      H = RF_PROBE_HELP_GUI returns the handle to a new RF_PROBE_HELP_GUI or the handle to
%      the existing singleton*.
%
%      RF_PROBE_HELP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RF_PROBE_HELP_GUI.M with the given input arguments.
%
%      RF_PROBE_HELP_GUI('Property','Value',...) creates a new RF_PROBE_HELP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RF_probe_help_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RF_probe_help_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RF_probe_help_gui

% Last Modified by GUIDE v2.5 29-Nov-2017 12:12:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RF_probe_help_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @RF_probe_help_gui_OutputFcn, ...
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


% --- Executes just before RF_probe_help_gui is made visible.
function RF_probe_help_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RF_probe_help_gui (see VARARGIN)

% Choose default command line output for RF_probe_help_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RF_probe_help_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RF_probe_help_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function help_txte_probe_Callback(hObject, eventdata, handles)
% hObject    handle to help_txte_probe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of help_txte_probe as text
%        str2double(get(hObject,'String')) returns contents of help_txte_probe as a double


% --- Executes during object creation, after setting all properties.
function help_txte_probe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to help_txte_probe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
