%PUST Projekt 1
%Zadanie 6
%Funkcja obliczaj¹ca b³¹d PID

function error = Zad6PID(x)
    %nastawy i czas probkowania (TODO: pomyï¿½leï¿½ o sekcjonowaniu kodu)
    %Ti = 24;
    %Td = 3;
    %K = 0.7;
    
    %nastawy
    K = x(1);
    Ti = x(2);
    Td = x(3);
    T = 0.5;
    
    %dane
    iterNum = 1270;
    Umin = 0.9;
    Umax = 1.3;
    Ypp = 2;
    Upp = 1.1;
    deltaUmax = 0.05;

    yZad = ones(iterNum, 1)*Ypp;
    yZad(21:270) = 2.05;
    yZad(271:520) = 1.95;
    yZad(521:770) = 2.1;
    yZad(771:1020) = 1.9;
    yZad(1021:1270) = 2.15;
    yZad = yZad - Ypp;

    %wzorki
    r0 = K*(1+T/(2*Ti)+Td/T);
    r1 = K*(T/(2*Ti)-2*Td/T-1);
    r2 = K*Td/T;

    %sygnaï¿½y
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

    error = sum(((yZad+Ypp) - Ypid).^2);
    disp("Wskaznik jakosci regulacji dla regulatora PID: "+ error);
end
    
% figure(1)
% subplot(2,1,1);
% plot(Y);
% hold on;
% plot(yZad+Ypp);
% hold off;
% title(['Regulator PID K=',sprintf('%g',K'),' Ti=',sprintf('%g',Ti),' Td=',sprintf('%g',Td)]);
% legend('y','yzad')
% subplot(2,1,2);
% plot(U);
