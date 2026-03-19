# Exercício 7 - Considerando SPF(10, 5, -3, 3),
# x = 9.99999, encontre a representação de x em ponto flutuante

beta = 10;
t = 5;
emin = -3;
emax = 3;

x = 9.99999;

e = floor(log10(x));
m = x / 10^e;

if (e >= emin && e <= emax)
    printf("X existe em ponto flutuante? Sim\n");
    % truncamento
    m_trunc = floor(m * 10^4) / 10^4;
    x_trunc = m_trunc * 10^e

    % arredondamento
    m_round = round(m * 10^4) / 10^4;
    x_round = m_round * 10^e
else
    printf("X existe em ponto flutuante? Não\n");
end
