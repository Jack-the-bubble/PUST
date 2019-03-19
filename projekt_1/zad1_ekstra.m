%PUST Projekt 1
%Zadanie 1

clear Y;
clear U;

Y(1:151) = 4;
U(1:151) = 1.1;

for k = 12:1:151
    Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
end
U1
%punkt pracy z zadania 1 poprawny, poniewa� warto�ci Y po uruchomieniu
%skryptu pozosta�y 2
figure(1)
hold on
stairs(Y)
hold off
hold on
stairs(U)
hold off

Y(1:151) = 3;

for k = 12:1:151
    Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
end

hold on
stairs(Y)
hold off
hold on
stairs(U)
hold off

Y(1:151) = 2;

for k = 12:1:151
    Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
end

hold on
stairs(Y)
hold off
hold on
stairs(U)
hold off
nazwa1 = 'od_4.txt';
nazwa2 = 'od_3.txt';
nazwa3 = 'od_2.txt';
nazwa4 = 'U.txt';
 
file = fopen(nazwa1, 'w');
A = [(1:iterNum);U'];
fprintf(file, '%4.3f %.3f \n',A);
fclose(file);
