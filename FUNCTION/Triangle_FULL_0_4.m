clear;
clc;
%************************DATA TABLE*****************************
% 900 mm:
% Roll:    A=900;    R=55
% Cut:     A=969.28; R=75
% Add cut: CH=8;     CL=168
%***************************************************************
%**************************INPUT********************************
%***************************************************************
% Calc data:
AlfaAcc   = 0.01;   % delta alfa
DotAcc    = 360;    % Delta dot in output
% Roll data:
SizeRoll  = 830.7;    % Simbol size, mm
RadRoll   = 50;     % Radius of curvature, mm
LRoll     = 336.7;  % Carriage lenhth, mm (last - 338)
% Cut data:
SizeCut   = 972.7;  % Simbol size, mm
RadCut    = 76;     % Radius of curvature, mm
LCut      = 424.4;  % Carriage lenhth, mm
% Add to cut:
CutShape  = 0;      % 0 - original, 1 - mod (add small cut)
CutHeight = 8;      % Step down to metal at coner, mm
CutLength = 170;    % Length of cutdown at coner, mm
%***************************************************************
%*************************INTERNAL******************************
%***************************************************************
% SIMBOL GEOMETRIC DATA:
CutDelta     = 2*CutHeight*tand(60);
SizeSmallCut = SizeCut - CutDelta;
h            = (sqrt(3)/6)*SizeCut;                 % 1/3 of height (from center to side of triangle)
A            = (SizeCut - 4*RadCut*sind(60))/2;     % Real streght side of simbol
% GRID SIZE:
nAlfa        = 360/AlfaAcc;                         % Nome of calc stops
% ADD SMALL CUT:
BxBorder     = 0;
BxBorderDone = 0;
%***************************************************************
%***************************************************************
%***************************************************************



%***************************************************************
%********************MAIN CALCULATION***************************
%***************************************************************
[BangCut,  BxCut,  AlfaCut]  = Triangle(SizeCut,  RadCut,  LCut,  AlfaAcc);
[BangRoll, BxRoll, AlfaRoll] = Triangle(SizeRoll, RadRoll, LRoll, AlfaAcc);
%[BangRoll, BxRoll, AlfaRoll] = Triangle(SizeCut, RadCut, LCut, AlfaAcc);
if CutShape == 1
    [BangSmallCut,  BxSmallCut,  AlfaSmallCut]  = Triangle(SizeSmallCut,RadCut,LCut,AlfaAcc);
    BxSmallCut = BxSmallCut - CutHeight;
end
%***************************************************************
%*********************ADD SMALL CUT*****************************
%***************************************************************
if CutShape == 1
   % RANGE CALCULATION:
   AA         = 120 - 2*(atand(A/(LCut+h)));
   CutRange   = AA + ((360 - 3*AA)/3)/5;
   %CutRange         = 2*(60-atand((SizeCut/2-CutLength-CutDelta)/h));
   CutRangeDistance = (120-CutRange);
   % ADDING:
   for i=1:1:nAlfa
      if and((AlfaCut(i) > (CutRangeDistance/2)),(AlfaCut(i) < (CutRange+CutRangeDistance/2)))
          if BxBorderDone == 0
             BxBorder = BxCut(i);
             BxBorderDone = 1;
          end
          if BxSmallCut(i) < BxBorder
              BxCut(i) = BxBorder;
          else
              BxCut(i) = BxSmallCut(i);
          end
          BangCut(i) = BangSmallCut(i);
      elseif and((AlfaCut(i) > (CutRangeDistance*1.5+CutRange)),(AlfaCut(i) < (CutRangeDistance*1.5+CutRange*2)))
          if BxSmallCut(i) < BxBorder
              BxCut(i) = BxBorder;
          else
              BxCut(i) = BxSmallCut(i);
          end
          BangCut(i) = BangSmallCut(i);
      elseif and((AlfaCut(i) > (CutRangeDistance*2.5+CutRange*2)),(AlfaCut(i) < (CutRangeDistance*2.5+CutRange*3)))
          if BxSmallCut(i) < BxBorder
              BxCut(i) = BxBorder;
          else
              BxCut(i) = BxSmallCut(i);
          end
          BangCut(i) = BangSmallCut(i);
      end
   end
end

%DATA PLOT
subplot(1,1,1);
plot(AlfaCut, BangRoll, AlfaCut, BxRoll);
title(['CAM']);
xlabel('Master angle, grad');
ylabel('Coordindte grad/mm');
grid;
legend('Cut angle, grad','Cut Bx, mm','Roll angle, grad','Roll Bx, mm');


%***************************************************************
%******************WRIGHT DATA TO FILE**************************
%***************************************************************
WrightCamsToFile(BxRoll,BangRoll,AlfaRoll,'CAM_Bx_Roll.txt','CAM_Alfa_Roll.txt',nAlfa,DotAcc);
WrightCamsToFile(BxCut,BangCut,AlfaCut,'CAM_Bx_Cut.txt','CAM_Alfa_Cut.txt',nAlfa,DotAcc);





