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