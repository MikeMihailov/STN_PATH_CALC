function LoadBar(max,cur)
    bar = string(max+2);
    bar(1)='[';
    for i=1:1:max
        if(i<=cur)
            bar(i+1)='+';
        else
            bar(i+1)=' ';
        end
    end
    bar(i+2)=']';
    clc;
    bar
end