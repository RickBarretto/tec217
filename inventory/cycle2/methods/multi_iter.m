% =========================================================================
% REGRESSÃO LINEAR MÚLTIPLA
%
% Modelo:  y = c0 + c1*x1 + c2*x2 + ... + cp*xp
%
% Método:  Equações normais: (X^T X) c = X^T y
%          Resolvido por Eliminação de Gauss com pivotamento parcial.
%
% Quando usar:
%   • A variável resposta depende de DUAS OU MAIS variáveis independentes
%   • Você quer quantificar o efeito individual de cada preditor
%   • Extensão direta da regressão linear simples
%
% Saídas:
%   coef  → vetor [c0, c1, ..., cp]
%   stats → struct com Sr, r2
%
% O que é mostrado:
%   • Matriz de design expandida [1 | X]
%   • Produto X^T X e vetor X^T y
%   • Eliminação de Gauss passo a passo
%   • Coeficientes e R²
% =========================================================================
function [coef, stats] = multi_iter(X, y)
  y = y(:);
  [n, p] = size(X);
  m = p + 1;   % número de coeficientes (inclui intercepto c0)

  if length(y) ~= n
    error('Número de linhas de X deve coincidir com o tamanho de y');
  end

  fprintf('\n');
  fprintf('==========================================================\n');
  fprintf('  REGRESSÃO LINEAR MÚLTIPLA   (%d variáveis)\n', p);
  fprintf('==========================================================\n');

  % --- Matriz de design com coluna de 1s --------------------------------
  Xd = [ones(n,1), X];

  fprintf('\n--- Matriz de design Xd = [1 | X] ---\n');
  fprintf('%-6s', 'obs');
  fprintf('  %-8s', '1 (c0)');
  for j = 1:p; fprintf('  %-8s', sprintf('x%d', j)); end
  fprintf('  %-8s\n', 'y');
  fprintf('%s\n', repmat('-', 1, 12 + 10*m));
  for i = 1:n
    fprintf('%-6d', i);
    fprintf('  %-8.4f', Xd(i,:));
    fprintf('  %-8.4f\n', y(i));
  end

  % --- Equações normais: A = Xd'*Xd,  b = Xd'*y ---------------------
  A = Xd' * Xd;
  b_vec = Xd' * y;

  fprintf('\n--- Equações normais:  (Xd'' * Xd) * c = Xd'' * y ---\n');
  fprintf('\nMatriz A = Xd'' * Xd:\n');
  for i = 1:m
    fprintf('  [');
    fprintf(' %12.4f', A(i,:));
    fprintf('  ]\n');
  end
  fprintf('\nVetor b = Xd'' * y:\n');
  for i = 1:m
    fprintf('  b(%d) = %.6f\n', i-1, b_vec(i));
  end

  % --- Eliminação de Gauss com pivotamento parcial ----------------------
  Ab = [A, b_vec];
  fprintf('\n--- Eliminação de Gauss (pivotamento parcial) ---\n');
  fprintf('Matriz aumentada [A|b] inicial:\n');
  _print_matrix(Ab);

  for col = 1:m-1
    [~, idx] = max(abs(Ab(col:m, col)));
    idx = idx + col - 1;
    if idx ~= col
      Ab([col, idx], :) = Ab([idx, col], :);
      fprintf('\n  → Troca de linhas %d <-> %d\n', col, idx);
    end
    fprintf('\n  Eliminando coluna %d (pivô = %.4f):\n', col, Ab(col,col));
    for row = col+1:m
      f = Ab(row, col) / Ab(col, col);
      Ab(row, :) = Ab(row, :) - f * Ab(col, :);
      fprintf('    L%d ← L%d - (%.4f)*L%d\n', row, row, f, col);
    end
  end

  fprintf('\nMatriz [A|b] após eliminação:\n');
  _print_matrix(Ab);

  % --- Substituição retroativa ------------------------------------------
  c = zeros(m, 1);
  fprintf('\n--- Substituição retroativa ---\n');
  for i = m:-1:1
    soma = Ab(i, m+1);
    for j = i+1:m
      soma = soma - Ab(i,j)*c(j);
    end
    c(i) = soma / Ab(i,i);
    fprintf('  c%d = %.6f\n', i-1, c(i));
  end

  fprintf('\nCoeficientes:\n');
  fprintf('  c0 (intercepto) = %.6f\n', c(1));
  for j = 1:p
    fprintf('  c%d (x%d)         = %.6f\n', j, j, c(j+1));
  end
  fprintf('\nModelo: y = %.4f', c(1));
  for j = 1:p
    fprintf(' + %.4f*x%d', c(j+1), j);
  end
  fprintf('\n');

  % --- R² ---------------------------------------------------------------
  y_fit = Xd * c;
  Sr = sum((y - y_fit).^2);
  r2 = 1 - Sr / sum((y - mean(y)).^2);
  fprintf('\nR² = %.6f\n', r2);

  coef  = c;
  stats = struct('Sr', Sr, 'r2', r2);
end