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
function WrightCamsToFile(Bx,Bang,Alfa,BxName,BangName,nAlfa,dDot)
    % OUTPUT TO FILE:
    nDot     = ceil(nAlfa/dDot);	% Numer of dots in output
    %nDot = nAlfa;
    BangOut  = 1:1:nDot;            % Angel of car in u
    BxOut    = 1:1:nDot;            % Position of car in u
    TableOut = 1:1:nDot;            % Angel of table in u
    % WRIGHT:
    for i = 1:1:(nDot)
        BxOut(i) = -Bx(i*dDot);
        BangOut(i) = (Bang(i*dDot)*10/36);
        TableOut(i) = Alfa(i*dDot)/36;
        %BxOut(i) = -Bx(i);
        %BangOut(i) = (Bang(i)*10/36);
        %TableOut(i) = Alfa(i)/36;
    end
    TableOut(1) = Alfa(1)/36;
    if((Alfa(nAlfa)/36)>9.9 && (Alfa(nAlfa)/36)<10)
        TableOut(nDot) = 10;
    else
        TableOut(nDot) = Alfa(nAlfa)/36;
    end
    BxOut(1) = -Bx(1);
    BxOut(nDot) = -Bx(nAlfa);
    BangOut(1) = Bang(1)*10/36;
    BangOut(nDot) = Bang(nAlfa)*10/36;
    
    ToFileBx   = [TableOut;BxOut];
    ToFileAlfa = [TableOut;BangOut];

    fid_bx   = fopen(BxName,'w');
    fid_alfa = fopen(BangName,'w');
    fprintf(fid_bx,  '%2.4f; %3.4f\n',ToFileBx);
    fprintf(fid_alfa,'%2.4f; %3.4f\n',ToFileAlfa);
    fclose(fid_bx);
    fclose(fid_alfa);
end
%***************************************************************