%Projekt PUST
%Zadanie 4
%Symulacja algorytmu DMC

zad3skrypt = fullfile('Zad3.m');

run(zad3skrypt);


%REGULATOR DMC -----------------------------------------------------
%horyzonty
N = 289;
Nu = 289;
D = 289;
lambda = 1;

%przypisanie odpowiedzi skokowej (znormalizowanej=
st = Ynorm(12:300);
%pobrac z Zad3

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
% Obliczanie parametrów regulatora
I=eye(Nu);
K=((M'*M+lambda*I)^(-1))*M';
Ku=K(1,:)*Mp;
ke=sum(K(1,:));
    
% time=3000;



% -------------- DO REGULACJI ---------------
% stabil_time =1000;
% y_zad1 = -500;
% y_zad2 = 500;
iterNum = 1000;
Umin = 0.9;
Umax = 1.3;
Ypp = 2;
Upp = 1.1;

y = zeros(iterNum,1);
u = zeros(iterNum,1);
du = 0;
deltaUmax = 0.05;

yZad = ones(iterNum, 1)*Ypp; %najpierw -500, po 1s 500
yZad(21:iterNum) = 2.2;
ypast = 0.0; %poprzednia wartosc wyjscia
upast = 0.0; %poprzednia wartosc sterowania
e = 0.0; %uchyb

U = ones(iterNum,1)*Upp;
Y = ones(iterNum,1)*Ypp;
dUpast = zeros(D-1, 1); %wektor przeszlych przyrostow sterowan

% while licznik<time		
% 		
% if licznik < stabil_time
% 	yzad = y_zad1;
% else
% 	yzad = y_zad2;
% end

yZad = yZad - Ypp;

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

if U(k) <  Umin 
     U(k) = Umin;

elseif U(k) > Umax 
     U(k) = Umax;

end

    %ograniczenia na przyrosty sterowania
    if du >= deltaUmax
       U(k) = U(k-1) + deltaUmax;
       du = deltaUmax;
    elseif du <= -deltaUmax
       U(k) = U(k-1) - deltaUmax;
       du = -deltaUmax;
    end
    
    %dUpast = [u(k-1)-u(k-2) u(k-2)-u(k-3) .... dU(k-D+1)]

    %dUpast = circshift(dUpast, 1);
    %dUpast(1) = du;
    dUpast = [du; dUpast(1:end-1)];       
end

    figure(1)
    plot(U); hold on; plot(Y); hold off;hold on; plot(yZad+Ypp); hold off;    
figure(2)   
subplot(2,1,1);
plot(Y);
hold on;
plot(yZad+Ypp);
hold off;
title(['Regulator DMC D=',sprintf('%g',D'),' N=',sprintf('%g',N),' Nu=',sprintf('%g',Nu),' lambda=',sprintf('%g',lambda)]);
legend('y','yzad')
subplot(2,1,2);
plot(U);

%-----DO ZAPISYWANIA DO PLIKU-----------
%-----GENEROWANIE Ku--------------------
%  file = fopen('Ku.txt', 'w');
%  fprintf(file, '%.6f, \n', Ku');
%  fclose(file);