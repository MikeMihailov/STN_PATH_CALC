function [Bang,Ax,Ay,Bx,By,Alfa,End,Simb] = SQRT_Angel(HX,HY,R,L,dAlfa,Str,Ot,tOO)
%***************************************************************
%**************************DEBUG********************************
%***************************************************************
DebugPlot = 0;  % 1 - plot data from function
debug     = 0;
%***************************************************************
%*************************INTERNAL******************************
%***************************************************************
% SIMBOL GEOMETRIC DATA:
hx  = HX/2;
hy  = HY/2;
M   = tOO;
% GRID SIZE:
nAlfa  = 360/dAlfa;             % Nome of calc stops
% INCRIMENT:
CurAng = 1;                     % current angle - counter
% RANGES:
sqrtRengeNom = 12;                  % Nomber of triangle ranges
sqrtRenge    = 0:1:sqrtRengeNom;	% Mass triangle ranges initalistion
if (debug == 1)
    StartTime    = cputime;
end
%***************************************************************
%*************************OUTPUT********************************
%***************************************************************
Ax    = 0:1:(nAlfa-dAlfa);          % Position dot A on OX 
Ay    = 0:1:(nAlfa-dAlfa);          % Position dot A on OY
Bx    = 0:1:(nAlfa-dAlfa);          % Position dot B on OX
By    = 0:1:(nAlfa-dAlfa);          % Position dot B on OY
Bang  = 0:1:(nAlfa-dAlfa);          % Angel of car in grad
Betta = 0:1:(nAlfa-dAlfa);      	% Current angel
Simb  = 0:1:(nAlfa-dAlfa);
Alfa  = Str:dAlfa:(Str+360-dAlfa);	% Turn angle
%***************************************************************
%***************************************************************
%***************************************************************


%***************************************************************
%******************RANGE CALCULATION****************************
%***************************************************************
%    8_ _ _ _7_ _ _6    /\
% 9 |               | 5 |
%   |               |   |
%   |               |   |
%10 |               | 4 | H
%   |               |   |
%   |               |   | 
%11 | _ _ _ _ _ _ _ | 3 |
%   12     13-1    2    \/
%***************************************************************
Ox = Ot(1);
HalfStreghtAngleRangeX = atand(Ox/(hx + L)) ;
HalfStreghtAngleRangeY = atand(Ox/(hy + L)) ;
RadiusAngleRange       = 90 - HalfStreghtAngleRangeX - HalfStreghtAngleRangeY;

sqrtRenge(1)  = 0;                                      % Start point
sqrtRenge(2)  = HalfStreghtAngleRangeX;                 % 1  - 2
sqrtRenge(3)  = sqrtRenge(2)  + RadiusAngleRange;       % 2  - 3
sqrtRenge(4)  = sqrtRenge(3)  + HalfStreghtAngleRangeY; % 3  - 4
sqrtRenge(5)  = sqrtRenge(4)  + HalfStreghtAngleRangeY; % 4  - 5
sqrtRenge(6)  = sqrtRenge(5)  + RadiusAngleRange;       % 5  - 6
sqrtRenge(7)  = sqrtRenge(6)  + HalfStreghtAngleRangeX; % 6  - 7
sqrtRenge(8)  = sqrtRenge(7)  + HalfStreghtAngleRangeX; % 7  - 8
sqrtRenge(9)  = sqrtRenge(8)  + RadiusAngleRange;       % 8  - 9
sqrtRenge(10) = sqrtRenge(9)  + HalfStreghtAngleRangeY; % 9  - 10
sqrtRenge(11) = sqrtRenge(10) + HalfStreghtAngleRangeY; % 10 - 11
sqrtRenge(12) = sqrtRenge(11) + RadiusAngleRange;       % 11 - 12
sqrtRenge(13) = sqrtRenge(12) + HalfStreghtAngleRangeX; % 12 - 13

if (debug == 1)
    "RANG at " + (cputime-StartTime) + " sec!"
end
%***************************************************************
%********************MAIN CALCULATION***************************
%***************************************************************

%********************STREGHT PART 1->2**************************
strAng = HalfStreghtAngleRangeX;
h      = hx;
for ang = 0:dAlfa:strAng
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
if (debug == 1)
    "1->2 at " + (cputime-StartTime) + " sec!"
end
%*********************ANGLE PART 2->3***************************
% Halfe angle
temp = RadiusAngleRange/2;
st_d = 0;
en_d = temp-dAlfa;
for ang = st_d:dAlfa:en_d
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
% Halfe angle
st_d = 45;
en_d = st_d + temp - dAlfa;
for ang = st_d:dAlfa:en_d
    a = ang-135;
    Cy = M*cosd(a);
    Cx = M*sind(a);
    Cr = L+R;
    Bang(CurAng) = -atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)-Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
if (debug == 1)
    "2->3 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 3->4**************************
strAng = HalfStreghtAngleRangeY;
h      = hy;
buf = sqrtRenge(4)-sqrtRenge(3);
for ang = 0:dAlfa:(strAng - dAlfa)
    AAd = (h + L)*tand(strAng-ang);
    Ay(CurAng)    = -L*sind(strAng-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(buf-ang)+Ax(CurAng);
    Betta(CurAng) = strAng-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
if (debug == 1)
    "3->4 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 4->5**************************
strAng = HalfStreghtAngleRangeY;
h      = hy;
for ang = 0:dAlfa:strAng
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
if (debug == 1)
    "4->5 at " + (cputime-StartTime) + " sec!"
end
%*********************ANGLE PART 5->6***************************
% Halfe angle
temp = RadiusAngleRange/2;
st_d = 0;
en_d = temp-dAlfa;
for ang = st_d:dAlfa:en_d
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
% Halfe angle
st_d = 45;
en_d = st_d + temp - dAlfa;
for ang = st_d:dAlfa:en_d
    a = ang-135;
    Cy = M*cosd(a);
    Cx = M*sind(a);
    Cr = L+R;
    Bang(CurAng) = -atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)-Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
if (debug == 1)
    "5->6 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 6->7**************************
strAng = HalfStreghtAngleRangeX;
h      = hx;
buf = sqrtRenge(4)-sqrtRenge(3);
for ang = 0:dAlfa:(strAng - dAlfa)
    AAd = (h + L)*tand(strAng-ang);
    Ay(CurAng)    = -L*sind(strAng-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(buf-ang)+Ax(CurAng);
    Betta(CurAng) = strAng-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
if (debug == 1)
    "6->7 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 7->8**************************
strAng = HalfStreghtAngleRangeX;
h      = hx;
for ang = 0:dAlfa:strAng
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
if (debug == 1)
    "7->8 at " + (cputime-StartTime) + " sec!"
end
%*********************ANGLE PART 8->9***************************
% Halfe angle
temp = RadiusAngleRange/2;
st_d = 0;
en_d = temp-dAlfa;
for ang = st_d:dAlfa:en_d
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
% Halfe angle
st_d = 45;
en_d = st_d + temp - dAlfa;
for ang = st_d:dAlfa:en_d
    a = ang-135;
    Cy = M*cosd(a);
    Cx = M*sind(a);
    Cr = L+R;
    Bang(CurAng) = -atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)-Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
if (debug == 1)
    "8->9 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 9->10**************************
strAng = HalfStreghtAngleRangeY;
h      = hy;
buf = sqrtRenge(10)-sqrtRenge(9);
for ang = 0:dAlfa:(strAng - dAlfa)
    AAd = (h + L)*tand(strAng-ang);
    Ay(CurAng)    = -L*sind(strAng-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(buf-ang)+Ax(CurAng);
    Betta(CurAng) = strAng-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
if (debug == 1)
    "9->10 at " + (cputime-StartTime) + " sec!"
end
%********************STREGHT PART 10->11*************************
strAng = HalfStreghtAngleRangeY;
h      = hy;
for ang = 0:dAlfa:strAng
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
if (debug == 1)
    "10->11 at " + (cputime-StartTime) + " sec!"
end
%*********************ANGLE PART 11->12**************************
% Halfe angle
temp = RadiusAngleRange/2;
st_d = 0;
en_d = temp-dAlfa;
for ang = st_d:dAlfa:en_d
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
% Halfe angle
st_d = 45;
en_d = st_d + temp - dAlfa;
for ang = st_d:dAlfa:en_d
    a = ang-135;
    Cy = M*cosd(a);
    Cx = M*sind(a);
    Cr = L+R;
    Bang(CurAng) = -atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    Bx(CurAng)   = sqrt(Cr*Cr-Cy*Cy)-Cx;
    By(CurAng)   = 0;
    Ax(CurAng)   = (Bx(CurAng)-L*cosd(Bang(CurAng)));
    Ay(CurAng)   = L*sind(Bang(CurAng));
    Simb(CurAng) = 1;
    CurAng       = CurAng + 1;
end
if (debug == 1)
    "11->12 at " + (cputime-StartTime) + " sec!"
end
%*******************STREGHT PART 12->13************************* 
strAng = HalfStreghtAngleRangeX;
h      = hx;
for ang = 0:dAlfa:(strAng - dAlfa)
	AAd = (h + L)*tand(strAng-ang);
    Ay(CurAng)    = -L*sind(strAng-ang);
    Ax(CurAng)    = sqrt(h*h + AAd*AAd - Ay(CurAng)*Ay(CurAng));
    By(CurAng)    = 0;
    Bx(CurAng)    = L*cosd(strAng-ang)+Ax(CurAng);
    Betta(CurAng) = strAng-ang;
    Bang(CurAng)  = asind(Ay(CurAng)/L);
    Simb(CurAng)  = 1;
    CurAng        = CurAng + 1;
end
if (debug == 1)
    "12->13 at " + (cputime-StartTime) + " sec!"
end
%***************************************************************
%**********************DATA OUTPUT******************************
%***************************************************************
End = CurAng-1;
if DebugPlot == 1
    subplot(1,1,1);
    plot(Alfa(1:CurAng-1), Bang(1:CurAng-1), Alfa(1:CurAng-1), Ay(1:CurAng-1));
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