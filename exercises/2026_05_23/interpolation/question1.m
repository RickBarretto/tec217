clc; clear; close all;

x = [0, 0.5, 1.0];
f = [1.0, 2.12, 3.55];
xav = 0.7;

% Diferencas divididas
n = length(x);
DD = zeros(n,n);
DD(:,1) = f(:);
for j = 2:n
  for i = 1:n-j+1
    DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x(i+j-1) - x(i));
  end
end
b = DD(1,:);

fprintf('Coef Newton: b0=%.4f  b1=%.4f  b2=%.4f\n', b(1), b(2), b(3));

% Horner
val = b(n);
for k = n-1:-1:1
  val = val*(xav - x(k)) + b(k);
end
fprintf('P2(%.1f) = %.4f\n', xav, val);
fprintf('Exato   = %.4f\n', exp(xav)+sin(xav));

% Grafico
xp = linspace(0, 1, 300);
Pp = zeros(size(xp));
for i = 1:length(xp)
  v = b(n);
  for k = n-1:-1:1, v = v*(xp(i)-x(k))+b(k); end
  Pp(i) = v;
end

plot(xp, exp(xp)+sin(xp), 'r--', xp, Pp, 'b-', x, f, 'ko', xav, val, 'b^');
legend('f(x)','P2(x)','nos','P2(0.7)'); grid on;
title('Q1 - Newton'); xlabel('x'); ylabel('y');