A = [10  3 -2;
      2  8 -1;
      1  1  5];
b = [57; 20; -4];
tol = 0.0005;
max_iter = 100;
x0 = [0; 0; 0];
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
fprintf('beta = [%.4f  %.4f  %.4f]\n', beta(1), beta(2), beta(3));
if max(beta) < 1
    disp('Critério de Sassenfeld satisfeito: convergência garantida.')
else
    disp('AVISO: critério de Sassenfeld NÃO satisfeito.')
end

# ── Iterações ───────────────────────────────────────────────────────────────
disp(''); disp('=== Iterações Gauss-Seidel ===');
fprintf('%-6s  %-10s  %-10s  %-10s  %-12s\n', 'iter', 'x1', 'x2', 'x3', 'erro_max(%)');
x = x0;
for k = 1:max_iter
    x_old = x;
    for i = 1:n
        sigma = A(i,:) * x - A(i,i) * x(i);
        x(i) = (b(i) - sigma) / A(i,i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf('%-6d  %-10.6f  %-10.6f  %-10.6f  %-12.2e\n', k, x(1), x(2), x(3), max(erro));
    if max(erro) < tol, break, end
end

# ── Resultado ───────────────────────────────────────────────────────────────
disp(''); disp('=== Resultado ===');
fprintf('x = [%.6f  %.6f  %.6f]\n', x(1), x(2), x(3));
fprintf('Iterações: %d  |  Erro máx: %.2e\n', k, max(erro));