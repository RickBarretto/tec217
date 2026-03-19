# Exercício 2 - Representação de números em ponto flutuante
# onde existem 8 dígitos para a mantissa e 2 dígitos para o expoente, 
# ambos na base 10.

x = 12345.6789;

format long
mantissa = x / 10^floor(log10(abs(x)));
expoente = floor(log10(abs(x)));

% Mantissa com 8 dígitos
mantissa_8 = round(mantissa * 1e8) / 1e8;
representacao = mantissa_8 * 10^expoente
