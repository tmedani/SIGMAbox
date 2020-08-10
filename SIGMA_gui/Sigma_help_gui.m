function varargout = Sigma_help_gui(varargin)
% SIGMA_HELP_GUI MATLAB code for sigma_help_gui.fig
%      SIGMA_HELP_GUI, by itself, creates a new SIGMA_HELP_GUI or raises the existing
%      singleton*.
%
%      H = SIGMA_HELP_GUI returns the handle to a new SIGMA_HELP_GUI or the handle to
%      the existing singleton*.
%
%      SIGMA_HELP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGMA_HELP_GUI.M with the given input arguments.
%
%      SIGMA_HELP_GUI('Property','Value',...) creates a new SIGMA_HELP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sigma_help_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sigma_help_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sigma_help_gui

% Last Modified by GUIDE v2.5 22-Nov-2017 18:19:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sigma_help_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Sigma_help_gui_OutputFcn, ...
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


% --- Executes just before sigma_help_gui is made visible.
function Sigma_help_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sigma_help_gui (see VARARGIN)

% Choose default command line output for sigma_help_gui
handles.output = hObject;

% axes(handles.axes1)
% matlabImage = imread('bci_logo.png');
% image(matlabImage)
% axis off
% axis image


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sigma_help_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sigma_help_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
