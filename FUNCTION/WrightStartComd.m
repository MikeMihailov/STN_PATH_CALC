function WrightStartComd(Bx,Bang,Alfa,size,FileName)
    ToFile = [Bx(1);(Bang(1)*10/36);(Alfa(1)/36)];
    fid_st   = fopen(FileName,'w');
    fprintf(fid_st,  '***********Start***********\n');
    fprintf(fid_st,  '    Bx     Bang    Alfa    \n');
    fprintf(fid_st,  '%2.4f; %2.4f; %3.4f\n ',ToFile);
    fclose(fid_st);
end