n = 30;
m = 6;
start = -2;
stop = 2;

x = linspace(start, stop, n);
eps = 1;
rng(1);

r = rand(1, n) * eps;

y_1 = x.*(cos(r+0.5*x.^3)+sin(0.5*x.^3));
y_2 = 4*x.^5 - 5*x.^4 - 20*x.^3 + 10*x.^2 + 40*x + 10 + r;




A = ones (n, m);

for j = 2 : m
    for i = 1 : n
        A(i, j) = A(i, j - 1) * x(i); 
    end    
end

[Q, R] = qr(A, 0);
B = A'*A;


% We have Rx = Q'y, Where R is an upper traiangle matrix of size m , n:
figure(1)
x_QR_1 = backward(R, Q' * y_1');
plot(x, y_1, 'o');
hold on
plot(x, A*x_QR_1, '-');

figure(2)
x_QR_2 = backward(R, Q' * y_2');
plot(x, y_2, 'o');
hold on
plot(x, A*x_QR_2, '-');


function x_to_be = backward(U, b)
    % https://github.com/maziark/FYS3150-2018/blob/master/Project1/project1.cpp
    n = length(b);
    x_to_be = b;
    x_to_be(n) = x_to_be(n) / U(n, n);
    % backward step
    for i = n - 1 : -1 : 1
        % Using the fact that the matrix is upper traiangle
        for j = i + 1 : n
            x_to_be(i) = x_to_be(i) - U(i, j) * x_to_be(j);
        end
        % dividing by the diagonal value
        x_to_be(i) = x_to_be(i) / U(i, i);
    end
end



