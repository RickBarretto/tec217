# Exercício 10 - número de algarismos significativos

x = 0.4537e4;
x_ap = 0.4501e4;

erro_relativo = abs(x - x_ap)/abs(x)

% número de algarismos significativos
algorismos_significativos = floor(-log10(erro_relativo))