# Exercício 5 - Considerando SPF(10, 5, -3, 3), de base 2,
# indentifique as regiões de underflow e overflow.

beta = 10;
t = 5;
emin = -3;
emax = 3;

underflow = beta^(emin)
overflow = (1 - beta^(-t)) * beta^(emax)