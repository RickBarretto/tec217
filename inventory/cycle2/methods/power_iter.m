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