function varargout = sigma_start_gui(varargin)
% sigma_start_gui - the main Graphical User Interface (GUI) environment 
%  for imaging of brain functional connectivity from electrophysiological signals
%
% Authors: 
%  Bin He, Yakang Dai, Lin Yang, and Han Yuan at the University of Minnesota, USA, 
%  with substantial contributions from Fabio Babiloni and Laura Astolfi 
%  at the University of Rome "La Sapienza", Italy, plus addition contributions 
%  from Christopher Wilke at the University of Minnesota, USA. 
% 
% Usage: 
% To start the main sigma_start_gui GUI, please type
%           >> sigma_start_gui
% in the command window of MATLAB and press the Enter key.
% 
% Description:
% sigma_start_gui (Electrophysiological Connectome) is a MATLAB-based software with GUI  
% for mapping and imaging of brain functional connectivity from electrophysiological 
% signals. Currently the sigma_start_gui includes three main functions: 
% 1) EEG connectivity analysis, including 
%       a) preprocessing of EEG data in time or frequency domain, potential mapping 
%           and functional connectivity mapping on a realistic geometry scalp;  
%       b) estimating cortical current sources from the scalp EEG 
%           and imaging functional connectivity in the source domain.
% 2) MEG connectivity analysis, including 
%       a) preprocessing of MEG data in time or frequency domain, field mapping 
%           and functional connectivity mapping on a realistic MEG sensor surface;  
%       b) estimating cortical current sources from the MEG data
%           and imaging functional connectivity in the source domain.
% 3) Imaging the cortical functional connectivity from the ECoG data, including 
%      preprocessing of ECoG signals and visualizing the cortical potential maps and connectivity maps.
% The three functions are implemented in the eegfc, megfc and ecogfc modules, respectively. 
% The three modules can be called in the main GUI of the sigma_start_gui, as well as 
% in the command window of MATLAB. Please see the sigma_start_gui Manual 
% for details via 'Menu bar -> Help -> Manual' in the main sigma_start_gui window).
%
% Reference for sigma_start_gui (please cite): 
% B. He, Y. Dai, L. Astolfi, F. Babiloni, H. Yuan, L. Yang. 
% sigma_start_gui: A MATLAB Toolbox for Mapping and Imaging of Brain Functional Connectivity. 
% Journal of Neuroscience Methods. 195:261-269, 2011.
% 
% Reference for eegfc() (please cite):
% F. Babiloni, F. Cincotti, C. Babiloni, F. Carducci, D. Mattia, L. Astolfi, A. Basilisco, P. M. Rossini, 
% L. Ding, Y. Ni, J. Cheng, K. Christine, J. Sweeney, B. He. Neuroimage. 2005 Jan 1;24(1):118-31. 
% Estimation of the cortical functional connectivity with the multimodal integration of high-resolution 
% EEG and fMRI data by directed transfer function.
%
% Reference for ecogfc() (please cite):
% C. Wilke, W. van Drongelen, M. Kohrman, B. He. 
% Neocortical seizure foci localization by means of a directed transfer function method. 
% Epilepsia. 51(4):564-72, 2010.
%
% Reference for megfc() (please cite):
% Y. Dai, B. He. 
% MEG-based Brain Functional Connectivity Analysis Using sigma_start_gui. 
% Proc. of 8th International Symposium on Noninvasive Functional Source Imaging of the Brain and Heart and 
% the 8th International Conference on Bioelectromagnetism. 9-11, 2011.
%
% Y. Dai, W. Zhang, D. L. Dickens, B. He. 
% Source Connectivity Analysis from MEG and its Application to Epilepsy Patients. 
% Brain Topography. 25(2):157-166, 2012.
%
% Reference for ADTF function, (please cite) 
% C. Wilke, L. Ding, B. He, 
% Estimation of time-varying connectivity patterns through the use of an adaptive directed transfer function. 
% IEEE Trans Biomed Eng. 2008 Nov; 55(11):2557-64.
% 
% Program Author: Yakang Dai, University of Minnesota, USA
%
% User feedback welcome: e-mail: econnect@umn.edu
%

% License
% ==============================================================
% This program is part of the sigma_start_gui.
% 
% Copyright (C) 2010 Regents of the University of Minnesota. All rights reserved.
% Correspondence: binhe@umn.edu
% Web: sigma_start_gui.umn.edu
%
% This program is free software for academic research: you can redistribute it and/or modify
% it for non-commercial uses, under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program. If not, see http://www.gnu.org/copyleft/gpl.html.
%
% This program is for research purposes only. This program
% CAN NOT be used for commercial purposes. This program 
% SHOULD NOT be used for medical purposes. The authors 
% WILL NOT be responsible for using the program in medical
% conditions.
% ==========================================


% Revision Logs
% ==========================================
%
% Yakang Dai, 19-May-2010 13:02:06
% Release Version 2.0 beta 
%
% Yakang Dai, 01-Mar-2010 15:20:30
% Release Version 1.0 beta 
%
% ========================================== 


% --- Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sigma_start_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sigma_start_gui_OutputFcn, ...
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


% --- Executes just before sigma_start_gui is made visible.
function sigma_start_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sigma_start_gui (see VARARGIN)

% Choose default command line output for sigma_start_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sigma_start_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.sigma_logo);
logo = imread('sigma_logo.png');
bkg = double([logo(1,1,1), logo(1,1,2), logo(1,1,3),]);
bkg = bkg ./ 255.0;
set(hObject,'Color',bkg);
set(handles.logotext,'BackgroundColor',bkg);
image(logo);
axis off;
axis image;

% --- Outputs from this function are returned to the command line.
function varargout = sigma_start_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function main_manual_Callback(hObject, eventdata, handles)
% hObject    handle to main_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%open('sigma-Manual.pdf');


% --------------------------------------------------------------------
function main_help_Callback(hObject, eventdata, handles)
% hObject    handle to main_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function main_about_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to main_about_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_about_sigma;


% --------------------------------------------------------------------
function menu_tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%open('sigma-Tutorial.pdf');
open('sigma_quick_tuto.pdf');




% --------------------------------------------------------------------
function main_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to main_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sigma_start.
function sigma_start_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ICI 
% il faut initialiser les parameter pour définir les chemins et les paths de données et de sortie, 
% ça doit se faire d'une maniére interactive, avec un moyen de visualiser
% sous forme d'une dialogue box , comme celle de brainstrom, avec un
% eventuel tree pour les paths, en optine biensure
% les soriie seront utilisé comme argument d'enyré pour lancer le gui
f=gcf;% get the current figure,
hf=findobj(f,'Name',f.Name);% close the figure
close(hf)

sigma_select_paths

%gui_aure_v1

% --- Executes on button press in sigma_cancel.
function sigma_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hf=findobj('Name','SIGMA 1.0 - Signal Processing & Machine Learning');
% close(hf)
f=gcf;% get the current figure,
hf=findobj(f,'Name',f.Name);% close the figure
close(hf)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pop_about_sigma

% --- Executes on button press in sigma_start_tuto_pushbutton.
function sigma_start_tuto_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to sigma_start_tuto_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('sigma_quick_tuto.pdf');
