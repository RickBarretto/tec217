# Guia de Uso — Interpolação Polinomial

> Scripts para prova no computador: rode, troque os valores, leia as iterações.

---

## Como Usar na Prova

### Passo 1 — Configure os dados do enunciado

Abra `main.m` e altere apenas estas 4 linhas:

```octave
x       = [0, 0.5, 1.0];         % nós de interpolação
f       = [1.0, 2.12, 3.55];     % valores f(x_i)
xav     = 0.7;                    % ponto de avaliação

f_exata = @(t) exp(t) + sin(t);  % função exata — ou [] se não houver
```

### Passo 2 — Escolha o método

Descomente **uma** linha, mantenha as outras duas com `%`:

```octave
[val, coef] = newton_iter(x, f, xav);
% [val, coef] = lagrange_iter(x, f, xav);
% [val, coef] = vandermonde_iter(x, f, xav);
```

### Passo 3 — Execute

```octave
>> cd interpolation
>> main
```

---

## O que Cada Método Imprime

### Newton
```
Tabela de Diferenças Divididas:
i     x_i       f[ ]        f[*,]         f[*,*,]
1     0         1.000000    2.240000      0.310000
2     0.5       2.120000    2.860000
3     1.0       3.550000

Coeficientes de Newton:
  b0 = 1.000000
  b1 = 2.240000
  b2 = 0.310000

Horner — avaliação em x = 0.7:
  passo inicial: val = b2 = 0.310000
  k=1: val = val*(0.7 - 0.5) + 2.240000 = 2.302000
  k=0: val = val*(0.7 - 0)   + 1.000000 = 2.611400

P(0.7) = 2.611400
```

### Lagrange
```
L_0(x):
  numerador   = prod(0.7 - [0.5  1.0]) = 0.060000
  denominador = prod(0   - [0.5  1.0]) = 0.500000
  L_0(0.7)    = 0.120000
  f_0 * L_0   = 1.000000 * 0.120000 = 0.120000

L_1(x):
  ...

Soma total P(0.7) = 0.120000 + 2.226000 + 0.265500 = 2.611500
```

### Vandermonde
```
Matriz de Vandermonde V:
  [  1.0000   0.0000   0.0000 ]
  [  1.0000   0.5000   0.2500 ]
  [  1.0000   1.0000   1.0000 ]

Número de condição de V: 1.3276e+01

Coeficientes monomiais (P(x) = a0 + a1*x + a2*x^2 + ...):
  a0 = 1.000000
  a1 = 1.930000
  a2 = 0.620000

Horner — avaliação em x = 0.7:
  passo inicial: val = a2 = 0.620000
  k=1: val = val*0.7 + 1.930000 = 2.364000
  k=0: val = val*0.7 + 1.000000 = 2.654800
```

---

## Quando Usar Cada Método

| Situação | Método |
|----------|--------|
| Enunciado pede tabela de diferenças divididas | **Newton** |
| Enunciado pede as bases L_i(x) ou polinômios cardinais | **Lagrange** |
| Enunciado pede os coeficientes a0, a1, a2... ou a matriz V | **Vandermonde** |
| Adicionar novos nós sem recalcular tudo | **Newton** |
| Qualquer um (mesmo resultado final) | Escolha o que o professor pediu |

---

## Avisos

> ⚠️ **Vandermonde mal condicionado:** para `n > 5`, a matriz V torna-se instável. O script exibe `*** ATENÇÃO ***` automaticamente quando isso ocorre.

> ⚠️ **Extrapolação:** evite avaliar `xav` fora do intervalo `[min(x), max(x)]`. O polinômio pode dar valores absurdos.

> ⚠️ **Fenômeno de Runge:** para `n` muito grande, o polinômio oscila nas bordas. Para provas de cálculo numérico, `n ≤ 5` é o caso mais comum.

---

## Compatibilidade

- GNU Octave 6+
- MATLAB R2020b+

Não requer toolboxes adicionais.