% Atividade 1 - Regressao Polinomial por Minimos Quadrados

graphics_toolkit("gnuplot");

rand('state', 42);
x = linspace(0, 15, 100)';
e = 0.7 * rand(100, 1);
y = sin(x / 1.5) + 0.1 * x + e;

graus = [1, 2, 4, 10];
cores = {'b', 'r', 'g', 'm'};

figure;
plot(x, y, 'k.', 'MarkerSize', 4);
hold on;
x_plot = linspace(0, 15, 500)';

for gi = 1:length(graus)
  g = graus(gi);
  m = g + 1;
  n = length(x);

  A = zeros(m, m);
  b = zeros(m, 1);

  for i = 1:m
    k1 = i - 1;
    k2 = i;
    for j = 1:m
      if j == 1
        A(i, 1) = n;
      else
        s = 0;
        for k = 1:n
          s = s + x(k)^k2;
        end
        A(i, j) = s;
        A(j, i) = s;
        k2 = k2 + 1;
      end
    end
    s = 0;
    if i == 1
      for k = 1:n
        s = s + y(k);
      end
    else
      for k = 1:n
        s = s + y(k) * x(k)^k1;
      end
    end
    b(i) = s;
  end

  printf('\n=== Grau %d ===\n', g);
  printf('Matriz de somatorios A:\n');
  for i = 1:m
    for j = 1:m
      printf('%16.4e', A(i,j));
    end
    printf('\n');
  end
  printf('Vetor soma de produto b:\n');
  for i = 1:m
    printf('  b(%d) = %.4f\n', i, b(i));
  end

  % Eliminacao de Gauss com pivotamento parcial
  Ab = [A, b];
  for col = 1:m-1
    [~, idx] = max(abs(Ab(col:m, col)));
    idx = idx + col - 1;
    if idx ~= col
      Ab([col, idx], :) = Ab([idx, col], :);
    end
    for row = col+1:m
      f = Ab(row, col) / Ab(col, col);
      Ab(row, :) = Ab(row, :) - f * Ab(col, :);
    end
  end
  a = zeros(m, 1);
  for i = m:-1:1
    a(i) = (Ab(i, m+1) - Ab(i, i+1:m) * a(i+1:m)) / Ab(i, i);
  end

  printf('Coeficientes (solucao do sistema linear):\n');
  for i = 1:m
    printf('  a%d = %.6f\n', i-1, a(i));
  end

  y_pred = zeros(n, 1);
  for k = 0:g
    y_pred = y_pred + a(k+1) * x.^k;
  end
  r2 = 1 - sum((y - y_pred).^2) / sum((y - mean(y)).^2);
  printf('R^2 = %.6f\n', r2);

  y_plot = zeros(500, 1);
  for k = 0:g
    y_plot = y_plot + a(k+1) * x_plot.^k;
  end
  plot(x_plot, y_plot, cores{gi}, 'LineWidth', 1.8, ...
       'DisplayName', sprintf('Grau %d (R^2=%.4f)', g, r2));
end

legend('Location', 'northwest');
xlabel('x'); ylabel('y');
title('Regressao Polinomial - Minimos Quadrados');
grid on;

print('-dpng', './question1.png');