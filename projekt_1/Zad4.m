%PUST Projekt 1
%Zadanie 4
%Symulacja cyfrowego algorytmu PID

%nastawy i czas probkowania (TODO: pomy�le� o sekcjonowaniu kodu)
K = 0.7;
Ti = 24;
Td = 3;
T = 0.5;


r0 = K*(1+T/(2*Ti)+Td/T);
r1 = K*(T/(2*Ti)-2*Td/T-1);
r2 = K*Td/T;


u = zeros(iterNum, 1);
e = zeros(iterNum, 1);
y = zeros(iterNum, 1);
U = ones(iterNum, 1)*Upp;
Y = ones(iterNum, 1)*Ypp;

for k = 12 : iterNum
    %SYMULACJA ALGORYTMU
    %pobranie wyjscia obiektu
    Y(k)=symulacja_obiektu3Y(U(k-10), U(k-11), Y(k-1), Y(k-2));

    %przesuniecie wyjscia i wart. zad. o punkt pracy
    y(k) = Y(k)-Ypp; 
%     yZad(k) = yZad(k)-Ypp;
    
    %uchyb
    e(k) = yZad(k) - y(k);

    %sterowanie z przesunieciem o punkt pracy
    u(k) = r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
    U(k) = u(k)+Upp;

    %ograniczenia na przyrosty sterowania
    if U(k) - U(k-1) >= deltaUmax
        U(k) = U(k-1) + deltaUmax;
    elseif U(k) - U(k-1) <= -deltaUmax
         U(k) = U(k-1) - deltaUmax;
    end
    
    %ograniczenia na wartosci sterowania
    if U(k) > Umax
        U(k) = Umax;
    elseif U(k) < Umin
        U(k) = Umin;
    end
    
end

Ypid = Y;
Upid = U;

figure(1)
subplot(2,1,1);
plot(Y);
hold on;
plot(yZad+Ypp);
hold off;
title(['Regulator PID K=',sprintf('%g',K'),' Ti=',sprintf('%g',Ti),' Td=',sprintf('%g',Td)]);
legend('y','y_{zad}')
xlabel('k');
ylabel('y,y_{zad}');
ylim([1.8 2.5]);
xlim([0 1270]);
subplot(2,1,2);
plot(U);
xlim([0 1270]);
legend('u')
xlabel('k');
ylabel('u');


% nazwa1 = sprintf('dane_zad_5/PID/U__PID_K=%g_Ti=%g_Td=%g.txt',K,Ti,Td);
% nazwa2 = sprintf('dane_zad_5/PID/Y__PID_K=%g_Ti=%g_Td=%g.txt',K,Ti,Td);
% nazwa3 = 'dane_zad_5/PID/Yzad.txt';
% 
% file = fopen(nazwa1, 'w');
% A = [(1:iterNum);U'];
% fprintf(file, '%4.3f %.3f \n',A);
% fclose(file);
% 
% file = fopen(nazwa2, 'w');
% B = [(1:iterNum);Y'];
% fprintf(file, '%4.3f %.3f \n',B);
% fclose(file);
% 
% file = fopen(nazwa3, 'w');
% C = [(1:iterNum);(yZad+Ypp)'];
% fprintf(file, '%4.3f %.3f \n',C);
% fclose(file);
