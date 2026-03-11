function theta = angle_from(x, y)
    if x > 0         theta = atan(y/x);
    elseif x < 0
        if y > 0     theta = atan(y/x) + pi;
        elseif y < 0 theta = atan(y/x) - pi;
        else         theta = pi;
        end
    else
        if y > 0     theta = pi/2;
        elseif y < 0 theta = -pi/2;
        else         theta = 0;
        end
    end
end
