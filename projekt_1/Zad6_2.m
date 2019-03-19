%PUST Projekt 1
%Zadanie 6

%% PID

%ograniczenia nastaw PID
Kmin = 0.1;
Kmax = 10;

Timin = 0.1;
Timax = 1000000;

Tdmin = 0;
Tdmax = 10000;

%funkcja celu (PID) -> Zad6PID (na razie)

%ograniczenia nierownosciowe
APID = [1 0 0; 0 1 0; 0 0 1; -1 0 0; 0 -1 0; 0 0 -1];
bPID = [Kmax; Timax; Tdmax; -Kmin; -Timin; -Tdmin];

%punkt startowy
x0PID = [1; 30; 5]; %2.5292 0.7016  20.8278 4.4081
%x0PID = [0.1; 1000000; 0]; %2.8232  0.8005  1000000, 3.0921

%x0PID = [0.1; 100; 1]; %2.5292 0.7016 20.8277 4.4081
%x0PID = [5; 1; 100]; %20.2945  4.7685 23.0429 100.2445
%x0PID = [2; 10; 10]; %13.4630   2.0247  9.6034  9.7047

%dodatkowe opcje
optionsPID = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'iter');

%x = [x(1) x(2) x(3)] = [K Ti Td]
xPID = fmincon(@Zad6PID, x0PID, APID, bPID, [], [], [], [], [], optionsPID);

%% DMC

%ograniczenia parametrów DMC
%Nmax = D;
Nmax = 182;
Nmin = 1;

%Numax = D;
Numin = 1;

lambdamax = 1000;
lambdamin = 0.1;

%funkcja celu (DMC) -> Zad6DMC (ponizej)

%ograniczenia nierownosciowe
ADMC = [1 0 0; -1 1 0; 0 0 1; -1 0 0; 0 -1 0; 0 0 -1];
bDMC = [Nmax; 0; lambdamax; -Nmin; -Numin; -lambdamin];

%punkt startowy
x0DMC = [60; 30; 5];

%dodatkowe opcje
optionsDMC = optimoptions(@ga, 'Display', 'iter', 'MaxGenerations', 100);

%N i Nu ca³kowite:
IntCon = [1 2];

%x = [x(1) x(2) x(3)] = [N Nu lambda]
%xDMC = fmincon(@Zad6DMC, x0DMC, ADMC, bDMC);
xDMC = ga(@Zad6DMC, 3, ADMC, bDMC, [], [], [], [], [], IntCon, optionsDMC);

%%

function error = Zad6PID(x)
    clear e u y U Y
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

    %obliczanie wskaznika jakosci
    error = sum(((yZad+Ypp) - Ypid).^2);
    disp("Wskaznik jakosci regulacji dla regulatora PID: "+ error);
end

function error = Zad6DMC(x)
    clear e u y U Y

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
    
    %pobranie odpowiedzi skokowej z zadania 3
    zad3skrypt = fullfile('Zad3.m');
    run(zad3skrypt);


    %REGULATOR DMC -----------------------------------------------------
    %horyzonty
    D = 182;
    %N = 35;
    %Nu = 2;
    %lambda = 21;
    
    N = x(1);
    Nu = x(2);
    lambda = x(3);

    %PARAMETRY 
    y = zeros(iterNum,1);
    u = zeros(iterNum,1);
    du = 0;

    ypast = 0.0; %poprzednia wartosc wyjscia
    upast = 0.0; %poprzednia wartosc sterowania
    e = 0.0; %uchyb

    U = ones(iterNum,1)*Upp;
    Y = ones(iterNum,1)*Ypp;
    dUpast = zeros(D-1, 1); %wektor przeszlych przyrostow sterowan

    %przypisanie odpowiedzi skokowej (znormalizowanej)
    st = Ynorm((chwila_skoku_U+1):300);

    % Macierz M
    M=zeros(N,Nu);
    for i=1:N
       for j=1:Nu
          if (i>=j)
             M(i,j)=st(i-j+1);
          end
       end
    end

    % Macierz Mp
    Mp=zeros(N,D-1);
    for i=1:N
       for j=1:D-1
          if (i+j)<=D-1
             Mp(i,j)=st(i+j)-st(j);
          else
             Mp(i,j)=st(D)-st(j);
          end      
       end
    end

    % Obliczanie parametrÃ³w regulatora
    I=eye(Nu);
    K=((M'*M+lambda*I)^(-1))*M';
    Ku=K(1,:)*Mp;
    ke=sum(K(1,:));

    % -------------- DO REGULACJI ---------------

    for k = 12 : iterNum

        ypast = y(k-1);
        upast = u(k-1);

        Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
        y(k) = Y(k) - Ypp;

        e = yZad(k) - y(k);

        ue = ke*e;
        uu = Ku*dUpast;

        du = ue-uu;
        u(k) = upast+du;

        U(k) = u(k) + Upp;

        %ograniczenia na przyrosty sterowania
        if du >= deltaUmax
           U(k) = U(k-1) + deltaUmax;
           du = deltaUmax;
        elseif du <= -deltaUmax
           U(k) = U(k-1) - deltaUmax;
           du = -deltaUmax;
        end

        %ograniczenia na wartosci sterowania
        if U(k) <  Umin 
             U(k) = Umin;
             du = Umin - U(k-1);

        elseif U(k) > Umax 
             U(k) = Umax;
             du = Umax - U(k-1);

        end
        
        dUpast = [du; dUpast(1:end-1)];       
    end
    
    Ydmc = Y;
    Udmc = U;
    
    %obliczanie wskaznika jakosci
    error = sum(((yZad+Ypp) - Ydmc).^2);
    disp("Wskaznik jakosci regulacji dla regulatora DMC: "+ error);
end