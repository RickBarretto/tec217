% =========================================================================
% GAUSS.M — Métodos de Eliminação de Gauss (funções reutilizáveis)
% =========================================================================
%
% MÉTODOS DISPONÍVEIS:
%
%   gauss_simples(A, b)      → Eliminação de Gauss sem pivotamento
%   gauss_pivot(A, b)        → Eliminação de Gauss com pivotamento parcial
%
% COMO USAR:
%
%   1. Defina a matriz A e o vetor b com os coeficientes do sistema.
%   2. Chame UMA das funções abaixo (descomente a que quiser).
%   3. A solução é retornada em x = [x1; x2; x3; ...].
%
% QUANDO USAR CADA MÉTODO:
%
%   gauss_simples  → quando o sistema é bem comportado, sem divisão por
%                    zero durante a eliminação (pivô nunca é zero ou
%                    muito pequeno).
%
%   gauss_pivot    → quando o sistema pode ter pivôs pequenos ou nulos.
%                    Mais estável numericamente. Preferível na maioria
%                    dos casos reais.
%
% CONFIGURAÇÃO (altere apenas estas variáveis):
%
%   A   → matriz dos coeficientes (n×n)
%   b   → vetor dos termos independentes (n×1)
%
% =========================================================================

clc; clear;

addpath(fullfile(fileparts(mfilename('fullpath')), 'methods'));

% =========================================================================
% -------------------------------------------------------------------------
%  IMPLEMENTAÇÕES — não precisa mexer aqui
% -------------------------------------------------------------------------
% =========================================================================


% -------------------------------------------------------------------------
% GAUSS SIMPLES — Eliminação sem pivotamento
%
%  O que é:
%    Transforma o sistema Ax=b em um sistema triangular superior usando
%    operações elementares de linha (subtração de múltiplos de linhas).
%    Em seguida, resolve por substituição retroativa.
%
%  Vantagens:
%    + Simples de entender e implementar
%    + Mostra claramente cada passo da eliminação
%    + Suficiente quando os pivôs não são nulos ou muito pequenos
%
%  Desvantagens:
%    - Falha (divisão por zero) se algum pivô for exatamente zero
%    - Instável quando pivôs são muito pequenos (erros de arredondamento)
%    - Não reordena linhas, o que pode amplificar erros numéricos
%
%  Parâmetros:
%    A  → matriz dos coeficientes (n×n), deve ser quadrada e não-singular
%    b  → vetor dos termos independentes (n×1)
%
%  Retorna:
%    x  → vetor solução (n×1)
% -------------------------------------------------------------------------
function x = gauss_simples(A, b)

  % --- Validações ---
  [r, c] = size(A);
  if r ~= c
    error('ERRO: Matriz A deve ser quadrada!');
  end

  d = det(A);
  n = length(b);

  printf('\n=========================================\n');
  printf('  MÉTODO: GAUSS SIMPLES\n');
  printf('=========================================\n');

  printf('\nVerificação: det(A) = %.6f\n', d);
  if abs(d) < 1e-12
    error('ERRO: det(A) ≈ 0. Sistema sem solução única!');
  else
    printf('Matriz não-singular. Prosseguindo.\n');
  end

  % --- Monta matriz aumentada [A|b] ---
  Ab = [A, b];

  printf('\nMatriz aumentada inicial [A|b]:\n');
  imprime_aumentada(Ab);

  % --- Eliminação progressiva ---
  printf('\n--- ELIMINAÇÃO PROGRESSIVA ---\n');

  for k = 1 : n-1
    printf('\nPasso k = %d  (coluna pivô %d, pivô = %.4f)\n', k, k, Ab(k,k));

    if abs(Ab(k,k)) < 1e-12
      error('ERRO: Pivô nulo no passo k=%d. Use gauss_pivot!', k);
    end

    for i = k+1 : n
      fator = Ab(i,k) / Ab(k,k);
      printf('  L%d <- L%d - (%.4f/%.4f)*L%d   fator = %.6f\n', ...
             i, i, Ab(i,k), Ab(k,k), k, fator);

      % Atualiza linha i
      Ab(i, k:n+1) = Ab(i, k:n+1) - fator * Ab(k, k:n+1);

      printf('  Linha %d resultante: ', i);
      printf('%8.4f ', Ab(i,:));
      printf('\n');
    end

    printf('\nMatriz aumentada após passo k = %d:\n', k);
    imprime_aumentada(Ab);
  end

  % --- Substituição retroativa ---
  x = substituicao_retroativa(Ab, n);

end


% -------------------------------------------------------------------------
% GAUSS COM PIVOTAMENTO PARCIAL — Eliminação com seleção do maior pivô
%
%  O que é:
%    Igual ao Gauss Simples, mas antes de cada passo de eliminação busca
%    o maior valor absoluto na coluna (entre as linhas restantes) e troca
%    essa linha para a posição de pivô. Isso evita divisão por zero e
%    reduz erros de arredondamento.
%
%  Vantagens:
%    + Numericamente mais estável que o Gauss Simples
%    + Evita falha por pivô nulo (salvo sistema singular)
%    + Recomendado para uso geral e sistemas mal condicionados
%    + Mesma complexidade computacional do Gauss Simples: O(n³)
%
%  Desvantagens:
%    - Requer troca de linhas, o que aumenta levemente a complexidade
%      de implementação (mas não o custo computacional)
%    - Pivotamento parcial não garante estabilidade para matrizes
%      muito mal condicionadas (apenas pivotamento completo garantiria)
%
%  Parâmetros:
%    A  → matriz dos coeficientes (n×n), deve ser quadrada e não-singular
%    b  → vetor dos termos independentes (n×1)
%
%  Retorna:
%    x  → vetor solução (n×1)
% -------------------------------------------------------------------------
function x = gauss_pivot(A, b)

  % --- Validações ---
  [r, c] = size(A);
  if r ~= c
    error('ERRO: Matriz A deve ser quadrada!');
  end

  d = det(A);
  n = length(b);

  printf('\n=========================================\n');
  printf('  MÉTODO: GAUSS COM PIVOTAMENTO PARCIAL\n');
  printf('=========================================\n');

  printf('\nVerificação: det(A) = %.6f\n', d);
  if abs(d) < 1e-12
    error('ERRO: det(A) ≈ 0. Sistema sem solução única!');
  else
    printf('Matriz não-singular. Prosseguindo.\n');
  end

  % --- Monta matriz aumentada [A|b] ---
  Ab = [A, b];

  printf('\nMatriz aumentada inicial [A|b]:\n');
  imprime_aumentada(Ab);

  % --- Eliminação progressiva com pivotamento ---
  printf('\n--- ELIMINAÇÃO COM PIVOTAMENTO PARCIAL ---\n');

  for k = 1 : n-1
    printf('\nPasso k = %d\n', k);

    % Busca maior pivô na coluna k
    printf('  Buscando pivô máximo na coluna %d (linhas %d até %d):\n', k, k, n);
    p   = k;
    Max = abs(Ab(k,k));

    for ii = k+1 : n
      teste = abs(Ab(ii,k));
      printf('    |a(%d,%d)| = %.4f', ii, k, teste);
      if teste > Max
        Max = teste;
        p   = ii;
        printf('  <-- novo máximo');
      end
      printf('\n');
    end

    printf('  Pivô máximo: |a(%d,%d)| = %.4f\n', p, k, Max);

    % Troca de linhas (se necessário)
    if p ~= k
      printf('  Pivotamento: trocando linha %d <-> linha %d\n', k, p);
      temp    = Ab(p,:);
      Ab(p,:) = Ab(k,:);
      Ab(k,:) = temp;
      printf('  Matriz após troca:\n');
      imprime_aumentada(Ab);
    else
      printf('  Sem troca (linha %d já tem o maior pivô).\n', k);
    end

    % Eliminação abaixo do pivô
    printf('\n  Eliminação (pivô = %.4f):\n', Ab(k,k));

    for i = k+1 : n
      fator = Ab(i,k) / Ab(k,k);
      printf('  L%d <- L%d - (%.4f/%.4f)*L%d   fator = %.6f\n', ...
             i, i, Ab(i,k), Ab(k,k), k, fator);

      Ab(i, k:n+1) = Ab(i, k:n+1) - fator * Ab(k, k:n+1);

      printf('  Linha %d resultante: ', i);
      printf('%8.4f ', Ab(i,:));
      printf('\n');
    end

    printf('\nMatriz aumentada após passo k = %d:\n', k);
    imprime_aumentada(Ab);
  end

  % --- Substituição retroativa ---
  x = substituicao_retroativa(Ab, n);

end


% -------------------------------------------------------------------------
% SUBSTITUIÇÃO RETROATIVA — resolve sistema triangular superior
%
%  Função auxiliar compartilhada pelos dois métodos.
%  Recebe a matriz aumentada já triangularizada e resolve de baixo para cima.
% -------------------------------------------------------------------------
function x = substituicao_retroativa(Ab, n)

  printf('\n--- SUBSTITUIÇÃO RETROATIVA ---\n');

  x = zeros(n, 1);

  % Última variável
  x(n) = Ab(n, n+1) / Ab(n, n);
  printf('\nx(%d) = %.6f / %.6f = %.6f\n', n, Ab(n,n+1), Ab(n,n), x(n));

  % Demais variáveis (de baixo para cima)
  for i = n-1 : -1 : 1
    soma = Ab(i, n+1);
    printf('\nx(%d): soma inicial = %.6f\n', i, soma);

    for j = i+1 : n
      printf('  soma <- %.6f - (%.6f)*(%.6f) = %.6f\n', ...
             soma, Ab(i,j), x(j), soma - Ab(i,j)*x(j));
      soma = soma - Ab(i,j) * x(j);
    end

    x(i) = soma / Ab(i,i);
    printf('x(%d) = %.6f / %.6f = %.6f\n', i, soma, Ab(i,i), x(i));
  end

end


% -------------------------------------------------------------------------
% IMPRIME AUMENTADA — exibe a matriz [A|b] formatada
%
%  Função auxiliar de exibição. Funciona para qualquer n.
% -------------------------------------------------------------------------
function imprime_aumentada(Ab)
  [nr, nc] = size(Ab);
  nc_A = nc - 1;  % número de colunas de A
  for i = 1 : nr
    printf(' ');
    for j = 1 : nc_A
      printf('%8.4f  ', Ab(i,j));
    end
    printf('|  %8.4f\n', Ab(i,nc));
  end
end

% =========================================================================
%                  <<< CONFIGURE AQUI >>>
% =========================================================================

% --- Exemplo 1: Gauss Simples ---
A = [ 10,  2, -1;
      -3, -5,  2;
       1,  1,  6 ];

b = [ 27; -61.5; -21.5 ];

% --- Exemplo 2: Gauss com Pivotamento (troque A e b abaixo) ---
% A = [  2, -6, -1;
%       -3, -1,  7;
%       -8,  1, -2 ];
%
% b = [ -38; -34; -20 ];

% =========================================================================
%           <<< EXECUTE UM MÉTODO (descomente um) >>>
% =========================================================================

x = gauss_simples(A, b);
% x = gauss_pivot(A, b);

% =========================================================================
% Resultado final
% =========================================================================

printf('\n');
printf('=========================================\n');
printf('  SOLUÇÃO DO SISTEMA\n');
printf('=========================================\n');
for i = 1 : length(x)
  printf('  x%d = %12.6f\n', i, x(i));
end
printf('=========================================\n');
