A = [ 2 -1  0  0;
     -1  2 -1  0;
      0 -1  2 -1;
      0  0 -1  2];
b = [1; 2; 9; 11];
tol = 0.0005;
max_iter = 10;
x0 = [0; 0; 0; 0];
n = size(A, 1);

# ── Critério de Linhas ──────────────────────────────────────────────────────
disp('=== Critério de Linhas ===');
satisfaz = true;
for i = 1:n
    if abs(A(i,i)) <= sum(abs(A(i,:))) - abs(A(i,i))
        satisfaz = false;
    end
end
if satisfaz
    disp('Diagonal estritamente dominante: convergência garantida.')
else
    disp('AVISO: critério de diagonal dominante NÃO satisfeito.')
end

# ── Monta C e d ─────────────────────────────────────────────────────────────
disp(''); disp('=== Montando C e d ===');
C = zeros(n);
d = zeros(n, 1);
for i = 1:n
    d(i) = b(i) / A(i,i);
    for j = 1:n
        if i ~= j
            C(i,j) = -A(i,j) / A(i,i);
        end
    end
end
disp('C ='); disp(C);
fprintf('d = [%.4f  %.4f  %.4f  %.4f]\n', d(1), d(2), d(3), d(4));

# ── Iterações ───────────────────────────────────────────────────────────────
disp(''); disp('=== Iterações Jacobi ===');
fprintf('%-6s  %-10s  %-10s  %-10s  %-10s  %-12s\n', 'iter', 'x1', 'x2', 'x3', 'x4', 'erro_max(%)');
x = x0;
converged = false;
for k = 1:max_iter
    x_new = C * x + d;
    erro = abs((x_new - x) ./ max(abs(x_new), 1e-10)) * 100;
    x = x_new;
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