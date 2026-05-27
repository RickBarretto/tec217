% Atividade 2 - Regressao Linear Multipla por Minimos Quadrados

graphics_toolkit("gnuplot");

X = [0,   0;
     2,   1;
     2.5, 2;
     1,   3;
     4,   6;
     7,   2];
y = [5; 10; 9; 0; 3; 27];

n = size(X, 1);
p = size(X, 2);
m = p + 1;

Xd = [ones(n, 1), X];

A = zeros(m, m);
b = zeros(m, 1);

for i = 1:m
  for j = 1:m
    s = 0;
    for k = 1:n
      s = s + Xd(k, i) * Xd(k, j);
    end
    A(i, j) = s;
  end
  s = 0;
  for k = 1:n
    s = s + y(k) * Xd(k, i);
  end
  b(i) = s;
end

printf('Matriz de somatorios A:\n');
for i = 1:m
  for j = 1:m
    printf('%12.4f', A(i,j));
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
c = zeros(m, 1);
for i = m:-1:1
  c(i) = (Ab(i, m+1) - Ab(i, i+1:m) * c(i+1:m)) / Ab(i, i);
end

printf('Coeficientes (solucao do sistema linear):\n');
printf('  c0 = %.6f\n', c(1));
printf('  c1 = %.6f\n', c(2));
printf('  c2 = %.6f\n', c(3));
printf('Modelo: y = %.4f + %.4f*x1 + %.4f*x2\n', c(1), c(2), c(3));

y_fit = Xd * c;
r2 = 1 - sum((y - y_fit).^2) / sum((y - mean(y)).^2);
printf('R^2 = %.6f\n', r2);

% Grafico 3D
x1r = linspace(min(X(:,1))-0.5, max(X(:,1))+0.5, 30);
x2r = linspace(min(X(:,2))-0.5, max(X(:,2))+0.5, 30);
[X1g, X2g] = meshgrid(x1r, x2r);
Yg = c(1) + c(2)*X1g + c(3)*X2g;

figure;
surf(X1g, X2g, Yg, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;
plot3(X(:,1), X(:,2), y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot3(X(:,1), X(:,2), y_fit, 'b^', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
xlabel('x1'); ylabel('x2'); zlabel('y');
title(sprintf('Regressao Linear Multipla\ny = %.3f + %.3f x1 + %.3f x2  (R^2=%.4f)', c(1), c(2), c(3), r2));
legend('Plano ajustado', 'Pontos reais', 'Pontos ajustados');
grid on;
print('-dpng', './question2.png');