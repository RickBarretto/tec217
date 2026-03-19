# Exercício 11 - Erro absoluto, erro relativo e número de algarismos significativos

x = 314.159;
x_ap = 314.15;

erro_absoluto = abs(x - x_ap)
erro_relativo = erro_absoluto / abs(x)

algorismos_significativos = floor(-log10(erro_relativo))
