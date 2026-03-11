tries = [
     0
     2
    10
    -4
];

error_threshold = 1e-4;

for i = 1:length(tries)
    a = tries(i);
    [x, trace] = babylon(a, error_threshold);

    figure;
    plot(0:length(trace)-1, trace, '-o');
    xlabel('Iteração');
    ylabel('x');
    title(sprintf('Convergência de x para a = %d', a));
    grid on;
end
