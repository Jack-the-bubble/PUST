%Projekt PUST
%Zadanie 4
%Symulacja algorytmu DMC
clear all
zad3skrypt = fullfile('Lab1Zad3b.m');

run(zad3skrypt);

clear U Y

% podstawowe wartosci
Upp = 28;
iterNum = 900;
yZad = ones(iterNum, 1)*Ypp;
% yZad(1:600) = 35; %potem zmienic na 50
yZad(1:iterNum) = 45;
yZad = yZad - Ypp;
Umin = 0;
Umax = 100;
chwila_skoku_U = 9;

%REGULATOR DMC -----------------------------------------------------
%horyzonty
D = 600;
N = 600;
Nu = 600;
lambda = 21;

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


%przypisanie odpowiedzi skokowej (znormalizowanej=
st = Ynorm((chwila_skoku_U+1):900);
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

% -------------- DO REGULACJI ---------------

for k = 10 : iterNum


    
ypast = y(k-1);
upast = u(k-1);

% Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
Y(k) = b1* U(k - x(4) - 1) + b2 * U(k - x(4) - 2) - a1 * Y(k-1) - a2 * Y(k-2);
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


    
    %dUpast = [u(k-1)-u(k-2) u(k-2)-u(k-3) .... dU(k-D+1)]

    %dUpast = circshift(dUpast, 1);
    %dUpast(1) = du;
    dUpast = [du; dUpast(1:end-1)];       
end


Ydmc = Y;
Udmc = U;
%figure(1)
%plot(U); hold on; plot(Y); hold off;hold on; plot(yZad+Ypp); hold off;    
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