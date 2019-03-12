%PUST Lab1
%Zad3b
%Wyznaczenie modelu odpowiedzi skokowej

%load('step_responseXX');
%load('step_response40.mat');


% 
% %ograniczenia nierownosciowe
% A = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; -1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 -1];
% b = [100; 100; 100; 100; 0.1; 0.1; 0.1; 0.1];
% 
% %punkt startowy
% x0 = [1; 30; 5; 2];
% 
% %dodatkowe opcje
% options = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'iter');
% 
% %param = [T1 T2 K Td]
% x = fmincon(@model, x0, A, b, [], [], [], [], [], options);


%ograniczenia nierownosciowe
A = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; -1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 -1];
b = [100; 100; 100; 100; 0.1; 0.1; 0.1; 1];

%punkt startowy
x0 = [1; 6; 5; 1];

%dodatkowe opcje
options = optimoptions(@ga, 'Display', 'iter', 'MaxGenerations', 100);

%Td ca�kowite:
IntCon = 4;

%param = [T1 T2 K Td]
x = ga(@model, 4, A, b, [], [], [], [], [], IntCon, options);


function error = model(param)

    load('step-response40.mat');

    Ypp = 35.62;
    %wartosc_skoku_U = zalezy;
    wartosc_skoku_U = 12; %40 - 28

    Ynorm = (step_response - Ypp)./wartosc_skoku_U;

    Td = param(4); %opoznienie
    iterNum = length(step_response); %length(step_response)
    %uzad = 1; %zadane sterowanie

    u = ones(1, iterNum);
    y = zeros(1,iterNum);

    alpha1 = exp(-1/param(1));
    alpha2 = exp (-1/param(2));
    a1 = - alpha1 - alpha2;
    a2 = alpha1 * alpha2;
    b1 = param(3) / (param(1)-param(2)) * (param(1) * (1-alpha1) - param(2)*(1-alpha2));
    b2 = param(3) / (param(1)-param(2)) * (alpha1*param(2) * (1-alpha2) - alpha2*param(1) * (1-alpha1));
    
    for k = 3+Td:iterNum
        %y(k) = b1 * u(k - param(4) - 1) + b2 * u(k - param(4) - 2) - a1 * y(k-1) - a2 * y(k-2);
        y(k) = b1 * u(k - Td - 1) + b2 * u(k - Td - 2) - a1 * y(k-1) - a2 * y(k-2);

    end
    
    error = sum((Ynorm - y).^2);
    disp("Wskaznik dopasowania: "+ error);
end

%dorobic optymalizacje i przedstawienie na wykresie