iterNum=740;
x0=28;
y0=35.62;
    load('step-response40.mat');
    nazwa1 = 'odpowiedz_40.txt';
    nazwa2 = 'U_40.txt';
    x1=40
    y1=step_response(iterNum);
    
    load('step-response60.mat');
    nazwa1 = 'odpowiedz_60.txt';
    nazwa2 = 'U_60.txt';
    x2=60;
    y2=step_response(iterNum);
    
    load('step-response80.mat');
    nazwa1 = 'odpowiedz_80.txt';
    nazwa2 = 'U_80.txt';
    x3=80;
    y3=step_response(iterNum);
x=[x0 x1 x2 x3];
y=[y0 y1 y2 y3];

file = fopen('x_stat', 'w');
A = [(1:4);x];
fprintf(file, '%4.3f %.3f \n',A);
fclose(file);
 
file = fopen('y_stat', 'w');
B = [(1:4);y];
fprintf(file, '%4.3f %.3f \n',B);
fclose(file);