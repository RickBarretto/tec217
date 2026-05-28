% =========================================================================
% GRUPO.M — Sistemas Lineares: Métodos Diretos, Análise e Iterativos
% UEFS – TEC 217 – Métodos Computacionais
% =========================================================================
%
% MÉTODOS DISPONÍVEIS:
%
%   ── Diretos ─────────────────────────────────────────────────────────────
%   gauss_pivot(A, b)             Gauss c/ pivoteamento parcial + determinante
%   gauss_jordan(A, b)            Gauss-Jordan (redução total)
%   gauss_simples(A, b)           Gauss sem pivoteamento
%   decomp_lu(A, b)               Decomposição LU (Doolittle) + solução
%   decomp_lu(A, b, b_alt)        LU reaproveitando L e U para vetor alternativo
%   matriz_inversa(A)             Inversão via Gauss-Jordan + verificação
%
%   ── Análise ─────────────────────────────────────────────────────────────
%   normas_matriz(A)              Normas ||A||₁ e ||A||∞ com normalização de linhas
%   numero_condicao(A)            Número de condição cond(A) = ||A||∞ · ||A⁻¹||∞
%
%   ── Iterativos ──────────────────────────────────────────────────────────
%   jacobi_iter(A, b, x0, tol, max_iter)
%   seidel_iter(A, b, x0, tol, max_iter)
%   sor_iter(A, b, x0, w, tol, max_iter)
%
% COMO USAR:
%   1. Configure A, b e parâmetros na seção <<< CONFIGURE AQUI >>>
%   2. Descomente UMA chamada de método
%   3. Execute: octave grupo.m  (ou F5 no Octave/Matlab)
%
% TOLERÂNCIA (métodos iterativos):
%   tol está em % — para εs = 5% use tol = 5
%                 — para εs = 0.05% use tol = 0.05
%
% =========================================================================

clc; clear; close all;

% =========================================================================
%                      <<< CONFIGURE AQUI >>>
%          Descomente O BLOCO do método que deseja executar
% =========================================================================


% ── Q1 — Gauss com Pivoteamento Parcial + Determinante ───────────────────
%   Sistema:  2x1 - 6x2 - x3 = -38
%            -3x1 - x2 + 7x3 = -34
%            -8x1 + x2 - 2x3 = -20
% A = [ 2 -6 -1;
%      -3 -1  7;
%      -8  1 -2];
% b = [-38; -34; -20];
% gauss_pivot(A, b);


% ── Q2 — Gauss-Jordan (sistema de tanques) ───────────────────────────────
%   Equações de balanço de massa (estado estacionário):
%   Tanque 1: 130c1 - 30c2        = 200
%   Tanque 2: -90c1 + 90c2        = 0
%   Tanque 3: -40c1 - 60c2 + 120c3 = 500
%   (Q12=90, Q13=40, Q21=30, Q23=60, Q33=120)
% A = [130 -30   0;
%      -90  90   0;
%      -40 -60 120];
% b = [200; 0; 500];
% gauss_jordan(A, b);


% ── Q3 — Gauss Sem Pivoteamento (composição de minas) ────────────────────
%   Mina 1: 52% areia, 30% cf, 18% cg
%   Mina 2: 20% areia, 50% cf, 30% cg
%   Mina 3: 25% areia, 20% cf, 55% cg
%   Necessidade: 4800 m³ areia, 5800 m³ cf, 5700 m³ cg
% A = [0.52 0.20 0.25;
%      0.30 0.50 0.20;
%      0.18 0.30 0.55];
% b = [4800; 5800; 5700];
% gauss_simples(A, b);


% ── Q4 — Decomposição LU (Doolittle) ─────────────────────────────────────
%   (a) Sistema original
%   (b) Vetor alternativo b_alt = [12; 18; -6] reaproveitando L e U
A = [ 7  2 -3;
      2  5 -3;
      1 -1 -6];
b     = [-12; -20; -26];
b_alt = [ 12;  18;  -6];
decomp_lu(A, b, b_alt);    % remove b_alt para resolver só (a)


% ── Q5 — Matriz Inversa ──────────────────────────────────────────────────
%   Sistema:  10x1 + 2x2 - x3 = 27
%            -3x1 - 6x2 + 2x3 = -61.5
%             x1 + x2 + 5x3 = -21.5
% A = [10  2 -1;
%      -3 -6  2;
%       1  1  5];
% matriz_inversa(A);


% ── Q6 — Normas da Matriz ────────────────────────────────────────────────
% A = [ 8  2 -10;
%      -9  1   3;
%      15 -1   6];
% normas_matriz(A);


% ── Q7 — Número de Condição (Vandermonde) ────────────────────────────────
% x1 = 4; x2 = 2; x3 = 7;
% A = [x1^2 x1 1; x2^2 x2 1; x3^2 x3 1];
% numero_condicao(A);


% ── Q8 — Gauss-Seidel (εs = 5%) ──────────────────────────────────────────
% A  = [0.8 -0.4  0  ;
%      -0.4  0.8 -0.4;
%       0   -0.4  0.8];
% b  = [41; 25; 105];
% x0 = zeros(3, 1);
% tol = 5;          % εs = 5%
% max_iter = 100;
% seidel_iter(A, b, x0, tol, max_iter);


% ── Q9 — Jacobi (εs = 5%) ────────────────────────────────────────────────
% A = [10  2 -1;
%      -3 -6  2;
%       1  1  5];
% b = [27; -61.5; -21.5];
% x0 = zeros(3, 1);
% tol = 5;
% max_iter = 100;
% jacobi_iter(A, b, x0, tol, max_iter);


% ── Q10 — SOR com εs = 5% ────────────────────────────────────────────────
%   Sistema rearanjado para diagonal dominante:
%     Original:  2x1-6x2-x3=-38, -3x1-x2+7x3=-34, -8x1+x2-2x3=-20
%     Rearanjado: linha 3 na pos 1, linha 1 na pos 2, linha 2 na pos 3
%     Verificação diagonal dominante:
%       |-8| > |1|+|-2| = 3  ✔
%       |-6| > |2|+|-1| = 3  ✔
%       | 7| > |-3|+|-1| = 4 ✔
% A_sor = [-8  1 -2;
%           2 -6 -1;
%          -3 -1  7];
% b_sor = [-20; -38; -34];
% x0 = zeros(3,1);
% tol = 5;
% max_iter = 100;
% w = 1.25;   % teste: 0.5, 1.0, 1.25, 1.5, 1.75 — escolha o menor nº iterações
% sor_iter(A_sor, b_sor, x0, w, tol, max_iter);


% =========================================================================
% =========================================================================
%              IMPLEMENTAÇÕES — não precisa editar abaixo
% =========================================================================
% =========================================================================


% -------------------------------------------------------------------------
% GAUSS COM PIVOTEAMENTO PARCIAL
%
% QUANDO USAR:
%   Método direto padrão. Use quando precisar da solução + determinante.
%   Pivoteamento evita divisão por zero e reduz erros de arredondamento.
%
% VANTAGENS:
%   + Numericamente estável (pivoteamento parcial)
%   + Calcula o determinante como subproduto
%   + Funciona para qualquer sistema com solução única
%
% DESVANTAGENS:
%   - O(n³) operações — lento para sistemas muito grandes
%   - Destrói a matriz original (trabalha sobre cópia)
%
% FÓRMULA (eliminação progressiva):
%   Para cada coluna pivô k:
%     1. Busca linha r tal que |A(r,k)| = max{|A(i,k)|, i ≥ k}
%     2. Troca linhas k e r  (conta para sinal do det)
%     3. Para i > k:  fator m = A(i,k)/A(k,k)
%                     A(i,:) = A(i,:) - m * A(k,:)
%   Determinante = ∏ A(k,k) × (-1)^(nº trocas)
%   Retro-substituição: x(n→1)
%     x(i) = (b(i) - Σ A(i,j)*x(j)) / A(i,i)   j > i
% -------------------------------------------------------------------------
function gauss_pivot(A, b)
  b = b(:);
  n = size(A, 1);
  Aug = [A, b];   % matriz aumentada
  trocas = 0;

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║   GAUSS com Pivoteamento Parcial + Determinante  ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n--- Matriz aumentada inicial [A|b] ---\n');
  print_aug(Aug);

  % ── Eliminação progressiva ─────────────────────────────────────────────
  for k = 1:n-1
    % pivot parcial: encontra linha de maior |valor| na coluna k
    [~, r] = max(abs(Aug(k:n, k)));
    r = r + k - 1;
    if r ~= k
      Aug([k r], :) = Aug([r k], :);
      trocas = trocas + 1;
      fprintf('\n  Troca: linha %d ↔ linha %d\n', k, r);
      print_aug(Aug);
    end

    if abs(Aug(k,k)) < 1e-12
      fprintf('  AVISO: pivô nulo na coluna %d — sistema singular!\n', k);
      return;
    end

    fprintf('\n--- Eliminação coluna %d (pivô = %.4g) ---\n', k, Aug(k,k));
    for i = k+1:n
      m = Aug(i,k) / Aug(k,k);
      Aug(i,:) = Aug(i,:) - m * Aug(k,:);
      fprintf('  L%d = L%d - (%.4g) × L%d\n', i, i, m, k);
    end
    print_aug(Aug);
  end

  % ── Determinante ──────────────────────────────────────────────────────
  det_val = prod(diag(Aug(1:n,1:n))) * (-1)^trocas;
  fprintf('\n--- Determinante ---\n');
  fprintf('  det(A) = ∏(diagonais) × (-1)^%d = %.6g\n', trocas, det_val);

  % ── Retro-substituição ────────────────────────────────────────────────
  fprintf('\n--- Retro-substituição ---\n');
  x = zeros(n,1);
  for i = n:-1:1
    x(i) = (Aug(i,n+1) - Aug(i,i+1:n)*x(i+1:n)) / Aug(i,i);
    fprintf('  x%d = %.6f\n', i, x(i));
  end

  % ── Verificação ───────────────────────────────────────────────────────
  fprintf('\n--- Verificação  Ax ≈ b ---\n');
  res = A*x - b;
  for i = 1:n
    fprintf('  Equação %d: %.6f  (resíduo = %.2e)\n', i, (A*x)(i), res(i));
  end

  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  fprintf('  det(A) = %.6g\n', det_val);
end


% -------------------------------------------------------------------------
% GAUSS-JORDAN
%
% QUANDO USAR:
%   Quando quiser a solução diretamente sem retro-substituição, ou quando
%   precisar inverter a matriz em seguida. Reduz [A|b] → [I|x].
%
% VANTAGENS:
%   + Não requer etapa de retro-substituição
%   + Base do algoritmo de inversão de matrizes
%   + Resultado imediato: última coluna é a solução
%
% DESVANTAGENS:
%   - ~50% mais operações que Gauss simples
%   - Sem pivoteamento pode ser instável (esta implementação não pivota)
%
% FÓRMULA (eliminação total):
%   Para cada linha pivô k:
%     1. Normaliza: L(k) = L(k) / A(k,k)
%     2. Para todo i ≠ k: L(i) = L(i) - A(i,k) × L(k)
%   Resultado: [A|b] → [I|x]
% -------------------------------------------------------------------------
function gauss_jordan(A, b)
  b = b(:);
  n = size(A, 1);
  Aug = [A, b];

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║           GAUSS-JORDAN (redução total)           ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n--- Matriz aumentada inicial [A|b] ---\n');
  print_aug(Aug);

  for k = 1:n
    if abs(Aug(k,k)) < 1e-12
      fprintf('  AVISO: pivô nulo na coluna %d!\n', k);
      return;
    end

    % Normaliza linha pivô
    piv = Aug(k,k);
    Aug(k,:) = Aug(k,:) / piv;
    fprintf('\n--- Passo %d — normaliza L%d (÷ %.4g) ---\n', k, k, piv);
    print_aug(Aug);

    % Elimina nas demais linhas (acima e abaixo)
    for i = 1:n
      if i ~= k
        fator = Aug(i,k);
        if abs(fator) > 1e-14
          Aug(i,:) = Aug(i,:) - fator * Aug(k,:);
          fprintf('  L%d = L%d - (%.4g) × L%d\n', i, i, fator, k);
        end
      end
    end
    print_aug(Aug);
  end

  x = Aug(:, n+1);
  fprintf('\n--- Resultado ---\n');
  for i = 1:n
    fprintf('  x%d = %.6f\n', i, x(i));
  end
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
end


% -------------------------------------------------------------------------
% GAUSS SEM PIVOTEAMENTO
%
% QUANDO USAR:
%   Quando o enunciado pedir explicitamente "sem pivoteamento" (Q3).
%   Use só se souber que não há pivôs nulos ou muito pequenos.
%
% VANTAGENS:
%   + Mais simples de implementar/mostrar à mão
%   + Suficiente quando o sistema é bem condicionado
%
% DESVANTAGENS:
%   - Pode falhar ou dar resultado ruim se pivô for zero ou pequeno
%   - Sem controle de erros de arredondamento
%
% FÓRMULA: idêntica ao Gauss com pivoteamento, mas sem a etapa de troca.
% -------------------------------------------------------------------------
function gauss_simples(A, b)
  b = b(:);
  n = size(A, 1);
  Aug = [A, b];

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║        GAUSS sem Pivoteamento                    ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n--- Matriz aumentada inicial [A|b] ---\n');
  print_aug(Aug);

  for k = 1:n-1
    if abs(Aug(k,k)) < 1e-12
      fprintf('  ERRO: pivô nulo na coluna %d — use gauss_pivot!\n', k);
      return;
    end
    fprintf('\n--- Eliminação coluna %d (pivô = %.4g) ---\n', k, Aug(k,k));
    for i = k+1:n
      m = Aug(i,k) / Aug(k,k);
      Aug(i,:) = Aug(i,:) - m * Aug(k,:);
      fprintf('  m_%d%d = %.6f  →  L%d = L%d - %.4g×L%d\n', i,k, m, i,i, m, k);
    end
    print_aug(Aug);
  end

  fprintf('\n--- Retro-substituição ---\n');
  x = zeros(n,1);
  for i = n:-1:1
    x(i) = (Aug(i,n+1) - Aug(i,i+1:n)*x(i+1:n)) / Aug(i,i);
    fprintf('  x%d = %.6f\n', i, x(i));
  end

  fprintf('\n--- Verificação  Ax ≈ b ---\n');
  res = A*x - b;
  for i = 1:n
    fprintf('  Eq %d: %.6f  (resíduo = %.2e)\n', i, (A*x)(i), res(i));
  end
  fprintf('\n  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
end


% -------------------------------------------------------------------------
% DECOMPOSIÇÃO LU — MÉTODO DE DOOLITTLE
%
% QUANDO USAR:
%   Ideal quando precisar resolver Ax = b para VÁRIOS vetores b diferentes,
%   pois L e U são calculados uma vez e reutilizados (Q4).
%
% VANTAGENS:
%   + Solução de múltiplos b sem refazer a decomposição
%   + Mesmo custo computacional do Gauss (O(n³)), mas amortizado
%   + Útil para cálculo de determinante e inversa
%
% DESVANTAGENS:
%   - Sem pivoteamento (pode ser instável para sistemas mal condicionados)
%   - L e U não são únicos sem restrição extra (Doolittle: L_ii = 1)
%
% FÓRMULA (Doolittle — diagonal de L = 1):
%   u_kj = a_kj - Σ(l_km · u_mj)   m = 1..k-1    (elementos de U)
%   l_ik = (a_ik - Σ(l_im · u_mk)) / u_kk   m = 1..k-1   (elementos de L)
%
%   Depois:
%   Ly = b  →  y_i = b_i - Σ l_ij·y_j   (substituição progressiva)
%   Ux = y  →  x_i = (y_i - Σ u_ij·x_j)/u_ii  (retro-substituição)
% -------------------------------------------------------------------------
function decomp_lu(A, b, b_alt)
  if nargin < 3, b_alt = []; end
  b = b(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║   DECOMPOSIÇÃO LU — Método de Doolittle          ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  % ── Decomposição ──────────────────────────────────────────────────────
  fprintf('\n--- Calculando L e U ---\n');
  fprintf('  Convenção Doolittle: L_ii = 1 (diagonal de L é 1)\n\n');
  L = eye(n);
  U = zeros(n);

  for k = 1:n
    % linha k de U
    for j = k:n
      U(k,j) = A(k,j) - L(k,1:k-1) * U(1:k-1,j);
    end
    fprintf('  U(%d,:) = [', k); fprintf(' %.4g', U(k,:)); fprintf(' ]\n');

    % coluna k de L
    for i = k+1:n
      L(i,k) = (A(i,k) - L(i,1:k-1) * U(1:k-1,k)) / U(k,k);
    end
    if k < n
      fprintf('  L(:,%d) = [', k); fprintf(' %.4g', L(:,k)); fprintf(' ]\n\n');
    end
  end

  fprintf('\n  L =\n'); disp(L);
  fprintf('  U =\n'); disp(U);

  % ── Verificação A = L·U ────────────────────────────────────────────────
  erro_lu = max(max(abs(A - L*U)));
  fprintf('  Verificação  ||A - L·U||∞ = %.2e\n', erro_lu);

  % ── Determinante ──────────────────────────────────────────────────────
  det_val = prod(diag(U));
  fprintf('\n  det(A) = ∏(diag de U) = %.6g\n', det_val);

  % ── Resolve para b (vetor principal) ──────────────────────────────────
  fprintf('\n--- Resolvendo para b = ['); fprintf(' %.4g', b); fprintf(' ] ---\n');
  y = lu_forward(L, b);
  x = lu_backward(U, y);
  fprintf('\n  Substituição progressiva  Ly = b:\n');
  fprintf('  y = ['); fprintf(' %.6f', y); fprintf(' ]\n');
  fprintf('\n  Retro-substituição  Ux = y:\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  fprintf('\n  Verificação  Ax - b = ['); fprintf(' %.2e', A*x - b); fprintf(' ]\n');

  % ── Resolve para b_alt (vetor alternativo) ────────────────────────────
  if ~isempty(b_alt)
    b_alt = b_alt(:);
    fprintf('\n--- Reaproveitando L e U para b_alt = [');
    fprintf(' %.4g', b_alt); fprintf(' ] ---\n');
    y2 = lu_forward(L, b_alt);
    x2 = lu_backward(U, y2);
    fprintf('  y = ['); fprintf(' %.6f', y2); fprintf(' ]\n');
    fprintf('  x = ['); fprintf(' %.6f', x2); fprintf(' ]\n');
    fprintf('  Verificação  Ax - b_alt = ['); fprintf(' %.2e', A*x2 - b_alt); fprintf(' ]\n');
  end
end


% -------------------------------------------------------------------------
% MATRIZ INVERSA (via Gauss-Jordan)
%
% QUANDO USAR:
%   Quando o enunciado pedir [A]⁻¹ explicitamente (Q5).
%   Para resolver um único Ax = b, NÃO use inversa — use Gauss.
%
% VANTAGENS:
%   + Fornece A⁻¹ diretamente
%   + Verificação simples: A · A⁻¹ = I
%
% DESVANTAGENS:
%   - O(n³) — mais caro que resolver Ax = b diretamente
%   - Acumula mais erros de arredondamento
%   - Inútil se só quiser um vetor solução
%
% FÓRMULA:
%   Monta [A | I] e aplica Gauss-Jordan até obter [I | A⁻¹]
%   Cada coluna de A⁻¹ resulta de resolver Ax = e_i (vetores canônicos)
% -------------------------------------------------------------------------
function matriz_inversa(A)
  n = size(A, 1);
  Aug = [A, eye(n)];

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║       MATRIZ INVERSA via Gauss-Jordan            ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n--- Matriz aumentada inicial [A | I] ---\n');
  print_aug(Aug);

  for k = 1:n
    if abs(Aug(k,k)) < 1e-12
      fprintf('  ERRO: pivô nulo na coluna %d — matriz singular!\n', k);
      return;
    end
    piv = Aug(k,k);
    Aug(k,:) = Aug(k,:) / piv;
    fprintf('\n  Passo %d — normaliza L%d (÷ %.4g)\n', k, k, piv);
    for i = 1:n
      if i ~= k && abs(Aug(i,k)) > 1e-14
        Aug(i,:) = Aug(i,:) - Aug(i,k) * Aug(k,:);
      end
    end
    print_aug(Aug);
  end

  Ainv = Aug(:, n+1:end);
  fprintf('\n--- A⁻¹ =\n'); disp(Ainv);

  fprintf('--- Verificação  A × A⁻¹ =\n');
  prod_check = A * Ainv;
  disp(prod_check);
  fprintf('  Erro máx ||A·A⁻¹ - I||∞ = %.2e\n', max(max(abs(prod_check - eye(n)))));
end


% -------------------------------------------------------------------------
% NORMAS DA MATRIZ: ||A||₁ e ||A||∞
%
% QUANDO USAR:
%   Para medir o "tamanho" de uma matriz ou estimar erros (Q6).
%   Passo inicial para calcular número de condição.
%
% PROCEDIMENTO (conforme Q6):
%   1. Normaliza cada linha: divide pelo maior |elemento| da linha
%   2. ||A||∞ = max soma das linhas  = max_i( Σ_j |a_ij| )   (norma de linha)
%   3. ||A||₁ = max soma das colunas = max_j( Σ_i |a_ij| )   (norma de coluna)
%
% NOTA:
%   A normalização escala a matriz antes de calcular as normas,
%   reduzindo a influência de diferentes ordens de magnitude entre linhas.
% -------------------------------------------------------------------------
function normas_matriz(A)
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║     NORMAS DA MATRIZ  ||A||₁  e  ||A||∞          ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  fprintf('\n--- Matriz original A ---\n');
  disp(A);

  % ── Normalização por linhas ────────────────────────────────────────────
  fprintf('--- Normalizando: divide cada linha pelo maior |elemento| ---\n');
  An = zeros(size(A));
  for i = 1:n
    m = max(abs(A(i,:)));
    An(i,:) = A(i,:) / m;
    fprintf('  Linha %d: max|a_%d,j| = %.4g  →  linha / %.4g\n', i, i, m, m);
  end
  fprintf('\n  A normalizada:\n');
  disp(An);

  % ── Norma ∞ (máximo das somas de linha) ────────────────────────────────
  somas_linha = sum(abs(An), 2);
  fprintf('--- Norma infinita ||A||∞ = max(somas das linhas) ---\n');
  for i = 1:n
    fprintf('  Linha %d: Σ|a_%d,j| = %.6f\n', i, i, somas_linha(i));
  end
  norma_inf = max(somas_linha);
  fprintf('  ||A||∞ = %.6f\n', norma_inf);

  % ── Norma 1 (máximo das somas de coluna) ──────────────────────────────
  somas_col = sum(abs(An), 1);
  fprintf('\n--- Norma 1  ||A||₁ = max(somas das colunas) ---\n');
  for j = 1:n
    fprintf('  Coluna %d: Σ|a_i,%d| = %.6f\n', j, j, somas_col(j));
  end
  norma_1 = max(somas_col);
  fprintf('  ||A||₁ = %.6f\n', norma_1);

  fprintf('\n--- Resultado ---\n');
  fprintf('  ||A||∞ = %.6f\n', norma_inf);
  fprintf('  ||A||₁ = %.6f\n', norma_1);
end


% -------------------------------------------------------------------------
% NÚMERO DE CONDIÇÃO
%
% QUANDO USAR:
%   Para avaliar se o sistema é bem ou mal condicionado antes de resolver (Q7).
%   Número de condição alto → solução sensível a erros de arredondamento.
%
% INTERPRETAÇÃO:
%   cond ≈ 1       → bem condicionado (excelente)
%   cond ~ 10²–10⁴ → razoável
%   cond > 10⁶     → mal condicionado (desconfie dos resultados)
%   cond ~ 1/ε_máquina → singular efetivo
%
% FÓRMULA:
%   cond(A) = ||A||∞ · ||A⁻¹||∞
%   onde ||A||∞ = max soma das linhas (sem normalização prévia)
% -------------------------------------------------------------------------
function numero_condicao(A)
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║          NÚMERO DE CONDIÇÃO  cond(A)             ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  fprintf('\n  Matriz A:\n'); disp(A);

  % ── ||A||∞ ──────────────────────────────────────────────────────────────
  normA = max(sum(abs(A), 2));
  fprintf('--- ||A||∞ = max(somas das linhas) = %.6f\n', normA);
  somas = sum(abs(A), 2);
  for i = 1:n
    fprintf('  Linha %d: %.6f\n', i, somas(i));
  end

  % ── Inversa de A ──────────────────────────────────────────────────────
  Aug = [A, eye(n)];
  for k = 1:n
    if abs(Aug(k,k)) < 1e-12
      fprintf('  ERRO: matriz singular — número de condição infinito.\n');
      return;
    end
    Aug(k,:) = Aug(k,:) / Aug(k,k);
    for i = 1:n
      if i ~= k
        Aug(i,:) = Aug(i,:) - Aug(i,k) * Aug(k,:);
      end
    end
  end
  Ainv = Aug(:, n+1:end);
  fprintf('\n  A⁻¹ =\n'); disp(Ainv);

  % ── ||A⁻¹||∞ ──────────────────────────────────────────────────────────
  normAinv = max(sum(abs(Ainv), 2));
  fprintf('--- ||A⁻¹||∞ = %.6f\n', normAinv);

  % ── Número de condição ─────────────────────────────────────────────────
  cond_val = normA * normAinv;
  fprintf('\n--- Resultado ---\n');
  fprintf('  cond(A) = ||A||∞ × ||A⁻¹||∞ = %.6f × %.6f = %.6f\n', ...
          normA, normAinv, cond_val);
  if cond_val < 10
    fprintf('  → Bem condicionado\n');
  elseif cond_val < 1e4
    fprintf('  → Condicionamento razoável\n');
  elseif cond_val < 1e6
    fprintf('  → Mal condicionado — atenção aos resultados\n');
  else
    fprintf('  → MUITO mal condicionado — resultados podem ser inválidos!\n');
  end
end


% -------------------------------------------------------------------------
% JACOBI
%
% QUANDO USAR:
%   Primeira opção iterativa quando a matriz é estritamente diagonal dominante.
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
%
% CRITÉRIO DE CONVERGÊNCIA:
%   Critério de Linhas: |a_ii| > Σ|a_ij| para todo i (j≠i) → garante convergência
%   Raio espectral de C: ρ(C) < 1 → garante convergência
%
% FÓRMULA:
%   x_i^(k+1) = (b_i - Σ a_ij·x_j^(k)) / a_ii   (j ≠ i)
%   Forma matricial: x^(k+1) = C·x^(k) + d
%     C_ij = -a_ij/a_ii  (i≠j),  C_ii = 0
%     d_i  =  b_i/a_ii
% -------------------------------------------------------------------------
function x = jacobi_iter(A, b, x0, tol, max_iter)
  b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║              JACOBI — Iterativo                  ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  % ── Critério de Linhas ─────────────────────────────────────────────────
  fprintf('\n--- Critério de Linhas (Diagonal Dominante) ---\n');
  satisfaz = true;
  for i = 1:n
    s = sum(abs(A(i,:))) - abs(A(i,i));
    ok = abs(A(i,i)) > s;
    fprintf('  Linha %d: |%.4g| %s %.4g  → %s\n', ...
            i, A(i,i), iif(ok,'>','≤'), s, iif(ok,'OK','FALHA'));
    if ~ok, satisfaz = false; end
  end
  fprintf('  %s\n', iif(satisfaz, ...
    '✔ Diagonal dominante: convergência GARANTIDA.', ...
    '✘ AVISO: critério NÃO satisfeito.'));

  % ── Monta C e d ────────────────────────────────────────────────────────
  fprintf('\n--- Montando C e d ---\n');
  C = zeros(n); d = zeros(n,1);
  for i = 1:n
    d(i) = b(i) / A(i,i);
    for j = 1:n
      if i ~= j, C(i,j) = -A(i,j) / A(i,i); end
    end
  end
  fprintf('  C =\n'); disp(C);
  fprintf('  d = ['); fprintf(' %.6f', d); fprintf(' ]\n');
  rho = max(abs(eig(C)));
  fprintf('\n  Raio espectral ρ(C) = %.6f  %s\n', rho, ...
          iif(rho < 1, '< 1 → convergência GARANTIDA.', '≥ 1 → DIVERGÊNCIA possível!'));

  % ── Iterações ──────────────────────────────────────────────────────────
  fprintf('\n--- Iterações (tol = %.4g%%) ---\n', tol);
  hdr = ['%-6s' repmat('  %-12s',1,n) '  %-14s\n'];
  vrs = {'iter'}; for i=1:n, vrs{end+1}=sprintf('x%d',i); end; vrs{end+1}='erro_max(%)';
  fprintf(hdr, vrs{:});
  fprintf('%s\n', repmat('-',1,6+n*14+16));
  row = ['%-6d' repmat('  %-12.6f',1,n) '  %-14.2e\n'];

  x = x0; converged = false;
  for k = 1:max_iter
    x_new = C*x + d;
    erro  = abs((x_new - x) ./ max(abs(x_new), 1e-10)) * 100;
    x     = x_new;
    fprintf(row, k, x, max(erro));
    if max(erro) < tol, converged = true; break; end
  end

  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  fprintf('  %s\n', iif(converged, ...
    sprintf('Convergiu em %d iterações  |  Erro máx: %.2e%%', k, max(erro)), ...
    sprintf('NÃO convergiu em %d iterações  |  Erro máx: %.2e%%', max_iter, max(erro))));
end


% -------------------------------------------------------------------------
% GAUSS-SEIDEL
%
% QUANDO USAR:
%   Quando Jacobi for lento. Converge em ~metade das iterações de Jacobi.
%   Use quando puder aproveitar os valores já atualizados na mesma iteração.
%
% VANTAGENS:
%   + Converge mais rápido que Jacobi (usa x_i já atualizado)
%   + Mesma condição de convergência que Jacobi
%   + Atualiza x in-place (economiza memória)
%
% DESVANTAGENS:
%   - Não paralelizável (cada x_i depende dos anteriores já atualizados)
%   - Pode divergir sem diagonal dominante
%
% CRITÉRIO DE CONVERGÊNCIA — Sassenfeld:
%   β_i = (Σ|a_ij|·β_j [j<i]  +  Σ|a_ij| [j>i]) / |a_ii|
%   Se max(β_i) < 1 → convergência garantida
%
% FÓRMULA:
%   x_i^(k+1) = (b_i - Σ a_ij·x_j^(k+1) [j<i] - Σ a_ij·x_j^(k) [j>i]) / a_ii
% -------------------------------------------------------------------------
function x = seidel_iter(A, b, x0, tol, max_iter)
  b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║          GAUSS-SEIDEL — Iterativo                ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');

  % ── Critério de Sassenfeld ─────────────────────────────────────────────
  fprintf('\n--- Critério de Sassenfeld ---\n');
  fprintf('  β_i = (Σ|a_ij|·β_j [j<i] + Σ|a_ij| [j>i]) / |a_ii|\n\n');
  beta = zeros(n,1);
  for i = 1:n
    s = 0;
    for j = 1:i-1, s = s + abs(A(i,j))*beta(j); end
    for j = i+1:n, s = s + abs(A(i,j)); end
    beta(i) = s / abs(A(i,i));
    fprintf('  β_%d = %.6f\n', i, beta(i));
  end
  fprintf('\n  max(β) = %.6f  %s\n', max(beta), ...
          iif(max(beta)<1,'< 1 → Sassenfeld OK: convergência GARANTIDA.', ...
              '≥ 1 → AVISO: pode não convergir.'));

  % ── Iterações ──────────────────────────────────────────────────────────
  fprintf('\n--- Iterações (tol = %.4g%%) ---\n', tol);
  hdr = ['%-6s' repmat('  %-12s',1,n) '  %-14s\n'];
  vrs = {'iter'}; for i=1:n, vrs{end+1}=sprintf('x%d',i); end; vrs{end+1}='erro_max(%)';
  fprintf(hdr, vrs{:});
  fprintf('%s\n', repmat('-',1,6+n*14+16));
  row = ['%-6d' repmat('  %-12.6f',1,n) '  %-14.2e\n'];

  x = x0; converged = false;
  for k = 1:max_iter
    x_old = x;
    for i = 1:n
      sigma = A(i,:)*x - A(i,i)*x(i);
      x(i)  = (b(i) - sigma) / A(i,i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf(row, k, x, max(erro));
    if max(erro) < tol, converged = true; break; end
  end

  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  fprintf('  %s\n', iif(converged, ...
    sprintf('Convergiu em %d iterações  |  Erro máx: %.2e%%', k, max(erro)), ...
    sprintf('NÃO convergiu em %d iterações  |  Erro máx: %.2e%%', max_iter, max(erro))));
end


% -------------------------------------------------------------------------
% SOR — Successive Over-Relaxation
%
% QUANDO USAR:
%   Quando Gauss-Seidel for lento e quiser acelerar com um fator w (Q10).
%   w = 1 reproduz Gauss-Seidel exatamente (bom ponto de partida).
%
% VANTAGENS:
%   + Pode convergir MUITO mais rápido com w ótimo
%   + w=1 → idêntico a Gauss-Seidel (fácil de validar)
%
% DESVANTAGENS:
%   - Requer escolha cuidadosa de w (w ruim diverge)
%   - Não há fórmula simples para w ótimo em geral
%
% ESCOLHA DE w:
%   0 < w < 1  → sub-relaxação (estabiliza sistemas difíceis)
%   w = 1      → Gauss-Seidel puro
%   1 < w < 2  → super-relaxação (acelera convergência)
%   w ≥ 2      → sempre diverge
%   Dica: teste w = 0.5, 1.0, 1.25, 1.5, 1.75 e compare nº de iterações
%
% FÓRMULA:
%   x_gs_i   = (b_i - sigma) / a_ii          (passo Gauss-Seidel)
%   x_i^(k+1) = w·x_gs_i + (1-w)·x_i^(k)    (relaxação)
% -------------------------------------------------------------------------
function x = sor_iter(A, b, x0, w, tol, max_iter)
  b = b(:); x0 = x0(:);
  n = size(A, 1);

  fprintf('\n');
  fprintf('╔══════════════════════════════════════════════════╗\n');
  fprintf('║      SOR — Successive Over-Relaxation            ║\n');
  fprintf('╚══════════════════════════════════════════════════╝\n');
  fprintf('\n  Fator de relaxação w = %.4f  ', w);
  if     w < 1,   fprintf('(sub-relaxação — mais estável)\n');
  elseif w == 1,  fprintf('(Gauss-Seidel puro)\n');
  elseif w < 2,   fprintf('(super-relaxação — pode acelerar)\n');
  else,           fprintf('AVISO: w ≥ 2 → sempre diverge!\n');
  end

  % ── Verificação diagonal dominante (para SOR é necessária) ────────────
  fprintf('\n--- Verificação diagonal dominante ---\n');
  for i = 1:n
    s = sum(abs(A(i,:))) - abs(A(i,i));
    ok = abs(A(i,i)) > s;
    fprintf('  Linha %d: |%.4g| %s %.4g  → %s\n', i, A(i,i), ...
            iif(ok,'>','≤'), s, iif(ok,'OK','FALHA'));
  end

  % ── Iterações ──────────────────────────────────────────────────────────
  fprintf('\n--- Iterações (w=%.4g, tol=%.4g%%) ---\n', w, tol);
  hdr = ['%-6s' repmat('  %-12s',1,n) '  %-14s\n'];
  vrs = {'iter'}; for i=1:n, vrs{end+1}=sprintf('x%d',i); end; vrs{end+1}='erro_max(%)';
  fprintf(hdr, vrs{:});
  fprintf('%s\n', repmat('-',1,6+n*14+16));
  row = ['%-6d' repmat('  %-12.6f',1,n) '  %-14.2e\n'];

  x = x0; converged = false;
  for k = 1:max_iter
    x_old = x;
    for i = 1:n
      sigma = A(i,:)*x - A(i,i)*x(i);
      x_gs  = (b(i) - sigma) / A(i,i);
      x(i)  = w*x_gs + (1-w)*x_old(i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf(row, k, x, max(erro));
    if max(erro) < tol, converged = true; break; end
  end

  fprintf('\n--- Resultado ---\n');
  fprintf('  x = ['); fprintf(' %.6f', x); fprintf(' ]\n');
  fprintf('  %s\n', iif(converged, ...
    sprintf('Convergiu em %d iterações  |  Erro máx: %.2e%%', k, max(erro)), ...
    sprintf('NÃO convergiu em %d iterações  |  Erro máx: %.2e%%', max_iter, max(erro))));
end


% =========================================================================
%                      FUNÇÕES AUXILIARES INTERNAS
% =========================================================================

% Substituição progressiva: resolve Ly = b (L triangular inferior)
function y = lu_forward(L, b)
  n = length(b); y = zeros(n,1);
  for i = 1:n
    y(i) = (b(i) - L(i,1:i-1)*y(1:i-1)) / L(i,i);
  end
end

% Retro-substituição: resolve Ux = y (U triangular superior)
function x = lu_backward(U, y)
  n = length(y); x = zeros(n,1);
  for i = n:-1:1
    x(i) = (y(i) - U(i,i+1:n)*x(i+1:n)) / U(i,i);
  end
end

% Imprime matriz aumentada formatada
function print_aug(Aug)
  [m, nc] = size(Aug);
  n = nc - 1;
  for i = 1:m
    fprintf('  |');
    for j = 1:n
      fprintf(' %8.4f', Aug(i,j));
    end
    fprintf('  |  %8.4f |\n', Aug(i,end));
  end
  fprintf('\n');
end

% Condicional inline: iif(cond, a, b)
function r = iif(cond, a, b)
  if cond, r = a; else, r = b; end
end