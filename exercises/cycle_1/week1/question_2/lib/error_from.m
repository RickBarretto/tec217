function e = error_from(new, old)
    e = abs((new - old) ./ new);
end
