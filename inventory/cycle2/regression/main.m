method = 'linear'; % 'linear', 'power', 'poly', or 'multiple'

switch lower(method)
  case 'linear'
  case 'power'
  case 'poly'
  case 'multiple'
  otherwise
    error('Unknown method.');
end
