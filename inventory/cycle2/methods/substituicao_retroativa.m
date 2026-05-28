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
