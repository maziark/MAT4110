n = 30;
start = -2;
stop = 2;

x = linspace(start, stop, n);

eps = 1;
rng(1);
r = rand(1, n) * eps;

y = 4*x.^5 - 5*x.^4 - 20*x.^3 + 10*x.^2 + 40*x + 10 + r;

plot(x, y, 'o');
