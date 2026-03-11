function [x, trace] = babylon(a, error_threshold)
    is_negative = a < 0;
    # using b to avoid reassigning a, which is used for printing the result
    b = abs(a);

    if b == 0 
        x = 0;
        trace = [0];
    else
        x = b / 2;
        trace = [x];
        e = Inf;

        while e >= error_threshold
            old_x = x;
            x = close_sqrt(b, x);
            e = error_from(x, old_x);
            trace = [trace, x];
        end
    end
    x;
end
