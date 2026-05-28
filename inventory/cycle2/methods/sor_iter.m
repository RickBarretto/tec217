% -------------------------------------------------------------------------
% SOR — Successive Over-Relaxation
%
% QUANDO USAR:
%   Quando Gauss-Seidel for lento e você souber (ou quiser testar) um bom
%   valor de w. É uma generalização de Gauss-Seidel com aceleração.
%
% VANTAGENS:
%   + Pode convergir MUITO mais rápido que Gauss-Seidel com w ótimo
%   + Reduz o número de iterações significativamente em sistemas grandes
%   + w=1 reproduz exatamente Gauss-Seidel (bom para testar)
%
% DESVANTAGENS:
%   - Requer escolha cuidadosa de w (w ruim pode divergir)
%   - Não há fórmula simples para w ótimo em geral
%   - Mais complexo de implementar e explicar
%
% ESCOLHA DE w:
%   0 < w < 1  → sub-relaxação  (estabiliza sistemas difíceis)
%   w = 1      → Gauss-Seidel puro
%   1 < w < 2  → super-relaxação (acelera convergência)
%   w ≥ 2      → diverge sempre
%   Regra prática: comece com w = 1.25 e ajuste observando as iterações.
%
% FÓRMULA:
%   x_gs_i = (b_i - sigma) / a_ii        (passo Gauss-Seidel)
%   x_i^(k+1) = w * x_gs_i + (1-w) * x_i^(k)   (relaxação)
% -------------------------------------------------------------------------
function x = sor_iter(A, b, x0, w, tol, max_iter)
  A = A; b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║     SOR — Successive Over-Relaxation             ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n  Fator de relaxação w = %.4f\n', w);
  if w < 1
    fprintf('  Modo: sub-relaxação  (w < 1) → mais estável, mais lento\n');
  elseif w == 1
    fprintf('  Modo: Gauss-Seidel puro  (w = 1)\n');
  elseif w < 2
    fprintf('  Modo: super-relaxação  (1 < w < 2) → pode acelerar convergência\n');
  else
    fprintf('  AVISO: w ≥ 2 → o método sempre diverge!\n');
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
      sigma = A(i,:) * x - A(i,i) * x(i);
      x_gs  = (b(i) - sigma) / A(i,i);         % passo Gauss-Seidel
      x(i)  = w * x_gs + (1 - w) * x_old(i);  % relaxação
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf(row, k, x, max(erro));
    if max(erro) < tol
      converged = true;
      break;
    end
  end

  % ── Resultado ──────────────────════════════════════════════════════════
  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  if converged
    fprintf('  Convergiu em %d iterações  |  Erro máx: %.2e%%\n', k, max(erro));
  else
    fprintf('  NÃO convergiu em %d iterações  |  Erro máx: %.2e%%\n', max_iter, max(erro));
  end
end