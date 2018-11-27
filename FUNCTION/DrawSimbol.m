clear;
clc;
clf;
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Simbol Data:
SimbSize = 900; % mm
SimbRad  = 55;  % mm
RollAdd  = 21;  % mm
CutAdd   = 20;  % mm
% Machine Data:
L = 400;        % From center of carriet to end of scissors
% Cut Tech Proc Data:
CutInputAng = 30; % grad
CutLagAng   = 1;  % grad
MinCutRad   = 40; % mm
% Calc Data:
dAlfa   = 0.01;   % delta alfa
DotAcc  = 100;    % Delta dot in output
FullAng = 360;    % Full revolv of curve, grad
%***************************************************************
%***********************INTERNAL********************************
%***************************************************************
nAlfa  = FullAng/dAlfa;     % Nome of calc stops
CurAng = 1;                 % current angle - counter
Betta  = 0:1:(nAlfa-dAlfa); % Current angel
OUT_Ax = 0:1:(nAlfa-dAlfa); % Position dot A on OX 
OUT_Ay = 0:1:(nAlfa-dAlfa); % Position dot A on OY
OUT_By = 0:1:(nAlfa-dAlfa); % Position dot B on OY
%***************************************************************
%************************OUTPUT*********************************
%***************************************************************
OUT_Bx = 0:1:(nAlfa-dAlfa);             % Position dot B on OX
OUT_Bang   = 0:1:(nAlfa-dAlfa);         % Angel of car in grad
OUT_Alfa   = 0:dAlfa:(FullAng-dAlfa);   % Turn angle
%***************************************************************
%*********************MAIN DATA CALC****************************
%***************************************************************
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
%***************************************************************
%***************************************************************
%***************************************************************





%***************************************************************
%******************DRAW FIRST CUT LINE**************************
%***************************************************************
%  First cut contain side cut and angle cut.
%************************SIDE***********************************
FCS_r  = CutAdd/(1-cosd(CutInputAng));
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
%***********************ANGLE***********************************
tetta = 60-CutInputAng;
FCA_r = (SimbRad+RollAdd+2*CutAdd)/(sind(tetta)*s3+cosd(tetta)-1);
FCA_tA = linspace(150+CutInputAng,270-CutInputAng);
FCA_tB = linspace(270+CutInputAng,390-CutInputAng);
FCA_tC = linspace(30+CutInputAng,150-CutInputAng);
FCA_dx = (BisxCut-FCA_r)*cosd(30);
FCA_dy = (BisxCut-FCA_r)*sind(30);
FCA_A  = [-FCA_dx -FCA_dy];
FCA_B  = [FCA_dx  -FCA_dy];
FCA_C  = [0 (BisxCut-FCA_r)];
line(FCA_r*cosd(FCA_tA)+FCA_A(1),FCA_r*sind(FCA_tA)+FCA_A(2),'Color','red');
line(FCA_r*cosd(FCA_tB)+FCA_B(1),FCA_r*sind(FCA_tB)+FCA_B(2),'Color','red');
line(FCA_r*cosd(FCA_tC)+FCA_C(1),FCA_r*sind(FCA_tC)+FCA_C(2),'Color','red');
%***********************TRAVEL**********************************
FCT_a  = FCA_r*2*sind(60-CutInputAng);
FCT_b  = FCS_r*cosd(90-CutInputAng);
FCT_xs = BlankSize/2 - FCT_b - FCT_a;
FCT_r = FCT_xs/(2*sind(CutInputAng));
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
%***************************************************************
%************************GRAPH**********************************
%***************************************************************
axis equal;
grid;
%***************************************************************
%***************************************************************
%***************************************************************








%***************************************************************
%********************START CONDITION****************************
%***************************************************************
% LINE:
x = sqrt(L*L/(1+cotd(CutInputAng)*cotd(CutInputAng)));
y = -cotd(CutInputAng)*sqrt(L*L/(1+cotd(CutInputAng)*cotd(CutInputAng)));
Bx = x-FCT_b;
By = -Blank_h+y;
StartTableAng = atand(Bx/By);
StatrtCarAng  = atand(By/Bx) - atand((y)/(x));
% POLL:
OUT_Ay(1) = L*sind(StatrtCarAng);
OUT_By(1) = 0;

OUT_Bx(1)   = By/cosd(StartTableAng);
OUT_Bang(1) = StatrtCarAng;
OUT_Alfa(1) = StartTableAng;

OUT_Ax(1) = -OUT_Bx(1)-sqrt(L*L-OUT_Ay(1)*OUT_Ay(1));
%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
FCS_tb_ang = StartTableAng*2*(-1);
%***
x1 = sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+60)));
y1 = -cotd(CutInputAng+60)*sqrt(L*L/(1+cotd(CutInputAng+60)*cotd(CutInputAng+6)));

FCA_stBx       = BlankSize/2-FCT_a+x;
FCA_stBy       = -Blank_h+y;
FCA_st_tb_ang  = -atand(FCA_stBx/FCA_stBy);
FCA_st_cr_ang  = atand(FCA_stBx/FCA_stBy) + atand(y/x)+90;

FCA_end_tb_ang = atand((BlankSize/2-FCT_a*cosd(60)+x1)/(Blank_h-FCT_a*sind(60)));
FCA_tb_ang     = FCA_end_tb_ang - FCA_st_tb_ang;
%***
FCT_ang = 60 - FCA_tb_ang/2 - FCS_tb_ang/2;
%***************************************************************
%***********************BANG-Bx-ALFA****************************
%***************************************************************
CurAng = 1;
%1.
for ang = StartTableAng:dAlfa:(FCS_tb_ang)
    Betta(CurAng) = ang;
    Cy = FCR_or*sind(ang);
    Cx = FCR_or*cosd(ang);
    Cr = L-FCS_r;
    
    OUT_Bang(CurAng) = atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    OUT_Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)+Cx;
    OUT_By(CurAng)   = 0;
    OUT_Ax(CurAng)   = OUT_Bx(CurAng)-L*cosd(OUT_Bang(CurAng))
    OUT_Ay(CurAng)   = L*sind(OUT_Bang(CurAng));
end
%***************************************************************
%***************************************************************
%***************************************************************