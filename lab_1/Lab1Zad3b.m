%PUST Lab1
%Zad3b
%Wyznaczenie modelu odpowiedzi skokowej

%load('step_responseXX');

Ypp = 35.62;
%wartosc_skoku_U = zalezy;


Ynorm = (step_response - Ypp)./wartosc_skoku_U;

Td = 0; %opoznienie
iterNum = 1; %length(step_response)
%uzad = 1; %zadane sterowanie

u = ones(iterNum,1);
y = zeros(iterNum,1);



%param = [T1 T2 K Td]

function y = model(param)

    alpha1 = exp(-1/param(1));
    alpha2 = exp (-1/param(2));
    a1 = - alpha1 - alpha2;
    a2 = alpha1 * alpha2;
    b1 = param(3) / (param(1)-param(2)) * (param(1) * (1-alpha1) - param(2)*(1-alpha2));
    b2 = param(3) / (param(1)-param(2)) * (alpha1*param(2) * (1-alpha2) - alpha2*param(1) * (1-alpha1));
    
    for k = 3:iterNum
        y(k) = b1 * u(k - param(4) - 1) + b2 * u(k - param(4) - 2) - a1 * y(k-1) - a2 * y(k-2);
    end
end

%dorobic optymalizacje i przedstawienie na wykresie