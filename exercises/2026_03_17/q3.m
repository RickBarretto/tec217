# Exercício 3 - Considerando SPF(10, 5, -3, -3), de base 10

beta = 10;
t = 5;
emin = -3;
emax = 3;

# a) menor número positivo representável
menor_numero_positivo = beta^(emin) * 1

# b) maior número positivo representável
maior_numero_positivo = (1 - beta^(-t)) * beta^(emax)

# c) total de números positivos representáveis
total_positivos = (beta-1) * beta^(t-1) * (emax - emin + 1)

# d) total de números reais representáveis
total_reais = 2 * total_positivos + 1
