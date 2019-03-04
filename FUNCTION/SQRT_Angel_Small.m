function [Bang,Ax,Ay,Bx,By,Alfa,End,Simb] = SQRT_Angel_Small(HX,HY,R,L,dAlfa,Str,R2,H2X,H2Y,alf,shift,Ot,Rt,hTranz,AdOO,TRlen,RTXb)
%***************************************************************
%**************************DEBUG********************************
%***************************************************************
DebugPlot = 0;  % 1 - plot data from function
%***************************************************************
%*************************INTERNAL******************************
%***************************************************************
% SIMBOL GEOMETRIC DATA:
hx  = HX/2;
hy  = HY/2;
Mx  = HX - hx - 2*R;
My  = HY - hy - 2*R;

h2x = H2X/2;
h2y = H2Y/2;
M2x = H2X - h2x - 2*R2;         % From center of triangle to center of coner curvature
M2y = H2Y - h2y - 2*R2;         % From center of triangle to center of coner curvature

ddx = M2x - Mx;
ddy = M2y - My;

TRx = shift + ddx*cosd(45);     % Streght tranzit size
TRy = shift + ddy*cosd(45);     % Streght tranzit size

Sx  = (HX - 4*R*sind(45))/2-TRx;% Real streght half side of simbol
Sy  = (HY - 4*R*sind(45))/2-TRy;% Real streght half side of simbol

% GRID SIZE:
nAlfa  = 360/dAlfa;             % Nome of calc stops
% INCRIMENT:
CurAng = 1;                     % current angle - counter
% RANGES:
sqrtRengeNom          = 12;     % Nomber of triangle ranges
RadiusAngleRange      = 0;      %
HalfStreghtAngleRange = 0;      % Range of the half of streght part of simbol
sqrtRenge = 0:1:sqrtRengeNom;	% Mass triangle ranges initalistion
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
Oy = -Ot(2);

HalfStreghtAngleRangeY = atand((hy - Rt)/hx) ;
HalfStreghtAngleRangeX = atand(Ox/(hx + L)) ;
HalfStreghtAngleRangeY = atand(Ox/(hy + L)) ;
RadiusAngleRange       = 90 - HalfStreghtAngleRangeX - HalfStreghtAngleRangeY;
dx = (Rt+L)*sind(alf);
dy = (Rt+L)*(1-cosd(alf));
TranzitAngleRange = atand((Ox+dx)/(hx+L-dy)) - HalfStreghtAngleRangeY;

B = RTXb + L*sind(alf);
A = hy+L*cosd(alf)-2*Rt*sind(alf/2)*sind(alf/2);
LineAngRange = atand(B/(A-TRlen*sind(alf))) - TranzitAngleRange - HalfStreghtAngleRangeY;

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

%***************************************************************
%********************MAIN CALCULATION***************************
%***************************************************************
if (HX > HY)
    h = HX/2;
else
    h = HY/2;
end
alfFC = acosd(h/firstCutRad);
%********************ANGLE PART 11->12**************************
% Halfe angle
temp = (TriangleRenge(12) - TriangleRenge(11))/2;
st_d = -alfFC;
en_d = st_d + temp - TranzitAngleRange - LineAngRange - dAlfa;
% Tranzit Line

% Tranzit radius

%*******************STREGHT PART 12->13************************* 

%********************STREGHT PART 1->2**************************

%*********************ANGLE PART 2->3***************************

% Tranzit radius

% Tranzit Line

% Halfe angle

% Halfe angle

% Tranzit Line

% Tranzit radius

%********************STREGHT PART 3->4**************************

%********************STREGHT PART 4->5**************************

%*********************ANGLE PART 5->6***************************

% Tranzit radius

% Tranzit Line

% Halfe angle

% Halfe angle

% Tranzit Line

% Tranzit radius

%********************STREGHT PART 6->7**************************

%********************STREGHT PART 7->8**************************

%*********************ANGLE PART 8->9***************************

% Tranzit radius

% Tranzit Line

% Halfe angle

% Halfe angle

% Tranzit Line

% Tranzit radius

%********************STREGHT PART 9->10**************************

%********************STREGHT PART 10->11*************************

%*********************ANGLE PART 11->12**************************

% Tranzit radius

% Tranzit Line

% Halfe angle










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