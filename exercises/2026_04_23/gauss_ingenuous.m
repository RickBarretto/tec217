A = [ 10,  2, -1;
      -3, -5,  2;
       1,  1,  6 ];

b = [ 27; -61.5; -21.5 ];

n = length(b);

printf('Sistema original:\n');
printf('  10*x1 + 2*x2 -  x3 =  27\n');
printf('  -3*x1 - 5*x2 + 2*x3 = -61.5\n');
printf('   1*x1 + 1*x2 + 6*x3 = -21.5\n\n');


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

printf('Matriz aumentada inicial [A|b]:\n');
printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(1,:));
printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(2,:));
printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(3,:));
printf('\n');


% ---------------------------------------------------------------


printf('Eliminação Progressiva\n');

for k = 1 : n-1
  printf('\n--- Passo k = %d  (coluna pivô %d, pivô = %.4f) ---\n', k, k, Ab(k,k));

  for i = k+1 : n
    fator = Ab(i,k) / Ab(k,k);
    printf('  L%d <- L%d - (%.4f/%.4f) * L%d    fator = %.6f\n', ...
           i, i, Ab(i,k), Ab(k,k), k, fator);

    % Atualiza linha i
    for j = k : n+1
      Ab(i,j) = Ab(i,j) - fator * Ab(k,j);
    end

    printf('  Linha %d resultante: ', i);
    printf('%8.4f ', Ab(i,:));
    printf('\n');
  end

  printf('\nMatriz aumentada após passo k = %d:\n', k);
  printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(1,:));
  printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(2,:));
  printf('  %8.4f  %8.4f  %8.4f  |  %8.4f\n', Ab(3,:));
end

% ---------------------------------------------------------------

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

% ---------------------------------------------------------------

printf('Solução FInal\n');
printf('  x1 = %12.6f\n', x(1));
printf('  x2 = %12.6f\n', x(2));
printf('  x3 = %12.6f\n', x(3));

