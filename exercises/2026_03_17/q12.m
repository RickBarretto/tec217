# Exercício 12 - Erros para x = 1.4142 e y = 1.4286

x = 1.4142;
y = 1.4286;

z_real = x - y

% simulando arredondamento com 3 dígitos
fl = @(v) round(v * 100) / 100;

x_fl = fl(x);
y_fl = fl(y);

z_fl = fl(x_fl - y_fl)

% erros
erro_absoluto = abs(z_real - z_fl)
erro_relativo = erro_absoluto / abs(z_real)
