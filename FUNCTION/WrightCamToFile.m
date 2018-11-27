%***************************************************************
% Input:
%   Bx       - Array of carriet move, mm
%   Bang     - Array of carriet angles, rad
%   Alfa     - Array of table angels, rad
%   BxName   - Name of CAM-file for Bx, str
%   BangName - Name of CAM-file for bang, str
%   nAlfa    - Input arrays size
%   dDot     - Output arrays size
%***************************************************************
function WrightCamToFile(ToCAM,Alfa,CAMName,nAlfa,dDot)
    % OUTPUT TO FILE:
    nDot     = ceil(nAlfa/dDot);	% Numer of dots in output
    CAMOut   = 1:1:nDot;            % u
    TableOut = 1:1:nDot;            % Angel of table in u
    % CONVERT TO UNIT:
    for i = 1:1:(nDot)
        CAMOut(i)   = ToCAM(i*dDot)/36;
        TableOut(i) = Alfa(i*dDot)/36;
    end
    % ENDS:
    TableOut(1) = Alfa(1)/36;
    if((Alfa(nAlfa)/36)>9.9 && (Alfa(nAlfa)/36)<10)
        TableOut(nDot) = 10;
    else
        TableOut(nDot) = Alfa(nAlfa)/36;
    end
    CAMOut(1)    = ToCAM(1);
    CAMOut(nDot) = ToCAM(nAlfa)/36;
    % WRIGHT:
    ToFileCAM    = [TableOut;CAMOut];
    fid_CAM      = fopen(CAMName,'w');
    fprintf(fid_CAM,'%2.4f; %3.4f\n',ToFileCAM);
    fclose(fid_CAM);
end
%***************************************************************