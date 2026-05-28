# gauss.m — Eliminação de Gauss

Funções reutilizáveis para resolver sistemas lineares **Ax = b** pelo método de Eliminação de Gauss. Duas variantes disponíveis: simples e com pivotamento parcial.

---

## Como configurar (3 passos)

### 1. Defina a matriz e o vetor

```octave
A = [ 10,  2, -1;
      -3, -5,  2;
       1,  1,  6 ];

b = [ 27; -61.5; -21.5 ];
```

### 2. Escolha o método (descomente um)

```octave
x = gauss_simples(A, b);
% x = gauss_pivot(A, b);
```

### 3. Execute

```
octave gauss.m
```

A solução aparece ao final como `x1`, `x2`, `x3`, ...

---

## Métodos disponíveis

### `gauss_simples(A, b)`

**O que faz:** elimina variáveis de cima para baixo sem reordenar linhas. Após a triangularização, resolve por substituição retroativa.

**Quando usar:**
- Sistema bem condicionado
- Pivôs claramente diferentes de zero
- Quando o enunciado pede Gauss sem pivotamento

**Vantagens:**
- Mais simples de acompanhar passo a passo
- Saída mais direta, sem etapas de busca de pivô

**Desvantagens:**
- Falha com divisão por zero se um pivô for nulo
- Instável quando pivôs são muito pequenos
- Erros de arredondamento podem se acumular

---

### `gauss_pivot(A, b)`

**O que faz:** antes de cada passo de eliminação, busca o maior valor absoluto na coluna e troca essa linha para a posição de pivô. Depois elimina normalmente e resolve por substituição retroativa.

**Quando usar:**
- Situação geral — preferência padrão
- Quando o pivô da coluna é zero ou próximo de zero
- Quando o enunciado pede Gauss com pivotamento parcial

**Vantagens:**
- Evita divisão por zero
- Numericamente mais estável
- Reduz erros de arredondamento
- Mesma complexidade computacional: O(n³)

**Desvantagens:**
- Inclui etapas extras de busca e troca de linhas
- Ligeiramente mais difícil de acompanhar manualmente

---

## Saída gerada (o que cada etapa mostra)

Ambos os métodos imprimem:

| Etapa | O que aparece |
|---|---|
| Verificação | `det(A)` — confirma se o sistema tem solução única |
| Matriz inicial | `[A|b]` aumentada antes da eliminação |
| Passo k | Coluna pivô, pivô atual, fator de eliminação de cada linha |
| Linha resultante | Valores da linha após a operação |
| Matriz após passo | Estado completo de `[A|b]` a cada iteração |
| Substituição | Cálculo detalhado de cada variável, de baixo para cima |
| Solução | `x1, x2, ..., xn` |

O `gauss_pivot` adiciona, a cada passo:
- Busca do maior `|a(i,k)|` nas linhas restantes
- Indicação de qual linha foi trocada (ou que não houve troca)
- Estado da matriz após a troca, antes da eliminação

---

## Exemplos prontos

### Exemplo 1 — Gauss Simples

```
10*x1 + 2*x2 -  x3 =  27
-3*x1 - 5*x2 + 2*x3 = -61.5
 1*x1 + 1*x2 + 6*x3 = -21.5
```

```octave
A = [ 10,  2, -1;
      -3, -5,  2;
       1,  1,  6 ];
b = [ 27; -61.5; -21.5 ];
x = gauss_simples(A, b);
```

Solução esperada: `x1 = 2.0, x2 = -4.0, x3 = -3.5` (verifique com seu sistema).

---

### Exemplo 2 — Gauss com Pivotamento

```
 2*x1 - 6*x2 -  x3 = -38
-3*x1 -  x2 + 7*x3 = -34
-8*x1 +  x2 - 2*x3 = -20
```

```octave
A = [  2, -6, -1;
      -3, -1,  7;
      -8,  1, -2 ];
b = [ -38; -34; -20 ];
x = gauss_pivot(A, b);
```

---

## Troca rápida de sistema

Para testar outro sistema, altere apenas `A` e `b` no bloco `<<< CONFIGURE AQUI >>>` do arquivo `gauss.m`. Não é necessário mexer nas funções.

---

## Comparação rápida

| Critério | Gauss Simples | Gauss Pivotamento |
|---|---|---|
| Reordena linhas? | Não | Sim (busca maior pivô) |
| Falha com pivô zero? | Sim | Não |
| Estabilidade numérica | Menor | Maior |
| Complexidade | O(n³) | O(n³) |
| Quando preferir | Sistemas bem condicionados | Uso geral |

---

## Estrutura do arquivo

```
gauss.m
├── <<< CONFIGURE AQUI >>>      ← altere A, b e escolha o método
├── gauss_simples(A, b)         ← implementação sem pivotamento
├── gauss_pivot(A, b)           ← implementação com pivotamento parcial
├── substituicao_retroativa()   ← auxiliar compartilhada pelos dois métodos
└── imprime_aumentada()         ← auxiliar de exibição formatada
```