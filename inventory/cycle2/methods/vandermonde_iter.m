% -------------------------------------------------------------------------
% VANDERMONDE — Sistema linear V*a = f
%
%  O que mostra:
%    • Matriz de Vandermonde montada
%    • Vetor de coeficientes a0, a1, ..., an-1
%    • Número de condição (alerta de instabilidade)
%    • Avaliação via Horner
% -------------------------------------------------------------------------
function [val, a] = vandermonde_iter(x, f, xav)
  x = x(:); f = f(:); n = length(x);

  fprintf('\n=== VANDERMONDE — Sistema Linear ===\n');

  % Monta V
  V = zeros(n,n);
  for j=1:n; V(:,j) = x.^(j-1); end

  fprintf('\nMatriz de Vandermonde V:\n');
  for i=1:n
    fprintf('  [');
    fprintf(' %10.4f', V(i,:));
    fprintf('  ]\n');
  end

  cond_V = cond(V);
  fprintf('\nNúmero de condição de V: %.4e', cond_V);
  if cond_V > 1e8
    fprintf('  *** ATENÇÃO: matriz mal condicionada! ***');
  end
  fprintf('\n');

  a = V \ f;
  fprintf('\nCoeficientes monomiais (P(x) = a0 + a1*x + a2*x^2 + ...):\n');
  for k=1:n; fprintf('  a%d = %.6f\n', k-1, a(k)); end

  % Horner
  fprintf('\nHorner — avaliação em x = %g:\n', xav);
  val = a(n);
  fprintf('  passo inicial: val = a%d = %.6f\n', n-1, val);
  for k = n-1:-1:1
    val = val*xav + a(k);
    fprintf('  k=%d: val = val*%.4g + %.6f = %.6f\n', k, xav, a(k), val);
  end
end