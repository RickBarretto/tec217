
# 'ingenuo' | 'pivot'
method = 'ingenuo';

switch lower(method)
  case 'ingenuo'
  case 'pivot'
  otherwise
    error('Unknown method.');
end