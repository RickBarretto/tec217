% -------------------------------------------------------------------------
% GAUSS-SEIDEL
%
% QUANDO USAR:
%   Quando Jacobi for lento ou quando puder usar os valores atualizados
%   imediatamente. Geralmente converge em ~metade das iterações de Jacobi.
%
% VANTAGENS:
%   + Converge mais rápido que Jacobi (usa x_i já atualizado na mesma iter)
%   + Mesma condição de convergência que Jacobi
%   + Economiza memória (atualiza x in-place)
%
% DESVANTAGENS:
%   - Não paralelizável (x_i depende dos x_j já atualizados no mesmo passo)
%   - Pode divergir sem diagonal dominante, igual ao Jacobi
%
% CRITÉRIO DE CONVERGÊNCIA:
%   Critério de Sassenfeld: β_i < 1 para todo i
%     β_i = (Σ|a_ij|*β_j  +  Σ|a_ij|) / |a_ii|
%            j<i                j>i
%   Mais forte que o critério de linhas: se Sassenfeld passa, converge.
%
% FÓRMULA:
%   x_i^(k+1) = (b_i - Σ a_ij*x_j^(k+1) - Σ a_ij*x_j^(k)) / a_ii
%                        j<i                  j>i
%   (usa os valores JÁ atualizados na mesma iteração para j < i)
% -------------------------------------------------------------------------
function x = seidel_iter(A, b, x0, tol, max_iter)
  A = A; b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║        GAUSS-SEIDEL — Iterações                  ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  % ── Critério de Sassenfeld ─────────────────────────────────────────────
  fprintf('\n--- Critério de Sassenfeld ---\n');
  fprintf('  Fórmula: β_i = (Σ|a_ij|*β_j [j<i] + Σ|a_ij| [j>i]) / |a_ii|\n\n');
  beta = zeros(n, 1);
  for i = 1:n
    s = 0;
    for j = 1:i-1
      s = s + abs(A(i,j)) * beta(j);
    end
    for j = i+1:n
      s = s + abs(A(i,j));
    end
    beta(i) = s / abs(A(i,i));
    fprintf('  β_%d = %.6f\n', i, beta(i));
  end
  fprintf('\n  max(β) = %.6f', max(beta));
  if max(beta) < 1
    fprintf('  < 1 → Critério de Sassenfeld satisfeito: convergência GARANTIDA.\n');
  else
    fprintf('  ≥ 1 → AVISO: critério NÃO satisfeito. Pode não convergir.\n');
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
    x_old = x;
    for i = 1:n
      sigma = A(i,:) * x - A(i,i) * x(i);   % usa x já atualizado
      x(i)  = (b(i) - sigma) / A(i,i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
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