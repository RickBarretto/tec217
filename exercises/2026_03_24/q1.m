% Bissecao - f(x) = sin(x) - cos(x)
f = @(x) sin(x) - cos(x);
a = 0.5; b = 1.0; e = 0.02;
N = ceil(log2((b-a)/e)) + 5;

if f(a)*f(b) > 0
  error('Nao ha mudanca de sinal!');
end

fprintf('%-4s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n', ...
        'Iter','a','f(a)','b','f(b)','r','f(r)','TInterv');

for it = 1:N
  r  = (a + b) / 2;
  Ea = abs(b - a);
  fprintf('%-4d %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f\n', ...
          it, a, f(a), b, f(b), r, f(r), Ea);
  if Ea <= e
    fprintf('\nRaiz aproximada: r = %.6f\n', r);
    break
  end
  if f(a)*f(r) < 0
    b = r;
  else
    a = r;
  end
end