function varargout = OCR(varargin)
% RUNOCR MATLAB code for RUNOCR.fig
%      RUNOCR, by itself, creates a new RUNOCR or raises the existing
%      singleton*.
%
%      H = RUNOCR returns the handle to a new RUNOCR or the handle to
%      the existing singleton*.
%
%      RUNOCR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNOCR.M with the given input arguments.
%
%      RUNOCR('Property','Value',...) creates a new RUNOCR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OCR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OCR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RUNOCR

% Last Modified by GUIDE v2.5 20-Apr-2018 19:19:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OCR_OpeningFcn, ...
                   'gui_OutputFcn',  @OCR_OutputFcn, ...
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


% --- Executes just before RUNOCR is made visible.
function OCR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RUNOCR (see VARARGIN)

axes(handles.imageaxis);
set(handles.runocr,'Enable','off');
set(handles.imageaxis,'xtick',[],'ytick',[]);
load NN.mat Theta1 Theta2;
handles.Theta1 = Theta1;
handles.Theta2 = Theta2;

% Choose default command line output for RUNOCR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes RUNOCR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OCR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runocr.
function runocr_Callback(hObject, eventdata, handles)
% hObject    handle to runocr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

img = handles.img;

set(handles.runocr,'Enable','off');

totaltime = 0;
set(handles.runocr,'String','Preprocessing ...');
tic;
preprocessedimg = preprocess(img);
preprocessingtime = toc; totaltime = totaltime + preprocessingtime;
handles.preprocessedimg = preprocessedimg;
figure(2);
imshow(preprocessedimg);

set(handles.runocr,'String','Segmenting ...');
tic;
X = segment(preprocessedimg);
segmentationtime = toc; totaltime = totaltime + segmentationtime;
figure(3);
displayData(X);

set(handles.runocr,'String','Recogninzing ...');
tic;
y = recognize(handles.Theta1, handles.Theta2, X);
classificationtime = toc; totaltime = totaltime + classificationtime;

text = '';
for i = 1:length(y)
    if y(i) < 27 
        text = strcat(text, char(y(i) + 64));
    elseif y(i) < 53
        text = strcat(text, char(y(i) + 70));
    else 
        text = strcat(text, char(y(i) - 5));
    end
end
set(handles.text, 'String', text);

set(handles.preprocessingtime, 'String', sprintf('%0.6fs (%0.1f%%)', preprocessingtime, preprocessingtime*100/totaltime));
set(handles.segmentationtime, 'String', sprintf('%0.6fs (%0.1f%%)', segmentationtime, segmentationtime*100/totaltime));
set(handles.classificationtime, 'String', sprintf('%0.6fs (%0.1f%%)', classificationtime, classificationtime*100/totaltime));
set(handles.totaltime,'String',sprintf('%0.6fs',totaltime));
set(handles.runocr,'String','Run OCR');

guidata(hObject,handles);


function text_Callback(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text as text
%        str2double(get(hObject,'String')) returns contents of text as a double


% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

[fn, pn] = uigetfile('Input Images/*.*','Select input file');
complete = strcat(pn,fn);
set(handles.path, 'String', complete);

img = imread(complete);
handles.img = img;
imshow(img);

set(handles.runocr, 'Enable', 'on');
set(handles.text, 'String', 'TEXT');

guidata(hObject, handles);
