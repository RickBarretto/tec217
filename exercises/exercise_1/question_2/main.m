tries = [
    0
    2
    10
    -4
];

error_threshold = 1e-4;

disp("a\te\tsqrt(a)");

for i = 1:length(tries)
    a = tries(i);
    [x, trace] = babylon(a, error_threshold);

    if a < 0
        fprintf('%.0f\t1e-4\t%.5fi\n', a, x);
    else
        fprintf('%.0f\t1e-4\t%.5f\n', a, x);
    end
end
