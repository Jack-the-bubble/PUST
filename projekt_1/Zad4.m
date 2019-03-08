%PUST Projekt 1
%Zadanie 4
%Symulacja cyfrowego algorytmu PID

clear all

Upp = 1.1;
Ypp = 2;
Umin = 0.9;
Umax = 1.3;
deltaUmax = 0.05;
iterNum = 300; %liczba iteracji

%nastawy i czas probkowania (TODO: pomyœleæ o sekcjonowaniu kodu)
Ti = 100;
Td = 0.1;
K = 0.4;
T = 0.5;

%wzorki
r0 = K*(1+T/(2*Ti)+Td/T);
r1 = K*(T/(2*Ti)-2*Td/T-1);
r2 = K*Td/T;

%sygna³y
u = zeros(iterNum, 1);
e = zeros(iterNum, 1);
y = zeros(iterNum, 1);
U = ones(iterNum, 1)*Upp;
Y = ones(iterNum, 1)*Ypp;

%wartoœci zadane
yZad(1:20) = 2;
yZad(21:iterNum) = 2.2; %TODO: jeszcze raz zastanowiæ siê, czy to dobra próbka na skok

for k = 12 : 300
    %SYMULACJA ALGORYTMU
    %pobranie wyjscia obiektu
    Y(k)=symulacja_obiektu3Y(U(k-10), U(k-11), Y(k-1), Y(k-2));

    %przesuniecie wyjscia i wart. zad. o punkt pracy
    y(k) = Y(k)-Ypp; 
    yZad(k) = yZad(k)-Ypp;
    
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

stairs([1:iterNum],Y);
hold on
%stairs([1:iterNum], U); TODO: mo¿e lepiej na osobnym wykresie?
stairs([1:iterNum],yZad+Ypp); %TODO: jak sensownie przedstawiæ wart. zad. na tym wykresie?
