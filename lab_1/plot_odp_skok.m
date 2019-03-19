
i=3
iterNum=740;
if(i==1)
    load('step-response40.mat');
    nazwa1 = 'odpowiedz_40.txt';
    nazwa2 = 'U_40.txt';
    a=40;
elseif(i==2)
    load('step-response60.mat');
    nazwa1 = 'odpowiedz_60.txt';
    nazwa2 = 'U_60.txt';
    a=60;
elseif(i==3)
    load('step-response80.mat');
    nazwa1 = 'odpowiedz_80.txt';
    nazwa2 = 'U_80.txt';
    a=80;
    end

file = fopen(nazwa1, 'w');
A = [(1:iterNum);step_response(1:iterNum)];
fprintf(file, '%4.3f %.3f \n',A);
fclose(file);
 
file = fopen(nazwa2, 'w');
B = [(1:iterNum);ones(iterNum,1)'*a];
fprintf(file, '%4.3f %.3f \n',B);
fclose(file);