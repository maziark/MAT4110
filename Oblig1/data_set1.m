n = 30;
start = -2;
stop = 2;

x = linspace(start, stop, n);
eps = 1;
rng(1);

r = rand(1, n) * eps;

y = x.*(cos(r+0.5*x.^3)+sin(0.5*x.^3));

plot(x,y,'o');

