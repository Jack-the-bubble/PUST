clear all
Upp = 1.1;
Ypp = 2;
Umin = 0.9;
Umax = 1.3;
deltaUMax = 0.05;
iterNum = 300;
yZad = 4;


Ti = 100;
Td = 0.1;
K = 5;
T = 0.5;

r0 = K*(1+T/(2*Ti)+Td/T);
r1 = K*(T/(2*Ti)-2*Td/T-1);
r2 = K*Td/T;




u = zeros(iterNum, 1);
e = zeros(iterNum, 1);
y = zeros(iterNum, 1);
U = ones(iterNum, 1)*Upp;
Y = ones(iterNum, 1)*Ypp;
yZad = ones(iterNum, 1)*2.3;


for k = 12 : 300;
    Y(k)=symulacja_obiektu3Y(U(k-10), U(k-11), Y(k-1), Y(k-2));

y(k) = Y(k)-Ypp;
e(k) = yZad(k) - y(k);
u(k) = r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
U(k) = u(k)+Upp;
end

stairs([1:iterNum], Y);
hold on
% stairs([1:iterNum], yZad);
stairs([1:iterNum], u);