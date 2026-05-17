A = [10  3 -2;
      2  8 -1;
      1  1  5];
b = [57; 20; -4];
tol = 0.0005;
max_iter = 100;
x0 = [0; 0; 0];
w = 1.25;
n = size(A, 1);

# ── Iterações SOR ───────────────────────────────────────────────────────────
disp('=== Iterações SOR ===');
fprintf('w = %.2f\n', w);
fprintf('%-6s  %-10s  %-10s  %-10s  %-12s\n', 'iter', 'x1', 'x2', 'x3', 'erro_max(%)');
x = x0;
for k = 1:max_iter
    x_old = x;
    for i = 1:n
        sigma = A(i,:) * x - A(i,i) * x(i);
        x_gs = (b(i) - sigma) / A(i,i);
        x(i) = w * x_gs + (1 - w) * x_old(i);
    end
    erro = abs((x - x_old) ./ max(abs(x), 1e-10)) * 100;
    fprintf('%-6d  %-10.6f  %-10.6f  %-10.6f  %-12.2e\n', k, x(1), x(2), x(3), max(erro));
    if max(erro) < tol, break, end
end

# ── Resultado ───────────────────────────────────────────────────────────────
disp(''); disp('=== Resultado ===');
fprintf('x = [%.6f  %.6f  %.6f]\n', x(1), x(2), x(3));
fprintf('Iterações: %d  |  Erro máx: %.2e\n', k, max(erro));