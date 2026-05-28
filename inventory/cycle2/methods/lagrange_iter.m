% -------------------------------------------------------------------------
% LAGRANGE — Bases polinomiais
%
%  O que mostra:
%    • Cálculo de cada L_i(xav) com os produtos explícitos
%    • Contribuição de cada nó: f_i * L_i(xav)
%    • Soma final
% -------------------------------------------------------------------------
function [val, Lvals] = lagrange_iter(x, f, xav)
  x = x(:)'; f = f(:)'; n = length(x);

  fprintf('\n=== LAGRANGE — Bases polinomiais ===\n');
  fprintf('\nAvaliação em x = %g:\n', xav);

  Lvals = zeros(1,n);
  val = 0;
  for i = 1:n
    idx = [1:i-1, i+1:n];          % índices j ≠ i
    num = prod(xav - x(idx));
    den = prod(x(i)  - x(idx));
    Lvals(i) = num / den;

    fprintf('\n  L_%d(x):\n', i-1);
    fprintf('    numerador  = prod(%.4g - [', xav);
    fprintf(' %.4g', x(idx)); fprintf(' ]) = %.6f\n', num);
    fprintf('    denominador= prod(%.4g - [', x(i));
    fprintf(' %.4g', x(idx)); fprintf(' ]) = %.6f\n', den);
    fprintf('    L_%d(%.4g) = %.6f\n', i-1, xav, Lvals(i));
    fprintf('    f_%d * L_%d = %.6f * %.6f = %.6f\n', ...
            i-1, i-1, f(i), Lvals(i), f(i)*Lvals(i));
    val = val + f(i)*Lvals(i);
  end

  fprintf('\nSoma total P(%g) = ', xav);
  for i=1:n
    if i>1; fprintf(' + '); end
    fprintf('%.6f', f(i)*Lvals(i));
  end
  fprintf(' = %.6f\n', val);
end