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