%PUST Projekt 1
%Zadanie 2
%Uruchomienie z argumentem 0 do wykresu odpowiedzi skokowych,
%z argumentem 1 do wyznaczenia charakterystyki statycznej

function[] = Zad2(arg)

    %do wykresu odpowiedzi skokowych 10 iteracji i skok Ukon o 0.03
    %do char stat 100 iteracji i skok Ukon o 0.003
    if arg == 0
        iter = 10;
        Uskok = 0.03;
    elseif arg == 1
        iter = 100;
        Uskok = 0.003;
    elseif arg == 2
        iter = 100;
        Uskok = 0.003;
        rozp = -1;
    else
        disp('Zly argument!');
        return
    end

    U(1:10) = 1.1;
    Ukon = 0.95;
    if arg == 2
        Ukon = 1.1;
    end
    kwyk = 1:1:200;
    Y(1:200) = 2;
   
    for i = 1:iter

        U(11:200) = Ukon;

        for k = 12:1:200
           Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
        end

        Ustat(i) = Ukon;
        Ystat(i) = Y(200);

        subplot(2,1,1)
        xlabel('k');
        ylabel('Y')
        stairs(kwyk,Y)
        hold on

        subplot(2,1,2)
        xlabel('k');
        ylabel('U')
        stairs(kwyk,U)
        hold on

        Ukon = Ukon + i*Uskok*(rozp^i);

    end
    hold off
    if arg == 0
        matlab2tikz('wykresy_dane/odp_skokowa_10.tex', 'showInfo', false);
    elseif arg == 1
        matlab2tikz('wykresy_dane/odp_skokowa_100.tex', 'showInfo', false);
    elseif arg == 2
        matlab2tikz('wykresy_dane/odp_skokowa_rozchodzaca.tex', 'showInfo', false);
    end
    
    if arg == 1 || arg == 2
        figure
        plot (Ustat, Ystat) %TODO: czy nie powinni�my zrobi� tego jako zbi�r punkt�w zamiast ci�g�ej funkcji?
        xlabel('U statyczne');
        ylabel('Y statyczne');
        matlab2tikz('wykresy_dane/char_statyczna.tex', 'showInfo', false);
    end
end

