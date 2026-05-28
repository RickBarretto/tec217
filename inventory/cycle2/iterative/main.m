
method = 'jacobi'; % 'jacobi', 'seidel', or 'sor'

switch lower(method)
  case 'jacobi'
  case 'seidel'
  case 'sor'
  otherwise
    error('Unknown method.');
end
