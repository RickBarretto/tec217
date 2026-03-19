# Exercício 1 - Erros Absolutos, Relativos e Percentuais

x = 1/3;
y = 1/3000;

x_ap = 0.3333;
y_ap = 0.0003;

% erros absolutos
ea_x = abs(x - x_ap)
ea_y = abs(y - y_ap)

% erros relativos
er_x = ea_x / abs(x)
er_y = ea_y / abs(y)

% erros percentuais
ep_x = er_x * 100
ep_y = er_y * 100