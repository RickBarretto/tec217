function [x, Ab, info] = pivot(A, b, opts)
%PIVOT Gaussian elimination with partial pivoting.
%   [x, Ab, info] = pivot(A, b, opts)
%
% Inputs:
%   A    : square coefficient matrix (n x n)
%   b    : right-hand side vector (n x 1)
%   opts : optional struct
%          opts.verbose      (default true)
%          opts.tol          (default 1e-12)
%          opts.captureSteps (default false)
%
% Outputs:
%   x    : solution vector
%   Ab   : final augmented matrix [U | y]
%   info : diagnostics struct (detA, swaps, steps)

if nargin < 3
	opts = struct();
end

opts = normalize_opts(opts);

[n, m] = size(A);
if n ~= m
	error('ERRO: Matriz A deve ser quadrada!');
end
if length(b) ~= n
	error('ERRO: Vetor b deve ter tamanho n.');
end

info.detA = det(A);
info.swaps = 0;
info.steps = {};

if abs(info.detA) < opts.tol
	error('ERRO: det(A) ~= 0. Sistema sem solucao unica.');
end

Ab = [A, b(:)];

if opts.verbose
	printf('Augmented matrix [A|b] (initial):\n');
	print_augmented(Ab);
	printf('\nElimination (partial pivoting)\n');
end

for k = 1 : n-1
	if opts.verbose
		printf('\n--- Step k = %d ---\n', k);
	end

	% Find max pivot in column k
	p = k;
	maxval = abs(Ab(k,k));
	for i = k+1 : n
		if abs(Ab(i,k)) > maxval
			maxval = abs(Ab(i,k));
			p = i;
		end
	end

	if maxval < opts.tol
		error('ERRO: Pivo nulo ou muito pequeno em k = %d.', k);
	end

	if p ~= k
		Ab([k, p], :) = Ab([p, k], :);
		info.swaps = info.swaps + 1;
		if opts.verbose
			printf('  Swap rows %d <-> %d\n', k, p);
		end
	end

	pivot = Ab(k,k);
	for i = k+1 : n
		fator = Ab(i,k) / pivot;
		if opts.verbose
			printf('  L%d <- L%d - (%.6f) * L%d\n', i, i, fator, k);
		end
		for j = k : n+1
			Ab(i,j) = Ab(i,j) - fator * Ab(k,j);
		end
	end

	if opts.captureSteps
		info.steps{end+1} = Ab; %#ok<AGROW>
	end

	if opts.verbose
		print_augmented(Ab);
	end
end

if opts.verbose
	printf('\nBack substitution\n');
end

x = back_substitution(Ab, opts);

end

function x = back_substitution(Ab, opts)
	[n, m] = size(Ab);
	if m ~= n + 1
		error('ERRO: Matriz aumentada invalida.');
	end

	x = zeros(n, 1);
	for i = n : -1 : 1
		if abs(Ab(i,i)) < opts.tol
			error('ERRO: Pivo nulo ou muito pequeno em i = %d.', i);
		end
		soma = Ab(i, n+1);
		for j = i+1 : n
			soma = soma - Ab(i,j) * x(j);
		end
		x(i) = soma / Ab(i,i);
	end
end

function print_augmented(Ab)
	[n, m] = size(Ab);
	if m ~= n + 1
		error('ERRO: Matriz aumentada invalida.');
	end
	for i = 1 : n
		printf('  ');
		for j = 1 : n
			printf('%10.4f ', Ab(i,j));
		end
		printf('| %10.4f\n', Ab(i,n+1));
	end
end

function opts = normalize_opts(opts)
	if ~isfield(opts, 'verbose')
		opts.verbose = true;
	end
	if ~isfield(opts, 'tol')
		opts.tol = 1e-12;
	end
	if ~isfield(opts, 'captureSteps')
		opts.captureSteps = false;
	end
end
