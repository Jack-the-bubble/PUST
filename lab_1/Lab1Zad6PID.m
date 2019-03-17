%PUST Projekt 1 Lab1
%Zadanie 6
%Funkcja obliczaj�ca b��d PID

addpath('F:\SerialCommunication'); % add a path to the functions
initSerialControl COM5 % initialise com port

    %nastawy i czas probkowania (TODO: pomyslec o sekcjonowaniu kodu)
    %Ti = 24;
    %Td = 3;
    %K = 0.7;
    
    %nastawy
%     K = x(1);
%     Ti = x(2);
%     Td = x(3);

    K = 8;
    Ti = 20;
    Td = 0;
    T = 1;
    
    %dane
    iterNum = 1200;
    Umin = 0;
    Umax = 100;
    Ypp = 35.62;
    Upp = 28;
    %deltaUmax = 0.05;

    yZad = ones(iterNum, 1)*Ypp;
    yZad(1:600) = 35; %potem zmienic na 50
    yZad(601:1200) = 45;
    yZad = yZad - Ypp;

    %wzorki
    r0 = K*(1+T/(2*Ti)+Td/T);
    r1 = K*(T/(2*Ti)-2*Td/T-1);
    r2 = K*Td/T;

    %sygnaly
    u = zeros(iterNum, 1);
    e = zeros(iterNum, 1);
    U = ones(iterNum, 1)*Upp; %zmienic tak, zeby bral od poczatku aktualne wartosci u i y
    Y = ones(iterNum, 1)*Ypp;
    
    k = 3;

    while(1)
        %SYMULACJA ALGORYTMU
        %pobranie wyjscia obiektu
        measurements = readMeasurements(1:7);
        Y(k)= measurements(1);

        %przesuniecie wyjscia i wart. zad. o punkt pracy
        y = Y(k)-Ypp; 
    %     yZad(k) = yZad(k)-Ypp;

        %uchyb
        e(k) = yZad(k) - y;

        %sterowanie z przesunieciem o punkt pracy
        u(k) = r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
        U(k) = u(k)+Upp;

        %ograniczenia na przyrosty sterowania
%         if U(k) - U(k-1) >= deltaUmax
%             U(k) = U(k-1) + deltaUmax;
%         elseif U(k) - U(k-1) <= -deltaUmax
%                 U(k) = U(k-1) - deltaUmax;
%         end

        %ograniczenia na wartosci sterowania
        if U(k) > Umax
            U(k) = Umax;
        elseif U(k) < Umin
            U(k) = Umin;
        end
        
        sendControls([ 1, 2, 3, 4, 5, 6], ... send for these elements
                     [50 , 0, 0, 0, U(k), 0]);  % new corresponding control values
        
        %wykresy
        figure(1)
        subplot(2,1,1);
        plot(Y(1:k));
        hold on;
        plot(yZad(1:k)+Ypp);
        hold off;
        title(['Regulator PID K=',sprintf('%g',K'),' Ti=',sprintf('%g',Ti),' Td=',sprintf('%g',Td)]);
        legend('y','yzad')
        subplot(2,1,2);
        stairs(U(1:k));
        drawnow;
        
        disp('U: ' + U(k) +' Y: '+ Y(k) +' Yzad: '+ yZad(k)+Ypp);
    
        k = k+1;
        waitForNewIteration();
        
    
    end