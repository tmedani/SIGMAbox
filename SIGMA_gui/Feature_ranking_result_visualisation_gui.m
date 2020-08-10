function varargout = Feature_ranking_result_visualisation_gui(varargin)
% Feature_ranking_result_VISUALISATION_GUI MATLAB code for Feature_ranking_result_visualisation_gui.fig
%      Feature_ranking_result_VISUALISATION_GUI, by itself, creates a new Feature_ranking_result_VISUALISATION_GUI or raises the existing
%      singleton*.
%
%      H = Feature_ranking_result_VISUALISATION_GUI returns the handle to a new Feature_ranking_result_VISUALISATION_GUI or the handle to
%      the existing singleton*.
%
%      Feature_ranking_result_VISUALISATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Feature_ranking_result_VISUALISATION_GUI.M with the given input arguments.
%
%      Feature_ranking_result_VISUALISATION_GUI('Property','Value',...) creates a new Feature_ranking_result_VISUALISATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Feature_ranking_result_visualisation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Feature_ranking_result_visualisation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Feature_ranking_result_visualisation_gui

% Last Modified by GUIDE v2.5 13-Feb-2018 18:08:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Feature_ranking_result_visualisation_gui_OpeningFcn, ...
    'gui_OutputFcn',  @Feature_ranking_result_visualisation_gui_OutputFcn, ...
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


% --- Executes just before Feature_ranking_result_visualisation_gui is made visible.
function Feature_ranking_result_visualisation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Feature_ranking_result_visualisation_gui (see VARARGIN)

% Choose default command line output for Feature_ranking_result_visualisation_gui
handles.output = hObject;
if(nargin == 6)
    feature_result=varargin{1};
else
   feature_result = []; 
end

if isfield(feature_result,'feature_matrix_cross_term_id')
    handles.feature_cross_term.Enable='on';
else
    handles.feature_cross_term.Enable='off';
end


hObject.Name='SIGMA : Feature Ranking';
% check if data are given to the GUI
if(~isempty(varargin) > 0)
    
    handles.input_feature = varargin{1};
    handles.input_method = varargin{2};
    handles.init_parameter = varargin{3};
    % call the fill table function
    Sigma_fill_ranking_tableGUI(handles)
    
else
    handles.input = [];
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Feature_ranking_result_visualisation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Feature_ranking_result_visualisation_gui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in FRRV_pb_load_data.
function FRRV_pb_load_data_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.mat');
if( FileName == 0)
    disp('load cancelled')
else    
    load([PathName,FileName ]);
    if(exist('feature_result'))
    % give names
    handles.input_feature = feature_result;
    handles.input_method = init_method;
    handles.init_parameter=init_parameter;
    
    Sigma_fill_ranking_tableGUI(handles)
    

    else
        disp('no feature ranking data in this file');
    end
end
guidata(hObject, handles);


% --- Executes on button press in feature_3D_distribution.
function feature_3D_distribution_Callback(hObject, eventdata, handles)
% hObject    handle to feature_3D_distribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
if ~isfield(handles,'input_feature')
    msgbox('There is nothing to display','SIGMA error','error');
    return;
end
handles.feature_result = handles.input_feature;
handles.init_method = handles.input_method;
handles.init_parameter=handles.init_parameter;
tf = isfield(handles.feature_result, 'o_best_features_matrix');
if tf==1
    %h=figure;
    Sigma_3DScatterPlot(handles.init_parameter,handles.init_method,handles.feature_result);
else
    msgbox('You should run the OFR before','SIGMA Error','error');
    return;
end


% --- Executes on button press in feature_cross_term.
function feature_cross_term_Callback(hObject, eventdata, handles)
% hObject    handle to feature_cross_term (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Sigma_display_cross_term_feature_ranking(handles.input_feature)
