# `iterative.m` — Métodos Iterativos para Sistemas Lineares

Arquivo único para resolver sistemas **Ax = b** pelos métodos de **Jacobi**, **Gauss-Seidel** e **SOR**.
Projetado para prova: troque os dados no bloco de configuração, descomente o método e execute.

---

## Como configurar (3 passos)

### Passo 1 — Defina o sistema

```octave
A = [10  3 -2;
      2  8 -1;
      1  1  5];
b = [57; 20; -4];
```

> A pode ter qualquer dimensão n×n. Basta colar a matriz e o vetor.

### Passo 2 — Defina os parâmetros de parada

```octave
x0       = zeros(size(b));  % chute inicial — normalmente zeros
tol      = 0.0005;          % tolerância em % (critério de parada)
max_iter = 100;             % máximo de iterações permitidas
w        = 1.25;            % fator de relaxação (só para SOR)
```

### Passo 3 — Escolha o método (descomente um)

```octave
x = jacobi_iter(A, b, x0, tol, max_iter);
% x = seidel_iter(A, b, x0, tol, max_iter);
% x = sor_iter(A, b, x0, w, tol, max_iter);
```

---

## Exemplos prontos para copiar

### Sistema 3×3 (exemplo com Jacobi)

```octave
A = [10  3 -2;  2  8 -1;  1  1  5];
b = [57; 20; -4];
x0 = zeros(3,1);  tol = 0.0005;  max_iter = 100;
x = jacobi_iter(A, b, x0, tol, max_iter);
```

### Sistema 4×4 (exemplo com Gauss-Seidel)

```octave
A = [ 2 -1  0  0; -1  2 -1  0;  0 -1  2 -1;  0  0 -1  2];
b = [1; 2; 9; 11];
x0 = zeros(4,1);  tol = 0.0005;  max_iter = 10;
x = seidel_iter(A, b, x0, tol, max_iter);
```

### Sistema 3×3 com SOR

```octave
A = [10  3 -2;  2  8 -1;  1  1  5];
b = [57; 20; -4];
x0 = zeros(3,1);  tol = 0.0005;  max_iter = 100;  w = 1.25;
x = sor_iter(A, b, x0, w, tol, max_iter);
```

---

## Métodos — Referência rápida

### Jacobi

| Item | Detalhe |
|---|---|
| **Fórmula** | `x_i^(k+1) = (b_i − Σ a_ij·x_j^(k)) / a_ii` (j≠i) |
| **Forma matricial** | `x^(k+1) = C·x^(k) + d` |
| **Critério de convergência** | Critério de Linhas: `|a_ii| > Σ|a_ij|` para todo i |
| **O que o código mostra** | Critério de linhas · Matriz C e vetor d · Raio espectral ρ(C) · Tabela de iterações |

**Vantagens**
- Simples de entender e implementar
- Cada x_i novo é independente dos outros → paralelizável
- Bom para matrizes esparsas e diagonalmente dominantes

**Desvantagens**
- Converge mais devagar que Gauss-Seidel
- Requer armazenar x_old e x_new separadamente
- Sem diagonal dominante, pode divergir

**Use quando:** a matriz é claramente diagonal dominante e você precisa de simplicidade.

---

### Gauss-Seidel

| Item | Detalhe |
|---|---|
| **Fórmula** | `x_i^(k+1) = (b_i − Σ a_ij·x_j^(k+1) [j<i] − Σ a_ij·x_j^(k) [j>i]) / a_ii` |
| **Diferença do Jacobi** | Usa os valores **já atualizados** na mesma iteração |
| **Critério de convergência** | Critério de Sassenfeld: `max(β_i) < 1` |
| **O que o código mostra** | Cálculo de cada β_i · Diagnóstico Sassenfeld · Tabela de iterações |

**Cálculo de β (Sassenfeld):**
```
β_i = (Σ|a_ij|·β_j  [j<i]  +  Σ|a_ij|  [j>i]) / |a_ii|
```

**Vantagens**
- Converge geralmente em ~metade das iterações do Jacobi
- Atualiza x in-place (economiza memória)
- Critério de Sassenfeld é mais forte que o de linhas

**Desvantagens**
- Não paralelizável (x_i depende dos x_j atualizados no mesmo passo)
- Mesma limitação de convergência que Jacobi sem diagonal dominante

**Use quando:** Jacobi funciona mas é lento, ou quando Sassenfeld está satisfeito.

---

### SOR — Successive Over-Relaxation

| Item | Detalhe |
|---|---|
| **Fórmula** | `x_gs = passo Gauss-Seidel` → `x_i^(k+1) = w·x_gs + (1−w)·x_i^(k)` |
| **Parâmetro extra** | `w` (fator de relaxação) |
| **O que o código mostra** | Diagnóstico de w · Tabela de iterações |

**Escolha de w:**

| Valor de w | Efeito |
|---|---|
| `0 < w < 1` | Sub-relaxação — mais estável, mais lento |
| `w = 1` | Equivale exatamente a Gauss-Seidel |
| `1 < w < 2` | Super-relaxação — pode acelerar muito |
| `w ≥ 2` | Sempre diverge |

**Vantagens**
- Pode reduzir drasticamente o número de iterações com w ótimo
- w = 1 reproduz Gauss-Seidel (bom ponto de partida)
- Excelente para sistemas grandes e bem estruturados

**Desvantagens**
- Requer escolha cuidadosa de w (w ruim = divergência)
- Não há fórmula simples para w ótimo em geral
- Mais complexo de justificar na prova se não souber explicar w

**Use quando:** Gauss-Seidel convergiu mas ainda é lento, e você tem liberdade de ajustar w.

---

## Fluxo de decisão — qual método escolher?

```
Tenho Ax = b para resolver iterativamente
│
├─ Verifico Critério de Linhas (diagonal dominante)?
│    Sim → Jacobi funciona; tente também Seidel para comparar
│    Não → cuidado, mas Seidel ainda pode convergir (verifique Sassenfeld)
│
├─ Velocidade importa?
│    Não muito → Jacobi (mais simples de explicar)
│    Sim        → Gauss-Seidel (≈ metade das iterações)
│
└─ Gauss-Seidel ainda lento?
       Sim → SOR com w ∈ (1, 2), comece com w = 1.25
```

---

## Critério de parada — como funciona

O erro relativo percentual é calculado a cada iteração:

```
erro_i = |x_i^(k+1) − x_i^(k)| / max(|x_i^(k+1)|, ε) × 100%
```

O método para quando `max(erro_i) < tol`.

> `tol = 0.0005` significa parar quando o erro máximo for menor que **0,0005%**.

---

## O que aparece na saída

Para todos os métodos a saída inclui:

1. **Diagnóstico de convergência** — critério de linhas (Jacobi) ou Sassenfeld (Seidel/SOR)
2. **Matrizes intermediárias** — C e d para Jacobi; β para Seidel
3. **Tabela de iterações** — uma linha por passo com todos os x_i e o erro máximo
4. **Resultado final** — vetor solução, número de iterações e erro final

---

## Observações para a prova

- **Chute inicial zero** é o mais comum nos enunciados: `x0 = zeros(size(b))`
- **Tolerância 0.0005** equivale a **0,05%** de erro relativo (padrão típico)
- **max_iter pequeno** (ex: 10) força o código a parar mesmo sem convergir — útil quando o enunciado pede apenas as primeiras N iterações
- Se o enunciado der apenas os primeiros passos, compare com a coluna `iter` da tabela impressa
- Para **SOR**, se o enunciado não especificar w, use `w = 1` (= Gauss-Seidel) para garantir reprodutibilidade