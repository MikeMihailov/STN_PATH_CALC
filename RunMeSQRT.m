%***************************************************************
%*********************CLEAR WORCKSPACE**************************
%***************************************************************
clear;  % delate all var n worckspace
clc;    % clear comand line
%***************************************************************
%*************************INCLUDE*******************************
%***************************************************************
curdir = cd;                    % Get cur direction name
addpath([curdir '\FUNCTION']);  % Include folder with extra functions
StartTime = cputime;            % Start time megerment
%***************************************************************
%**************************PLOT*********************************
%***************************************************************
clf;                % clear plot window
subplot(1,1,1);     % make new sub plot window
plotWork = 1;
DebugPlot = 0;
PlotFirstCutTest = 1;
PlotData = 0;
axis equal;
grid;
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Simbol Data:
SimbSizeX = 908;
SimbSizeY = 908;
SimbRad   = 49;      % mm49
RollAdd   = 22;      % mm
CutRad    = 69;      % mm
CutAdd    = 24;

ShiftLen = 200;      % mm


% Machine Data:
L  = 402;           % From center of carriet to end of scissors(было 512)
LR = 307;           % Carriage lenhth, mm (last - 339)
% Cut Tech Proc Data:
CutInputAng = 30;   % grad
CutLagAng   = 1;    % grad
MinCutRad   = 45;   % mm (45)
% Calc Data:
dAlfa   = 0.001;	% delta alfa
DotAcc  = 200;      % Delta dot in output
FullAng = 720;      % Full revolv of curve, grad
% EXPEREMENTAL:
% Driver data
MstAcc    = 1;      % Master acceleration, u/s^2
SupMstVel = 1;      % grad/sec
LowVel    = 0.1;    % Low speed of tabel
MaxVel    = 1;      % Max speed of tabel
%***************************************************************
%***********************INTERNAL********************************
%***************************************************************
BarMax    = 18;     % Nomber of bar dots
BarCur    = 0;      % Start bar dot

nAlfa   = FullAng/dAlfa;        % Nome of calc stops
%***************************************************************
%************************OUTPUT*********************************
%***************************************************************
OUT_Bx    = 0:1:(nAlfa-dAlfa);         % Position dot B on OX
OUT_Bang  = 0:1:(nAlfa-dAlfa);         % Angel of car in grad
OUT_Alfa  = 0:dAlfa:(FullAng-dAlfa);   % Turn angle
OUT_Table = 0:dAlfa:(FullAng-dAlfa);   % Table CAM
%***************************************************************
%*********************MAIN DATA CALC****************************
%***************************************************************
CutSizeX   = SimbSizeX + RollAdd*2;
CutSizeY   = SimbSizeY + RollAdd*2;

BlankSizeX = CutSizeX + CutAdd*2;     % width, mm
BlankSizeY = CutSizeY + CutAdd*2;     % length, mm
%***************************************************************
%***************************************************************
%***************************************************************





%***************************************************************
%*********************DRAW SIMBOL LINE**************************
%***************************************************************
%BLANK
dX = BlankSizeX/2;
dY = BlankSizeY/2;
line([ dX  dX],[ dY -dY],'Color','green');
line([ dX -dX],[-dY -dY],'Color','green');
line([-dX -dX],[ dY -dY],'Color','green');
line([-dX  dX],[ dY  dY],'Color','green');
%ROLL
dX1 = SimbSizeX/2;
dX2 = SimbSizeX/2-SimbRad;
dY1 = SimbSizeY/2;
dY2 = SimbSizeY/2-SimbRad;

tO1 = linspace(0,90);
tO2 = linspace(270,360);
tO3 = linspace(180,270);
tO4 = linspace(90,180);

line([ dX1  dX1],[ dY2 -dY2],'Color','blue');
line([ dX2 -dX2],[-dY1 -dY1],'Color','blue');
line([-dX1 -dX1],[ dY2 -dY2],'Color','blue');
line([-dX2  dX2],[ dY1  dY1],'Color','blue');

line(SimbRad*cosd(tO1)+dX2,SimbRad*sind(tO1)+dY2,'Color','blue');
line(SimbRad*cosd(tO2)+dX2,SimbRad*sind(tO2)-dY2,'Color','blue');
line(SimbRad*cosd(tO3)-dX2,SimbRad*sind(tO3)-dY2,'Color','blue');
line(SimbRad*cosd(tO4)-dX2,SimbRad*sind(tO4)+dY2,'Color','blue');

Otr = [ dX2  dY2];
Odr = [ dX2 -dY2];
Odl = [-dX2 -dY2];
Otl = [-dX2  dY2];
%CUT
dX1 = CutSizeX/2;
dX2 = CutSizeX/2-CutRad;
dY1 = CutSizeY/2;
dY2 = CutSizeY/2-CutRad;

line([ dX1  dX1],[ dY2 -dY2],'Color','red');
line([ dX2 -dX2],[-dY1 -dY1],'Color','red');
line([-dX1 -dX1],[ dY2 -dY2],'Color','red');
line([-dX2  dX2],[ dY1  dY1],'Color','red');

line(CutRad*cosd(tO1)+Otr(1),CutRad*sind(tO1)+Otr(2),'Color','red');
line(CutRad*cosd(tO2)+Odr(1),CutRad*sind(tO2)+Odr(2),'Color','red');
line(CutRad*cosd(tO3)+Odl(1),CutRad*sind(tO3)+Odl(2),'Color','red');
line(CutRad*cosd(tO4)+Otl(1),CutRad*sind(tO4)+Otl(2),'Color','red');






