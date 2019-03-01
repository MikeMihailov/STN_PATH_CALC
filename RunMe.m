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
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Simbol Data:
SimbSize = 923;     % mm
SimbRad  = 51;      % mm
CutRad   = 68;      % mm 68
ShiftLen = 20;      % mm
RollAdd  = 20;      % mm24
CutAdd   = 12;      % mm
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
%***************************************************************
%***********************INTERNAL********************************
%***************************************************************
BarMax  = 18;   % Nomber of bar dots
BarCur  = 0;    % Start bar dot

CutType = 0;                    % 0 - withcut at side, 1 - without
nAlfa   = FullAng/dAlfa;        % Nome of calc stops
CurSide = 1;                    % Current angle - counter
Betta   = 0:1:(nAlfa-dAlfa);    % Current angel
OUT_Ax  = 0:1:(nAlfa-dAlfa);    % Position dot A on OX 
OUT_Ay  = 0:1:(nAlfa-dAlfa);    % Position dot A on OY
OUT_By  = 0:1:(nAlfa-dAlfa);    % Position dot B on OY
DrawSim = 0:1:(nAlfa-dAlfa);    % Sign for drawing

VelChart = 0:1:(nAlfa-dAlfa);   % Chart of chenging velocity
VelPoint = 1:1:5;               % Coordinats of velocity changing
TimeLine = 0:1:(nAlfa-dAlfa);   % Line of time

nTriAlfa= 360/dAlfa;            % Nome of calc stops
TR_Bang = 0:1:(nTriAlfa-dAlfa); % Buffer for bang
TR_Bett = 0:1:(nTriAlfa-dAlfa); % Buffer for betta
TR_Sim  = 0:1:(nTriAlfa-dAlfa); % Buffer for sign
TR_Ax   = 0:1:(nTriAlfa-dAlfa); % Buffer for Ax
TR_Ay   = 0:1:(nTriAlfa-dAlfa); % Buffer for Ay
TR_Bx   = 0:1:(nTriAlfa-dAlfa); % Buffer for Bx
TR_By   = 0:1:(nTriAlfa-dAlfa); % Buffer for By
TR_Alfa = 0:1:(nTriAlfa-dAlfa); % Buffer for Alfa
TR_End  = 0;                    % End of bufer calculations

TR_ExtremumsNumber = 6;
TR_Extremums = 1:1:TR_ExtremumsNumber;           % Array of extremums
TR_SpeedPoints = 1:1:2*TR_ExtremumsNumber;
%***************************************************************
%************************OUTPUT*********************************
%***************************************************************
OUT_Bx     = 0:1:(nAlfa-dAlfa);         % Position dot B on OX
OUT_Bang   = 0:1:(nAlfa-dAlfa);         % Angel of car in grad
OUT_Alfa   = 0:dAlfa:(FullAng-dAlfa);   % Turn angle
OUT_Table  = 0:dAlfa:(FullAng-dAlfa);   % Table CAM
%***************************************************************
%*********************MAIN DATA CALC****************************
%***************************************************************
LoadBar(BarMax,BarCur);                     % Show current bar line
s3 = sqrt(3);                               % Just sqrt of 3 =)
h = (s3/6)*SimbSize;                        % 1/3 of height (from center to side of triangle), mm
H = h*3;                                    % Height, mm
CutSimbSize = SimbSize+2*s3*RollAdd;        % Size of simbol after cut, mm
BlankSize = SimbSize+2*s3*(RollAdd+CutAdd); % Size of blank, mm
BisxRoll  = (SimbSize/s3)-SimbRad;          % Distance on bisector from centor of simbol to top of roll radius
BisxCut   = BisxRoll + CutRad - SimbRad;    % Distance on bisector from centor of simbol to top of cut radius
BisxBlank = BlankSize/s3;                   % Distance on bisector from centor of simbol to coner of blank
Blank_h   = BlankSize*(s3/6);               % 1/3 of blank height
Blank_H   = Blank_h*3;                      % Blank height
BarCur=BarCur + 1;                          % Increment bar line
LoadBar(BarMax,BarCur);                     % Show current bar line
%***************************************************************
%***************************************************************
%***************************************************************








%***************************************************************
%*********************DRAW SIMBOL LINE**************************
%***************************************************************
%The center of draw will be the centor of simbol. To the top will
%be OY, tj the lest - OX
%*************************BLANK*********************************
BlA = [-BlankSize/2 -Blank_h];                          % Left down coner x y, mm
BlB = [BlankSize/2 -Blank_h];                           % Right down coner x y, mm
BlC = [0 (Blank_H - Blank_h)];                          % Top center coner x y, mm
line([BlA(1) BlB(1)],[BlA(2) BlB(2)],'Color','green');	% Draw AB
line([BlB(1) BlC(1)],[BlB(2) BlC(2)],'Color','green');  % Draw BC
line([BlA(1) BlC(1)],[BlA(2) BlC(2)],'Color','green');  % Draw AC
%************************RADIUS********************************
thetaA = linspace(5*pi/6,3*pi/2);   % Ends of radius A
thetaB = linspace(-pi/2,pi/6);      % Ends of radius B
thetaC = linspace(pi/6,5*pi/6);     % Ends of radius C
%*************************ROLL*********************************
RlA = [-(SimbSize/2-SimbRad*s3) (-h+SimbRad)];                  % Center of left down radius, mm
RlB = [(SimbSize/2-SimbRad*s3) (-h+SimbRad)];                   % Center of right down radius, mm
RlC = [0 (H-h-2*SimbRad)];                                      % Center of top radius, mm
line(SimbRad*cos(thetaA)+RlA(1),SimbRad*sin(thetaA)+RlA(2));    % Draw left redius
line(SimbRad*cos(thetaB)+RlB(1),SimbRad*sin(thetaB)+RlB(2));    % Draw right radius
line(SimbRad*cos(thetaC)+RlC(1),SimbRad*sin(thetaC)+RlC(2));	% Draw top radius
RlA1 = [-(SimbSize/2-SimbRad*s3) -h];                           % Left-down 
RlB1 = [(SimbSize/2-SimbRad*s3) -h];                            % Right-down
RlB2 = [(RlB1(1)+(s3/2)*SimbRad) (RlB1(2)+3*SimbRad/2)];        % Right-up
RlC1 = [(s3*SimbRad/2) (H-h-1.5*SimbRad)];                      % Top-right
RlC2 = [-(s3*SimbRad/2) (H-h-1.5*SimbRad)];                     % Top-left
RlA2 = [(-RlB1(1)-(s3/2)*SimbRad) (RlB1(2)+3*SimbRad/2)];       % Left-up
line([RlA1(1) RlB1(1)],[RlA1(2) RlB1(2)]);                      % Draw line AB
line([RlB2(1) RlC1(1)],[RlB2(2) RlC1(2)]);                      % Draw line BC
line([RlC2(1) RlA2(1)],[RlC2(2) RlA2(2)]);                      % Draw line AC
%*************************CUT**********************************
dx = RollAdd*s3/2;                                              % cut-roll delta x
dy = RollAdd/2;                                                 % cut-roll delta 
ddx = ShiftLen * sind(30);                                      % shift side for small radius tranzaction
ddy = ShiftLen * cosd(30);                                      % shift side for small radius tranzaction
CtA1 = [RlA(1)+ShiftLen (RlA1(2)-RollAdd)];                     % ! Left-down 
CtB1 = [RlB(1)-ShiftLen (RlB1(2)-RollAdd)];                     % ! Right-down
CtB2 = [RlB2(1)+dx-ddx RlB2(2)+dy+ddy];                         % ! Right-up
CtC1 = [RlC1(1)+dx+ddx RlC1(2)+dy-ddy];                         % ! Top-right
CtC2 = [RlC2(1)-dx-ddx RlC2(2)+dy-ddy];                         % ! Top-left
CtA2 = [RlA2(1)-dx+ddx RlA2(2)+dy+ddy];                         % ! Left-up
line([CtA1(1) CtB1(1)],[CtA1(2) CtB1(2)]);                      % ! Draw line AB
line([CtB2(1) CtC1(1)],[CtB2(2) CtC1(2)]);                      % ! Draw line BC
line([CtC2(1) CtA2(1)],[CtC2(2) CtA2(2)]);                      % ! Draw line AC

% Tranzaction radius parametrs:
AdA  = [RlA(1)+ShiftLen RlA(2)+ShiftLen*tand(30)];
AdB  = [RlB(1)-ShiftLen RlB(2)+ShiftLen*tand(30)];
AdC  = [RlC(1) RlC(2)-ShiftLen/sind(60)];
AdR  = AdB(2) - CtB1(2);
AdOO = sqrt(AdA(1)*AdA(1)+AdA(2)*AdA(2));

xxx = (ShiftLen/sind(60)*CutRad)/(AdR-CutRad);
alf = 60 - acosd(CutRad/xxx);

thetaAdA = linspace(270,270-alf);
line(AdR*cosd(thetaAdA)+AdA(1),AdR*sind(thetaAdA)+AdA(2),'Color','red');
thetaAdA = linspace(150+alf,150);
line(AdR*cosd(thetaAdA)+AdA(1),AdR*sind(thetaAdA)+AdA(2),'Color','red');
thetaAdA = linspace(270,270+alf);
line(AdR*cosd(thetaAdA)+AdB(1),AdR*sind(thetaAdA)+AdB(2),'Color','red');
thetaAdA = linspace(30,30-alf);
line(AdR*cosd(thetaAdA)+AdB(1),AdR*sind(thetaAdA)+AdB(2),'Color','red');
thetaAdA = linspace(150-alf,150);
line(AdR*cosd(thetaAdA)+AdC(1),AdR*sind(thetaAdA)+AdC(2),'Color','red');
thetaAdA = linspace(30+alf,30);
line(AdR*cosd(thetaAdA)+AdC(1),AdR*sind(thetaAdA)+AdC(2),'Color','red');

thetaACut = linspace(150+alf,270-alf);   % Ends of radius A
thetaBCut = linspace(-90+alf,30-alf);      % Ends of radius B
thetaCCut = linspace(30+alf,150-alf);     % Ends of radius C

line(CutRad*cosd(thetaACut)+RlA(1),CutRad*sind(thetaACut)+RlA(2));      % Draw A left redius
line(CutRad*cosd(thetaBCut)+RlB(1),CutRad*sind(thetaBCut)+RlB(2));      % Draw B right radius
line(CutRad*cosd(thetaCCut)+RlC(1),CutRad*sind(thetaCCut)+RlC(2));      % Draw C top radius

dddx = 2*AdR*sind(alf/2)*cosd(alf/2); 
dddy = 2*AdR*sind(alf/2)*sind(alf/2);
dddx60 = 2*AdR*sind(alf/2)*cosd(alf/2+60); 
dddy60 = 2*AdR*sind(alf/2)*sind(alf/2+60);
dddxC = 2*AdR*sind(alf/2)*cosd(60-alf/2);
dddyC = 2*AdR*sind(alf/2)*sind(60-alf/2);

TranzA11 = [CtA1(1)-dddx CtA1(2)+dddy];
TranzA22 = [CtA2(1)-dddx60 CtA2(2)-dddy60];
TranzB11 = [CtB1(1)+dddx CtB1(2)+dddy];
TranzB22 = [CtB2(1)+dddx60 CtB2(2)-dddy60];
TranzC11 = [CtC1(1)-dddxC CtC1(2)+dddyC];
TranzC22 = [CtC2(1)+dddxC CtC2(2)+dddyC];

dddx = 2*CutRad*sind(alf/2)*cosd(alf/2); 
dddy = 2*CutRad*sind(alf/2)*sind(alf/2);
dddx60 = 2*CutRad*sind(alf/2)*cosd(alf/2+60); 
dddy60 = 2*CutRad*sind(alf/2)*sind(alf/2+60);
dddxC = 2*CutRad*sind(alf/2)*cosd(60-alf/2);
dddyC = 2*CutRad*sind(alf/2)*sind(60-alf/2);

TranzA12 = [RlA(1)-dddx RlA(2)-CutRad+dddy];
TranzA21 = [RlA(1)-CutRad*cosd(30)-dddx60 RlA(2)+CutRad*sind(30)-dddy60];
TranzB12 = [RlB(1)+dddx RlB(2)-CutRad+dddy];
TranzB21 = [RlB(1)+CutRad*cosd(30)+dddx60 RlB(2)+CutRad*sind(30)-dddy60];
TranzC12 = [RlC(1)+CutRad*cosd(30)-dddxC RlC(2)+CutRad*sind(30)+dddyC];
TranzC21 = [RlC(1)-CutRad*cosd(30)+dddxC RlC(2)+CutRad*sind(30)+dddyC];

line([TranzA12(1) TranzA11(1)],[TranzA12(2) TranzA11(2)],'Color','green');                      % ! Draw line AB
line([TranzA21(1) TranzA22(1)],[TranzA21(2) TranzA22(2)],'Color','green');                      % ! Draw line AB
line([TranzB12(1) TranzB11(1)],[TranzB12(2) TranzB11(2)],'Color','green');                      % ! Draw line AB
line([TranzB21(1) TranzB22(1)],[TranzB21(2) TranzB22(2)],'Color','green');                      % ! Draw line AB
line([TranzC12(1) TranzC11(1)],[TranzC12(2) TranzC11(2)],'Color','green');                      % ! Draw line AB
line([TranzC21(1) TranzC22(1)],[TranzC21(2) TranzC22(2)],'Color','green');                      % ! Draw line AB

x1 = TranzA12(1);
x2 = TranzA11(1);

y1 = TranzA12(2);
y2 = TranzA11(2);

a = (y2-y1)/(x2-x1);
b = y1-a*x1;


hTranz = sqrt((b*b)/(a*a+1));

BarCur=BarCur + 1;                                              % Increment bar line
LoadBar(BarMax,BarCur);                                         % Show current bar line
%***************************************************************
%***************************************************************
%***************************************************************





%***************************************************************
%******************DRAW FIRST CUT LINE**************************
%***************************************************************
%  First cut contain side cut and angle cut.
%************************SIDE***********************************
FCS_r  = CutAdd/(1-cosd(CutInputAng));  % Calc radius of side cut
%***********************ANGLE***********************************
g      = Blank_h*2 - BisxCut;
FCA_r  = g/(2*cosd(CutInputAng)-1);
FCA_or = BisxCut-FCA_r;
FCA_dx = FCA_or*cosd(30);
FCA_dy = FCA_or*sind(30);
FCA_A  = [-FCA_dx -FCA_dy];
FCA_B  = [FCA_dx  -FCA_dy];
FCA_C  = [0 (BisxCut-FCA_r)];
if (PlotFirstCutTest == 1)
    tetta  = 60-CutInputAng;
    FCA_tA = linspace(150+CutInputAng,270-CutInputAng);
    FCA_tB = linspace(270+CutInputAng,390-CutInputAng);
    FCA_tC = linspace(30+CutInputAng,150-CutInputAng);
    line(FCA_r*cosd(FCA_tA)+FCA_A(1),FCA_r*sind(FCA_tA)+FCA_A(2),'Color','red');
    line(FCA_r*cosd(FCA_tB)+FCA_B(1),FCA_r*sind(FCA_tB)+FCA_B(2),'Color','red');
    line(FCA_r*cosd(FCA_tC)+FCA_C(1),FCA_r*sind(FCA_tC)+FCA_C(2),'Color','red');
end
%***********************TRAVEL**********************************


FCT_a  = FCA_r*2*sind(60-CutInputAng);
FCT_xs = BlankSize/2 - FCT_a;
FCT_r  = FCT_xs/cosd(90-CutInputAng);
FCT_OO = FCT_r*sind(90-CutInputAng) - Blank_h + (CutRad - SimbRad)/3;


FCT_a  = FCA_dx + FCA_r*sind(CutInputAng);
FCT_r  = FCT_a/sind(CutInputAng);
FCT_OO = FCT_a/tand(CutInputAng) - Blank_h;
FCT_dx = FCT_OO*cosd(30);
FCT_dy = FCT_OO*sind(30);
FCT_A  = [FCT_dx  -FCT_dy];
FCT_B  = [-FCT_dx -FCT_dy];
FCT_C  = [0        FCT_OO];
if (PlotFirstCutTest == 1)
    FCT_tA = linspace(150-CutInputAng,150+CutInputAng);
    FCT_tB = linspace(30-CutInputAng,30+CutInputAng);
    FCT_tC = linspace(-CutInputAng-90,CutInputAng-90);
    line(FCT_r*cosd(FCT_tA)+FCT_A(1),FCT_r*sind(FCT_tA)+FCT_A(2),'Color','red');
    line(FCT_r*cosd(FCT_tB)+FCT_B(1),FCT_r*sind(FCT_tB)+FCT_B(2),'Color','red');
    line(FCT_r*cosd(FCT_tC)+FCT_C(1),FCT_r*sind(FCT_tC)+FCT_C(2),'Color','red');
end
%***************************************************************
%************************GRAPH**********************************
%***************************************************************
axis equal;
grid;
BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%***************************************************************
%***************************************************************








%***************************************************************
%********************START CONDITION****************************
%***************************************************************
x = sqrt(L*L/(1+cotd(CutInputAng)*cotd(CutInputAng)));
y = -cotd(CutInputAng)*sqrt(L*L/(1+cotd(CutInputAng)*cotd(CutInputAng)));
%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
x1 = sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+60)));
y1 = -cotd(CutInputAng+60)*sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+60)));
FCA_stBx       = BlankSize/2-FCT_a+x;
FCA_stBy       = -Blank_h+y;


te1 = (L+FCT_r)*sind(CutInputAng);
te2 = (L+FCT_r)*cosd(CutInputAng) - FCT_OO;
Dy = sqrt(te2*te2 + te1*te1);
FCA_st_tb_ang  = atand(te1/te2);
FCA_st_cr_ang  = FCA_st_tb_ang - CutInputAng;
FCA_end_tb_ang = acosd(FCT_dy/Dy);
FCA_tb_ang = FCA_end_tb_ang - FCA_st_tb_ang;
FCT_tb_ang = 60 - FCA_tb_ang/2;
BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%*************************FIRST CUT*****************************
%***************************************************************
CurAng = 1;
st_d   = 1;
en_d   = 1;

%3. Angle

st_d = FCA_st_tb_ang;

VelPoint(1)= CurAng; %1-st input
en_d = 60;
opi  = 0;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCA_or,FCA_r,L,1,60,opi,0,0);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
% Ok
st_d    = ang + dAlfa;
en_d    = FCA_end_tb_ang-dAlfa;
ang_d   = 1;
CurSide = CurSide + 1;
for ang = st_d:dAlfa:en_d
    Betta(CurAng)    = ang;
    OUT_Ax(CurAng)   = OUT_Ax(CurAng-ang_d*2);
    OUT_Ay(CurAng)   = -OUT_Ay(CurAng-ang_d*2);
    OUT_Bx(CurAng)   = OUT_Bx(CurAng-ang_d*2);
    OUT_Bang(CurAng) = -OUT_Bang(CurAng-ang_d*2);
    OUT_By(CurAng)   = 0;
    DrawSim(CurAng)  = 1;
    CurAng = CurAng + 1;
    ang_d  = ang_d + 1;
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);


%4,5,6 Trevel
st_d    = en_d + dAlfa;
en_d    = st_d + FCT_tb_ang;
FCT_or  = sqrt(FCT_dx*FCT_dx+FCT_dy*FCT_dy);
FCT_ang = atand(FCT_dy/FCT_dx);
opi     = 1;
for ang = st_d:dAlfa:en_d
	Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,1);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
st_d    = ang + dAlfa;
en_d    = st_d + FCT_tb_ang;
FCT_ang = atand(FCT_dy/FCT_dx);
opi     = 1;
for ang = st_d:dAlfa:en_d
	Betta(CurAng)   = ang;
	[OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,0);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
BarCur = BarCur + 3;
LoadBar(BarMax,BarCur);
%7. Angel
st_d = ang + dAlfa;
en_d = 180;
VelPoint(2)= CurAng; %2-nd input

opi = 0;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCA_or,FCA_r,L,1,180,opi,0,0);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
st_d    = ang + dAlfa;
en_d    = st_d + FCA_tb_ang/2-dAlfa;
ang_d   = 1;
for ang = st_d:dAlfa:en_d
    Betta(CurAng)    = ang;
    OUT_Ax(CurAng)   = OUT_Ax(CurAng-ang_d*2);
    OUT_Ay(CurAng)   = -OUT_Ay(CurAng-ang_d*2);
    OUT_Bx(CurAng)   = OUT_Bx(CurAng-ang_d*2);
    OUT_Bang(CurAng) = -OUT_Bang(CurAng-ang_d*2);
    OUT_By(CurAng)   = 0;
    DrawSim(CurAng)  = 1;
    CurAng = CurAng + 1;
    ang_d  = ang_d + 1;
end  
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

%8,9,10 Trevel
st_d    = ang + dAlfa;
en_d    = st_d + FCT_tb_ang;
FCT_or  = sqrt(FCT_dx*FCT_dx+FCT_dy*FCT_dy);
FCT_ang = atand(FCT_dy/FCT_dx)*2;
opi     = 1;
for ang = st_d:dAlfa:en_d
	Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,1);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
st_d    = ang + dAlfa;
en_d    = st_d + FCT_tb_ang;
FCT_ang = atand(FCT_dy/FCT_dx)*2;
opi     = 1;
for ang = st_d:dAlfa:en_d
	Betta(CurAng)    = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,0);
    DrawSim(CurAng)  = 1;
    CurAng = CurAng + 1;
end
BarCur = BarCur + 3;
LoadBar(BarMax,BarCur);

%11. Half angel
st_d = ang + dAlfa;
en_d = 300;

VelPoint(3)= CurAng; %3-rd input


opi = 1;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCA_or,FCA_r,L,1,300,opi,1,0);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%**************************************************************************
%**************************************SECOND CUT**************************
%**************************************************************************

CurAng = CurAng - 1;
[TR_Bang,TR_Ax,TR_Ay,TR_Bx,TR_By,TR_Alfa,TR_End,TR_Sim] = Triangle_Angle_Small(CutSimbSize,CutRad,L,dAlfa,Betta(CurAng),SimbRad,SimbSize,alf,ShiftLen,AdB,AdR,hTranz,AdOO,AdR);
for i = 1:1:TR_End
    OUT_Bang(CurAng+i) = TR_Bang(i);
    OUT_Ax(CurAng+i)   = TR_Ax(i);
    OUT_Ay(CurAng+i)   = TR_Ay(i);
    OUT_Bx(CurAng+i)   = TR_Bx(i);
    OUT_By(CurAng+i)   = TR_By(i);
    Betta(CurAng+i)    = TR_Alfa(i);
    DrawSim(CurAng+i)  = TR_Sim(i);
end
CurAng = CurAng + TR_End;
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

%**************************************************************************
%***********************PLOT CUT*******************************************
%**************************************************************************
for i = 1:1:CurAng-1
    rho(i) = Betta(i) + DrawSim(i)*atand(OUT_Ay(i)/OUT_Ax(i))+270;
    rhi(i) = sqrt(OUT_Ax(i)*OUT_Ax(i)+OUT_Ay(i)*OUT_Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
if (plotWork == 0)
    line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

for i = 1:1:CurAng-1
   rho(i) = Betta(i) + 270;
   rhi(i) = sqrt(OUT_Bx(i)*OUT_Bx(i)+OUT_By(i)*OUT_By(i));
   xx(i)  = rhi(i)*cosd(rho(i));
   yy(i)  = rhi(i)*sind(rho(i));
end
if (plotWork == 0)
    line(xx(1:CurAng-1),yy(1:CurAng-1)); %,'Marker','square'
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%********************SAVE START COND****************************
%***************************************************************
cd([curdir '\OUTPUT']);
addpath([curdir '\FUNCTION']);    % Include folder with extra functions
WrightStartComd(OUT_Bx,OUT_Bang,Betta,(CurAng-1),'StCut');
cd(curdir);
%***************************************************************
%*******************SAVE CUT TO CAM*****************************
%***************************************************************
norm_bx = OUT_Bx(1);
norm_ba = OUT_Bang(1);
norm_al = Betta(1);
norm_tb = OUT_Table(1);
for i = 1:1:CurAng-1
    Betta(i)     = Betta(i)    - norm_al;
    OUT_Bx(i)    = OUT_Bx(i)   - norm_bx;
    %************************************
    OUT_Bx(i)    = 0 - OUT_Bx(i);
    %************************************
    OUT_Bang(i)  = OUT_Bang(i) - norm_ba;
    OUT_Table(i) = OUT_Table(i)- norm_tb;
end
cd([curdir '\OUTPUT']);
addpath([curdir '\FUNCTION']);    % Include folder with extra functions
DotAcc  = 1200;	% Delta dot in output
WrightCamsToFile(OUT_Bx,OUT_Bang,Betta,'CAM_Bx_Cut.txt','CAM_Alfa_Cut.txt',(CurAng-1),DotAcc);
WrightCamToFile(OUT_Table,Betta,'CAM_Table.txt',(CurAng-1),DotAcc);
cd(curdir);
BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%**********************CALC ROLL********************************
%***************************************************************
CurAng = 1;
%TR_Bett
[TR_Bang,TR_Ax,TR_Ay,TR_Bx,TR_By,TR_Alfa,TR_End,TR_Sim,TR_Extremums] = Triangle(SimbSize,SimbRad,LR,dAlfa,0,0);
CurAng = TR_End;
%***************************************************************
%***********************PLOT ROLL*******************************
%***************************************************************
for i = 1:1:CurAng-1
    rho(i) = TR_Alfa(i) + atand(TR_Ay(i)/TR_Ax(i))+270;
    rhi(i) = sqrt(TR_Ax(i)*TR_Ax(i)+TR_Ay(i)*TR_Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
if (plotWork == 0)
    line(xx(1:CurAng-1),yy(1:CurAng-1),'color','green');
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

for i = 1:1:CurAng-1
   rho(i) = TR_Alfa(i) + 270;
   rhi(i) = sqrt(TR_Bx(i)*TR_Bx(i)+TR_By(i)*TR_By(i));
   xx(i)  = rhi(i)*cosd(rho(i));
   yy(i)  = rhi(i)*sind(rho(i));
end
if (plotWork == 0)
    line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

if PlotData == 1
    subplot(1,1,1);
    plot(TR_Alfa(1:CurAng-1), TR_Bang(1:CurAng-1), TR_Alfa(1:CurAng-1), TR_Bx(1:CurAng-1));
    title(['Coordindte of A & B.']);
    xlabel('Angle, grad');
    ylabel('Coordindte, mm');
    grid;
    legend;
end

%***************************************************************
%***********************SAVE ROLL CAM***************************
%***************************************************************
cd([curdir '\OUTPUT']);
addpath([curdir '\FUNCTION']);    % Include folder with extra functions
WrightStartComd(TR_Bx,TR_Bang,TR_Alfa,(CurAng-1),'StRoll');
cd(curdir);
norm_bx = TR_Bx(1);
norm_ba = TR_Bang(1);
norm_al = TR_Alfa(1);
for i = 1:1:TR_End
    TR_Alfa(i) = TR_Alfa(i) - norm_al; %
    TR_Bx(i)   = TR_Bx(i)   - norm_bx;
    %************************************
    TR_Bx(i)   = 0 - TR_Bx(i);
    %************************************
    TR_Bang(i) = TR_Bang(i) - norm_ba;
end
cd([curdir '\OUTPUT']);
addpath([curdir '\FUNCTION']);    % Include folder with extra functions
DotAcc  = 720;	% Delta dot in output
WrightCamsToFile(TR_Bx,TR_Bang,TR_Alfa,'CAM_Bx_Roll.txt','CAM_Alfa_Roll.txt',TR_End,DotAcc);
cd(curdir);

%***********************
% Speed Up/Down points^:
delta = TR_Alfa(TR_End)/DotAcc;	% Numer of dots in output
for i=1:1:TR_ExtremumsNumber
    TR_SpeedPoints(2*i-1)=TR_Extremums(i)-17*delta;
    TR_SpeedPoints(2*i)=TR_Extremums(i) + 7*delta;
end
cd([curdir '\OUTPUT']);
file = fopen('RollExtremums.txt','w');
fprintf(file,  '%3.4f \r\n',TR_SpeedPoints);
fclose(file);
cd(curdir);
%***********************


BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%***************************************************************
%***************************************************************


EstTime = cputime - StartTime;
%h = msgbox('Operation Completed','Success');