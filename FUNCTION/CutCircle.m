%**************************************************************************
%**************************************************************************
%**************************************************************************
%                               CutCircle
%  This function calc position of points A and B in polar coordinate.
% Input:
%   ang  - the angel of table turning, grad
%   a    - shift of circle center, mm
%   r    - circle radius, mm
%   L    - from center of carriet to end of scissors, mm
%   out  - 1 - outline or 0 - inline circle
%   alf  - angle betwen shhift line and zero line of table
%   opi  - 1 - Co in 0-pi, 0 - Co in pi-3pi
% Output:
%   Bang - angel of carriet turning
%   Ax   - OX position of dot A
%   Ay   - OY position of dot A
%   Bx   - OX position of dot B
%   By   - OY position of dot B
%**************************************************************************
function [Bang,Ax,Ay,Bx,By] = CutCircle(ang,a,r,L,out,alf,opi,d,BangInvert)
    if(ang>180)
        alfa = ang-90;
    else
        alfa = ang;
    end
        
    if (opi == 0)
        Cy = a*sind(alfa-alf);
        Cx = a*cosd(alfa-alf);  
    elseif(opi == 1)
        Cy = a*cosd(alfa-alf);
        Cx = a*sind(alfa-alf);
    end
    
    if (d==1)
        Cx = Cx*(-1);
    end
   
    if (out == 0)
        Cr = L-r;
    elseif(out == 1)
        Cr = L+r; 
        if(Cy<0)
            Cy=Cy*(-1);
        end
    end
    Bang = atand(Cy/sqrt(Cr*Cr-Cy*Cy));
    if (Cx>L)
        Bx   = Cx-sqrt(Cr*Cr-Cy*Cy);
    else
        Bx   = Cx+sqrt(Cr*Cr-Cy*Cy);
    end
    By   = 0;
    Ax   = Bx-L*cosd(Bang);
    Ay   = L*sind(Bang);    
    if (BangInvert == 1)
        Bang = (-1)*Bang;
        Ay = (-1)*Ay;
    end;
end
%**************************************************************************
%**************************************************************************
%**************************************************************************