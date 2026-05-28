% =========================================================================
% REGRESSÃO POLINOMIAL
%
% Modelo:  y = a0 + a1*x + a2*x² + ... + ag*x^g
%
% Método:  Equações normais dos mínimos quadrados montadas explicitamente.
%          Sistema (g+1)×(g+1) resolvido por Eliminação de Gauss com
%          pivotamento parcial.
%
% Quando usar:
%   • Relação não-linear que não segue lei de potência ou exponencial
%   • Você quer controlar o grau do ajuste (underfitting vs overfitting)
%   • Grau 1 = regressão linear; graus altos podem se ajustar demais
%
% ATENÇÃO: Graus muito altos (>6) podem gerar instabilidade numérica.
%
% Saídas:
%   coef  → vetor [a0, a1, ..., ag]
%   stats → struct com Sr, r2
%
% O que é mostrado:
%   • Matriz de somatórios A e vetor b das equações normais
%   • Matriz aumentada [A|b] antes e depois da eliminação
%   • Substituição retroativa passo a passo
%   • Coeficientes e R²
%   • Predição em x_pred (se fornecido)
% =========================================================================
function [coef, stats] = poly_iter(x, y, grau, x_pred)
  if nargin < 4; x_pred = []; end
  x = x(:); y = y(:);
  n = length(x);
  g = grau;
  m = g + 1;   % número de coeficientes

  fprintf('\n');
  fprintf('==========================================================\n');
  fprintf('  REGRESSÃO POLINOMIAL   grau %d\n', g);
  fprintf('==========================================================\n');

  % --- Monta equações normais -------------------------------------------
  % A(i,j) = Σ x^(i+j-2),  b(i) = Σ y * x^(i-1)
  A = zeros(m, m);
  b_vec = zeros(m, 1);
  for i = 1:m
    for j = 1:m
      A(i,j) = sum(x .^ (i+j-2));
    end
    b_vec(i) = sum(y .* x .^ (i-1));
  end

  fprintf('\n--- Equações normais (mínimos quadrados) ---\n');
  fprintf('Matriz A (somatórios Σx^k):\n');
  for i = 1:m
    fprintf('  [');
    fprintf(' %14.4e', A(i,:));
    fprintf('  ]\n');
  end
  fprintf('\nVetor b (somatórios Σy*x^k):\n');
  for i = 1:m
    fprintf('  b(%d) = %.6f\n', i-1, b_vec(i));
  end

  % --- Eliminação de Gauss com pivotamento parcial ----------------------
  Ab = [A, b_vec];

  fprintf('\n--- Eliminação de Gauss (pivotamento parcial) ---\n');
  fprintf('Matriz aumentada [A|b] inicial:\n');
  _print_matrix(Ab);

  for col = 1:m-1
    % Pivotamento
    [~, idx] = max(abs(Ab(col:m, col)));
    idx = idx + col - 1;
    if idx ~= col
      Ab([col, idx], :) = Ab([idx, col], :);
      fprintf('\n  → Troca de linhas %d <-> %d (pivotamento)\n', col, idx);
    end
    fprintf('\n  Eliminando coluna %d (pivô = %.4e):\n', col, Ab(col,col));
    for row = col+1:m
      f = Ab(row, col) / Ab(col, col);
      Ab(row, :) = Ab(row, :) - f * Ab(col, :);
      fprintf('    L%d ← L%d - (%.4f)*L%d\n', row, row, f, col);
    end
  end

  fprintf('\nMatriz [A|b] após eliminação:\n');
  _print_matrix(Ab);

  % --- Substituição retroativa ------------------------------------------
  a = zeros(m, 1);
  fprintf('\n--- Substituição retroativa ---\n');
  for i = m:-1:1
    soma = Ab(i, m+1);
    for j = i+1:m
      soma = soma - Ab(i,j)*a(j);
    end
    a(i) = soma / Ab(i,i);
    fprintf('  a%d = (%.4f', i-1, Ab(i, m+1));
    for j = i+1:m
      fprintf(' - %.4f*a%d', Ab(i,j), j-1);
    end
    fprintf(') / %.4f = %.6f\n', Ab(i,i), a(i));
  end

  fprintf('\nCoeficientes do polinômio:\n');
  for i = 1:m
    fprintf('  a%d = %.6f\n', i-1, a(i));
  end
  fprintf('Modelo: y = ');
  for i = 1:m
    if i == 1
      fprintf('%.4f', a(i));
    elseif i == 2
      fprintf(' + %.4f*x', a(i));
    else
      fprintf(' + %.4f*x^%d', a(i), i-1);
    end
  end
  fprintf('\n');

  % --- R² ---------------------------------------------------------------
  y_pred = zeros(n, 1);
  for k = 0:g
    y_pred = y_pred + a(k+1) .* x.^k;
  end
  Sr = sum((y - y_pred).^2);
  r2 = 1 - Sr / sum((y - mean(y)).^2);
  fprintf('\nR² = %.6f\n', r2);

  % --- Predição ---------------------------------------------------------
  if ~isempty(x_pred)
    y_hat = 0;
    for k = 0:g
      y_hat = y_hat + a(k+1) * x_pred^k;
    end
    fprintf('\n--- Predição ---\n');
    fprintf('y(%.4g) = ', x_pred);
    for k = 0:g
      if k == 0
        fprintf('%.4f', a(k+1));
      else
        fprintf(' + %.4f*(%.4g)^%d', a(k+1), x_pred, k);
      end
    end
    fprintf(' = %.6f\n', y_hat);
  end

  coef  = a;
  stats = struct('Sr', Sr, 'r2', r2);
end
