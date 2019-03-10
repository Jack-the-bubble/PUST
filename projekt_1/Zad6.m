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
x0PID = [1; 30; 5];

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

%funkcja celu (DMC) -> Zad6DMC (na razie)

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

