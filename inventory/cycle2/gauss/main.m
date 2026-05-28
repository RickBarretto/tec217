
# 'ingenuo' | 'pivot'
method = 'ingenuo';

% Sistema de exemplo. Troque A e b para testar outros casos.
A = [ 10,  2, -1;
      -3, -5,  2;
       1,  1,  6 ];

b = [ 27; -61.5; -21.5 ];

opts.verbose = true;
opts.tol = 1e-12;
opts.captureSteps = true;

switch lower(method)
  case 'ingenuo'
    [x, Ab, info] = ingenuous(A, b, opts);
  case 'pivot'
    [x, Ab, info] = pivot(A, b, opts);
  otherwise
    error('Unknown method.');
end

printf('\nSolucao final:\n');
for i = 1:length(x)
  printf('  x%d = %12.6f\n', i, x(i));
end

printf('\nDiagnosticos:\n');
printf('  det(A) = %.6e\n', info.detA);
printf('  trocas = %d\n', info.swaps);
if isfield(info, 'steps')
  printf('  passos = %d\n', length(info.steps));
end