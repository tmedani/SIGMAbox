function varargout = input_probe_feature(varargin)
% INPUT_PROBE_FEATURE MATLAB code for input_probe_feature.fig
%      INPUT_PROBE_FEATURE, by itself, creates a new INPUT_PROBE_FEATURE or raises the existing
%      singleton*.
%
%      H = INPUT_PROBE_FEATURE returns the handle to a new INPUT_PROBE_FEATURE or the handle to
%      the existing singleton*.
%
%      INPUT_PROBE_FEATURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INPUT_PROBE_FEATURE.M with the given input arguments.
%
%      INPUT_PROBE_FEATURE('Property','Value',...) creates a new INPUT_PROBE_FEATURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before input_probe_feature_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to input_probe_feature_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help input_probe_feature

% Last Modified by GUIDE v2.5 22-May-2018 16:50:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @input_probe_feature_OpeningFcn, ...
                   'gui_OutputFcn',  @input_probe_feature_OutputFcn, ...
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


% --- Executes just before input_probe_feature is made visible.
function input_probe_feature_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to input_probe_feature (see VARARGIN)

% Choose default command line output for input_probe_feature
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes input_probe_feature wait for user response (see UIRESUME)
% uiwait(handles.get_probe_feature_gui);


% --- Outputs from this function are returned to the command line.
function varargout = input_probe_feature_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in validate.
function validate_Callback(hObject, eventdata, handles)
% hObject    handle to validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
probe_feature = get(handles.input_nb_feature,'String');
setappdata(0,'probe_feature',probe_feature);
close(handles.get_probe_feature_gui)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'probe_feature',1);
close(handles.get_probe_feature_gui)




function input_probe_feature_Callback(hObject, eventdata, handles)
% hObject    handle to input_probe_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_probe_feature as text
%        str2double(get(hObject,'String')) returns contents of input_probe_feature as a double


% --- Executes during object creation, after setting all properties.
function input_probe_feature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_probe_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
