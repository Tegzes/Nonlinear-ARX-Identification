function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 02-Jan-2019 22:03:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('iddata-08.mat');

%% Getting inputs
m = input('Degree m: ');
na = input('Order na: ');
nb = input('Order nb: ');
nk = 1; % let default nk be 1
n = na+nb; % no. of system's inputs

%% Identification data 
uid = id.u;
yid = id.y;
handles.uid = uid;
handles.yid = yid;


%% Validation data
yval = val.y;
uval = val.u;
handles.yval = yval;
handles.uval = uval;

# at negative time samples we consider elements to be 0 
 yid=[zeros(1,na+nb),yid'];
 uid=[zeros(1,na+nb),uid'];
 
 yval=[zeros(1,na+nb),yval'];
 uval=[zeros(1,na+nb),uval'];



%% Prediction on Identification Data

% matrix of phi parameters
phi = ObtainPhi(yid,uid,na,nb,nk,m,n);

% vector of theta parameters
theta = phi\id_array(:,3);

% estimated output
yhat = phi*theta;
handles.yhat = yhat;

mse = ObtainMSE(yhat,id_array(:,3));
handles.mse = mse;

%% Prediction on validation data

phiv = ObtainPhi(yval,uval,na,nb,nk,m,n);

yhatv = phiv*theta;
handles.yhatv = yhatv;

msev = ObtainMSE(yhatv,val_array(:,3));
handles.msev = msev;

%%% Simulation

% we consider the inital simulated yhat a vector of zeros
% to which we are going to add appropiate elements
ysid=[zeros(n,1)];

ysiv=[zeros(n,1)];

%% Simulation of identification data

ysid = Simulation(na,nb,nk,m,uid,ysid,theta);
handles.ysid = ysid;

mse_sid = ObtainMSE(ysid,yid');
handles.mse_sid = mse_sid;

%% Simulation on validation data
ysiv = Simulation(na,nb,nk,m,uval,ysiv,theta);
handles.ysiv = ysiv;

mse_sv = ObtainMSE(ysiv,yval');
handles.mse_sv = mse_sv;

handles.m = m;
handles.na = na;
handles.nb = nb;

set(handles.m_val,'string',handles.m);
set(handles.nb_val,'string',handles.nb);
set(handles.na_val,'string',handles.na);


% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Id_val.
function Id_val_Callback(hObject, eventdata, handles)
% hObject    handle to Id_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.id_axes)
axes(handles.id_axes)
plot(handles.uid);title('Identification Data');
hold on
plot(handles.yid,'r');legend('U id','Y Id');

% --- Executes on button press in valid_val.
function valid_val_Callback(hObject, eventdata, handles)
% hObject    handle to valid_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.val_axes)
axes(handles.val_axes);
plot(handles.uval);title('Validation Data');
hold on
plot(handles.yval,'r');legend('U Val','Y Val');


% --- Executes on button press in id_predict.
function id_predict_Callback(hObject, eventdata, handles)
% hObject    handle to id_predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.id_axes)
axes(handles.id_axes)
plot(handles.yid);hold on
plot(handles.yhat,'r');
title(['MSE prediction id=',num2str(handles.mse)]); legend('Y id','Y id aproximated');

% --- Executes on button press in valid_predict.
function valid_predict_Callback(hObject, eventdata, handles)
% hObject    handle to valid_predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.val_axes)
axes(handles.val_axes)
plot(handles.yval);hold on
plot(handles.yhatv,'r');
title(['MSE prediction val=',num2str(handles.msev)]); legend('Y id','Y val aproximated');

% --- Executes on button press in id_sim.
function id_sim_Callback(hObject, eventdata, handles)
% hObject    handle to id_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.id_axes)
axes(handles.id_axes);
plot(handles.yid);hold on
plot(handles.ysid,'r');
title(['MSE simulation id = ',num2str(handles.mse_sid)]);
legend('Y id','Y sim id');

% --- Executes on button press in valid_sim.
function valid_sim_Callback(hObject, eventdata, handles)
% hObject    handle to valid_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.val_axes)
axes(handles.val_axes)
plot(handles.yval);hold on
plot(handles.ysiv,'r');
title(['MSE simulation val = ',num2str(handles.mse_sv)]);
legend('Y val','Y sim val');


% --- Executes during object creation, after setting all properties.
function Id_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Id_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function m_val_Callback(hObject, eventdata, handles)
% hObject    handle to m_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m_val as text
%        str2double(get(hObject,'String')) returns contents of m_val as a double


% --- Executes during object creation, after setting all properties.
function m_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function na_val_Callback(hObject, eventdata, handles)
% hObject    handle to na_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of na_val as text
%        str2double(get(hObject,'String')) returns contents of na_val as a double


% --- Executes during object creation, after setting all properties.
function na_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to na_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_val_Callback(hObject, eventdata, handles)
% hObject    handle to nb_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_val as text
%        str2double(get(hObject,'String')) returns contents of nb_val as a double


% --- Executes during object creation, after setting all properties.
function nb_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
