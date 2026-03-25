% Falsa Posicao - f(x) = x^3 - 9x + 3
f = @(x) x.^3 - 9*x + 3;
a = 0.0; b = 1.0; e = 5e-4; N = 100;

if f(a)*f(b) > 0
  error('Nao ha raizes no intervalo!');
end

r    = (a*f(b) - b*f(a)) / (f(b) - f(a));
it   = 1;
Ea   = Inf;

fprintf('%-4s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-10s\n', ...
        'Iter','a','f(a)','b','f(b)','r','f(r)','TInterv','Ea');

while it <= N
  TInterv = abs(b - a);
  fprintf('%-4d %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f %-10.6f %-10.2e\n', ...
          it, a, f(a), b, f(b), r, f(r), TInterv, Ea);
  if it >= N || Ea <= e
    fprintf('\nRaiz aproximada: r = %.6f\n', r);
    break
  end
  if f(a)*f(r) < 0
    b = r;
  else
    a = r;
  end
  it    = it + 1;
  r_ant = r;
  r     = (a*f(b) - b*f(a)) / (f(b) - f(a));
  Ea    = abs(r - r_ant) / abs(r);
end