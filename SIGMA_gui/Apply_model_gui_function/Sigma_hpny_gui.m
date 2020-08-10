function varargout = Sigma_hpny_gui(varargin)
% SIGMA_HPNY_GUI MATLAB code for Sigma_hpny_gui.fig
%      SIGMA_HPNY_GUI, by itself, creates a new SIGMA_HPNY_GUI or raises the existing
%      singleton*.
%
%      H = SIGMA_HPNY_GUI returns the handle to a new SIGMA_HPNY_GUI or the handle to
%      the existing singleton*.
%
%      SIGMA_HPNY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGMA_HPNY_GUI.M with the given input arguments.
%
%      SIGMA_HPNY_GUI('Property','Value',...) creates a new SIGMA_HPNY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sigma_hpny_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sigma_hpny_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sigma_hpny_gui

% Last Modified by GUIDE v2.5 26-Dec-2017 12:19:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sigma_hpny_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Sigma_hpny_gui_OutputFcn, ...
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


% --- Executes just before Sigma_hpny_gui is made visible.
function Sigma_hpny_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sigma_hpny_gui (see VARARGIN)


% add the image to the GUI
%pwd_here=pwd;
sigma_dir = varargin{1}.init_parameter.sigma_directory;
if ispc
    filename = fullfile(sigma_dir,'SIGMA_documents\logo\hpny2018.png');
end
if ismac
    filename = fullfile(sigma_dir,'SIGMA_documents/logo/hpny2018.png');
end

%cd(handles.input.init_parameter.sigma_directory)
myImage = imread(filename);
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imshow(myImage);
set(handles.axes1,'Units','normalized');

% Choose default command line output for Sigma_hpny_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sigma_hpny_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sigma_hpny_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
