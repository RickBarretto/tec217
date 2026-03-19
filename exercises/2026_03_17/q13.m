# Exercício 13 - Limite de (1 - cos(x)) / x^2 para x -> 0

f_direta = @(x) (1 - cos(x)) ./ (x.^2);
f_relacao = @(x) (2 * sin(x/2).^2) ./ (x.^2);

x = 1e-5;
f_direta(x)
f_relacao(x)