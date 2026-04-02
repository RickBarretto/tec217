% Método da Iteração Linear

f = @(x) x^2 - 3*x + exp(x) - 2;
g = @(x) (x^2 + exp(x) - 2) / 3;

x0 = -0.5;
d = 1e-4;
N = 2;

xr = x0;
ea = Inf;

for iter = 1:N
  xrant = xr;
  xr = g(xrant);

  if xr != 0
    ea = abs((xr - xrant) / xr) * 100;
  end

  if ea < d || iter >= N
    printf('Raiz: %.6f | Iteracoes: %d | Erro: %.6f%%\n', xr, iter, ea);
    return
  end
end

printf('Metodo falhou em %d iteracoes.\n', N);

% Saída:
%
% No caso de x0 = -1:
% Raiz: -0.381864 | Iteracoes: 2 | Erro: 44.821452%
%
% No caso de x0 = -0.5:
% Raiz: -0.390550 | Iteracoes: 2 | Erro: 2.405107%
