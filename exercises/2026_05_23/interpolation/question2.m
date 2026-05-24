clc; clear; close all;

x = [0, 0.5, 1.0];
f = [1.3, 2.5, 0.9];
xav = 0.8;
n = length(x);
xp = linspace(0, 1, 300);

% Calcula L_i em um vetor
Li = @(i, xv) prod((xv - x([1:i-1, i+1:n])) ./ (x(i) - x([1:i-1, i+1:n])));

% P2(x) por Lagrange
Plag = @(xv) sum(arrayfun(@(i) f(i)*Li(i,xv), 1:n));

fprintf('P2(%.1f) = %.4f\n', xav, Plag(xav));

% Grafico
L0p = arrayfun(@(xv) Li(1,xv), xp);
L1p = arrayfun(@(xv) Li(2,xv), xp);
L2p = arrayfun(@(xv) Li(3,xv), xp);
P2p = arrayfun(@(xv) Plag(xv), xp);

subplot(1,2,1);
plot(xp,L0p,'r', xp,L1p,'g', xp,L2p,'m'); grid on;
legend('L0','L1','L2'); title('Bases de Lagrange'); xlabel('x');

subplot(1,2,2);
plot(xp, P2p, 'b', x, f, 'ko', xav, Plag(xav), 'b^'); grid on;
legend('P2(x)','nos','P2(0.8)'); title('Q2 - Lagrange'); xlabel('x');