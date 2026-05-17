A = [ 2 -1  0  0;
     -1  2 -1  0;
      0 -1  2 -1;
      0  0 -1  2];
b = [1; 2; 9; 11];
tol = 0.0005;
max_iter = 10;
x0 = [0; 0; 0; 0];
n = size(A, 1);

# ── Critério de Sassenfeld ───────────────────────────────────────────────────
disp('=== Critério de Sassenfeld ===');
beta = zeros(n, 1);
for i = 1:n
    s = 0;
    for j = 1:i-1
        s += abs(A(i,j)) * beta(j);
    end
    for j = i+1:n
        s += abs(A(i,j));
    end
    beta(i) = s / abs(A(i,i));
end
fprintf('beta = [%.4f  %.4f  %.4f  %.4f]\n', beta(1), beta(2), beta(3), beta(4));
if max(beta) < 1
    disp('Critério de Sassenfeld satisfeito: convergência garantida.')
else
    disp('AVISO: critério de Sassenfeld NÃO satisfeito.')
end

# ── Iterações ───────────────────────────────────────────────────────────────
disp(''); disp('=== Iterações Gauss-Seidel ===');
fprintf('%-6s  %-10s  %-10s  %-10s  %-10s  %-12s\n', 'iter', 'x1', 'x2', 'x3', 'x4', 'erro_max(%)');
x = x0;
converged = false;
for k = 1:max_iter
    x_old = x;
    for i = 1:n
        sigma = A(i,:) * x - A(i,i) * x(i);
        x(i) = (b(i) - sigma) / A(i,i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf('%-6d  %-10.4f  %-10.4f  %-10.4f  %-10.4f  %-12.2e\n', k, x(1), x(2), x(3), x(4), max(erro));
    if max(erro) < tol, converged = true; break, end
end

# ── Resultado ───────────────────────────────────────────────────────────────
disp(''); disp('=== Resultado ===');
fprintf('x = [%.4f  %.4f  %.4f  %.4f]\n', x(1), x(2), x(3), x(4));
if converged
    fprintf('Convergiu em %d iterações  |  Erro máx: %.2e\n', k, max(erro));
else
    fprintf('NÃO convergiu em %d iterações  |  Erro máx: %.2e\n', max_iter, max(erro));
end