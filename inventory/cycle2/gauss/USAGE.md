# Gauss - Reusable Methods (ingenuous and pivot)

This folder provides two reusable Gaussian elimination functions for linear systems $A x = b$.
They are designed for learning: you can swap values in A and b and watch the algorithm steps.

## Files

- [main.m](main.m): example driver
- [methods/ingenuous.m](methods/ingenuous.m): elimination without pivoting
- [methods/pivot.m](methods/pivot.m): elimination with partial pivoting

## How to use

1) Open [main.m](main.m)
2) Change A and b
3) Choose the method:
   - method = 'ingenuo'
   - method = 'pivot'
4) Run the script

## Function signatures

```
[x, Ab, info] = ingenuous(A, b, opts)
[x, Ab, info] = pivot(A, b, opts)
```

### Inputs

- A: square matrix (n x n)
- b: right-hand side vector (n x 1)
- opts (optional struct):
  - opts.verbose (default true): print steps
  - opts.tol (default 1e-12): pivot and singularity tolerance
  - opts.captureSteps (default false): store each step matrix

### Outputs

- x: solution vector
- Ab: final augmented matrix [U | y]
- info: diagnostics struct
  - info.detA: determinant of A
  - info.swaps: number of row swaps (0 for ingenuous)
  - info.steps: cell array of augmented matrices (if captureSteps=true)

## When to use

- ingenuous (no pivoting):
  - use only when you are sure pivots will not be small or zero
  - best for small, well-behaved systems and classroom demos

- pivot (partial pivoting):
  - use for most practical cases
  - more stable when A has small or zero pivots

## Advantages and disadvantages

### ingenuous

Advantages:
- simplest to understand and implement
- fewer operations than pivoting

Disadvantages:
- can fail with zero or tiny pivots
- numerically unstable for many systems

### pivot

Advantages:
- much better numerical stability
- handles zero or tiny pivots

Disadvantages:
- slightly more operations
- needs row swaps (changes the order of equations)

## Notes

- If you want to inspect each elimination step, set opts.captureSteps = true.
- For large or ill-conditioned systems, prefer pivoting.

---

# Gauss - Metodos Reutilizaveis (ingenuo e pivot)

Esta pasta oferece duas funcoes reutilizaveis de eliminacao de Gauss para sistemas lineares $A x = b$.
Elas foram pensadas para aprendizagem: voce pode trocar os valores de A e b e acompanhar as etapas do algoritmo.

## Arquivos

- [main.m](main.m): exemplo de uso
- [methods/ingenuous.m](methods/ingenuous.m): eliminacao sem pivotamento
- [methods/pivot.m](methods/pivot.m): eliminacao com pivotamento parcial

## Como usar

1) Abra [main.m](main.m)
2) Troque A e b
3) Escolha o metodo:
   - method = 'ingenuo'
   - method = 'pivot'
4) Execute o script

## Assinaturas das funcoes

```
[x, Ab, info] = ingenuous(A, b, opts)
[x, Ab, info] = pivot(A, b, opts)
```

### Entradas

- A: matriz quadrada (n x n)
- b: vetor do lado direito (n x 1)
- opts (struct opcional):
  - opts.verbose (padrao true): imprime etapas
  - opts.tol (padrao 1e-12): tolerancia de pivo e singularidade
  - opts.captureSteps (padrao false): armazena cada matriz de passo

### Saidas

- x: vetor solucao
- Ab: matriz aumentada final [U | y]
- info: struct de diagnostico
  - info.detA: determinante de A
  - info.swaps: numero de trocas de linha (0 no ingenuo)
  - info.steps: cell array de matrizes aumentadas (se captureSteps=true)

## Quando usar

- ingenuo (sem pivotamento):
  - use apenas quando tiver certeza de que os pivos nao serao pequenos ou nulos
  - melhor para sistemas pequenos, bem comportados e demonstracoes em sala

- pivot (pivotamento parcial):
  - use na maioria dos casos praticos
  - mais estavel quando A tem pivos pequenos ou nulos

## Vantagens e desvantagens

### ingenuo

Vantagens:
- mais simples de entender e implementar
- menos operacoes que o pivotamento

Desvantagens:
- pode falhar com pivos nulos ou muito pequenos
- instavel numericamente em muitos sistemas

### pivot

Vantagens:
- muito melhor estabilidade numerica
- lida com pivos nulos ou muito pequenos

Desvantagens:
- um pouco mais de operacoes
- precisa trocar linhas (muda a ordem das equacoes)

## Notas

- Se quiser inspecionar cada etapa da eliminacao, use opts.captureSteps = true.
- Para sistemas grandes ou mal condicionados, prefira o pivotamento.
