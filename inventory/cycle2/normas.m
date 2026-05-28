% =========================================================================
%                <<< NORMAS DE MATRIZ (OPCIONAL) >>>
% =========================================================================
%
% COMO USAR:
%   A → matriz que você já definiu acima
%
% DESCOMENTE para calcular:
%
%   n1   = norm1_matrix(A);
%   ninf = norminf_matrix(A);
%
% OBS:
%   - Pode usar antes de rodar Jacobi/Seidel/SOR
%   - Útil para análise de convergência (ex: ||C|| < 1)
%
% =========================================================================

% n1   = norm1_matrix(A);
% ninf = norminf_matrix(A);

% -------------------------------------------------------------------------
% NORMA 1 DE MATRIZ
% -------------------------------------------------------------------------
function n1 = norm1_matrix(A)
  A = abs(A);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║              NORMA 1 DE MATRIZ                   ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  fprintf('\n--- Somando colunas ---\n');

  col_sums = sum(A, 1);

  for j = 1:length(col_sums)
    fprintf('  Coluna %d → soma = %.6f\n', j, col_sums(j));
  end

  n1 = max(col_sums);

  fprintf('\n--- Resultado ---\n');
  fprintf('  ||A||₁ = %.6f\n', n1);
end


% -------------------------------------------------------------------------
% NORMA INFINITO DE MATRIZ
% -------------------------------------------------------------------------
function ninf = norminf_matrix(A)
  A = abs(A);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║           NORMA INFINITO DE MATRIZ               ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  fprintf('\n--- Somando linhas ---\n');

  row_sums = sum(A, 2);

  for i = 1:length(row_sums)
    fprintf('  Linha %d → soma = %.6f\n', i, row_sums(i));
  end

  ninf = max(row_sums);

  fprintf('\n--- Resultado ---\n');
  fprintf('  ||A||∞ = %.6f\n', ninf);
end