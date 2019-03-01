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

ShiftLen  = 20;       % mm


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
s3 = sqrt(3);                               % Just sqrt of 3 =)
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
%**************************BLANK********************************
dX = BlankSizeX/2;
dY = BlankSizeY/2;
line([ dX  dX],[ dY -dY],'Color','green');
line([ dX -dX],[-dY -dY],'Color','green');
line([-dX -dX],[ dY -dY],'Color','green');
line([-dX  dX],[ dY  dY],'Color','green');
%**************************ROLL*********************************
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

OaX = dX2;
OaY = dY2;

Otr = [ OaX  OaY];
Odr = [ OaX -OaY];
Odl = [-OaX -OaY];
Otl = [-OaX  OaY];

line(SimbRad*cosd(tO1)+Otr(1),SimbRad*sind(tO1)+Otr(2),'Color','blue');
line(SimbRad*cosd(tO2)+Odr(1),SimbRad*sind(tO2)+Odr(2),'Color','blue');
line(SimbRad*cosd(tO3)+Odl(1),SimbRad*sind(tO3)+Odl(2),'Color','blue');
line(SimbRad*cosd(tO4)+Otl(1),SimbRad*sind(tO4)+Otl(2),'Color','blue');
%*************************CUT************************************
% Staright part
dX1 = CutSizeX/2;
dX2 = OaX-ShiftLen;    
dY1 = CutSizeY/2;           
dY2 = OaY-ShiftLen;

line([ dX1  dX1],[ dY2 -dY2],'Color','blue');
line([ dX2 -dX2],[-dY1 -dY1],'Color','blue');
line([-dX1 -dX1],[ dY2 -dY2],'Color','blue');
line([-dX2  dX2],[ dY1  dY1],'Color','blue');
% Tranzaction radius parametrs:
OTRtr  = [ dX2  dY2];
OTRdr  = [ dX2 -dY2];
OTRdl  = [-dX2 -dY2];
OTRtl  = [-dX2  dY2];
TRR    = CutSizeX/2 - dX2;
xxx    = (ShiftLen/sind(45)*CutRad)/(TRR-CutRad);
TRalf  = 45 - acosd(CutRad/xxx);
tTRtr1 = linspace(0,TRalf);
tTRtr2 = linspace(90,90-TRalf);
tTRdr1 = linspace(-TRalf,0);
tTRdr2 = linspace(-90+TRalf,-90);
tTRdl1 = linspace(180,180+TRalf);
tTRdl2 = linspace(270,270-TRalf);
tTRtl1 = linspace(180,180-TRalf);
tTRtl2 = linspace(90,90+TRalf);
line(TRR*cosd(tTRtr1) + OTRtr(1), TRR*sind(tTRtr1) + OTRtr(2),'Color','red');
line(TRR*cosd(tTRtr2) + OTRtr(1), TRR*sind(tTRtr2) + OTRtr(2),'Color','red');
line(TRR*cosd(tTRdr1) + OTRdr(1), TRR*sind(tTRdr1) + OTRdr(2),'Color','red');
line(TRR*cosd(tTRdr2) + OTRdr(1), TRR*sind(tTRdr2) + OTRdr(2),'Color','red');
line(TRR*cosd(tTRdl1) + OTRdl(1), TRR*sind(tTRdl1) + OTRdl(2),'Color','red');
line(TRR*cosd(tTRdl2) + OTRdl(1), TRR*sind(tTRdl2) + OTRdl(2),'Color','red');
line(TRR*cosd(tTRtl1) + OTRtl(1), TRR*sind(tTRtl1) + OTRtl(2),'Color','red');
line(TRR*cosd(tTRtl2) + OTRtl(1), TRR*sind(tTRtl2) + OTRtl(2),'Color','red');
% Cut radius
tCUTtr = linspace(0+TRalf,90-TRalf);
tCUTdr = linspace(-90+TRalf,0-TRalf);
tCUTdl = linspace(-180+TRalf,-90-TRalf);
tCUTtl = linspace(180-TRalf,90+TRalf);
line(CutRad*cosd(tCUTtr)+Otr(1),CutRad*sind(tCUTtr)+Otr(2),'Color','blue');
line(CutRad*cosd(tCUTdr)+Odr(1),CutRad*sind(tCUTdr)+Odr(2),'Color','blue');
line(CutRad*cosd(tCUTdl)+Odl(1),CutRad*sind(tCUTdl)+Odl(2),'Color','blue');
line(CutRad*cosd(tCUTtl)+Otl(1),CutRad*sind(tCUTtl)+Otl(2),'Color','blue');
% Tranzaction line parametrs:
dddy = TRR*(1-cosd(TRalf));
dddx = sqrt(4*TRR*TRR*sind(TRalf/2)*sind(TRalf/2)-dddy*dddy); 

TRd_tr11 = [dX2+dddx dY1-dddy];
TRd_dr11 = [dX2+dddx -(dY1-dddy)];
TRd_dl11 = [-(dX2+dddx) -(dY1-dddy)];
TRd_tl11 = [-(dX2+dddx) dY1-dddy];

dddx = (TRR-ShiftLen)*tand(TRalf) - ((TRR-ShiftLen)/cosd(TRalf)-CutRad)*sind(TRalf);
dddy = (TRR-ShiftLen) - ((TRR-ShiftLen)/cosd(TRalf)-CutRad)*cosd(TRalf);

TRd_tr12 = [Odr(1)+dddx -(Odr(2)-dddy)];
TRd_dr12 = [Odr(1)+dddx Odr(2)-dddy];
TRd_dl12 = [-(Odr(1)+dddx) Odr(2)-dddy];
TRd_tl12 = [-(Odr(1)+dddx) -(Odr(2)-dddy)];

line([TRd_tr12(1) TRd_tr11(1)],[TRd_tr12(2) TRd_tr11(2)],'Color','green'); 
line([TRd_dr12(1) TRd_dr11(1)],[TRd_dr12(2) TRd_dr11(2)],'Color','green'); 
line([TRd_dl12(1) TRd_dl11(1)],[TRd_dl12(2) TRd_dl11(2)],'Color','green'); 
line([TRd_tl12(1) TRd_tl11(1)],[TRd_tl12(2) TRd_tl11(2)],'Color','green'); 

line([TRd_tr12(2) TRd_tr11(2)],[TRd_tr12(1) TRd_tr11(1)],'Color','green'); 
line([TRd_dr12(2) TRd_dr11(2)],[TRd_dr12(1) TRd_dr11(1)],'Color','green'); 
line([TRd_dl12(2) TRd_dl11(2)],[TRd_dl12(1) TRd_dl11(1)],'Color','green'); 
line([TRd_tl12(2) TRd_tl11(2)],[TRd_tl12(1) TRd_tl11(1)],'Color','green'); 
%***************************************************************
%***************************************************************
%***************************************************************






%***************************************************************
%******************DRAW FIRST CUT LINE**************************
%***************************************************************

