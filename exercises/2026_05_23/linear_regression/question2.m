x = [10 20 30 40 50 60 70 80]';
y = [25 70 380 550 610 1220 830 1450]';

n = length(x);
if length(y) != n
  error("x e y devem ter o mesmo tamanho");
end

X = log(x);
Y = log(y);

sum_X  = sum(X);
sum_Y  = sum(Y);
sum_XY = sum(X .* Y);
sum_X2 = sum(X .^ 2);

m  = (n*sum_XY - sum_X*sum_Y) / (n*sum_X2 - sum_X^2);
lb = (sum_Y - m*sum_X) / n;
b  = exp(lb);

Y_med = mean(Y);
St = sum((Y - Y_med).^2);
Sr = sum((Y - lb - m.*X).^2);

Sy   = sqrt(St / (n-1));
Sy_x = sqrt(Sr / (n-2));
r2   = (St - Sr) / St;

printf("m  (expoente)    = %.4f\n", m);
printf("b  (coeficiente) = %.4f\n", b);
printf("Modelo: y = %.4f * x^%.4f\n", b, m);
printf("Sy   = %.4f\n", Sy);
printf("Sy/x = %.4f\n", Sy_x);
printf("r²   = %.4f\n", r2);

x_plot = linspace(min(x), max(x), 300);
y_plot = b .* x_plot .^ m;

figure;

subplot(1, 2, 1);
plot(x, y, 'bo', 'MarkerFaceColor', 'b');
hold on;
plot(x_plot, y_plot, 'r-', 'LineWidth', 1.5);
xlabel('x'); ylabel('y');
title(sprintf('Espaço original | r² = %.4f', r2));
legend('Dados', sprintf('y = %.3f·x^{%.3f}', b, m));
grid on;

subplot(1, 2, 2);
plot(X, Y, 'bo', 'MarkerFaceColor', 'b');
hold on;
plot(log(x_plot), lb + m.*log(x_plot), 'r-', 'LineWidth', 1.5);
xlabel('ln(x)'); ylabel('ln(y)');
title('Espaço linearizado (log-log)');
legend('Dados (log)', 'Regressão linear');
grid on;