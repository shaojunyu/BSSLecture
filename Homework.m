% Shaojun Yu (shaojun.yu@emory.edu)
% Question 1
C = [4 1; 1 3];
[V, D] = eig(C);
V;
D;

% Question 2
N = 2;
v0 = rand(N, 1);
Itr = 100; % The number of power method iterations
v1 = EigenAnalysisPowerMethod(C, v0, Itr);
scale1 = (C*v1)./v1;
lambda1 = mean(scale1);

C = C - lambda1 * (v1 * v1');
v2 = EigenAnalysisPowerMethod(C, v0, Itr);
scale2 = (C*v2)./v2;
lambda2 = mean(scale2);

% plot
lamdas = (1:1:20);
C = [4 1; 1 3];
vectors = rand(20, 2);
for k = 1:20
    v1 = EigenAnalysisPowerMethod(C, v0, k);
    vectors(k,:) = v1;
    scale1 = (C*v1)./v1;
    lamdas(k) = mean(scale1);
end
% plot lamdas
plot(lamdas)
xlabel("Iterations")
ylabel("Lamda")

% plot vectors
plot(vectors)




