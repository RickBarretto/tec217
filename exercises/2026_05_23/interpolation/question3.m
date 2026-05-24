clc; clear; close all;

x1 = [0, 0.5, 1.0]; f1 = [1.0, 2.12, 3.55];
x2 = [0, 0.5, 1.0]; f2 = [1.3, 2.5,  0.9];

vand = @(x) [1 x(1) x(1)^2; 1 x(2) x(2)^2; 1 x(3) x(3)^2];

a1 = vand(x1) \ f1(:);
a2 = vand(x2) \ f2(:);

fprintf('Q1 coef: a0=%.4f  a1=%.4f  a2=%.4f\n', a1(1), a1(2), a1(3));
fprintf('Q1 P2(0.7) = %.4f\n', a1(1)+a1(2)*0.7+a1(3)*0.7^2);

fprintf('Q2 coef: a0=%.4f  a1=%.4f  a2=%.4f\n', a2(1), a2(2), a2(3));
fprintf('Q2 P2(0.8) = %.4f\n', a2(1)+a2(2)*0.8+a2(3)*0.8^2);

xp = linspace(0,1,300);
P1 = a1(1) + a1(2)*xp + a1(3)*xp.^2;
P2 = a2(1) + a2(2)*xp + a2(3)*xp.^2;

subplot(1,2,1);
plot(xp, exp(xp)+sin(xp),'r--', xp,P1,'b', x1,f1,'ko'); grid on;
legend('f(x)','Vand Q1','nos'); title('Q3 - Vandermonde Q1');

subplot(1,2,2);
plot(xp,P2,'b', x2,f2,'ko'); grid on;
legend('Vand Q2','nos'); title('Q3 - Vandermonde Q2');