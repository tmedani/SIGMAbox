function varargout = AM_help_gui(varargin)
% AM_HELP_GUI MATLAB code for AM_help_gui.fig
%      AM_HELP_GUI, by itself, creates a new AM_HELP_GUI or raises the existing
%      singleton*.
%
%      H = AM_HELP_GUI returns the handle to a new AM_HELP_GUI or the handle to
%      the existing singleton*.
%
%      AM_HELP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AM_HELP_GUI.M with the given input arguments.
%
%      AM_HELP_GUI('Property','Value',...) creates a new AM_HELP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AM_help_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AM_help_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AM_help_gui

% Last Modified by GUIDE v2.5 28-Nov-2017 11:39:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AM_help_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @AM_help_gui_OutputFcn, ...
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


% --- Executes just before AM_help_gui is made visible.
function AM_help_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AM_help_gui (see VARARGIN)

% Choose default command line output for AM_help_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AM_help_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AM_help_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
