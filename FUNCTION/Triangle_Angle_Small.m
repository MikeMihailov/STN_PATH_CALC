function [Bang,Ax,Ay,Bx,By,Alfa,End,Simb] = Triangle_Angle_Small(Size,R,L,dAlfa,Str,R2,Size2,alfLeft,alfRight,shiftLeft,shiftRight,OtLeft,OtRight,hTranzRight,hTranzLeft,AdOOLeft,AdOORight,AdRLeft,AdRRight,tcapLeft,tcapRight,TranzA11,TranzA12,TranzB11,TranzB12,Or,OSra,CtA1,CtB1)
%***************************************************************
%**************************DEBUG********************************
%***************************************************************
DebugPlot = 0;  % 1 - plot data from function
%***************************************************************
%**************************INPUT********************************
%***************************************************************
%   SIMBOL INPUT DATA:
% Size  - Simbol size, mm
% R     - Radius of curvature, mm
%   MASCHINE INPUT DATA:
% L     - Carriage lenhth for cut is 425 (for roll is 338)
%   ACCURACY:
% dAlfa - delta alfa
% Str   - Table start position
% CnR   - Cut not Roll(Add half angel and half side for CUT)
%***************************************************************
%*************************OUTPUT********************************
%***************************************************************
%Bang  - Angel move of carriage
%Bx    - Line move of carriage
%Alfa  - Angel grid
%***************************************************************
%*************************INTERNAL******************************
%***************************************************************
% SIMBOL GEOMETRIC DATA:
h = (sqrt(3)/6)*Size;                   % 1/3 of height (from center to side of triangle)
H = h*3;                                % Height
h2 = (sqrt(3)/6)*Size2;                 % 1/3 of height (from center to side of triangle)
H2 = h2*3;                              % Height
M = H2 - h2 - 2*R2;                     % From center of triangle to center of coner curvature
M2 = H-h-2*R;
dd = M2-M;

TrLeft  = shiftLeft+dd*cosd(30);            % WRONG Streght tranzit size
TrRight = shiftRight+dd*cosd(30);       	% WRONG Streght tranzit size
ALeft   = (Size - 4*R*sind(60))/2-TrLeft;   % ??? Real streght half side of simbol
ARight  = (Size - 4*R*sind(60))/2-TrRight;	% ??? Real streght half side of simbol
% GRID SIZE:
nAlfa = 360/dAlfa;                      		% Nome of calc stops
% INCRIMENT:
CurAng = 1;                            	 		% current angle - counter
% RANGES:
TriangleRengeNom = 9;                   		% Nomber of triangle ranges
TriangleRenge = 0:1:TriangleRengeNom;  	 		% Mass triangle ranges initalistion
%HalfStreghtAngleRange = 0;              		% Range of the half of streght part of simbol
RadiusAngleRange = 0;                   		%
%***************************************************************
%*************************OUTPUT********************************
%***************************************************************
Ax    = 0:1:(nAlfa-dAlfa);          % Position dot A on OX
Ay    = 0:1:(nAlfa-dAlfa);          % Position dot A on OY
Bx    = 0:1:(nAlfa-dAlfa);          % Position dot B on OX
By    = 0:1:(nAlfa-dAlfa);          % Position dot B on OY
Bang  = 0:1:(nAlfa-dAlfa);          % Angel of car in grad
Betta = 0:1:(nAlfa-dAlfa);      		% Current angel
Simb  = 0:1:(nAlfa-dAlfa);
%***************************************************************
%***************************************************************
%***************************************************************



%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
%         6 5
%  . . . . ^ . . . .   ^
%  . . . /   \ . . .   |
%  . 7 /       \ 4 .   |
% 8. /     .     \ . 3 | H
%  < _ _ _ _ _ _ _ >   |
%  9      10-1    2    \/
%***************************************************************
RadiusAngleRangeLeft       = 120 - 2*(atand(ALeft/(L+h)));
RadiusAngleRangeRight      = 120 - 2*(atand(ARight/(L+h)));

HalfStreghtAngleRangeLeft  = atand((-CtA1(1))/(L+h));
HalfStreghtAngleRangeRight = atand(CtB1(1)/(L+h));
%****
%Ok
TranzitAngleRangeLeft  = atand((OtLeft(1)+(AdRLeft+L)*sind(tcapLeft))/(h-AdRLeft+(AdRLeft+L)*cosd(tcapLeft)))-HalfStreghtAngleRangeLeft;
%Ok
TranzitAngleRangeRight = atand((-OtRight(1)+(AdRRight+L)*sind(tcapRight))/(h-AdRRight+(AdRRight+L)*cosd(tcapRight)))-HalfStreghtAngleRangeRight;

TarnzitAngleShiftAngLeft  = atand(OtLeft(1)/OtLeft(2));
TarnzitAngleShiftAngRight = atand(OtRight(1)/OtRight(2));

tettRight         = -atand((TranzA12(2)-TranzA11(2))/(TranzA12(1)-TranzA11(1)));
lenRight          = sqrt((TranzA12(2)-TranzA11(2))*(TranzA12(2)-TranzA11(2)) + (TranzA12(1)-TranzA11(1))*(TranzA12(1)-TranzA11(1)) );
CRight            = [TranzA11(1)-L*sind(tettRight)  TranzA11(2)-L*cosd(tettRight)];
DRight            = [CRight(1)-lenRight*cosd(tettRight) CRight(2)+ lenRight*sind(tettRight)];
LineAngRangeRight = atand(CRight(2)/CRight(1))-atand(DRight(2)/DRight(1));

tettLeft          = atand((TranzB12(2)-TranzB11(2))/(TranzB12(1)-TranzB11(1)));
lenLeft           = sqrt((TranzB12(2)-TranzB11(2))*(TranzB12(2)-TranzB11(2)) + (TranzB12(1)-TranzB11(1))*(TranzB12(1)-TranzB11(1)) );
CLeft             = [TranzB11(1)+L*sind(tettLeft)  TranzB11(2)-L*cosd(tettLeft)];
DLeft             = [CLeft(1)+lenLeft*cosd(tettLeft) CLeft(2)+ lenLeft*sind(tettLeft)];
LineAngRangeLeft  = atand(DLeft(2)/DLeft(1))-atand(CLeft(2)/CLeft(1));

OSrb = (60-OSra);
RadiusHalfLeft    = 60 - LineAngRangeLeft - TranzitAngleRangeLeft-HalfStreghtAngleRangeLeft+OSrb;
RadiusHalfRight   = 60 - LineAngRangeRight - TranzitAngleRangeRight-HalfStreghtAngleRangeRight-OSrb;
%****
TriangleRenge(1)  = 0;                                          % Start point
TriangleRenge(2)  = HalfStreghtAngleRangeLeft;                  % The end of first part
TriangleRenge(3)  = TriangleRenge(2) + RadiusAngleRangeLeft;				%?????????
TriangleRenge(4)  = TriangleRenge(3) + HalfStreghtAngleRangeRight;
TriangleRenge(5)  = TriangleRenge(4) + HalfStreghtAngleRangeLeft;
TriangleRenge(6)  = TriangleRenge(5) + RadiusAngleRangeLeft;				%?????????
TriangleRenge(7)  = TriangleRenge(6) + HalfStreghtAngleRangeRight;
TriangleRenge(8)  = TriangleRenge(7) + HalfStreghtAngleRangeLeft;
TriangleRenge(9)  = TriangleRenge(8) + RadiusAngleRangeLeft;				%?????????
TriangleRenge(10) = TriangleRenge(9) + HalfStreghtAngleRangeRight;   % Stop point


%***************************************************************
%********************MAIN CALCULATION***************************
%***************************************************************

%********************ANGLE PART 8->9****************************
%RIGHT
st_d = -60+OSrb;
en_d = st_d + RadiusHalfRight - dAlfa; %TranzitAngleRangeRight
for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,-60+OSrb,0,0,1);
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
angLeft = en_d - st_d;
% Tranzit Line
st_d = en_d;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang+tettRight;
    AAd           = (hTranzRight + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzRight*hTranzRight + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    a             = Bang(CurAng);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%Tranzit radius
st_d = en_d;
en_d = st_d + TranzitAngleRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L,1,-TarnzitAngleShiftAngRight,0,0,1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 9->10**************************
st_d = 0;
en_d = -en_d;
for ang = st_d:dAlfa:en_d
	AAd           = (h + L)*tand(HalfStreghtAngleRangeRight-ang);
    Ay(CurAng)    = -L*sind(HalfStreghtAngleRangeRight-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(HalfStreghtAngleRangeRight-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRangeRight-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************STREGHT PART 1->2**************************
st_d = 0;
en_d = HalfStreghtAngleRangeLeft-dAlfa;
for ang = st_d:dAlfa:en_d
    AAd = (h + L)*tand(ang);
    Ay(CurAng)    = L*sind(ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(ang)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************ANGLE PART 2->3****************************
%LEFT
%Tranzit radius
st_d = HalfStreghtAngleRangeLeft;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L,1,-TarnzitAngleShiftAngLeft,0,0,0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang-tettLeft;
    AAd           = (hTranzLeft + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzLeft*hTranzLeft + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%LEFT CONER
st_d   = en_d;
en_d   = st_d+RadiusHalfLeft-dAlfa;
angCon = en_d;
for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,0,0,0);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%RIGHT CONER
st_d = en_d;
en_d = st_d+RadiusHalfRight-dAlfa;
for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,0,0,1);
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang+tettRight-120;
    AAd           = (hTranzRight + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzRight*hTranzRight + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%Tranzit radius
st_d = en_d - dAlfa;
en_d = st_d + TranzitAngleRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L,1,120-TarnzitAngleShiftAngRight,0,0,1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 3->4**************************
buf = TriangleRenge(4)-TriangleRenge(3);
for ang = 0:dAlfa:(HalfStreghtAngleRangeRight-dAlfa)
    AAd = (h + L)*tand(HalfStreghtAngleRangeRight-ang);
    Ay(CurAng)    = -L*sind(buf-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(HalfStreghtAngleRangeRight-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRangeRight-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************STREGHT PART 4->5**************************
for ang = 0:dAlfa:(HalfStreghtAngleRangeLeft-dAlfa)
    AAd = (h + L)*tand(ang);
    Ay(CurAng)    = L*sind(ang)-0.1777;
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(ang)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************ANGLE PART 5->6****************************
%LEFT
%Tranzit radius
st_d = 120+HalfStreghtAngleRangeLeft;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L,1,120-TarnzitAngleShiftAngLeft,0,0,0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang-tettLeft-120;
    AAd           = (hTranzLeft + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzLeft*hTranzLeft + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%LEFT CONER
st_d    = en_d;
realEnd = 0;
angCon = 180+OSrb;
if (en_d+RadiusHalfLeft-dAlfa > 180)
    realEnd = st_d+RadiusHalfLeft-dAlfa;
    en_d = 180;
else
    en_d = st_d+RadiusHalfLeft-dAlfa;
end


for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,0,0,0);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

if (realEnd ~= 0)
    st_d = en_d+dAlfa;
    en_d = realEnd;
    for ang = st_d:dAlfa:en_d
        [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,1,1,1);
        Ax(CurAng) = -Ax(CurAng);
        Simb(CurAng)  = 1;
        CurAng        = CurAng + 1;
    end
end
%RIGHT CONER
realEnd = 0;
st_d = en_d-dAlfa;
if (st_d <180)
   realEnd = st_d+RadiusHalfRight-dAlfa;
   en_d    = 180;
   for ang = st_d:dAlfa:en_d
        [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,0,0,0);
        Ax(CurAng) = -Ax(CurAng);
        Simb(CurAng) = 1;
        CurAng       = CurAng + 1;
   end
   st_d = en_d+dAlfa;
   en_d = realEnd;
else
    en_d = st_d+RadiusHalfRight-dAlfa;
end

for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,angCon,1,1,1);
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang+tettRight-240;
    AAd           = (hTranzRight + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzRight*hTranzRight + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%Tranzit radius
st_d = en_d - dAlfa;
en_d = st_d + TranzitAngleRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L,1,180+60-TarnzitAngleShiftAngRight,1,1,1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 6->7**************************
buf = TriangleRenge(7)-TriangleRenge(6);
for ang = 0:dAlfa:(HalfStreghtAngleRangeRight-dAlfa)
    AAd           = (h + L)*tand(HalfStreghtAngleRangeRight-ang);
    Ay(CurAng)    = -L*sind(HalfStreghtAngleRangeRight-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(buf-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRangeRight-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************STREGHT PART 7->8**************************
for ang = 0:dAlfa:(HalfStreghtAngleRangeLeft-dAlfa)
    AAd           = (h + L)*tand(ang);
    Ay(CurAng)    = L*sind(ang)-0.1777;
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(ang)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************ANGLE PART 8->9****************************
%LEFT
%Tranzit radius
st_d = 240 + HalfStreghtAngleRangeLeft - dAlfa;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L,1,180+60-TarnzitAngleShiftAngLeft,1,1,0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al            = ang-tettLeft-240;
    AAd           = (hTranzLeft + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranzLeft*hTranzLeft + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%LEFT  CONER
st_d = en_d;
en_d = st_d+RadiusHalfLeft+dAlfa;
for ang = st_d:dAlfa:en_d
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,Or,R,L,1,360-OSra,1,1,0);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%***************************************************************
%**********************DATA OUTPUT******************************
%***************************************************************
Alfa  = Str:dAlfa:(Str+360-dAlfa);	% Turn angle
End = CurAng-1;
Alfa  = Str:dAlfa:End;	% Turn angle
if DebugPlot == 1
    subplot(1,1,1);
    plot(Alfa(1:CurAng-1), Bang(1:CurAng-1), Alfa(1:CurAng-1), Bx(1:CurAng-1));
    title(['Coordindte of A & B.']);
    xlabel('Angle, grad');
    ylabel('Coordindte, mm');
    grid;
    legend;
end
%***************************************************************
%***************************************************************
%***************************************************************
end
