% -------------------------------------------------------------------------
% NEWTON — Diferenças Divididas + Horner
%
%  O que mostra:
%    • Tabela de diferenças divididas completa (DD)
%    • Coeficientes b0, b1, ..., bn-1
%    • Passo a passo do Algoritmo de Horner
% -------------------------------------------------------------------------
function [val, b] = newton_iter(x, f, xav)
  x = x(:)'; f = f(:)'; n = length(x);

  fprintf('\n=== NEWTON — Diferenças Divididas ===\n');

  % Monta tabela DD
  DD = zeros(n,n);
  DD(:,1) = f(:);
  for j = 2:n
    for i = 1:n-j+1
      DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x(i+j-1) - x(i));
    end
  end

  % Imprime tabela
  fprintf('\nTabela de Diferenças Divididas:\n');
  fprintf('%-6s', 'i'); fprintf('%-10s','x_i'); fprintf('%-12s','f[ ]');
  for j=2:n; fprintf('%-14s', sprintf('f[%s]', repmat('*,',1,j-1))); end
  fprintf('\n');
  for i=1:n
    fprintf('%-6d%-10g', i, x(i));
    for j=1:n-i+1
      fprintf('%-14.6f', DD(i,j));
    end
    fprintf('\n');
  end

  b = DD(1,:);
  fprintf('\nCoeficientes de Newton:\n');
  for k=1:n; fprintf('  b%d = %.6f\n', k-1, b(k)); end

  % Horner
  fprintf('\nHorner — avaliação em x = %g:\n', xav);
  val = b(n);
  fprintf('  passo inicial: val = b%d = %.6f\n', n-1, val);
  for k = n-1:-1:1
    val = val*(xav - x(k)) + b(k);
    fprintf('  k=%d: val = val*(%.4g - %.4g) + %.6f = %.6f\n', ...
            k, xav, x(k), b(k), val);
  end
end