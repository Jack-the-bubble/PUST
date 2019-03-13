% clear all
load('step-response80.mat');

%parametry
 K = 8; %stare
 Ti = 20;
 Td = 0;
%  K = 41; % najszybsza regulacja
%  Ti = 11;
%  Td = 11;

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
% % normalizacja  
% G_y = (y1 - Ypp)/52;
% G_u = (u1 - Upp)/52;
% % estymacja transmitancji
% Grzalka = iddata(G_y, G_u, 1); % Zamiana I/O na obiekt na jakistam obiekt
% Gtrans = tfest(Grzalka, 2,0)   % Estymowanie transmitancji
% s = tf('s');
% Gtrans = Gtrans*exp(-8*s);%prawdziwe opóźnienie
% G_d = c2d(Gtrans,1,'zoh')
% 
% 
% 
% figure (1);plot(G_y);hold on;step(Gtrans);hold off;hold on; step(G_d);hold off;
% 
%  a = G_d.Numerator{1}(2);
%  b=G_d.Numerator{1}(3);
%  c=G_d.Denominator{1}(2);
%  d=G_d.Denominator{1}(3);

% % stara transmitancja

% %nowa transmitancja
% wykonac skrypt Lab1Zad3b
 
 
 
%PID-------------------------------------------------- 
 yZad = ones(iterNum, 1)*Ypp;
 yZad(1:600) = 45; %potem zmienic na 50
 yZad(601:1200) = 45;
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
