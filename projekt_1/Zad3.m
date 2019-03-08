%PUST Projekt 1
%Zadanie 3
%Przekszta�cenie odpowiedzi skokowej pod DMC
%Wzi�to ostatni� wyznaczon� odpowied� skokow� (Ukon = 1.25)
%TODO: po co w sumie generowa� wszystkie wcze�niejsze odpowiedzi skokowe?

iterNum = 300;

U(1:10) = 1.1;
Ukon = 1.22;
kwyk = 1:1:iterNum;
Y(1:iterNum) = 2;
%Ynorm(1:200) = 2;

%for i = 1:10
    
    U(11:iterNum) = Ukon;
    
    for k = 12:1:iterNum
       Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    end
    
%     subplot(2,1,1)
%     stairs(kwyk,Y)
%     hold on
%     
%     subplot(2,1,2)
%     plot(kwyk,U)
%     hold on

%     Ukon = Ukon + 0.03;

%end
%hold off

%normalizacja odpowiedzi skokowej
Ynorm = (Y - 2)./0.12;

% figure
% stairs(kwyk, Ynorm);

