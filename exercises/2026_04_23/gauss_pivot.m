
A = [  2, -6, -1;
      -3, -1,  7;
      -8,  1, -2 ];

b = [ -38; -34; -20 ];

n = length(b);

printf('Sistema originsl:\n');
printf('   2*x1 - 6*x2 -  x3 = -38\n');
printf('  -3*x1 -  x2 + 7*x3 = -34\n');
printf('  -8*x1 +  x2 - 2*x3 = -20\n\n');

[r, c] = size(A);
if r ~= c
  error('ERRO: Matriz A deve ser quadrada!');
end

d = det(A);
printf('Verificação: det(A) = %.6f\n', d);
if abs(d) < 1e-12
  error('ERRO: det(A) ≈ 0. Sistema sem solução única!');
else
  printf('Matriz não-singular. Prosseguindo com a eliminação.\n\n');
end

Ab = [A, b];

imprime_matriz = @(M) printf( ...
  '  %8.4f  %8.4f  %8.4f  |  %8.4f\n', M(1,:), M(2,:), M(3,:));

printf('Matriz aumentada inicial [A|b]:\n');
imprime_matriz(Ab);
printf('\n');

printf('Eliminação progressiva por pivotamento parcial\n');

for k = 1 : n-1

  % ------------------------------------------------------------
  % Busca o maior |a(i,k)| em i = k..n
  % ------------------------------------------------------------
  printf('\n--- Passo k = %d ---\n', k);
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
    printf('  >>> Pivotamento: trocando linha %d <-> linha %d\n', k, p);

    for jj = k : n+1
      temp      = Ab(p,jj);
      Ab(p,jj)  = Ab(k,jj);
      Ab(k,jj)  = temp;
    end

    % Também troca o vetor b (já embutido em Ab, mas mostra claramente)
    printf('  Matriz após troca:\n');
    imprime_matriz(Ab);
  else
    printf('  Sem troca necessária (linha %d já tem o maior pivô).\n', k);
  end

  % ELIMINAÇÃO da coluna k abaixo do pivô
  printf('\n  Eliminação (pivô = %.4f):\n', Ab(k,k));

  for i = k+1 : n
    fator = Ab(i,k) / Ab(k,k);
    printf('  L%d <- L%d - (%.4f / %.4f) * L%d    fator = %.6f\n', ...
           i, i, Ab(i,k), Ab(k,k), k, fator);

    for j = k : n+1
      Ab(i,j) = Ab(i,j) - fator * Ab(k,j);
    end

    printf('  Linha %d resultante: ', i);
    printf('%8.4f ', Ab(i,:));
    printf('\n');
  end

  printf('\nMatriz aumentada após passo k = %d:\n', k);
  imprime_matriz(Ab);
end

printf('Substituição retroativa\n');

x = zeros(n, 1);

% Última variável
x(n) = Ab(n, n+1) / Ab(n, n);
printf('\nx(%d) = b(%d) / a(%d,%d)  =  %.6f / %.6f  =  %.6f\n', ...
       n, n, n, n, Ab(n, n+1), Ab(n, n), x(n));

% Demais variáveis (de baixo para cima)
for i = n-1 : -1 : 1
  soma = Ab(i, n+1);
  printf('\nx(%d): soma inicial = b(%d) = %.6f\n', i, i, soma);
  for j = i+1 : n
    printf('  soma <- %.6f - (%.6f)*(%.6f) = %.6f\n', ...
           soma, Ab(i,j), x(j), soma - Ab(i,j)*x(j));
    soma = soma - Ab(i,j) * x(j);
  end
  x(i) = soma / Ab(i,i);
  printf('x(%d) = %.6f / %.6f = %.6f\n', i, soma, Ab(i,i), x(i));
end

printf('Solução Final\n');
printf('  x1 = %12.6f\n', x(1));
printf('  x2 = %12.6f\n', x(2));
printf('  x3 = %12.6f\n', x(3));
