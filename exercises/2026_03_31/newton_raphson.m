% Método de Newton-Raphson

f  = @(x) x^2 - 3*x + exp(x) - 2;
df = @(x) ((2*x) - 3 + exp(x));

x0 = -0.5;
d  = 1e-4;
N  = 5;

xn = x0;

for n = 1:N
  xn1 = xn - f(xn)/df(xn);

  ea = abs((xn1 - xn) / xn1) * 100;

  if ea < d
    printf('Raiz: %.6f | Iteracoes: %d | Erro: %.6f%%\n', xn1, n, ea);
    return
  end

  xn = xn1;
end

printf('Metodo falhou em %d iteracoes.\n', N);

% Saída:
%
% No caso de x0 = -1:
% Raiz: -0.390272 | Iteracoes: 5 | Erro: 0.000000%
%
% No caso de x0 = -0.5:
% Raiz: -0.390272 | Iteracoes: 4 | Erro: 0.000000%
