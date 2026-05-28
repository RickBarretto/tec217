% -------------------------------------------------------------------------
% JACOBI
%
% QUANDO USAR:
%   Primeira opção quando a matriz é estritamente diagonal dominante.
%   Fácil de paralelizar; cada iteração usa APENAS valores do passo anterior.
%
% VANTAGENS:
%   + Simples de implementar e entender
%   + Paralelizável (cada x_i novo é independente dos outros novos)
%   + Bom para matrizes esparsas e diagonalmente dominantes
%
% DESVANTAGENS:
%   - Converge mais lentamente que Gauss-Seidel
%   - Pode não convergir se a matriz não for diagonalmente dominante
%   - Requer armazenamento de x_old e x_new simultaneamente
%
% CRITÉRIO DE CONVERGÊNCIA:
%   Critério de Linhas: |a_ii| > Σ|a_ij| para todo i (j≠i)
%   Se satisfeito → convergência garantida.
%   Se NÃO satisfeito → pode ou não convergir (verifique na prática).
%
% FÓRMULA:
%   x_i^(k+1) = (b_i - Σ a_ij * x_j^(k)) / a_ii   (j ≠ i)
%   Em forma matricial: x^(k+1) = C*x^(k) + d
%     C_ij = -a_ij/a_ii  (i≠j),  C_ii = 0
%     d_i  =  b_i/a_ii
% -------------------------------------------------------------------------
function x = jacobi_iter(A, b, x0, tol, max_iter)
  A = A; b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║          JACOBI — Diferenças Divididas           ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  % ── Critério de Linhas ─────────────────────────────────────────────────
  fprintf('\n--- Critério de Linhas (Diagonal Dominante) ---\n');
  satisfaz = true;
  for i = 1:n
    soma_fora = sum(abs(A(i,:))) - abs(A(i,i));
    ok = abs(A(i,i)) > soma_fora;
    fprintf('  Linha %d: |%.4g| %s Σ|a_ij| = %.4g  →  %s\n', ...
            i, A(i,i), iif(ok,'>','≤'), soma_fora, iif(ok,'OK','FALHA'));
    if ~ok, satisfaz = false; end
  end
  if satisfaz
    fprintf('  ✔ Diagonal estritamente dominante: convergência GARANTIDA.\n');
  else
    fprintf('  ✘ AVISO: critério NÃO satisfeito. Pode não convergir.\n');
  end

  % ── Monta C e d ────────────────────────────────────────────────────────
  fprintf('\n--- Montando C e d ---\n');
  fprintf('  Fórmula: C_ij = -a_ij/a_ii  (i≠j)   d_i = b_i/a_ii\n\n');
  C = zeros(n);
  d = zeros(n, 1);
  for i = 1:n
    d(i) = b(i) / A(i,i);
    for j = 1:n
      if i ~= j
        C(i,j) = -A(i,j) / A(i,i);
      end
    end
  end
  fprintf('  C =\n'); disp(C);
  fprintf('  d = ['); fprintf(' %.6f', d); fprintf(' ]\n');

  % ── Raio espectral de C ────────────────────────────────────────────────
  rho = max(abs(eig(C)));
  fprintf('\n  Raio espectral ρ(C) = %.6f', rho);
  if rho < 1
    fprintf('  < 1 → convergência GARANTIDA pelo raio espectral.\n');
  else
    fprintf('  ≥ 1 → DIVERGÊNCIA possível!\n');
  end

  % ── Iterações ──────────────────────────────────────────────────────────
  fprintf('\n--- Iterações ---\n');
  header = ['%-6s' repmat('  %-12s', 1, n) '  %-14s\n'];
  vars = {'iter'};
  for i=1:n, vars{end+1} = sprintf('x%d', i); end
  vars{end+1} = 'erro_max(%)';
  fprintf(header, vars{:});
  fprintf('%s\n', repmat('-', 1, 6 + n*14 + 16));

  x = x0;
  k = 0;
  erro = Inf;
  converged = false;
  row = ['%-6d' repmat('  %-12.6f', 1, n) '  %-14.2e\n'];

  for k = 1:max_iter
    x_new = C * x + d;
    erro = abs((x_new - x) ./ max(abs(x_new), 1e-10)) * 100;
    x = x_new;
    fprintf(row, k, x, max(erro));
    if max(erro) < tol
      converged = true;
      break;
    end
  end

  % ── Resultado ──────────────────────────────────────────────────────────
  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  if converged
    fprintf('  Convergiu em %d iterações  |  Erro máx: %.2e%%\n', k, max(erro));
  else
    fprintf('  NÃO convergiu em %d iterações  |  Erro máx: %.2e%%\n', max_iter, max(erro));
  end
end