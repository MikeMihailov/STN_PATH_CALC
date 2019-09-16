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
plotWork         = 1;
DebugPlot        = 0;
PlotFirstCutTest = 1;
PlotData         = 0;
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Simbol Data:
SimbSize      = 921;  % mm
SimbRad       = 51;   % mm
CutRad        = 69;   % mm

ShiftLenLeft  = 45;   % mm new �� ������� ������ ������� ����� ����������� ������
ShiftLenRight = 45;   % mm new
ShiftRadLeft  = 100;  % mm new ������ ��������
ShiftRadRight = 100;  % mm new

RollAdd       = 24;   % mm
CutAdd        = 12;   % mm
CutRadTurn    = 0;    % grad new
CutRadShift   = 0;    % mm   new
CutTurnShift  = 100;  % mm   new
% Machine Data:
L  = 402;            % From center of carriet to end of scissors
LR = 307;            % Carriage lenhth, mm
% Cut Tech Proc Data:
CutInputAng = 5;     % grad
CutLagAng   = 1;     % grad
MinCutRad   = 45;    % mm
FSCR        = 500;   % mm, radius of side cut
CutType     = 0;     % 0 - withcut at side, 1 - without
% Calc Data:
dAlfa       = 0.001; % Delta alfa
DotAcc      = 200;   % Delta dot in output
FullAng     = 720;   % Full revolv of curve, grad
%***************************************************************
%***********************INTERNAL********************************
%***************************************************************
BarMax   = 18;   % Nomber of bar dots
BarCur   = 0;    % Start bar dot

nAlfa    = FullAng/dAlfa;         % Nome of calc stops
CurSide  = 1;                     % Current angle - counter
Betta    = 0:1:(nAlfa-dAlfa);     % Current angel
OUT_Ax   = 0:1:(nAlfa-dAlfa);     % Position dot A on OX
OUT_Ay   = 0:1:(nAlfa-dAlfa);     % Position dot A on OY
OUT_By   = 0:1:(nAlfa-dAlfa);     % Position dot B on OY
DrawSim  = 0:1:(nAlfa-dAlfa);     % Sign for drawing

VelChart = 0:1:(nAlfa-dAlfa);     % Chart of chenging velocity
VelPoint = 1:1:5;                 % Coordinats of velocity changing
TimeLine = 0:1:(nAlfa-dAlfa);     % Line of time

nTriAlfa = 360/dAlfa;             % Nome of calc stops
TR_Bang  = 0:1:(nTriAlfa-dAlfa);  % Buffer for bang
TR_Bett  = 0:1:(nTriAlfa-dAlfa);  % Buffer for betta
TR_Sim   = 0:1:(nTriAlfa-dAlfa);  % Buffer for sign
TR_Ax    = 0:1:(nTriAlfa-dAlfa);  % Buffer for Ax
TR_Ay    = 0:1:(nTriAlfa-dAlfa);  % Buffer for Ay
TR_Bx    = 0:1:(nTriAlfa-dAlfa);  % Buffer for Bx
TR_By    = 0:1:(nTriAlfa-dAlfa);  % Buffer for By
TR_Alfa  = 0:1:(nTriAlfa-dAlfa);  % Buffer for Alfa
TR_End   = 0;                     % End of bufer calculations

TR_ExtremumsNumber = 6;
TR_Extremums = 1:1:TR_ExtremumsNumber;     % Array of extremums
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
Cut_h = (s3/6)*CutSimbSize;
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
line(SimbRad*cos(thetaC)+RlC(1),SimbRad*sin(thetaC)+RlC(2));  	% Draw top radius
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
Or  = sqrt(RlA(1)*RlA(1) + RlA(2)*RlA(2));
Ors = sqrt(RlA(1)*RlA(1) + RlA(2)*RlA(2))+CutRadShift-CutTurnShift;
RlSA = [-(Ors*sind(60-CutRadTurn)+CutTurnShift*sind(60)) -(Ors*cosd(60-CutRadTurn)+CutTurnShift*cosd(60))];
RlSB = [  Ors*sind(60+CutRadTurn)+CutTurnShift*sind(60)  -(Ors*cosd(60+CutRadTurn)+CutTurnShift*cosd(60))];
RlSC = [-(Ors*sind(CutRadTurn))                            CutTurnShift+Ors*cosd(CutRadTurn)];

dx = RollAdd*s3/2;                                    % cut-roll delta x
dy = RollAdd/2;                                       % cut-roll delta

% Sides of triangel:
ddxLeft  = ShiftLenLeft  * sind(30);                  % shift side left for small radius tranzaction
ddyLeft  = ShiftLenLeft  * cosd(30);                  % shift side left for small radius tranzaction
ddxRight = ShiftLenRight * sind(30);                  % shift side right for small radius tranzaction
ddyRight = ShiftLenRight * cosd(30);                  % shift side right for small radius tranzaction

CtA1 = [RlA(1)+ShiftLenRight RlA1(2)-RollAdd];        % ! Left-down
CtB1 = [RlB(1)-ShiftLenLeft  RlB1(2)-RollAdd];        % ! Right-down
CtB2 = [RlB2(1)+dx-ddxRight  RlB2(2)+dy+ddyRight];    % ! Right-up
CtC1 = [RlC1(1)+dx+ddxLeft   RlC1(2)+dy-ddyLeft];     % ! Top-right
CtC2 = [RlC2(1)-dx-ddxRight  RlC2(2)+dy-ddyRight];    % ! Top-left
CtA2 = [RlA2(1)-dx+ddxLeft   RlA2(2)+dy+ddyLeft];     % ! Left-up

line([CtA1(1) CtB1(1)],[CtA1(2) CtB1(2)]);            % ! Draw line AB
line([CtB2(1) CtC1(1)],[CtB2(2) CtC1(2)]);            % ! Draw line BC
line([CtC2(1) CtA2(1)],[CtC2(2) CtA2(2)]);            % ! Draw line AC

% Tranzaction radius parametrs:
AdALeft   = [CtA2(1)+ShiftRadLeft*cosd(30)  CtA2(2)-ShiftRadLeft*sind(30)];%!
AdBLeft   = [RlB(1)-ShiftLenLeft           -Cut_h+ShiftRadLeft           ]; %!
AdCLeft   = [CtC1(1)-ShiftRadLeft*cosd(30)  CtC1(2)-ShiftRadLeft*sind(30)];%!
AdOOLeft  = sqrt(AdALeft(1)*AdALeft(1)+AdALeft(2)*AdALeft(2));
xxxLeft   = (ShiftLenLeft/sind(60)*CutRad)/(ShiftRadLeft-CutRad);
alfLeft   = 60 - acosd(CutRad/xxxLeft);

AdARight  = [RlA(1)+ShiftLenRight           -Cut_h+ShiftRadRight           ];%!
AdBRight  = [CtB2(1)-ShiftRadRight*cosd(30)  CtB2(2)-ShiftRadRight*sind(30)];%!
AdCRight  = [CtC2(1)+ShiftRadRight*cosd(30)  CtC2(2)-ShiftRadRight*sind(30)];%!
AdOORight = sqrt(AdARight(1)*AdARight(1)+AdARight(2)*AdARight(2));
xxxRight  = (ShiftLenRight/sind(60)*CutRad)/(ShiftRadRight-CutRad);
alfRight  = 60 - acosd(CutRad/xxxRight);
%*******
txRight   = RlSA(1) - AdARight(1);
tyRight   = RlSA(2) - AdARight(2);
tdRight   = sqrt(txRight*txRight+tyRight*tyRight);
tlRight   = tdRight*CutRad/(ShiftRadRight-CutRad);
tcapRight = 90-atand(tyRight/txRight)-acosd(CutRad/tlRight);

txLeft   = RlSB(1) - AdBLeft(1);
tyLeft   = RlSB(2) - AdBLeft(2);
tdLeft   = sqrt(txLeft*txLeft+tyLeft*tyLeft);
tlLeft   = tdLeft*CutRad/(ShiftRadLeft-CutRad);
tcapLeft = 90+atand(tyLeft/txLeft)-acosd(CutRad/tlLeft);

TranzA11 = [AdARight(1)-ShiftRadRight*sind(tcapRight)     AdARight(2)-ShiftRadRight*cosd(tcapRight)] ;
TranzB11 = [AdBLeft(1)+ShiftRadLeft*sind(tcapLeft)        AdBLeft(2)-ShiftRadLeft*cosd(tcapLeft)];
TranzB22 = [AdBRight(1)+ShiftRadRight*sind(tcapRight+60)  AdBRight(2)+ShiftRadRight*cosd(tcapRight+60)];
TranzC11 = [AdCLeft(1)+ShiftRadLeft*sind(tcapLeft+120)    AdCLeft(2)-ShiftRadLeft*cosd(tcapLeft+120)];
TranzC22 = [AdCRight(1)-ShiftRadRight*sind(tcapRight+120) AdCRight(2)-ShiftRadRight*cosd(tcapRight+120)];  % right
TranzA22 = [AdALeft(1)-ShiftRadLeft*sind(tcapLeft+60)     AdALeft(2)+ShiftRadLeft*cosd(tcapLeft+60)];      % left

TranzA12 = [RlSA(1)-CutRad*sind(tcapRight)     RlSA(2)-CutRad*cosd(tcapRight)];      % Right
TranzB12 = [RlSB(1)+CutRad*sind(tcapLeft)      RlSB(2)-CutRad*cosd(tcapLeft)];       % Left
TranzB21 = [RlSB(1)+CutRad*sind(tcapRight+60)  RlSB(2)+CutRad*cosd(tcapRight+60)];   % Right
TranzC12 = [RlSC(1)+CutRad*sind(tcapLeft+120)  RlSC(2)-CutRad*cosd(tcapLeft+120)];   % Left
TranzC21 = [RlSC(1)-CutRad*sind(tcapRight+120) RlSC(2)-CutRad*cosd(tcapRight+120)];  % Right
TranzA21 = [RlSA(1)-CutRad*sind(tcapLeft+60)   RlSA(2)+CutRad*cosd(tcapLeft+60)];    % Left
%*******
%1
thetaAdA = linspace(270,270-tcapRight);
line(ShiftRadRight*cosd(thetaAdA)+AdARight(1),ShiftRadRight*sind(thetaAdA)+AdARight(2),'Color','red');
%2
thetaAdA = linspace(270,270+tcapLeft);
line(ShiftRadLeft*cosd(thetaAdA)+AdBLeft(1),ShiftRadLeft*sind(thetaAdA)+AdBLeft(2),'Color','red');
%3
thetaAdA = linspace(30,30-tcapRight);
line(ShiftRadRight*cosd(thetaAdA)+AdBRight(1),ShiftRadRight*sind(thetaAdA)+AdBRight(2),'Color','red');
%4
thetaAdA = linspace(30+tcapLeft,30);
line(ShiftRadLeft*cosd(thetaAdA)+AdCLeft(1),ShiftRadLeft*sind(thetaAdA)+AdCLeft(2),'Color','red');
%5
thetaAdA = linspace(150-tcapRight,150);
line(ShiftRadRight*cosd(thetaAdA)+AdCRight(1),ShiftRadRight*sind(thetaAdA)+AdCRight(2),'Color','red');
%6
thetaAdA = linspace(150+tcapLeft,150);
line(ShiftRadLeft*cosd(thetaAdA)+AdALeft(1),ShiftRadLeft*sind(thetaAdA)+AdALeft(2),'Color','red');

% ANGEL RADIUS
thetaACut = linspace(150+tcapLeft,270-tcapRight);      % Ends of radius A
thetaBCut = linspace(-90+tcapLeft,30-tcapRight);       % Ends of radius B
thetaCCut = linspace(30+tcapLeft,150-tcapRight);       % Ends of radius C

line(CutRad*cosd(thetaACut)+RlSA(1),CutRad*sind(thetaACut)+RlSA(2));      % Draw A left redius
line(CutRad*cosd(thetaBCut)+RlSB(1),CutRad*sind(thetaBCut)+RlSB(2));      % Draw B right radius
line(CutRad*cosd(thetaCCut)+RlSC(1),CutRad*sind(thetaCCut)+RlSC(2));      % Draw C top radius
% TRANSIT LINE
line([TranzA12(1) TranzA11(1)],[TranzA12(2) TranzA11(2)],'Color','green');  % ! Draw line AB right
line([TranzB12(1) TranzB11(1)],[TranzB12(2) TranzB11(2)],'Color','green');  % ! Draw line AB left
line([TranzB21(1) TranzB22(1)],[TranzB21(2) TranzB22(2)],'Color','green');  % ! Draw line AB right
line([TranzC12(1) TranzC11(1)],[TranzC12(2) TranzC11(2)],'Color','green');  % ! Draw line AB left
line([TranzC21(1) TranzC22(1)],[TranzC21(2) TranzC22(2)],'Color','green');  % ! Draw line AB rifht
line([TranzA21(1) TranzA22(1)],[TranzA21(2) TranzA22(2)],'Color','green');  % ! Draw line AB left

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

if (FSCR < L)
    FSCR = L;
    h    = msgbox('Current side radius is too small. Programm will use minimum side radius','Warning');
end
CIA = acosd(1-CutAdd/FSCR);
if (CIA < CutInputAng)
    CIA  = CutInputAng;
    FSCR = CutAdd/(1-cosd(CutInputAng));    % Calc radius of side cut
    h    = msgbox('With current side radius angel is too small. Programm will use minimum cut angel','Warning');
end
salf = -atand(RlSC(1)/RlSC(2));
sg   = Blank_h*2 - BisxCut;
sr   = sg/(2*cosd(CIA)-1);
sx   = RlSC(1);
sy   = RlSC(2)-BisxCut+sr;
sd   = sqrt(sx*sx+sy*sy);
sdel = sd+CutRad-sr;
sbet = atand(sx/sy);

BisxCut = BisxCut + sdel;

%FCA_r = FCA_r + sdel;
%sCIA  = acosd((g+FCA_r)/(2*FCA_r));
%***********************ANGLE***********************************
g      = Blank_h*2 - BisxCut;
FCA_r  = g/(2*cosd(CIA)-1);
FCA_or = BisxCut-FCA_r;
FCA_dx = FCA_or*cosd(30);
FCA_dy = FCA_or*sind(30);
FCA_A  = [-FCA_dx -FCA_dy];
FCA_B  = [FCA_dx  -FCA_dy];
FCA_C  = [0 (BisxCut-FCA_r)];


if (PlotFirstCutTest == 1)
    tetta  = 60-CIA;
    FCA_tA = linspace(150+CIA,270-CIA);
    FCA_tB = linspace(270+CIA,390-CIA);
    FCA_tC = linspace(30+CIA, 150-CIA);
    line(FCA_r*cosd(FCA_tA)+FCA_A(1),FCA_r*sind(FCA_tA)+FCA_A(2),'Color','red');
    line(FCA_r*cosd(FCA_tB)+FCA_B(1),FCA_r*sind(FCA_tB)+FCA_B(2),'Color','red');
    line(FCA_r*cosd(FCA_tC)+FCA_C(1),FCA_r*sind(FCA_tC)+FCA_C(2),'Color','red');
end
%************************SIDE***********************************
if (CutType == 0)                       % Calc for normal situation
    FCR_or = Blank_h+FSCR-CutAdd;
    FCR_dx = FCR_or*cosd(30);
    FCR_dy = FCR_or*sind(30);
    FCR_A  = [0 -FCR_or];
    FCR_B  = [FCR_dx  FCR_dy];
    FCR_C  = [-FCR_dx FCR_dy];
    FCR_tA = linspace(90-CIA,  90+CIA);
    FCR_tB = linspace(210-CIA,210+CIA);
    FCR_tC = linspace(-30-CIA,-30+CIA);
    if (PlotFirstCutTest == 1)
        line(FSCR*cosd(FCR_tA)+FCR_A(1),FSCR*sind(FCR_tA)+FCR_A(2),'Color','red');
        line(FSCR*cosd(FCR_tB)+FCR_B(1),FSCR*sind(FCR_tB)+FCR_B(2),'Color','red');
        line(FSCR*cosd(FCR_tC)+FCR_C(1),FSCR*sind(FCR_tC)+FCR_C(2),'Color','red');
    end
end
%***********************TRAVEL**********************************
FCT_a  = 2*FCA_r*sind(60-CIA);
if (CutType == 0)
    FCT_b  = FSCR*sind(CIA);                  % line side proection on side radius
    FCT_xs = BlankSize/2 - FCT_b - FCT_a;
    FCT_r  = FCT_xs/(2*sind(CIA));
    FCT_dx = BlankSize/2 - FCT_a - FCT_xs/2;
    FCT_dy = FCT_r*cosd(CIA)-Blank_h;
    FCT_B1 = [FCT_dx  FCT_dy];
    FCT_A1 = [-FCT_dx FCT_dy];
    FCT_B2 = [(BlankSize/2        - FCT_r*cosd(CIA-30)               - FCT_a*cosd(60))   FCT_a*sind(60)+FCT_r*sind(CIA-30) - Blank_h];
    FCT_A2 = [(FCT_r*cosd(CIA-30) +  FCT_a*cosd(60)                  - BlankSize/2)      FCT_a*sind(60)+FCT_r*sind(CIA-30) - Blank_h];
    FCT_C1 = [(FCT_r*cosd(CIA-30) + (FCT_a+FCT_b*2+FCT_xs)*cosd(60)  - BlankSize/2)     (FCT_a+FCT_b*2+FCT_xs)*sind(60)+FCT_r*sind(CIA-30)-Blank_h];
    FCT_C2 = [-FCT_C1(1) FCT_C1(2)];
    FCT_tA1 = linspace(270-CIA,270+CIA);
    FCT_tB1 = linspace(270-CIA,270+CIA);
    FCT_tB2 = linspace(30 -CIA,30 +CIA);
    FCT_tA2 = linspace(150-CIA,150+CIA);
    FCT_tC1 = linspace(150-CIA,150+CIA);
    FCT_tC2 = linspace(30-CIA, 30 +CIA);
    if (PlotFirstCutTest == 1)
        line(FCT_r*cosd(FCT_tA1)+FCT_A1(1),FCT_r*sind(FCT_tA1)+FCT_A1(2),'Color','red');
        line(FCT_r*cosd(FCT_tB1)+FCT_B1(1),FCT_r*sind(FCT_tB1)+FCT_B1(2),'Color','red');
        line(FCT_r*cosd(FCT_tB2)+FCT_B2(1),FCT_r*sind(FCT_tB2)+FCT_B2(2),'Color','red');
        line(FCT_r*cosd(FCT_tA2)+FCT_A2(1),FCT_r*sind(FCT_tA2)+FCT_A2(2),'Color','red');
        line(FCT_r*cosd(FCT_tC1)+FCT_C1(1),FCT_r*sind(FCT_tC1)+FCT_C1(2),'Color','red');
        line(FCT_r*cosd(FCT_tC2)+FCT_C2(1),FCT_r*sind(FCT_tC2)+FCT_C2(2),'Color','red');
    end
elseif(CutType == 1)
    FCT_a  = FCA_r*2*sind(60-CIA);
    FCT_xs = BlankSize/2 - FCT_a;
    FCT_r  = FCT_xs/cosd(90-CIA);
    FCT_OO = FCT_r*sind(90-CIA) - Blank_h + (CutRad - SimbRad)/3;
    FCT_a  = FCA_dx + FCA_r*sind(CIA);
    FCT_r  = FCT_a/sind(CIA);
    FCT_OO = FCT_a/tand(CIA) - Blank_h;
    FCT_dx = FCT_OO*cosd(30);
    FCT_dy = FCT_OO*sind(30);
    FCT_A  = [FCT_dx  -FCT_dy];
    FCT_B  = [-FCT_dx -FCT_dy];
    FCT_C  = [0        FCT_OO];
    if (PlotFirstCutTest == 1)
        FCT_tA = linspace(150-CIA,150+CIA);
        FCT_tB = linspace(30 -CIA, 30+CIA);
        FCT_tC = linspace(-90-CIA,-90+CIA);
        line(FCT_r*cosd(FCT_tA)+FCT_A(1),FCT_r*sind(FCT_tA)+FCT_A(2),'Color','red');
        line(FCT_r*cosd(FCT_tB)+FCT_B(1),FCT_r*sind(FCT_tB)+FCT_B(2),'Color','red');
        line(FCT_r*cosd(FCT_tC)+FCT_C(1),FCT_r*sind(FCT_tC)+FCT_C(2),'Color','red');
    end
end
FCT_OO = FCT_a/tand(CIA) - Blank_h;
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
x = sqrt(L*L/(1+cotd(CIA)*cotd(CIA)));
xI = L*sind(CIA);
y = -cotd(CIA)*sqrt(L*L/(1+cotd(CIA)*cotd(CIA)));
if (CutType == 0)
    Bx = x-FCT_b;
    By = -Blank_h+y;
    StartTableAng = atand(Bx/By);
    StatrtCarAng  = atand(By/Bx) - atand((y)/(x));
end
%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
x1 = sqrt(L*L/(1+cotd(CIA+60)*cotd(CIA+60)));
y1 = -cotd(CIA+60)*sqrt(L*L/(1+cotd(CIA+60)*cotd(CIA+60)));
FCA_stBx = BlankSize/2-FCT_a+x;
FCA_stBy = -Blank_h+y;

FCA_st_tb_ang  = -atand(FCA_stBx/FCA_stBy);
FCA_st_cr_ang  = atand(FCA_stBx/FCA_stBy) + atand(y/x)+90;
FCA_end_tb_ang = atand((BlankSize/2-FCT_a*cosd(60)+x1)/(Blank_h-FCT_a*sind(60)+y1));
if (CutType == 0)
    FCA_tb_ang = FCA_end_tb_ang - FCA_st_tb_ang;
    FCS_tb_ang = StartTableAng*2;
    FCT_tb_ang = 60 - FCA_tb_ang/2 - FCS_tb_ang/2;
elseif(CutType == 1)
    FCA_tb_ang = FCA_end_tb_ang - FCA_st_tb_ang;
    FCT_tb_ang = 60 - FCA_tb_ang/2;
end


%te1 = (L+FCT_r)*sind(CIA);
%te2 = (L+FCT_r)*cosd(CIA) - FCT_OO;
%Dy = sqrt(te2*te2 + te1*te1);
%FCA_st_tb_ang  = atand(te1/te2);
%FCA_st_cr_ang  = FCA_st_tb_ang - CutInputAng;
%FCA_end_tb_ang = acosd(FCT_dy/Dy);
%FCA_tb_ang = FCA_end_tb_ang - FCA_st_tb_ang;
%if (CutType == 0)
%    FCS_tb_ang = StartTableAng*2;
%    FCT_tb_ang = 60 - FCA_tb_ang/2 - FCS_tb_ang/2;
%elseif(CutType == 1)
%    FCT_tb_ang = 60 - FCA_tb_ang/2;
%end

BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%*************************FIRST CUT*****************************
%***************************************************************
CurAng = 1;
st_d   = 1;
en_d   = 1;
%*************************1. Side*******************************
if (CutType == 0)
    opi  = 0;
    st_d = -StartTableAng;
    en_d = StartTableAng;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FSCR,L,0,0,opi,1,1);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%************************2. Travel******************************
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 1;
    FCT_or  = sqrt(FCT_dx*FCT_dx+FCT_dy*FCT_dy);
    FCT_ang = atand(FCT_dy/FCT_dx);
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,0,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
end
%************************3. Angle*******************************
if(CutType == 0)
    st_d = ang + dAlfa;
elseif(CutType == 1)
    st_d = FCA_st_tb_ang;
end
VelPoint(1)= CurAng;        %1-st input
en_d = 60;
opi  = 0;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCA_or,FCA_r,L,1,60,opi,0,0);
    DrawSim(CurAng) = 1;
    CurAng = CurAng + 1;
end
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
    ang_d  = ang_d  + 1;
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%**************************4. Trevel****************************
if (CutType == 0)
    FCT_ang = 90+atand(FCT_B2(2)/FCT_B2(1));
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 0;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,1);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%***************************5. Side*****************************
    VelPoint(2) = CurAng; %2-nd input
    opi  = 0;
    st_d = ang+dAlfa;
    en_d = st_d+FCS_tb_ang;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FSCR,L,0,120,opi,1,1);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%**************************6. Trevel****************************
    FCT_ang = 270-atand(FCT_C1(2)/FCT_C1(1));
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 0;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,0,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
%************************4,5,6 Trevel***************************
elseif(CutType == 1)
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
end
%**************************7. Angel*****************************
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
    ang_d  = ang_d  + 1;
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%**************************8. Trevel****************************
if (CutType == 0)
    FCT_ang = atand(-FCT_C2(2)/FCT_C2(1));
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 0;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,0,1);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%***************************9. Side*****************************
    VelPoint(4) = CurAng; %4-th input
    opi  = 1;
    st_d = ang+dAlfa;
    en_d = st_d+FCS_tb_ang;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FSCR,L,0,60,opi,1,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%*************************10. Trevel****************************
    FCT_ang = atand(FCT_A2(2)/FCT_A2(1));
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 0;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,0,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
%************************8,9,10 Trevel**************************
elseif(CutType == 1)
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
end
%***********************11. Half angel**************************
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
%***************************************************************
%*************************SECOND CUT****************************
%***************************************************************
CurAng = CurAng - 1;

%

alfffLeft = atand(TranzA12(2)/TranzA12(1)) - atand(TranzA11(2)/TranzA11(1))

[TR_Bang,TR_Ax,TR_Ay,TR_Bx,TR_By,TR_Alfa,TR_End,TR_Sim] = Triangle_Angle_Small(CutSimbSize,CutRad,L,dAlfa,Betta(CurAng),SimbRad,SimbSize,alfLeft,alfRight,ShiftLenLeft,ShiftLenRight,AdBLeft,AdARight,hTranz,AdOOLeft,AdOORight,ShiftRadLeft,ShiftRadRight,tcapLeft,tcapRight,TranzA11,TranzA12,TranzB11,TranzB12);
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
%***************************************************************
%**************************PLOT CUT*****************************
%***************************************************************
for i = 1:1:CurAng-1
    rho(i) = Betta(i) + DrawSim(i)*atand(OUT_Ay(i)/OUT_Ax(i))+270;
    rhi(i) = sqrt(OUT_Ax(i)*OUT_Ax(i)+OUT_Ay(i)*OUT_Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
if (plotWork == 1)
    line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
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
%***************************************************************
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
%***************************************************************
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
