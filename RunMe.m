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
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Simbol Data:
SimbSize = 921; % mm
SimbRad  = 55.5;  % mm(��������� 51; ����� 55,5)
RollAdd  = 22;  % mm
CutAdd   = 52;  % mm(52)
% Machine Data:
L  = 401;       % From center of carriet to end of scissors(���� 512)
LR = 307;       % Carriage lenhth, mm (last - 339)
% Cut Tech Proc Data:
CutInputAng = 30; % grad
CutLagAng   = 1;  % grad
MinCutRad   = 45; % mm (45)
% Calc Data:
dAlfa   = 0.001;	% delta alfa
DotAcc  = 200;	% Delta dot in output
FullAng = 720;	% Full revolv of curve, grad
%Driver data
MstAcc    = 1;  % Master acceleration, u/s^2
SupMstVel = 1;  % grad/sec
LowVel    = 0.1;% Low speed of tabel
MaxVel    = 1;  % Max speed of tabel
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
CutRad    = SimbRad + RollAdd;              % Radius of simbol after cut, mm
BisxRoll  = (SimbSize/s3)-SimbRad;          % Distance on bisector from centor of simbol to top of roll radius
BisxCut   = BisxRoll + RollAdd;             % Distance on bisector from centor of simbol to top of cut radius
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
line(CutRad*cos(thetaA)+RlA(1),CutRad*sin(thetaA)+RlA(2));      % Draw A left redius
line(CutRad*cos(thetaB)+RlB(1),CutRad*sin(thetaB)+RlB(2));      % Draw B right radius
line(CutRad*cos(thetaC)+RlC(1),CutRad*sin(thetaC)+RlC(2));      % Draw C top radius
dx = RollAdd*s3/2;                                              % cut-roll delta x
dy = RollAdd/2;                                                 % cut-roll delta y
CtA1 = [RlA1(1) (RlA1(2)-RollAdd)];                             % Left-down 
CtB1 = [RlB1(1) (RlB1(2)-RollAdd)];                             % Right-down
CtB2 = [RlB2(1)+dx RlB2(2)+dy];                                 % Right-up
CtC1 = [RlC1(1)+dx RlC1(2)+dy];                                 % Top-right
CtC2 = [RlC2(1)-dx RlC2(2)+dy];                                 % Top-left
CtA2 = [RlA2(1)-dx RlA2(2)+dy];                                 % Left-up
line([CtA1(1) CtB1(1)],[CtA1(2) CtB1(2)]);                      % Draw line AB
line([CtB2(1) CtC1(1)],[CtB2(2) CtC1(2)]);                      % Draw line BC
line([CtC2(1) CtA2(1)],[CtC2(2) CtA2(2)]);                      % Draw line AC
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
if (FCS_r < L)                          % if radius less than carriet length, table shood turn to the negative side. It is uncorrect. So we willn't cut at the side
    CutType = 1;                        % Save this fock
end
if (CutType == 0)                       % Calc for normal situation
    FCR_or = Blank_h+FCS_r-CutAdd;
    FCR_dx = FCR_or*cosd(30);
    FCR_dy = FCR_or*sind(30);
    FCR_A  = [0 -FCR_or];
    FCR_B  = [FCR_dx  FCR_dy];
    FCR_C  = [-FCR_dx FCR_dy];
    FCR_tA = linspace(90-CutInputAng,90+CutInputAng);
    FCR_tB = linspace(180-CutInputAng+30,180+2*CutInputAng-CutInputAng+30);
    FCR_tC = linspace(CutInputAng-30-2*CutInputAng,CutInputAng-30);
    line(FCS_r*cosd(FCR_tA)+FCR_A(1),FCS_r*sind(FCR_tA)+FCR_A(2),'Color','red');
    line(FCS_r*cosd(FCR_tB)+FCR_B(1),FCS_r*sind(FCR_tB)+FCR_B(2),'Color','red');
    line(FCS_r*cosd(FCR_tC)+FCR_C(1),FCS_r*sind(FCR_tC)+FCR_C(2),'Color','red');
end
%***********************ANGLE***********************************
tetta  = 60-CutInputAng;
FCA_r  = (SimbRad+RollAdd+2*CutAdd)/(sind(tetta)*s3+cosd(tetta)-1);
FCA_or = BisxCut-FCA_r;
FCA_tA = linspace(150+CutInputAng,270-CutInputAng);
FCA_tB = linspace(270+CutInputAng,390-CutInputAng);
FCA_tC = linspace(30+CutInputAng,150-CutInputAng);
FCA_dx = FCA_or*cosd(30);
FCA_dy = FCA_or*sind(30);
FCA_A  = [-FCA_dx -FCA_dy];
FCA_B  = [FCA_dx  -FCA_dy];
FCA_C  = [0 (BisxCut-FCA_r)];
line(FCA_r*cosd(FCA_tA)+FCA_A(1),FCA_r*sind(FCA_tA)+FCA_A(2),'Color','red');
line(FCA_r*cosd(FCA_tB)+FCA_B(1),FCA_r*sind(FCA_tB)+FCA_B(2),'Color','red');
line(FCA_r*cosd(FCA_tC)+FCA_C(1),FCA_r*sind(FCA_tC)+FCA_C(2),'Color','red');
%***********************TRAVEL**********************************
FCT_a  = FCA_r*2*sind(60-CutInputAng);
if (CutType == 0)
    FCT_b  = FCS_r*cosd(90-CutInputAng);
    FCT_xs = BlankSize/2 - FCT_b - FCT_a;
    FCT_r  = FCT_xs/(2*sind(CutInputAng));
    FCT_dx = BlankSize/2 - FCT_a - FCT_xs/2;
    FCT_dy = FCT_r*cosd(CutInputAng)-Blank_h;
    FCT_B1 = [FCT_dx  FCT_dy];
    FCT_A1 = [-FCT_dx FCT_dy];
    FCT_B2 = [(BlankSize/2 - FCT_r*cosd(CutInputAng-30) - FCT_a*cosd(60))   FCT_a*sind(60)+FCT_r*sind(CutInputAng-30)-Blank_h];
    FCT_A2 = [(FCT_r*cosd(CutInputAng-30) + FCT_a*cosd(60) - BlankSize/2)   FCT_a*sind(60)+FCT_r*sind(CutInputAng-30)-Blank_h];
    FCT_C1 = [(FCT_r*cosd(CutInputAng-30) + (FCT_a+FCT_b*2+FCT_xs)*cosd(60) - BlankSize/2)    (FCT_a+FCT_b*2+FCT_xs)*sind(60)+FCT_r*sind(CutInputAng-30)-Blank_h];
    FCT_C2 = [(BlankSize/2 - FCT_r*cosd(CutInputAng-30) - (FCT_a+FCT_b*2+FCT_xs)*cosd(60))    (FCT_a+FCT_b*2+FCT_xs)*sind(60)+FCT_r*sind(CutInputAng-30)-Blank_h];
    FCT_tA1 = linspace(270-CutInputAng,270+CutInputAng);
    FCT_tB1 = linspace(270-CutInputAng,270+CutInputAng);
    FCT_tB2 = linspace(30-CutInputAng,30+CutInputAng);
    FCT_tA2 = linspace(150-CutInputAng,150+CutInputAng);
    FCT_tC1 = linspace(150-CutInputAng,150+CutInputAng);
    FCT_tC2 = linspace(30-CutInputAng,30+CutInputAng);
    line(FCT_r*cosd(FCT_tA1)+FCT_A1(1),FCT_r*sind(FCT_tA1)+FCT_A1(2),'Color','red');
    line(FCT_r*cosd(FCT_tB1)+FCT_B1(1),FCT_r*sind(FCT_tB1)+FCT_B1(2),'Color','red');
    line(FCT_r*cosd(FCT_tB2)+FCT_B2(1),FCT_r*sind(FCT_tB2)+FCT_B2(2),'Color','red');
    line(FCT_r*cosd(FCT_tA2)+FCT_A2(1),FCT_r*sind(FCT_tA2)+FCT_A2(2),'Color','red');
    line(FCT_r*cosd(FCT_tC1)+FCT_C1(1),FCT_r*sind(FCT_tC1)+FCT_C1(2),'Color','red');
    line(FCT_r*cosd(FCT_tC2)+FCT_C2(1),FCT_r*sind(FCT_tC2)+FCT_C2(2),'Color','red');
elseif(CutType == 1)
    FCT_xs = BlankSize/2 - FCT_a;
    FCT_r  = FCT_xs/cosd(90-CutInputAng);
    FCT_OO = FCT_r*sind(90-CutInputAng) - Blank_h;
    FCT_dx = FCT_OO*cosd(30);
    FCT_dy = FCT_OO*sind(30);
    FCT_A  = [FCT_dx  -FCT_dy];
    FCT_B  = [-FCT_dx -FCT_dy];
    FCT_C  = [0        FCT_OO];
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
if (CutType == 0)
    Bx = x-FCT_b;
    By = -Blank_h+y;
    StartTableAng = atand(Bx/By);
    StatrtCarAng  = atand(By/Bx) - atand((y)/(x));
elseif (CutType == 1)
    
end
%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
x1 = sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+60)));
y1 = -cotd(CutInputAng+60)*sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+60)));
FCA_stBx       = BlankSize/2-FCT_a+x;
FCA_stBy       = -Blank_h+y;
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
BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%*************************FIRST CUT*****************************
%***************************************************************
CurAng = 1;
st_d   = 1;
en_d   = 1;
if (CutType == 0)
    %1. Side
    opi  = 0;
    st_d = -StartTableAng;
    en_d = StartTableAng;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FCS_r,L,0,0,opi,0,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
    %2. Travel
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

%3. Angle
if(CutType == 0)
    st_d = ang + dAlfa;
elseif(CutType == 1)
    st_d = FCA_st_tb_ang;
end
VelPoint(1)= CurAng; %1-st input
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
    ang_d  = ang_d + 1;
end
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

if (CutType == 0)
    %4. Trevel
    FCT_ang = 90+atand(FCT_B2(2)/FCT_B2(1));
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
    %5. Side
    VelPoint(2) = CurAng; %2-nd input
    opi     = 0;
    st_d    = ang+dAlfa;
    en_d    = st_d+FCS_tb_ang;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FCS_r,L,0,120,opi,0,0);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
    %6. Trevel
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
elseif(CutType == 1)
    %4,5,6 Trevel
    st_d    = ang + dAlfa;
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
%7. Angel
st_d = ang + dAlfa;
en_d = 180;
if (CutType == 0)
	VelPoint(3)= CurAng; %3-rd input
elseif(CutType == 1)
    VelPoint(2)= CurAng; %2-nd input
end

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

if (CutType == 0)
    %8. Trevel
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
    %9. Side
    VelPoint(4) = CurAng; %4-th input
    opi     = 1;
    st_d    = ang+dAlfa;
    en_d    = st_d+FCS_tb_ang;
    for ang = st_d:dAlfa:en_d
        Betta(CurAng) = ang;
        [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCR_or,FCS_r,L,0,60,opi,0,1);
        DrawSim(CurAng) = 1;
        CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
    %10. Trevel
    FCT_ang = atand(FCT_A2(2)/FCT_A2(1));
    st_d    = ang + dAlfa;
    en_d    = st_d + FCT_tb_ang;
    opi     = 0;
    for ang = st_d:dAlfa:en_d
       Betta(CurAng) = ang;
       [OUT_Bang(CurAng),OUT_Ax(CurAng),OUT_Ay(CurAng),OUT_Bx(CurAng),OUT_By(CurAng)] = CutCircle(ang,FCT_or,FCT_r,L,1,FCT_ang,opi,1,0);
       DrawSim(CurAng) = 1;
       CurAng = CurAng + 1;
    end
    BarCur = BarCur + 1;
    LoadBar(BarMax,BarCur);
elseif(CutType == 1)
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
end
%11. Half angel
st_d = ang + dAlfa;
en_d = 300;

if (CutType == 0)
	VelPoint(5)= CurAng; %5-th input
elseif(CutType == 1)
    VelPoint(3)= CurAng; %3-rd input
end

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
%***************************SECOND CUT**************************
%***************************************************************
CurAng = CurAng - 1;
[TR_Bang,TR_Ax,TR_Ay,TR_Bx,TR_By,TR_Alfa,TR_End,TR_Sim] = Triangle(CutSimbSize,CutRad,L,dAlfa,Betta(CurAng),1);
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
%***********************PLOT CUT********************************
%***************************************************************
for i = 1:1:CurAng-1
    rho(i) = Betta(i) + DrawSim(i)*atand(OUT_Ay(i)/OUT_Ax(i))+270;
    rhi(i) = sqrt(OUT_Ax(i)*OUT_Ax(i)+OUT_Ay(i)*OUT_Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

for i = 1:1:CurAng-1
   rho(i) = Betta(i) + 270;
   rhi(i) = sqrt(OUT_Bx(i)*OUT_Bx(i)+OUT_By(i)*OUT_By(i));
   xx(i)  = rhi(i)*cosd(rho(i));
   yy(i)  = rhi(i)*sind(rho(i));
end
line(xx(1:CurAng-1),yy(1:CurAng-1));
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%*********************VELOCYTY CHART****************************
%***************************************************************
%{
for i = 1:1:CurAng-1
    VelChart(i) = 1;                    % 1 u/s - base master velocyty
    TimeLine(i) = Betta(i)/SupMstVel;   % Time line for table angel
end
if (CutType == 0)
	VelDot = 5;
elseif(CutType == 1)
    VelDot = 3;
end
MstAcc = 0.1;
ttr = (MaxVel-LowVel)/MstAcc;
Str  = MaxVel*ttr-MstAcc*ttr*ttr/2;    % length of velosity chenge 
nStr = fix(Str/dAlfa);                 % nomber of points for Str

for i=1:1:VelDot
  for j=-nStr:1:0
    VelAng = VelPoint(i) + j;
    VelChart(VelAng) = (LowVel-MaxVel)*(nStr+j)/nStr + MaxVel;
  end
  for j=0:1:nStr
    VelAng = VelPoint(i) + j;
    VelChart(VelAng) = (MaxVel-LowVel)*j/nStr + LowVel;
  end
end

BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

%***************************************************************
%**********************CALC TABLE CAM***************************
%***************************************************************
OUT_Table(1) = VelChart(1)*TimeLine(1);
for i = 2:1:CurAng-1
    OUT_Table(i) = OUT_Table(i-1)+ VelChart(i)*(TimeLine(i)-TimeLine(i-1));
end
subplot(2,1,1);
plot(VelChart(1:CurAng-1));
grid;
subplot(2,1,2);
plot(OUT_Table(1:CurAng-1));
grid;
%}
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
[TR_Bang,TR_Ax,TR_Ay,TR_Bx,TR_By,TR_Alfa,TR_End,TR_Sim] = Triangle(SimbSize,SimbRad,LR,dAlfa,0,0);
CurAng = TR_End;
%***************************************************************
%***********************PLOT ROLL*******************************
%***************************************************************
for i = 1:1:CurAng-1
    rho(i) = TR_Alfa(i) + atand(TR_Ay(i)/TR_Ax(i))+90;
    rhi(i) = sqrt(TR_Ax(i)*TR_Ax(i)+TR_Ay(i)*TR_Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
line(xx(1:CurAng-1),yy(1:CurAng-1),'color','red');
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);

for i = 1:1:CurAng-1
   rho(i) = TR_Alfa(i) + 270;
   rhi(i) = sqrt(TR_Bx(i)*TR_Bx(i)+TR_By(i)*TR_By(i));
   xx(i)  = rhi(i)*cosd(rho(i));
   yy(i)  = rhi(i)*sind(rho(i));
end
%line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
BarCur = BarCur + 1;
LoadBar(BarMax,BarCur);
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
BarCur=BarCur + 1;
LoadBar(BarMax,BarCur);
%***************************************************************
%***************************************************************
%***************************************************************
EstTime = cputime - StartTime
h = msgbox('Operation Completed','Success');