function [Bang,Ax,Ay,Bx,By,Alfa,End,Simb] = Triangle_Angle_Small(Size,R,L,dAlfa,Str,R2,Size2,alfLeft,alfRight,shiftLeft,shiftRight,OtLeft,OtRight,hTranz,AdOOLeft,AdOORight,AdRLeft,AdRRight,tcapLeft,tcapRight,TranzA11,TranzA12,TranzB11,TranzB12)
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
HalfStreghtAngleRange = 0;              		% Range of the half of streght part of simbol
RadiusAngleRange = 0;                   		%
%***************************************************************
%*************************OUTPUT***s*****************************
%***************************************************************
Ax    = 0:1:(nAlfa-dAlfa);          % Position dot A on OX
Ay    = 0:1:(nAlfa-dAlfa);          % Position dot A on OY
Bx    = 0:1:(nAlfa-dAlfa);          % Position dot B on OX
By    = 0:1:(nAlfa-dAlfa);          % Position dot B on OY
Bang  = 0:1:(nAlfa-dAlfa);          % Angel of car in grad
Betta = 0:1:(nAlfa-dAlfa);      		% Current angel
Simb  = 0:1:(nAlfa-dAlfa);
Alfa  = Str:dAlfa:(Str+360-dAlfa);	% Turn angle
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
HalfStreghtAngleRangeLeft  = ((360 - 3*RadiusAngleRangeLeft)/6);
HalfStreghtAngleRangeRight = ((360 - 3*RadiusAngleRangeRight)/6);
%****
TranzitAngleRangeLeft = atand((OtLeft(1)+(AdRLeft+L)*sind(tcapLeft))/(h-AdRLeft+(AdRLeft+L)*cosd(tcapLeft)))-HalfStreghtAngleRangeLeft;
TranzitAngleRangeRight = atand((-OtRight(1)+(AdRRight+L)*sind(tcapRight))/(h-AdRRight+(AdRRight+L)*cosd(tcapRight)))-HalfStreghtAngleRangeRight;

tettRight = -atand((TranzA12(2)-TranzA11(2))/(TranzA12(1)-TranzA11(1)));
lenRight  = sqrt((TranzA12(2)-TranzA11(2))*(TranzA12(2)-TranzA11(2)) + (TranzA12(1)-TranzA11(1))*(TranzA12(1)-TranzA11(1)) );
CRight = [TranzA11(1)-L*sind(tettRight)  TranzA11(2)-L*cosd(tettRight)];
DRight = [CRight(1)-lenRight*cosd(tettRight) CRight(2)+ lenRight*sind(tettRight)];
LineAngRangeRight = atand(CRight(2)/CRight(1))-atand(DRight(2)/DRight(1));

tettLeft = atand((TranzB12(2)-TranzB11(2))/(TranzB12(1)-TranzB11(1)));
lenLeft  = sqrt((TranzB12(2)-TranzB11(2))*(TranzB12(2)-TranzB11(2)) + (TranzB12(1)-TranzB11(1))*(TranzB12(1)-TranzB11(1)) );
CLeft = [TranzB11(1)+L*sind(tettRight)  TranzB11(2)-L*cosd(tettRight)];
DLeft = [CLeft(1)+lenLeft*cosd(tettLeft) CLeft(2)+ lenLeft*sind(tettLeft)];
LineAngRangeLeft = atand(DLeft(2)/DLeft(1))-atand(CLeft(2)/CLeft(1));


OxLeft  = OtLeft(1);
OxRight = OtRight(1);
OyLeft  = -OtLeft(2);
OyRight = -OtRight(2);
dxLeft  = (AdRLeft +L)*sind(alfLeft);
dxRight = (AdRRight+L)*sind(alfRight);
dyLeft  = (AdRLeft +L)*(1-cosd(alfLeft));
dyRight = (AdRRight+L)*(1-cosd(alfRight));
%TranzitAngleRangeLeft  = atand((OxLeft +dxLeft )/(OyLeft +AdRLeft+L- dyLeft))  - atand(OxLeft/ (OyLeft+ AdRLeft+ L));
%TranzitAngleRangeRight = atand((OxRight+dxRight)/(OyRight+AdRRight+L-dyRight)) - atand(OxRight/(OyRight+AdRRight+L));
%****
LineAngRangeLeft  = atand(((L+R)*sind(alfLeft) +M*cosd(30)) / ((L+R)*cosd(alfLeft )+M*sind(30))) - atand((OxLeft +dxLeft )/(OyLeft +AdRLeft +L-dyLeft));
%LineAngRangeRight = atand(((L+R)*sind(alfRight)+M*cosd(30)) / ((L+R)*cosd(alfRight)+M*sind(30))) - atand((OxRight+dxRight)/(OyRight+AdRRight+L-dyRight));
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
temp = (TriangleRenge(9) - TriangleRenge(8))/2;
st_d = -60;
en_d = st_d + temp - TranzitAngleRangeRight - LineAngRangeRight - dAlfa; %TranzitAngleRangeRight
for ang = st_d:dAlfa:en_d
	Cy = M*cosd(ang-210);
    Cx = M*sind(ang-210);
    Cr = L+R;
    Bang(CurAng) = atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = Cx+sqrt(Cr*Cr-Cy*Cy);
    By(CurAng)   = 0;
    Ax(CurAng)   = Bx(CurAng)-L*cosd(Bang(CurAng));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
% Tranzit Line
st_d = en_d;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang+alfRight);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
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
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L, 1,  -60, 0,  0, 1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 9->10**************************
st_d = en_d;
buf = TriangleRenge(10)-TriangleRenge(9);

for ang = 0:dAlfa:(HalfStreghtAngleRange - dAlfa)
	AAd = (h + L)*tand(HalfStreghtAngleRange-ang);
    Ay(CurAng)    = -L*sind(HalfStreghtAngleRange-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(HalfStreghtAngleRange-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRange-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
st_d = st_d + HalfStreghtAngleRange- dAlfa;

%********************STREGHT PART 1->2**************************
for ang = 0:dAlfa:HalfStreghtAngleRange
    AAd = (h + L)*tand(ang);
    Ay(CurAng)    = L*sind(ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    temp1 = L*cosd(ang);
    temp2 = Ax(CurAng);
    Bx(CurAng)    = L*cosd(ang)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************ANGLE PART 2->3****************************
%LEFT
%Tranzit radius
st_d = HalfStreghtAngleRange;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L, 1, 60, 0,  0, 0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang-alfLeft);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

temp = (TriangleRenge(3) - TriangleRenge(2))/2;
for ang = (TranzitAngleRangeLeft+LineAngRangeLeft):dAlfa:(temp-dAlfa)
    Cx = M * cosd(temp-ang);
    By(CurAng) = 0;
    buf        = sqrt(Cx * Cx - M*M + (L+R)*(L+R));
    Bx(CurAng) = Cx + buf;

    Betta(CurAng) = asind((M*sind(RadiusAngleRange/2-ang))/(R+L));
    Ax(CurAng)    = Bx(CurAng) - L*cosd(Betta(CurAng));
    Ay(CurAng)    = L*sind(Betta(CurAng));
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%RIGHT
st_d = 60;
en_d = st_d + temp - LineAngRangeRight - TranzitAngleRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    Cy = M*cosd(ang-150);
    Cx = M*sind(ang-150);
    Cr = L+R;
    Bang(CurAng) = -atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)-Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang+alfRight-120);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
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
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L, 1,  60, 0,  0, 1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 3->4**************************
%CurAng = 154660;
buf = TriangleRenge(4)-TriangleRenge(3);
for ang = 0:dAlfa:(HalfStreghtAngleRange-dAlfa)
    AAd = (h + L)*tand(HalfStreghtAngleRange-ang);
    Ay(CurAng)    = -L*sind(buf-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(HalfStreghtAngleRange-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRange-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************STREGHT PART 4->5**************************
for ang = 0:dAlfa:HalfStreghtAngleRange
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
st_d = HalfStreghtAngleRange;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L, 1,  60, 0,  0, 0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang-alfLeft);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end


temp = (TriangleRenge(6) - TriangleRenge(5))/2;
for ang = (TranzitAngleRangeLeft+LineAngRangeLeft):dAlfa:(temp-dAlfa)
    Cx = M * cosd(temp-ang);
    By(CurAng) = 0;
    buf        = sqrt(Cx * Cx - M*M + (L+R)*(L+R));
    Bx(CurAng) = Cx + buf;

    Betta(CurAng) = asind((M*sind(RadiusAngleRange/2-ang))/(R+L));
    kuz           = L*cosd(Betta(CurAng));
    Ax(CurAng)    = Bx(CurAng) - kuz;
    Ay(CurAng)    = L*sind(Betta(CurAng));
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

%RIGHT
st_d = 120;
en_d = st_d + temp - LineAngRangeRight - TranzitAngleRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    Cy = M*cosd(ang-30);
    Cx = M*sind(ang-30);
    Cr = L+R;
    Bang(CurAng) = atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)+Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    %Bang(CurAng) = asin(Ay(CurAng)/L);
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeRight - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang+alfRight-180);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
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
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOORight,AdRRight,L, 1,  120, 0,  0, 1);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end
%********************STREGHT PART 6->7**************************
buf = TriangleRenge(7)-TriangleRenge(6);
for ang = 0:dAlfa:(HalfStreghtAngleRange - dAlfa)
    AAd = (h + L)*tand(HalfStreghtAngleRange-ang);
    Ay(CurAng)    = -L*sind(HalfStreghtAngleRange-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(buf-ang)+Ax(CurAng);
    Betta(CurAng) = HalfStreghtAngleRange-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%********************STREGHT PART 7->8**************************
for ang = 0:dAlfa:HalfStreghtAngleRange
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
%********************ANGLE PART 8->9****************************
%LEFT
%Tranzit radius
st_d = HalfStreghtAngleRange;
en_d = st_d + TranzitAngleRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    Betta(CurAng) = ang;
    [Bang(CurAng),Ax(CurAng),Ay(CurAng),Bx(CurAng),By(CurAng)] = CutCircle(ang,AdOOLeft,AdRLeft,L, 1,  60, 0,  0, 0);
    Simb(CurAng) = 1;
    CurAng = CurAng + 1;
end

% Tranzit Line
st_d = en_d - dAlfa;
en_d = st_d + LineAngRangeLeft - dAlfa;
for ang = st_d:dAlfa:en_d
    al = (ang-alfLeft);
    AAd = (hTranz + L)*tand(al);
    Ay(CurAng)    = L*sind(al);
    Ax(CurAng)    = sqrt(hTranz*hTranz + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(al)+Ax(CurAng);
    Betta(CurAng) = ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end

temp = (TriangleRenge(9) - TriangleRenge(8))/2;
for ang = (TranzitAngleRangeLeft+LineAngRangeLeft):dAlfa:(temp-dAlfa)
    Cx         = M * cosd(temp-ang);
    By(CurAng) = 0;
    buf        = sqrt(Cx * Cx - M*M + (L+R)*(L+R));
    Bx(CurAng) = Cx + buf;

    suz           = RadiusAngleRange/2-ang;
    Betta(CurAng) = asind((M*sind(suz))/(R+L));
    kuz           = L*cosd(Betta(CurAng));
    Ax(CurAng)    = Bx(CurAng) - kuz;
    Ay(CurAng)    = L*sind(Betta(CurAng));
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
%***************************************************************
%**********************DATA OUTPUT******************************
%***************************************************************
End = CurAng-1;
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
