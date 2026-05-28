# 📘 Lista 02 — Sistemas Lineares (Resolução Guiada com `list.m`)

Resolução completa das questões com:

* ✔ Enunciado original
* ✔ Modelagem matemática
* ✔ Passo a passo conceitual
* ✔ Como rodar no `list.m`



# Q1 — Gauss com Pivoteamento Parcial

## Enunciado

Resolver por eliminação de Gauss com pivoteamento parcial, calcular o determinante e verificar a solução.



## Sistema

```
2x₁ - 6x₂ - x₃ = -38  
-3x₁ - x₂ + 7x₃ = -34  
-8x₁ + x₂ - 2x₃ = -20
```



## Passo a passo

### 1. Matriz aumentada

```
[  2  -6  -1 | -38 ]
[ -3  -1   7 | -34 ]
[ -8   1  -2 | -20 ]
```



### 2. Pivoteamento (coluna 1)

Maior valor absoluto: **-8 → troca L1 ↔ L3**



### 3. Eliminação

Zerar abaixo do pivô:

```
L2 = L2 - (m21)L1  
L3 = L3 - (m31)L1
```



### 4. Forma triangular

```
[ *  *  * ]
[ 0  *  * ]
[ 0  0  * ]
```



### 5. Determinante

```
det(A) = produto da diagonal × (-1)^(trocas)
```



### 6. Retro-substituição

Resolve:

```
x₃ → x₂ → x₁
```



### 7. Verificação

```
Ax ≈ b
```



## Uso no script

```octave
A = [ 2 -6 -1;
     -3 -1  7;
     -8  1 -2];

b = [-38; -34; -20];

gauss_pivot(A, b);
```



# Q2 — Sistema de Tanques (Gauss-Jordan)

## Enunciado

Sistema em regime estacionário com balanço de massa. Resolver por Gauss-Jordan.



## Sistema

```
130c1 - 30c2        = 200  
-90c1 + 90c2        = 0  
-40c1 - 60c2 +120c3 = 500
```



## Passo a passo

### 1. Montar matriz

```
[130 -30   0 | 200]
[-90  90   0 | 0  ]
[-40 -60 120 | 500]
```



### 2. Normalizar pivô

```
L1 = L1 / 130
```



### 3. Zerar coluna

Para cada linha:

```
Li = Li - fator × Lk
```



### 4. Resultado final

```
[I | solução]
```



## Uso

```octave
A = [130 -30   0;
     -90  90   0;
     -40 -60 120];

b = [200; 0; 500];

gauss_jordan(A, b);
```



# Q3 — Mistura de Minas

## Enunciado

Determinar volume de cada mina para atender demanda de materiais.



## Sistema

```
0.52x1 + 0.20x2 + 0.25x3 = 4800  
0.30x1 + 0.50x2 + 0.20x3 = 5800  
0.18x1 + 0.30x2 + 0.55x3 = 5700
```



## Passo a passo

### 1. Montar matriz

### 2. Eliminação sem pivoteamento

```
m21 = a21/a11
m31 = a31/a11
```



### 3. Triangularização



### 4. Retro-substituição



## Uso

```octave
A = [0.52 0.20 0.25;
     0.30 0.50 0.20;
     0.18 0.30 0.55];

b = [4800; 5800; 5700];

gauss_simples(A, b);
```



# Q4 — Decomposição LU

## Enunciado

(a) Resolver com LU
(b) Resolver com vetor alternativo reutilizando L e U



## Passo a passo

### 1. Decompor

```
A = L · U
```



### 2. Resolver

```
Ly = b  
Ux = y
```



### 3. Reutilizar

Resolver novamente com novo b



## Uso

```octave
A = [ 7  2 -3;
      2  5 -3;
      1 -1 -6];

b     = [-12; -20; -26];
b_alt = [ 12;  18;  -6];

decomp_lu(A, b, b_alt);
```



# Q5 — Matriz Inversa

## Enunciado

Calcular A⁻¹ e verificar A·A⁻¹ = I



## Passo a passo

### 1. Montar

```
[A | I]
```



### 2. Aplicar Gauss-Jordan



### 3. Resultado

```
[I | A⁻¹]
```



## Uso

```octave
A = [10  2 -1;
     -3 -6  2;
      1  1  5];

matriz_inversa(A);
```



# Q6 — Normas

## Enunciado

Calcular ||A||₁ e ||A||∞ com normalização.



## Passo a passo

### 1. Normalizar linhas

### 2. Somar linhas → ||A||∞

### 3. Somar colunas → ||A||₁



## Uso

```octave
A = [ 8  2 -10;
     -9  1   3;
     15 -1   6];

normas_matriz(A);
```



# Q7 — Número de Condição

## Enunciado

Calcular cond(A) da matriz de Vandermonde.



## Passo a passo

### 1. Montar matriz

```
A = [x1² x1 1
     x2² x2 1
     x3² x3 1]
```



### 2. Calcular ||A||∞

### 3. Calcular A⁻¹

### 4. cond(A)



## Uso

```octave
x1 = 4; x2 = 2; x3 = 7;

A = [x1^2 x1 1;
     x2^2 x2 1;
     x3^2 x3 1];

numero_condicao(A);
```



# Q8 — Gauss-Seidel

## Enunciado

Resolver até erro < 5%



## Uso

```octave
A  = [0.8 -0.4  0;
     -0.4  0.8 -0.4;
      0   -0.4  0.8];

b  = [41; 25; 105];

x0 = zeros(3,1);

seidel_iter(A, b, x0, 5, 100);
```



# Q9 — Jacobi

## Uso

```octave
A = [10  2 -1;
     -3 -6  2;
      1  1  5];

b = [27; -61.5; -21.5];

x0 = zeros(3,1);

jacobi_iter(A, b, x0, 5, 100);
```



# Q10 — SOR

## Passo importante

Reorganizar para diagonal dominante.



## Uso

```octave
A = [-8  1 -2;
      2 -6 -1;
     -3 -1  7];

b = [-20; -38; -34];

x0 = zeros(3,1);

sor_iter(A, b, x0, 1.25, 5, 100);
```



# Observações finais

* Todos os métodos mostram **passo a passo completo**
* Ideal para prova (você literalmente copia o processo)
* Iterativos mostram tabela de convergência
