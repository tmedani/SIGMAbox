function varargout = DC_CV_help_gui(varargin)
% DC_CV_HELP_GUI MATLAB code for DC_CV_help_gui.fig
%      DC_CV_HELP_GUI, by itself, creates a new DC_CV_HELP_GUI or raises the existing
%      singleton*.
%
%      H = DC_CV_HELP_GUI returns the handle to a new DC_CV_HELP_GUI or the handle to
%      the existing singleton*.
%
%      DC_CV_HELP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DC_CV_HELP_GUI.M with the given input arguments.
%
%      DC_CV_HELP_GUI('Property','Value',...) creates a new DC_CV_HELP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DC_CV_help_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DC_CV_help_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DC_CV_help_gui

% Last Modified by GUIDE v2.5 12-Apr-2018 13:32:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DC_CV_help_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @DC_CV_help_gui_OutputFcn, ...
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


% --- Executes just before DC_CV_help_gui is made visible.
function DC_CV_help_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DC_CV_help_gui (see VARARGIN)

% Choose default command line output for DC_CV_help_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DC_CV_help_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DC_CV_help_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
