%Projekt PUST
%Zadanie 4
%Symulacja algorytmu DMC
clear all
lab1_zad3 = fullfile('Lab1Zad3b.m');

run(lab1_zad3);

%przypisanie odpowiedzi skokowej (znormalizowanej=
st = Ynorm(2:length(Ynorm));

% podstawowe wartosci
Upp = 28;
Ypp = 35.62;
iterNum = 900;
yZad = ones(iterNum, 1)*Ypp;
yZad(20:iterNum) = 44;
yZad(500:end) = 39;
yZad = yZad - Ypp;
Umin = 0-Upp;
Umax = 100-Upp;

%REGULATOR DMC -----------------------------------------------------
%horyzonty
% początkowe nastawy
D= 734;
N = 734;
Nu = 734;
lambda = 1;
% najlepsze nastawy
% D = 733;
% N = 170;
% Nu = 40;
% lambda =2;

%PARAMETRY 
du = 0;
ypast = 0.0; %poprzednia wartosc wyjscia
upast = 0.0; %poprzednia wartosc sterowania
e = 0.0; %uchyb

U = zeros(iterNum,1);
Y = zeros(iterNum,1);
dUpast = zeros(D-1, 1); %wektor przeszlych przyrostow sterowan

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

for k = 3+x(4)+2:iterNum

ypast = Y(k-1);
upast = U(k-1);

% Y(k) = symulacja_obiektu3Y(U(k-10),U(k-11),Y(k-1),Y(k-2));
Y(k) = b1* U(k - x(4) - 1) + b2 * U(k - x(4) - 2) - a1 * Y(k-1) - a2 * Y(k-2);

e = yZad(k) - Y(k);

ue = ke*e;
uu = Ku*dUpast;

du = ue-uu;
U(k) = upast+du;

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

%figure(1)
%plot(U); hold on; plot(Y); hold off;hold on; plot(yZad+Ypp); hold off;
figure(1);
plot(st);
figure(2)   
subplot(2,1,1);
plot(Y+Ypp);
hold on;
plot(yZad+Ypp);
hold off;
title(['Regulator DMC D=',sprintf('%g',D'),' N=',sprintf('%g',N),' Nu=',sprintf('%g',Nu),' lambda=',sprintf('%g',lambda)]);
legend('y','yzad')
subplot(2,1,2);
plot(U+Upp);

wskaznikDMC = sum(((yZad+Ypp) - (Y+Ypp)).^2);
disp('Wskaznik jakosci regulacji dla regulatora DMC: '+ wskaznikDMC);
