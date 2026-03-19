# Exercício 1 - Erros Absolutos, Relativos e Percentuais

x = 1/3;
y = 1/3000;

x_aproximado = 0.3333;
y_aproximado = 0.0003;

% erros absolutos
erro_absoluto_x = abs(x - x_aproximado)
erro_absoluto_y = abs(y - y_aproximado)

% erros relativos
erro_relativo_x = erro_absoluto_x / abs(x)
erro_relativo_y = erro_absoluto_y / abs(y)

% erros percentuais
erro_percentual_x = erro_relativo_x * 100
erro_percentual_y = erro_relativo_y * 100