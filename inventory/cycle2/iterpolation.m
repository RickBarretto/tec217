% =========================================================================
% MAIN.M — Script de prova: iterações dos métodos de interpolação
% =========================================================================
%
% COMO CONFIGURAR (apenas 3 variáveis):
%
%   x       → vetor com os nós de interpolação
%   f       → vetor com os valores f(x_i) em cada nó
%   xav     → ponto onde você quer estimar o valor
%
% COMO ESCOLHER O MÉTODO:
%
%   Descomente UMA das três chamadas na seção "EXECUTE UM MÉTODO".
%   As outras duas ficam comentadas com %.
%
% FUNÇÃO DE REFERÊNCIA (opcional):
%
%   f_exata → se o enunciado der a função analítica, coloque aqui.
%             Se não houver, troque por:  f_exata = [];
%
% =========================================================================

clc; clear; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'methods'));

% =========================================================================
%                  <<< CONFIGURE AQUI >>>
% =========================================================================

x       = [0, 0.5, 1.0];         % nós de interpolação
f       = [1.0, 2.12, 3.55];     % valores f(x_i)
xav     = 0.7;                    % ponto de avaliação

f_exata = @(t) exp(t) + sin(t);  % função exata — ou [] se não souber

% =========================================================================
%              <<< EXECUTE UM MÉTODO (descomente um) >>>
% =========================================================================

[val, coef] = newton_iter(x, f, xav);
% [val, coef] = lagrange_iter(x, f, xav);
% [val, coef] = vandermonde_iter(x, f, xav);

% =========================================================================
% Resultado final
% =========================================================================

fprintf('\nP(%g) = %.6f\n', xav, val);

if ~isempty(f_exata)
  exato = f_exata(xav);
  fprintf('f(%g) = %.6f  (valor exato)\n', xav, exato);
  fprintf('Erro  = %.2e\n', abs(val - exato));
end

% =========================================================================
% -------------------------------------------------------------------------
%  IMPLEMENTAÇÕES LOCAIS — não precisa mexer aqui
% -------------------------------------------------------------------------
% =========================================================================

% -------------------------------------------------------------------------
% NEWTON — Diferenças Divididas + Horner
%
%  O que mostra:
%    • Tabela de diferenças divididas completa (DD)
%    • Coeficientes b0, b1, ..., bn-1
%    • Passo a passo do Algoritmo de Horner
% -------------------------------------------------------------------------
function [val, b] = newton_iter(x, f, xav)
  x = x(:)'; f = f(:)'; n = length(x);

  fprintf('\n=== NEWTON — Diferenças Divididas ===\n');

  % Monta tabela DD
  DD = zeros(n,n);
  DD(:,1) = f(:);
  for j = 2:n
    for i = 1:n-j+1
      DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x(i+j-1) - x(i));
    end
  end

  % Imprime tabela
  fprintf('\nTabela de Diferenças Divididas:\n');
  fprintf('%-6s', 'i'); fprintf('%-10s','x_i'); fprintf('%-12s','f[ ]');
  for j=2:n; fprintf('%-14s', sprintf('f[%s]', repmat('*,',1,j-1))); end
  fprintf('\n');
  for i=1:n
    fprintf('%-6d%-10g', i, x(i));
    for j=1:n-i+1
      fprintf('%-14.6f', DD(i,j));
    end
    fprintf('\n');
  end

  b = DD(1,:);
  fprintf('\nCoeficientes de Newton:\n');
  for k=1:n; fprintf('  b%d = %.6f\n', k-1, b(k)); end

  % Horner
  fprintf('\nHorner — avaliação em x = %g:\n', xav);
  val = b(n);
  fprintf('  passo inicial: val = b%d = %.6f\n', n-1, val);
  for k = n-1:-1:1
    val = val*(xav - x(k)) + b(k);
    fprintf('  k=%d: val = val*(%.4g - %.4g) + %.6f = %.6f\n', ...
            k, xav, x(k), b(k), val);
  end
end

% -------------------------------------------------------------------------
% LAGRANGE — Bases polinomiais
%
%  O que mostra:
%    • Cálculo de cada L_i(xav) com os produtos explícitos
%    • Contribuição de cada nó: f_i * L_i(xav)
%    • Soma final
% -------------------------------------------------------------------------
function [val, Lvals] = lagrange_iter(x, f, xav)
  x = x(:)'; f = f(:)'; n = length(x);

  fprintf('\n=== LAGRANGE — Bases polinomiais ===\n');
  fprintf('\nAvaliação em x = %g:\n', xav);

  Lvals = zeros(1,n);
  val = 0;
  for i = 1:n
    idx = [1:i-1, i+1:n];          % índices j ≠ i
    num = prod(xav - x(idx));
    den = prod(x(i)  - x(idx));
    Lvals(i) = num / den;

    fprintf('\n  L_%d(x):\n', i-1);
    fprintf('    numerador  = prod(%.4g - [', xav);
    fprintf(' %.4g', x(idx)); fprintf(' ]) = %.6f\n', num);
    fprintf('    denominador= prod(%.4g - [', x(i));
    fprintf(' %.4g', x(idx)); fprintf(' ]) = %.6f\n', den);
    fprintf('    L_%d(%.4g) = %.6f\n', i-1, xav, Lvals(i));
    fprintf('    f_%d * L_%d = %.6f * %.6f = %.6f\n', ...
            i-1, i-1, f(i), Lvals(i), f(i)*Lvals(i));
    val = val + f(i)*Lvals(i);
  end

  fprintf('\nSoma total P(%g) = ', xav);
  for i=1:n
    if i>1; fprintf(' + '); end
    fprintf('%.6f', f(i)*Lvals(i));
  end
  fprintf(' = %.6f\n', val);
end

% -------------------------------------------------------------------------
% VANDERMONDE — Sistema linear V*a = f
%
%  O que mostra:
%    • Matriz de Vandermonde montada
%    • Vetor de coeficientes a0, a1, ..., an-1
%    • Número de condição (alerta de instabilidade)
%    • Avaliação via Horner
% -------------------------------------------------------------------------
function [val, a] = vandermonde_iter(x, f, xav)
  x = x(:); f = f(:); n = length(x);

  fprintf('\n=== VANDERMONDE — Sistema Linear ===\n');

  % Monta V
  V = zeros(n,n);
  for j=1:n; V(:,j) = x.^(j-1); end

  fprintf('\nMatriz de Vandermonde V:\n');
  for i=1:n
    fprintf('  [');
    fprintf(' %10.4f', V(i,:));
    fprintf('  ]\n');
  end

  cond_V = cond(V);
  fprintf('\nNúmero de condição de V: %.4e', cond_V);
  if cond_V > 1e8
    fprintf('  *** ATENÇÃO: matriz mal condicionada! ***');
  end
  fprintf('\n');

  a = V \ f;
  fprintf('\nCoeficientes monomiais (P(x) = a0 + a1*x + a2*x^2 + ...):\n');
  for k=1:n; fprintf('  a%d = %.6f\n', k-1, a(k)); end

  % Horner
  fprintf('\nHorner — avaliação em x = %g:\n', xav);
  val = a(n);
  fprintf('  passo inicial: val = a%d = %.6f\n', n-1, val);
  for k = n-1:-1:1
    val = val*xav + a(k);
    fprintf('  k=%d: val = val*%.4g + %.6f = %.6f\n', k, xav, a(k), val);
  end
end