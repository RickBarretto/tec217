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