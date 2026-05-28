method = 'newton'; % 'newton', 'lagrange', 'vandermonde', or 'jacobi'

switch lower(method)
  case 'newton'
  case 'lagrange'
  case 'vandermonde'
  otherwise
    error('Unknown method.');
end

