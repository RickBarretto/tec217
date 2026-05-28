% =========================================================================
% ITERATIVE.M — Métodos Iterativos para Sistemas Lineares Ax = b
% =========================================================================
%
% MÉTODOS DISPONÍVEIS:
%   jacobi_iter(A, b, x0, tol, max_iter)
%   seidel_iter(A, b, x0, tol, max_iter)
%   sor_iter(A, b, x0, w, tol, max_iter)
%
% COMO USAR — configure as variáveis abaixo e descomente UM método:
%
%   A        → matriz dos coeficientes (n x n)
%   b        → vetor dos termos independentes (n x 1)
%   x0       → chute inicial (normalmente zeros)
%   tol      → tolerância de parada em % (ex: 0.0005)
%   max_iter → número máximo de iterações
%   w        → fator de relaxação SOR (apenas para sor_iter)
%              w < 1  → sub-relaxação   (mais estável, mais lento)
%              w = 1  → equivale a Gauss-Seidel
%              w > 1  → super-relaxação (mais rápido, pode divergir)
%
% =========================================================================

clc; clear; close all;

% =========================================================================
%                     <<< CONFIGURE AQUI >>>
% =========================================================================

A = [10  3 -2;
      2  8 -1;
      1  1  5];
b = [57; 20; -4];

x0       = zeros(size(b));  % chute inicial
tol      = 0.0005;          % tolerância (%)
max_iter = 100;             % máximo de iterações
w        = 1.25;            % fator de relaxação (só para SOR)

% =========================================================================
%           <<< DESCOMENTE O MÉTODO DESEJADO >>>
% =========================================================================

x = jacobi_iter(A, b, x0, tol, max_iter);
% x = seidel_iter(A, b, x0, tol, max_iter);
% x = sor_iter(A, b, x0, w, tol, max_iter);

% =========================================================================
% =========================================================================
%            IMPLEMENTAÇÕES — não precisa editar abaixo
% =========================================================================
% =========================================================================


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


% ── Utilitário interno ─────────────────────────────────────────────────────
function r = iif(cond, a, b)
  if cond, r = a; else, r = b; end
end