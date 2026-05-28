% =========================================================================
% REGRESSION.M — Regressão por Mínimos Quadrados (passo a passo)
% =========================================================================
%
% MÉTODOS DISPONÍVEIS:
%
%   linear_iter  → Regressão linear simples         y = a1*x + a0
%   power_iter   → Regressão de potência            y = b * x^m
%   poly_iter    → Regressão polinomial             y = a0 + a1*x + ... + ag*x^g
%   multi_iter   → Regressão linear múltipla        y = c0 + c1*x1 + c2*x2 + ...
%
% COMO CONFIGURAR:
%   1. Preencha os vetores/matrizes na seção "CONFIGURE AQUI"
%   2. Descomente UMA chamada na seção "EXECUTE UM MÉTODO"
%   3. Execute o script
%
% =========================================================================

clc; clear; close all;

% =========================================================================
%                      <<< CONFIGURE AQUI >>>
% =========================================================================

% --- Dados para métodos univariados (linear, potência, polinomial) -------
x = [1 2 3 4 5 6 7 8 9 10]';
y = [1.3 3.5 4.2 5.0 7.0 8.8 10.1 12.5 13.0 15.6]';

% Ponto de predição: valor de x onde quer estimar y
% Coloque [] se não quiser prever nenhum ponto
x_pred = 5.5;

% --- Grau para regressão polinomial --------------------------------------
grau = 2;

% --- Dados para regressão linear múltipla --------------------------------
% X_mult: matriz n×p — cada coluna é uma variável independente (x1, x2, ...)
% y_mult: vetor coluna com os valores resposta
X_mult = [0,   0;
          2,   1;
          2.5, 2;
          1,   3;
          4,   6;
          7,   2];
y_mult = [5; 10; 9; 0; 3; 27];

% =========================================================================
%         <<< EXECUTE UM MÉTODO (descomente apenas um) >>>
% =========================================================================

[coef, stats] = linear_iter(x, y, x_pred);
% [coef, stats] = power_iter(x, y, x_pred);
% [coef, stats]  = poly_iter(x, y, grau, x_pred);
% [coef, stats]  = multi_iter(X_mult, y_mult);

% =========================================================================
% =========================================================================
%   IMPLEMENTAÇÕES — não precisa alterar abaixo desta linha
% =========================================================================
% =========================================================================


% =========================================================================
% REGRESSÃO LINEAR SIMPLES
%
% Modelo:  y = a1*x + a0
%
% Método:  Fórmulas fechadas das equações normais dos mínimos quadrados.
%
% Quando usar:
%   • Relação entre x e y é aproximadamente linear (gráfico dispersão ≈ reta)
%   • É o método mais simples; serve de base para entender os demais
%
% Saídas:
%   coef  → [a1, a0]  (inclinação e intercepto)
%   stats → struct com Sy, Sy_x, r2
%
% O que é mostrado:
%   • Todos os somatórios intermediários
%   • Cálculo de a1 e a0
%   • Desvio padrão dos dados (Sy), desvio padrão do erro (Sy/x)
%   • Coeficiente de determinação r²
%   • Predição em x_pred (se fornecido)
% =========================================================================
function [coef, stats] = linear_iter(x, y, x_pred)
  if nargin < 3; x_pred = []; end
  x = x(:); y = y(:);
  n = length(x);
  if length(y) ~= n
    error('x e y devem ter o mesmo tamanho');
  end

  fprintf('\n');
  fprintf('==========================================================\n');
  fprintf('  REGRESSÃO LINEAR SIMPLES   y = a1*x + a0\n');
  fprintf('==========================================================\n');

  % --- Somatórios -------------------------------------------------------
  sum_x  = sum(x);
  sum_y  = sum(y);
  sum_xy = sum(x .* y);
  sum_x2 = sum(x .^ 2);

  fprintf('\n--- Tabela de somatórios ---\n');
  fprintf('%-6s %10s %10s %12s %12s\n', 'i', 'x_i', 'y_i', 'x_i*y_i', 'x_i^2');
  fprintf('%s\n', repmat('-', 1, 54));
  for i = 1:n
    fprintf('%-6d %10.4f %10.4f %12.4f %12.4f\n', ...
            i, x(i), y(i), x(i)*y(i), x(i)^2);
  end
  fprintf('%s\n', repmat('-', 1, 54));
  fprintf('%-6s %10.4f %10.4f %12.4f %12.4f\n', ...
          'Soma', sum_x, sum_y, sum_xy, sum_x2);

  fprintf('\nn = %d\n', n);
  fprintf('Σx   = %.4f\n', sum_x);
  fprintf('Σy   = %.4f\n', sum_y);
  fprintf('Σxy  = %.4f\n', sum_xy);
  fprintf('Σx²  = %.4f\n', sum_x2);

  % --- Coeficientes -----------------------------------------------------
  fprintf('\n--- Cálculo dos coeficientes ---\n');
  denom = n*sum_x2 - sum_x^2;
  fprintf('Denominador = n*Σx² - (Σx)² = %d*%.4f - (%.4f)² = %.4f\n', ...
          n, sum_x2, sum_x, denom);

  a1 = (n*sum_xy - sum_x*sum_y) / denom;
  a0 = (sum_y - a1*sum_x) / n;
  fprintf('\na1 = (n*Σxy - Σx*Σy) / denom\n');
  fprintf('   = (%d*%.4f - %.4f*%.4f) / %.4f\n', n, sum_xy, sum_x, sum_y, denom);
  fprintf('   = %.6f\n', a1);
  fprintf('\na0 = (Σy - a1*Σx) / n\n');
  fprintf('   = (%.4f - %.4f*%.4f) / %d\n', sum_y, a1, sum_x, n);
  fprintf('   = %.6f\n', a0);

  fprintf('\nModelo ajustado: y = %.4f*x + %.4f\n', a1, a0);

  % --- Estatísticas -----------------------------------------------------
  y_med = mean(y);
  St    = sum((y - y_med).^2);
  Sr    = sum((y - a0 - a1.*x).^2);
  Sy    = sqrt(St / (n-1));
  Sy_x  = sqrt(Sr / (n-2));
  r2    = (St - Sr) / St;

  fprintf('\n--- Estatísticas de qualidade ---\n');
  fprintf('y_med = %.4f\n', y_med);
  fprintf('St    = Σ(yi - ȳ)²  = %.4f   (variação total)\n', St);
  fprintf('Sr    = Σ(yi - ŷi)² = %.4f   (variação dos resíduos)\n', Sr);
  fprintf('\nSy    = sqrt(St/(n-1)) = %.4f   (desvio padrão dos dados)\n', Sy);
  fprintf('Sy/x  = sqrt(Sr/(n-2)) = %.4f   (desvio padrão do erro)\n', Sy_x);
  fprintf('r²    = (St-Sr)/St     = %.6f\n', r2);

  % --- Predição ---------------------------------------------------------
  if ~isempty(x_pred)
    y_hat = a1*x_pred + a0;
    fprintf('\n--- Predição ---\n');
    fprintf('y(%.4g) = %.4f*%.4g + %.4f = %.6f\n', x_pred, a1, x_pred, a0, y_hat);
  end

  coef  = [a1, a0];
  stats = struct('Sy', Sy, 'Sy_x', Sy_x, 'r2', r2);
end


% =========================================================================
% REGRESSÃO DE POTÊNCIA (Lei de Potência)
%
% Modelo:  y = b * x^m
%
% Método:  Linearização via logaritmo natural:
%            ln(y) = ln(b) + m*ln(x)   →   Y = lb + m*X
%          Aplica regressão linear simples em (X, Y) = (ln x, ln y).
%
% Quando usar:
%   • Dados crescem/decrescem de forma acelerada (curva em lei de potência)
%   • Gráfico log-log dos dados parece linear
%   • Exemplo: leis físicas (F = k*m^n), crescimento populacional
%
% ATENÇÃO: x e y devem ser estritamente positivos (logaritmo definido).
%
% Saídas:
%   coef  → [b, m]  (coeficiente e expoente)
%   stats → struct com Sy, Sy_x, r2 (calculados no espaço linearizado)
%
% O que é mostrado:
%   • Transformação logarítmica de cada ponto
%   • Somatórios no espaço transformado
%   • Regressão linear em (ln x, ln y)
%   • Back-transform: b = exp(lb)
%   • Estatísticas no espaço linearizado
%   • Predição em x_pred (se fornecido)
% =========================================================================
function [coef, stats] = power_iter(x, y, x_pred)
  if nargin < 3; x_pred = []; end
  x = x(:); y = y(:);
  n = length(x);
  if any(x <= 0) || any(y <= 0)
    error('power_iter: x e y devem ser estritamente positivos.');
  end

  fprintf('\n');
  fprintf('==========================================================\n');
  fprintf('  REGRESSÃO DE POTÊNCIA   y = b * x^m\n');
  fprintf('==========================================================\n');

  % --- Linearização -----------------------------------------------------
  X = log(x);
  Y = log(y);

  fprintf('\n--- Transformação logarítmica (ln) ---\n');
  fprintf('%-6s %10s %10s %12s %12s\n', 'i', 'x_i', 'y_i', 'X=ln(x)', 'Y=ln(y)');
  fprintf('%s\n', repmat('-', 1, 54));
  for i = 1:n
    fprintf('%-6d %10.4f %10.4f %12.4f %12.4f\n', i, x(i), y(i), X(i), Y(i));
  end

  % --- Somatórios no espaço transformado --------------------------------
  sum_X  = sum(X);
  sum_Y  = sum(Y);
  sum_XY = sum(X .* Y);
  sum_X2 = sum(X .^ 2);

  fprintf('\n--- Somatórios no espaço linearizado ---\n');
  fprintf('n    = %d\n', n);
  fprintf('ΣX   = %.4f\n', sum_X);
  fprintf('ΣY   = %.4f\n', sum_Y);
  fprintf('ΣXY  = %.4f\n', sum_XY);
  fprintf('ΣX²  = %.4f\n', sum_X2);

  % --- Coeficientes no espaço linear ------------------------------------
  denom = n*sum_X2 - sum_X^2;
  fprintf('\nDenominador = n*ΣX² - (ΣX)² = %.4f\n', denom);

  m  = (n*sum_XY - sum_X*sum_Y) / denom;
  lb = (sum_Y - m*sum_X) / n;
  b  = exp(lb);

  fprintf('\nm  = (n*ΣXY - ΣX*ΣY) / denom = %.6f   (expoente)\n', m);
  fprintf('lb = (ΣY - m*ΣX) / n         = %.6f   (ln b)\n', lb);
  fprintf('b  = exp(lb)                  = %.6f   (coeficiente)\n', b);
  fprintf('\nModelo ajustado: y = %.4f * x^%.4f\n', b, m);

  % --- Estatísticas (espaço linearizado) --------------------------------
  Y_med = mean(Y);
  St    = sum((Y - Y_med).^2);
  Sr    = sum((Y - lb - m.*X).^2);
  Sy    = sqrt(St / (n-1));
  Sy_x  = sqrt(Sr / (n-2));
  r2    = (St - Sr) / St;

  fprintf('\n--- Estatísticas (espaço linearizado ln-ln) ---\n');
  fprintf('St    = %.4f\n', St);
  fprintf('Sr    = %.4f\n', Sr);
  fprintf('Sy    = %.4f\n', Sy);
  fprintf('Sy/x  = %.4f\n', Sy_x);
  fprintf('r²    = %.6f\n', r2);

  % --- Predição ---------------------------------------------------------
  if ~isempty(x_pred)
    y_hat = b * x_pred^m;
    fprintf('\n--- Predição ---\n');
    fprintf('y(%.4g) = %.4f * (%.4g)^%.4f = %.6f\n', x_pred, b, x_pred, m, y_hat);
  end

  coef  = [b, m];
  stats = struct('Sy', Sy, 'Sy_x', Sy_x, 'r2', r2);
end


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


% =========================================================================
% AUXILIAR: imprime matriz formatada (uso interno)
% =========================================================================
function _print_matrix(M)
  [nr, nc] = size(M);
  for i = 1:nr
    fprintf('  [');
    fprintf(' %12.4e', M(i,:));
    fprintf('  ]\n');
  end
end