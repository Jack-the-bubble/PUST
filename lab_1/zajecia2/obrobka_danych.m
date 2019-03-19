load('DMC_D=734,N=150,Nu=15,lambda=01.mat');

U=U(1:600);
Y=Y(1:600);
yZad=yZad(1:600);
iter=600;

% figure(2)
%      subplot(2,1,1);
%      stairs(Y);
%      hold on;
%      plot(yZad+Ypp);
%      hold off;
%      title(['Regulator PID K=',sprintf('%g',K'),' Ti=',sprintf('%g',Ti),' Td=',sprintf('%g',Td)]);
%      legend('y','yzad')
%      subplot(2,1,2);
%      stairs(U);
%      
% wskaznikPID = sum(((yZad+Ypp) - Y).^2);
% disp(wskaznikPID)
% 
%  nazwa1 = sprintf('PID/U__PID_K=%g_Ti=%g_Td=%g_real.txt',K,Ti,Td);
%  nazwa2 = sprintf('PID/Y__PID_K=%g_Ti=%g_Td=%g_real.txt',K,Ti,Td);
%  nazwa3 = 'PID/Yzad_real.txt';
%  
%  file = fopen(nazwa1, 'w', 'b');
%  A = [(1:iter);U'];
%  fprintf(file, '%4.3f %.3f \n',A);
%  fclose(file);
%  
% file = fopen(nazwa2, 'w');
% B = [(1:iter);Y'];
% fprintf(file, '%4.3f %.3f \n',B);
% fclose(file);
% 
% file = fopen(nazwa3, 'w');
% C = [(1:iter);(yZad+Ypp)'];
% fprintf(file, '%4.3f %.3f \n',C);
% fclose(file);

wskaznikDMC = sum(((yZad+Ypp) - Y).^2);
disp(wskaznikDMC)

figure(2)
subplot(2,1,1);
stairs(Y);
hold on;
plot(yZad+Ypp);
hold off;
title(['Regulator DMC D=',sprintf('%g',D'),' N=',sprintf('%g',N),' Nu=',sprintf('%g',Nu),' lambda=',sprintf('%g',lambda)]);
legend('y','y_{zad}')
xlabel('k');
ylabel('y,y_{zad}');
subplot(2,1,2);
stairs(U);

% nazwa1 = sprintf('DMC/U__DMC_D=%g_N=%g_Nu=%g_L=%g_real.txt',D,N,Nu,lambda);
% nazwa2 = sprintf('DMC/Y__DMC_D=%g_N=%g_Nu=%g_L=%g_real.txt',D,N,Nu,lambda);
% nazwa3 = 'DMC/Yzad_real.txt';
% 
% file = fopen(nazwa1, 'w');
% A = [(1:iter);U'];
% fprintf(file, '%4.3f %.3f \n',A);
% fclose(file);
% 
% file = fopen(nazwa2, 'w');
% B = [(1:iter);Y'];
% fprintf(file, '%4.3f %.3f \n',B);
% fclose(file);
% 
% file = fopen(nazwa3, 'w');
% C = [(1:iter);(yZad+Ypp)'];
% fprintf(file, '%4.3f %.3f \n',C);
% fclose(file);
