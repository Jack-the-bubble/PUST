% przed włączeniem symulacji należy uruchomić skrypt

clear all
run('Lab1Zad3b');
load('step-response80.mat');

%parametry
% K=9; %najlepszy współczynnik jakości
% Ti=50;
% Td=0;
 K = 8; %stare
 Ti = 20;
 Td = 0;
%  pierwsze nastawy
 K
 
 K = 41; % najszybsza regulacja
 Ti = 11;
 Td = 11;

 T = 1;


%OBIEKT-------------------------------------------------
y1=step_response';
u1=ones(length(step_response),1)*80;
%dane
 iterNum = 900;
 Ypp = 35.62;
 Upp = 28;
 Umin = 0 - Upp;
 Umax = 100 - Upp;
 
%PID-------------------------------------------------- 
 yZad = ones(iterNum, 1)*Ypp;
yZad(20:iterNum) = 44;
yZad(500:end) = 39;
 yZad = yZad - Ypp;
 
 %wzorki
 r0 = K*(1+T/(2*Ti)+Td/T);
 r1 = K*(T/(2*Ti)-2*Td/T-1);
 r2 = K*Td/T;
 
 %sygnaly
 e = zeros(iterNum, 1);
 U = zeros(iterNum, 1); %zmienic tak, zeby bral od poczatku aktualne wartosci u i y
 Y = zeros(iterNum, 1);
for(k=3+x(4)+2:iterNum)% bylo 11
     %SYMULACJA ALGORYTMU
     %pobranie wyjscia obiektu
%      Y(k)= a*U(k-9) + b*U(k-10) - c*Y(k-1) - d*Y(k-2); %obiekt stary, z
%      pdf-a?
    Y(k) = b1* U(k - x(4) - 1) + b2 * U(k - x(4) - 2) - a1 * Y(k-1) - a2 * Y(k-2);

     %uchyb
     e(k) = yZad(k) - Y(k);
     
     %sterowanie z przesunieciem o punkt pracy
     U(k) = r2*e(k-2)+r1*e(k-1)+r0*e(k)+U(k-1);
     
     %ograniczenia na wartosci sterowania
     if U(k) > Umax
         U(k) = Umax;
     elseif U(k) < Umin
         U(k) = Umin;
     end
     
     
end
figure(2)
     subplot(2,1,1);
     stairs(Y+Ypp);
     hold on;
     plot(yZad+Ypp);
     hold off;
     title(['Regulator PID K=',sprintf('%g',K'),' Ti=',sprintf('%g',Ti),' Td=',sprintf('%g',Td)]);
     legend('y','yzad')
     subplot(2,1,2);
     stairs(U+Upp);
     
% nazwa1 = sprintf('dane_zad_5/PID/U__PID_K=%g_Ti=%g_Td=%g_model.txt',K,Ti,Td);
% nazwa2 = sprintf('dane_zad_5/PID/Y__PID_K=%g_Ti=%g_Td=%g_model.txt',K,Ti,Td);
% nazwa3 = 'dane_zad_5/PID/Yzad_model.txt';
% 
% file = fopen(nazwa1, 'w', 'b');
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

     
 wskaznikPID = sum(((yZad+Ypp) - (Y+Ypp)).^2);
 disp("Wskaznik jakosci regulacji dla regulatora PID: "+ wskaznikPID);
