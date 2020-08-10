function varargout = Sigma_help_adaptive_gui(varargin)
% DC_HELP_CLASSIFICATION_METHOD_ONEBYONE MATLAB code for DC_help_classification_method_onebyone.fig
%      DC_HELP_CLASSIFICATION_METHOD_ONEBYONE, by itself, creates a new DC_HELP_CLASSIFICATION_METHOD_ONEBYONE or raises the existing
%      singleton*.
%
%      H = DC_HELP_CLASSIFICATION_METHOD_ONEBYONE returns the handle to a new DC_HELP_CLASSIFICATION_METHOD_ONEBYONE or the handle to
%      the existing singleton*.
%
%      DC_HELP_CLASSIFICATION_METHOD_ONEBYONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DC_HELP_CLASSIFICATION_METHOD_ONEBYONE.M with the given input arguments.
%
%      DC_HELP_CLASSIFICATION_METHOD_ONEBYONE('Property','Value',...) creates a new DC_HELP_CLASSIFICATION_METHOD_ONEBYONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DC_help_classification_method_onebyone_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DC_help_classification_method_onebyone_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DC_help_classification_method_onebyone

% Last Modified by GUIDE v2.5 12-Apr-2018 15:22:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DC_help_classification_method_onebyone_OpeningFcn, ...
                   'gui_OutputFcn',  @DC_help_classification_method_onebyone_OutputFcn, ...
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


% --- Executes just before DC_help_classification_method_onebyone is made visible.
function DC_help_classification_method_onebyone_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DC_help_classification_method_onebyone (see VARARGIN)

% Choose default command line output for DC_help_classification_method_onebyone
handles.output = hObject;
if isempty(varargin)
    text_to_display = 'nothing';
elseif ischar(varargin{1})
    text_to_display = (varargin{1});
elseif isstruct(varargin{1})
    text_to_display = (varargin{1}.text_to_display);
    name_of_gui = (varargin{1}.name_of_gui);
    handles.figure1.Name = name_of_gui;
end
handles.DC_help_classification_onebyone.String = text_to_display;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DC_help_classification_method_onebyone wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DC_help_classification_method_onebyone_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
