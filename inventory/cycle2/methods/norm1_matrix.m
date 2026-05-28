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