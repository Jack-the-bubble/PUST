%PUST Projekt 1
%Zadanie 5
%Doświadczalne dobranie parametrów regulatorów PID i DMC
%Skrypt uruchamia regulatory zaimplementowane w zad4.m i
%zad4DMCKamilMichal.m
% #TODO lepszy dobór parametrów i wyznaczanie wskaźnika jakości regulacji

clear all;

iterNum = 1270;
Umin = 0.9;
Umax = 1.3;
Ypp = 2;
Upp = 1.1;
deltaUmax = 0.05;

yZad = ones(iterNum, 1)*Ypp;
yZad(21:270) = 2.05;
yZad(271:520) = 1.95;
yZad(521:770) = 2.1;
yZad(771:1020) = 1.9;
yZad(1021:1270) = 2.15;
yZad = yZad - Ypp;

PID = fullfile('Zad4.m');
run(PID);

DMC = fullfile('Zad4DMCKamilMichal.m');
run(DMC);