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
