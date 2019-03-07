U(1:10) = 1.1;
Ukon = 0.95;
kwyk = 1:1:200;
%Ynorm(1:200) = 2;

%do wykresu odpowiedzi skokowych 10 iteracji i skok Ukon o 0.03
%do char stat 100 iteracji i skok Ukon o 0.003
for i = 1:10
    
    U(11:200) = Ukon;
    
    for k = 12:1:200
       Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    end
    
    subplot(2,1,1)
    stairs(kwyk,Y)
    hold on
    
    subplot(2,1,2)
    plot(kwyk,U)
    hold on

    Ukon = Ukon + 0.03;

end
hold off

Ynorm = (Y - 2)./0.15;

figure
stairs(kwyk, Ynorm);

