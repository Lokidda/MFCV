function varargout = Inpainter(varargin)
% INPAINTER MATLAB code for Inpainter.fig
% 
% This code contains the main framework for interactive Inpainting. Most
% of it concerns the interface and you won't have to touch it.
% 
% The only function that is of any interest to you is 
% 
% 'segment_ClickedCallback'
% 
% which is placed at the end of this file.
% 
% This function will need your code for removing the selected region from
% the image and performing the primal dual algorithm.
% 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inpainter_OpeningFcn, ...
                   'gui_OutputFcn',  @Inpainter_OutputFcn, ...
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


% --- Executes just before Inpainter is made visible.
function Inpainter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inpainter (see VARARGIN)

% Choose default command line output for Inpainter
handles.output = hObject;

% Initialize the parameters
handles.drawer = false;
handles.lambda = 1.0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inpainter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inpainter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function openFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.filename, handles.pathname] = uigetfile({'*.png;*.jpg;*.bmp' ; '*'});
addpath(genpath(handles.pathname));

% Read the image, store it in the handles and show it
handles.image   = imread(handles.filename);
handles.width   = size(handles.image,2);
handles.height  = size(handles.image,1);
handles.channel = size(handles.image,3);

if(isfield(handles,'imgPos')) % in case another image was on screen already
    delete(handles.imgPos);
end

f = imshow(handles.filename);
handles.imgPos = f;

% Forground / Background initialization
handles.inpaintReg = [];

% Make sure all drawing options are set to off
handles.drawer = false;

% Size of the brush for painting
handles.brushSize = 3;

% Update the structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function drawer_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to drawer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.drawer = ~handles.drawer;

if(handles.drawer)
    set(handles.imgPos,'ButtonDownFcn',@startDrawFcn);
else
    set(handles.imgPos,'ButtonDownFcn',@stopDrawFcn);
end

set(handles.figure1,'WindowButtonUpFcn', @stopDrawFcn);

guidata(hObject, handles);

% --------------------------------------------------------------------
function startDrawFcn(hObject, eventdata)
handles = guidata( ancestor(hObject, 'image') );
fprintf('Start drawing\n');

guidata(hObject,handles);

set(handles.figure1, 'WindowButtonMotionFcn', @drawing);

% --------------------------------------------------------------------
function drawing(hObject, eventData)
handles = guidata( ancestor(hObject, 'figure') ); % recover the handles

a = get(handles.imgPos,'Parent'); % axis of the image
set(a, 'Units', 'pixels');
pt = get(a, 'CurrentPoint'); % get current position of the cursor on the image
pt = pt(1,1:2); % CurrentPoint gives 3D coordinates of a projected line, we only need the 2d position

% Paint on the image
paintedPixels = getPaintedPixels(pt,handles.brushSize,handles.width, handles.height);

handles.inpaintReg = [handles.inpaintReg ; paintedPixels];
handles.inpaintReg = unique(handles.inpaintReg,'rows');
LineSpec = 'r';

hold on
plot(a, paintedPixels(:,1), paintedPixels(:,2), LineSpec);

guidata(hObject, handles);


% --------------------------------------------------------------------
function stopDrawFcn(hObject, eventData)
handles = guidata( ancestor(hObject, 'figure') );
set(handles.figure1, 'WindowButtonMotionFcn', '');


function lambda_Callback(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda as text
%        str2double(get(hObject,'String')) returns contents of lambda as a double
handles.lambda = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Inpaint_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Inpaint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata( ancestor(hObject, 'figure') ); % recover the handles
a = get(handles.imgPos,'Parent'); % axis of the image
set(a, 'Units', 'pixels');false

% Set all drawing options to 
handles.drawer = false;

% Read the image we want to segment and its parameters
I = handles.image;
w = handles.width;
h = handles.height;

% Extract the seeds for inpainting region
inpaintReg = handles.inpaintReg;

%% Remove the inpainted region from the image

% Your code here


%% Primal dual inpainting

% Your code here

% Note: if you want to show your inpainted results on the interface, use
% the following code

% handles.imgPos = imshow(uint8(Ix), 'Parent', a);

% where Ix is your unknown function. However, for simplicity, you can also
% print the results on a separate figure. Be careful if you want to show
% the evolution of the results, you need to always use the same figure, for
% instance figure(2).





