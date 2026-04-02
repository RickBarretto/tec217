% Método da Secante

f = @(x) x^2 - 3*x + exp(x) - 2;

xa = -0.39;
xn = -0.4;
d  = 1e-4;
N  = 10;

for n = 1:N
  xn1 = xn - f(xn) * (xn - xa) / (f(xn) - f(xa));

  ea = abs((xn1 - xn) / xn1) * 100;

  if ea < d
    printf('Raiz: %.6f | Iteracoes: %d | Erro: %.6f%%\n', xn1, n, ea);
    return
  end

  xa = xn;
  xn = xn1;
end

printf('Metodo falhou em %d iteracoes.\n', N);


% Saída esperada
%
% No caso de x0 = -2, x-1 = 2:
% Raiz: 1.446239 | Iteracoes: 9 | Erro: 0.000004%
%
% No caso de x0 = -0.2, x-1 = -0.5:
% Raiz: -0.390272 | Iteracoes: 5 | Erro: 0.000000%
% 
% No caso de x0 = -0.3, x-1 = -0.4:
% Raiz: -0.390272 | Iteracoes: 4 | Erro: 0.000000%
%
% No caso de x0 = -0.39, x-1 = -0.4:
% Raiz: -0.390272 | Iteracoes: 3 | Erro: 0.000001%
