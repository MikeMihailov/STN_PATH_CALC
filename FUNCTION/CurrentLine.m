%***************************************************************
%*********************CLEAR WORCKSPACE**************************
%***************************************************************
clear;      % delate all var in worckspace
clc;        % clear comand line
%***************************************************************
%*************************INCLUDE*******************************
%***************************************************************
curdir = cd;                    % Get cur direction name
%***************************************************************
%**************************PLOT*********************************
%***************************************************************
clf;                % clear plot window
%subplot(2,2,1);     % make new sub plot window
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Line data:
AngStart = -45; % Left range of sector
AngEnd   = 45;  % Right range of sector
h        = 290; % Distanse betwen center of table and line
% Machine Data:
L        = 511; % From center of carriet to end of scissors
% Calc Data:
dAlfa   = 0.001;% delta alfa
DotAcc  = 200;  % Delta dot in output
%***************************************************************
%***********************INTERNAL********************************
%***************************************************************
FullAng = AngEnd-AngStart;      % Sector size
nAlfa   = FullAng/dAlfa;        % Number of calc dots
nCos    = 3*pi/nAlfa;             % Size of Sin wave
nSin    = 4*pi/nAlfa;
Betta   = 0:1:(nAlfa-dAlfa);
Bang    = 0:1:(nAlfa-dAlfa);
Bx      = 0:1:(nAlfa-dAlfa);
By      = 0:1:(nAlfa-dAlfa);
Ax      = 0:1:(nAlfa-dAlfa);
Ay      = 0:1:(nAlfa-dAlfa);
S       = 0:1:(nAlfa-dAlfa);
temp    = 0:1:(nAlfa-dAlfa);
CurAng  = 0;                    % Counter
%***************************************************************
%************************DRAW TASK******************************
%***************************************************************
subplot(3,1,1);     % make new sub plot window
X = [h*tand(AngStart) h*tand(AngEnd)];              % Calc ends of line
Y = [h h];                                          % Line is normal to 0X
thetaA = linspace(0,2*pi);                          % Hole round
%line(5*cos(thetaA),5*sin(thetaA),'Color','green');	% Draw Center
line([X(1) X(2)],[Y(1) Y(2)],'Color','green');      % Draw Line
grid;
axis equal;
%***************************************************************
%*********************MAIN DATA CALC****************************
%***************************************************************
ang = AngStart;
amp_bang = 0;
amp_Bx   = 0;

for CurAng = 1:1:(nAlfa+1)
  Betta(CurAng) = ang;
  temp(CurAng)  = ang;
  Bang(CurAng)  = ang;
  Bx(CurAng)    = (h+L)/cosd(ang);
  By(CurAng)    = 0;
  
  Ay(CurAng)    = L*sind(ang);
  Ax(CurAng)    = h/cosd(ang)+Ay(CurAng)*tand(ang);
  ang           = ang + dAlfa;
end
%***************************************************************
%********************PLOT RESULT********************************
%***************************************************************
for i = 1:1:nAlfa
    rho(i) = Betta(i) + atand(Ay(i)/Ax(i))+90;
    rhi(i) = sqrt(Ax(i)*Ax(i)+Ay(i)*Ay(i));
    xx(i)  = rhi(i)*cosd(rho(i));
    yy(i)  = rhi(i)*sind(rho(i));
end
line(xx(1:CurAng-1),yy(1:CurAng-1),'color','k');
line([X(1) X(2)],[Y(1) Y(2)],'Color','green');      % Draw Line

subplot(3,1,2);     % make new sub plot window
plot(Bx);
grid;
subplot(3,1,3);     % make new sub plot window
plot(Bang);
grid;
%***************************************************************
%*******************SAVE CUT TO CAM*****************************
%***************************************************************
norm_bx = Bx(1);
norm_ba = Bang(1);
norm_al = Betta(1);

for i = 1:1:(nAlfa+1)
    Betta(i) = Betta(i) - norm_al;
    Bx(i)    = Bx(i)    - norm_bx;
    Bang(i)  = Bang(i)  - norm_ba;
end

%cd([curdir '\OUTPUT']);
%addpath([curdir '\FUNCTION']);    % Include folder with extra functions
WrightCamsToFile(Bx,Bang,Betta,'BxCutLine.txt','AlfaCutLine.txt',(nAlfa-1),DotAcc);
%***************************************************************
%***************************************************************
%***************************************************************
'ready'