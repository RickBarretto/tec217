# Exercício 14 - Aproximação usando série de Taylor

x = 0.5;
valor_verdadeiro = exp(x);

soma = 1;
termo = 1;
n = 1;

erro_aproximado = 100;

printf("n\taprox\t\t\tErro Verdadeiro(%%)\tErro Aproximado(%%)\n");

while (true)

    termo = termo * (x / n);
    soma_old = soma;
    soma = soma + termo;

    # Erros percentuais
    erro_verdadeiro = abs((valor_verdadeiro - soma)/valor_verdadeiro)*100;
    erro_aproximado = abs((soma - soma_old)/soma)*100;

    printf("%d\t%.8f\t%.6f\t\t%.6f\n", n, soma, erro_verdadeiro, erro_aproximado);

    # Critério de parada
    if (erro_aproximado < 0.05)
        break;
    end

    n = n + 1;
end

printf("\nValor final: %.8f\n", soma);
printf("Valor verdadeiro: %.8f\n", valor_verdadeiro);