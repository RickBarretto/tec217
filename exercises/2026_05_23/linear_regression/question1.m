x = [1 2 3 4 5 6 7 8 9 10]';
y = [1.3 3.5 4.2 5.0 7.0 8.8 10.1 12.5 13.0 15.6]';

n = length(x);
if length(y) != n
  error("x e y devem ter o mesmo tamanho");
end

sum_x  = sum(x);
sum_y  = sum(y);
sum_xy = sum(x .* y);
sum_x2 = sum(x .^ 2);

a1 = (n*sum_xy - sum_x*sum_y) / (n*sum_x2 - sum_x^2);
a2 = (sum_y - a1*sum_x) / n;

y_med = mean(y);
St = sum((y - y_med).^2);
Sr = sum((y - a2 - a1.*x).^2);

Sy   = sqrt(St / (n-1));
Sy_x = sqrt(Sr / (n-2));
r2   = (St - Sr) / St;

printf("a1 (inclinação)  = %.4f\n", a1);
printf("a2 (interseção)  = %.4f\n", a2);
printf("Sy   = %.4f\n", Sy);
printf("Sy/x = %.4f\n", Sy_x);
printf("r²   = %.4f\n", r2);

x_plot = linspace(min(x), max(x), 200);
y_plot = a1*x_plot + a2;

figure;
plot(x, y, 'bo', 'MarkerFaceColor', 'b');
hold on;
plot(x_plot, y_plot, 'r-', 'LineWidth', 1.5);
xlabel('x'); ylabel('y');
title(sprintf('Regressão Linear | r² = %.4f', r2));
legend('Dados', sprintf('y = %.4fx + %.4f', a1, a2));
grid on;