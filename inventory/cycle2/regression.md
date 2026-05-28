# regression.m — Documentação

Guia de uso dos quatro métodos de regressão por mínimos quadrados implementados em `regression.m`. Todos mostram o passo a passo completo, úteis para acompanhar e conferir iterações na prova.

---

## Índice

1. [Como configurar e executar](#como-configurar)
2. [linear\_iter — Regressão Linear Simples](#linear_iter)
3. [power\_iter — Regressão de Potência](#power_iter)
4. [poly\_iter — Regressão Polinomial](#poly_iter)
5. [multi\_iter — Regressão Linear Múltipla](#multi_iter)
6. [Tabela comparativa](#tabela-comparativa)

---

## Como configurar

Abra `regression.m` e edite **apenas** a seção `<<< CONFIGURE AQUI >>>`:

```octave
% Dados para métodos univariados (linear, potência, polinomial)
x = [1 2 3 4 5 6 7 8 9 10]';
y = [1.3 3.5 4.2 5.0 7.0 8.8 10.1 12.5 13.0 15.6]';

% Ponto de predição (deixe [] para não calcular)
x_pred = 5.5;

% Grau do polinômio (apenas para poly_iter)
grau = 2;

% Dados para regressão múltipla
X_mult = [0, 0; 2, 1; 2.5, 2; ...];   % n linhas × p colunas
y_mult = [5; 10; 9; ...];
```

Depois, na seção `<<< EXECUTE UM MÉTODO >>>`, **descomente uma** linha e comente as demais:

```octave
[coef, stats] = linear_iter(x, y, x_pred);
% [coef, stats] = power_iter(x, y, x_pred);
% [coef, stats] = poly_iter(x, y, grau, x_pred);
% [coef, stats] = multi_iter(X_mult, y_mult);
```

---

## `linear_iter` — Regressão Linear Simples

### Modelo

```
y = a1 * x + a0
```

### Quando usar

Quando os dados parecem seguir uma **reta** ao plotar x vs y. É o método mais simples e de menor custo computacional.

### Como funciona (o que é mostrado)

| Etapa | O que aparece |
|---|---|
| Somatórios | Tabela com `xi`, `yi`, `xi·yi`, `xi²` e suas somas |
| Coeficientes | Cálculo explícito de `a1` e `a0` com valores intermediários |
| Estatísticas | `Sy` (desvio dos dados), `Sy/x` (desvio do erro), `r²` |
| Predição | `y(x_pred)` se `x_pred` for fornecido |

### Fórmulas

```
a1 = (n·Σxy  - Σx·Σy) / (n·Σx² - (Σx)²)
a0 = (Σy - a1·Σx) / n

St = Σ(yi - ȳ)²
Sr = Σ(yi - ŷi)²
Sy   = sqrt(St / (n-1))
Sy/x = sqrt(Sr / (n-2))
r²   = (St - Sr) / St
```

### Vantagens

- Solução fechada (sem iterações ou sistemas lineares)
- Fácil de conferir manualmente
- `r²` intuitivo: quanto mais perto de 1, melhor

### Desvantagens

- Modela **apenas relações lineares**
- Sensível a outliers (eles distorcem `a1` e `a0`)

### Exemplo de uso

```octave
x = [1 2 3 4 5]';
y = [2.1 3.9 6.2 7.8 10.0]';
x_pred = 3.5;
[coef, stats] = linear_iter(x, y, x_pred);
% coef = [a1, a0]
% stats.r2, stats.Sy, stats.Sy_x
```

---

## `power_iter` — Regressão de Potência

### Modelo

```
y = b * x^m
```

### Quando usar

Quando o gráfico de `ln(y)` vs `ln(x)` parece linear (relação log-log). Frequente em leis físicas, biológicas e de escala.

**Requisito:** `x > 0` e `y > 0` (logaritmo indefinido para zero ou negativos).

### Como funciona (o que é mostrado)

| Etapa | O que aparece |
|---|---|
| Transformação | Tabela com `xi`, `yi`, `X=ln(xi)`, `Y=ln(yi)` |
| Somatórios | `ΣX`, `ΣY`, `ΣXY`, `ΣX²` no espaço transformado |
| Coeficientes | `m` (expoente) e `lb = ln(b)`, depois `b = exp(lb)` |
| Estatísticas | `r²`, `Sy`, `Sy/x` no espaço linearizado |
| Predição | `y(x_pred) = b * x_pred^m` |

### Fórmulas

```
X = ln(x),  Y = ln(y)
m  = (n·ΣXY - ΣX·ΣY) / (n·ΣX² - (ΣX)²)
lb = (ΣY - m·ΣX) / n
b  = exp(lb)
```

### Vantagens

- Modela crescimento acelerado sem precisar de sistema linear
- Linearização simples (ln-ln)

### Desvantagens

- `r²` é calculado no espaço **transformado** (ln-ln), não no original
- Não funciona com `x ≤ 0` ou `y ≤ 0`
- Pode sub-ponderar erros grandes no espaço original

### Exemplo de uso

```octave
x = [10 20 30 40 50 60 70 80]';
y = [25 70 380 550 610 1220 830 1450]';
[coef, stats] = power_iter(x, y, 45);
% coef = [b, m]
```

---

## `poly_iter` — Regressão Polinomial

### Modelo

```
y = a0 + a1·x + a2·x² + ... + ag·x^g
```

### Quando usar

Quando a relação entre x e y é curvilínea mas **não** segue claramente uma lei de potência ou exponencial. Útil para ajustar formas de onda, dados com pico/vale, etc.

### Como funciona (o que é mostrado)

| Etapa | O que aparece |
|---|---|
| Equações normais | Matriz `A` (somatórios `Σx^k`) e vetor `b` (`Σy·x^k`) |
| Eliminação de Gauss | Cada passo de troca de linhas e zeragem por linha |
| Substituição retroativa | Cálculo de cada `ai` com expressão explícita |
| Resultado | Coeficientes `a0…ag` e `R²` |
| Predição | `y(x_pred)` avaliando o polinômio |

### Fórmulas (equações normais)

A matriz `A` de tamanho `(g+1) × (g+1)`:

```
A(i,j) = Σ x^(i+j-2)      para i,j = 1…g+1
b(i)   = Σ y · x^(i-1)
```

Sistema resolvido por **Eliminação de Gauss com pivotamento parcial**.

### Vantagens

- Controle direto do grau: experimente `grau=1,2,4`
- Pode modelar formas complexas

### Desvantagens

- Graus altos (≥ 7) causam **instabilidade numérica** (matriz `A` mal-condicionada)
- `R²` sempre cresce com o grau — não garante que o modelo generaliza bem
- Custo computacional cresce com o grau

### Escolha do grau — guia rápido

| `R²` com grau baixo | Sugestão |
|---|---|
| ≥ 0,99 | Grau 1 ou 2 basta |
| 0,90–0,98 | Tente grau 2 ou 3 |
| < 0,90 | Verifique os dados; pode ser outro modelo |

### Exemplo de uso

```octave
x = linspace(0, 15, 100)';
y = sin(x/1.5) + 0.1*x;
[coef, stats] = poly_iter(x, y, 4, 7.0);
% coef = [a0; a1; a2; a3; a4]
% stats.r2
```

---

## `multi_iter` — Regressão Linear Múltipla

### Modelo

```
y = c0 + c1·x1 + c2·x2 + ... + cp·xp
```

### Quando usar

Quando **mais de uma variável independente** influencia `y`. Extensão direta da regressão linear simples para `p > 1` preditores.

### Como funciona (o que é mostrado)

| Etapa | O que aparece |
|---|---|
| Matriz de design | `Xd = [1 | X]` — tabela com coluna de 1s e todas as variáveis |
| Equações normais | `A = Xd'·Xd` e `b = Xd'·y` |
| Eliminação de Gauss | Passo a passo idêntico ao `poly_iter` |
| Coeficientes | `c0` (intercepto) + `c1…cp` |
| Resultado | Modelo completo e `R²` |

### Fórmulas

```
Xd = [1, x1, x2, ..., xp]   (n × (p+1))
A  = Xd' * Xd               ((p+1) × (p+1))
b  = Xd' * y                ((p+1) × 1)
Resolver: A * c = b
```

### Como passar os dados

`X_mult` é uma **matriz** onde cada **coluna** é uma variável independente e cada **linha** é uma observação:

```octave
% 6 observações, 2 variáveis (x1 e x2)
X_mult = [x1_1, x2_1;
          x1_2, x2_2;
          ...];
y_mult = [y_1; y_2; ...];
[coef, stats] = multi_iter(X_mult, y_mult);
```

### Vantagens

- Quantifica o efeito **individual** de cada variável
- Usa o mesmo algoritmo que o polinomial (Gauss) — fácil de entender
- Escalável para qualquer número de variáveis

### Desvantagens

- Assume relação **linear** com cada preditor
- Preditores correlacionados entre si (multicolinearidade) distorcem os coeficientes
- Não modela interações entre variáveis (ex: `x1·x2`) sem adicioná-las manualmente como coluna extra

---

## Tabela comparativa

| Método | Modelo | Variáveis | Sistema linear? | Restrições |
|---|---|---|---|---|
| `linear_iter` | `a1·x + a0` | 1 | Não (fórmula fechada) | Nenhuma |
| `power_iter` | `b·x^m` | 1 | Não (fórmula fechada) | `x > 0`, `y > 0` |
| `poly_iter` | `Σai·x^i` | 1 | Sim — Gauss | Grau ≤ 6 recomendado |
| `multi_iter` | `Σcj·xj` | p ≥ 2 | Sim — Gauss | Linearidade em cada xj |

### Interpretação do `r²`

| Valor | Interpretação |
|---|---|
| 0,99–1,00 | Ajuste excelente |
| 0,95–0,98 | Ajuste muito bom |
| 0,90–0,94 | Aceitável |
| < 0,90 | Modelo pode não ser adequado |

> **Atenção:** em `power_iter` o `r²` é calculado no espaço `ln-ln`. Um `r²` alto ali não garante exatamente o mesmo ajuste no espaço original.