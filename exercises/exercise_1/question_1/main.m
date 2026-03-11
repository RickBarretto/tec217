data = [
     2,  0;
     2,  1;
     0,  3;
    -3,  1;
    -2,  0;
    -1, -2;
     0,  0;
     0, -2;
     2,  2;
];

disp("x\ty\tr\t0")
for i = 1:size(data, 1)

    x = data(i, 1);
    y = data(i, 2);
    r = radius_from(x, y);
    theta = angle_from(x, y);

    fprintf("%d\t%d", x, y);
    fprintf("\t%.2f\t%.2f\n", r, theta);
end
