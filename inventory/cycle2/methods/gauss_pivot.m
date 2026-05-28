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
