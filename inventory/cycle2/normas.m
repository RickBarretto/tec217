% =========================================================================
%                <<< NORMAS DE MATRIZ (OPCIONAL) >>>
% =========================================================================
%
% COMO USAR:
%   A → matriz que você já definiu acima
%
% DESCOMENTE para calcular:
%
%   n1   = norm1_matrix(A);
%   ninf = norminf_matrix(A);
%
% OBS:
%   - Pode usar antes de rodar Jacobi/Seidel/SOR
%   - Útil para análise de convergência (ex: ||C|| < 1)
%
% =========================================================================

A = [10  2 -1;
     -3 -6  2;
      1  1  5];

n1   = norm1_matrix(A);
% ninf = norminf_matrix(A);
