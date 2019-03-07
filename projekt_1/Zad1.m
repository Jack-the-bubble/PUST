clear Y;
clear U;

Y(1:151) = 2;
U(1:151) = 1.1;

for k = 12:1:151
    Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
    
end

%punkt pracy z zadania 1 poprawny