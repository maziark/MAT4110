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

B = A'*A;

[L, D] = Cholesky(B);
% Now R is a lower triangle matrix. And we can use the forward subs.
R = L * D^(0.5);



figure(1)
x_result_1 = backward(R' , forward (R , A' * y_1'));
plot(x, y_1, 'o');
hold on
plot(x, A * x_result_1, '-');

figure(2)
x_result_2 = backward(R' , forward (R , A' * y_2'));
plot(x, y_2, 'o');
hold on
plot(x, A * x_result_2, '-');


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

function x_to_be = forward(U, b)
    n = length(U);
    x_to_be = zeros(n, 1);
    for i = 1 : n
        % Normalizing the diagonal
        x_to_be(i) = b(i) / U(i, i);
        % Updating the values
        b(i+1 : n) = b(i+1 : n) - U(i + 1 : n, i) * x_to_be(i);
    end
    
end

function [L, D] = Cholesky(A)
    n = length(A); 
    
    L = zeros(n);
    D = zeros(n);
    
    % Setting the initial value for A_k, k = 0;
    A_k = A;
    for k = 1: n
        D(k, k) = A_k(k, k);
        L_k = A_k(:, k) / D(k, k);
       
        A_k = A_k - D(k, k) * (L_k * L_k');
        
        L(: , k) = L_k;
    end  
end



