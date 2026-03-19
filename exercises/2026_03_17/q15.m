# Exercício 15 - Erro de aproximação para derivada usando diferença centrada

# Função dada
f = @(x) -0.1*x.^4 - 0.15*x.^3 - 0.5*x.^2 - 0.25*x + 1.2;

# Derivada exata da função dada
df = @(x) -0.4*x.^3 - 0.45*x.^2 - x - 0.25;

x0 = 0.5;
valor_exato = df(x0);

h = 1;

printf("h\t\tDiferença Finita\tErro Verdadeiro\n");

H = [];
ERRO = [];

for i = 1:10
    # Diferença centrada
    deriv_aprox = (f(x0 + h) - f(x0 - h)) / (2*h);

    erro = abs(valor_exato - deriv_aprox);

    printf("%.10f\t%.10f\t%.10f\n", h, deriv_aprox, erro);

    H(end+1) = h;
    ERRO(end+1) = erro;

    h = h / 10;
end

figure;
loglog(H, ERRO, '-o');
grid on;
xlabel('h');
ylabel('Erro');
title('Erro vs Passo h (escala log-log)');