% check_ch26_ai.m -- Ch. 26 (AI ethics): Th 26.1, Th 26.5, Ex 26.1, Prop 26.5
fprintf('\n--- check_ch26_ai: Ch26 ---\n');

% --- Theorem 26.1: preimage of a smooth reward has dimension 8 ---------------
w = sym([2 -1 3 1 1 4 -2 5 1]);
ge_check('GE-THM-26-1', 32739, size(null(w),2) == 8, ...
    'level set R^-1(r) of a (linear, regular) reward on R^9 is 8-dimensional', '8');

% --- Theorem 26.5: alignment tax bound T(v) <= C K(v) L^2 -------------------
% Constant-covariance Mahalanobis metric (the book's edge-weight form) is flat: K = 0.
syms x1 x2 real
g = [2 1; 1 3];                        % constant PD metric (any constant Sigma^-1)
X = [x1 x2]; Gam = sym(zeros(2,2,2)); gi = inv(g);
for i = 1:2, for j = 1:2, for kk = 1:2
    s = 0;
    for l = 1:2, s = s + gi(i,l)*(diff(g(l,j),X(kk)) + diff(g(l,kk),X(j)) - diff(g(j,kk),X(l)))/2; end
    Gam(i,j,kk) = s;
end, end, end
flat = all(Gam(:) == 0);
% two routes to the goal, d_1 cost and full 2-D cost (Sigma = I for clarity)
dA = [1 3]; dB = [2 0];                 % route A: cheap on d_1, costly on d_2; route B: the reverse
fullA = dA*dA.'; fullB = dB*dB.'; c1A = dA(1)^2; c1B = dB(1)^2;
scalarPick = 'A'; if c1B < c1A, scalarPick = 'B'; end
manPick = 'A';  if fullB < fullA, manPick = 'B'; end
Ttax = c1B - c1A;                       % manifold route B minus scalar route A, d_1 cost
ge_check('GE-THM-26-5', 33046, ~(flat && Ttax > 0), ...
    'T(v) <= C K(v) L^2 (so T ~ 0 where K ~ 0; "In flat regions ... the scalar-optimal path is close to the manifold-optimal path")', ...
    sprintf('constant-Sigma metric has all Christoffels 0 (flat=%d, K = 0), yet scalar route %s (d_1 cost %d, full %d) vs manifold route %s (d_1 cost %d, full %d) gives alignment tax T = %d > 0 = C*K*L^2', ...
    flat, scalarPick, c1A, fullA, manPick, c1B, fullB, Ttax));
syms Lh positive
ge_check('GE-THM-26-5', 33084, limit(Lh^2/exp(Lh), Lh, inf) ~= 0, ...
    '(c) "alignment tax increases with decision horizon (L^2 dependence) ... long-horizon planning ... is exponentially more expensive"', ...
    sprintf('L^2 growth is polynomial: lim L^2/e^L = %s; the bound supports "quadratically", not "exponentially"', char(limit(Lh^2/exp(Lh), Lh, inf))));

% --- Example 26.1: COMPAS false-positive rates ------------------------------
ratio = 44.9/23.5;
ge_check('TEXT-Ch26', 33519, ratio > 1.8 && ratio < 2, ...
    'Black defendants "nearly twice as likely" to be falsely flagged: FPR 44.9% vs 23.5%', sprintf('ratio = %.2f', ratio));

% --- Prop 26.5 illustration: 95% aggregate with 95% on d_1 and 20% on d_3 ----
eqMax = (8*1 + 0.2)/9;
w3max = (1 - 0.95)/(1 - 0.2);
ge_check('TEXT-Ch26', 33472, w3max > 0, ...
    '"scores 95% on an aggregate safety benchmark ... 95% safe on d_1 but 20% on d_3" is arithmetically possible', ...
    sprintf('needs weight on d_3 <= %.4f', w3max));
ge_check('TEXT-Ch26', 33472, [], ...
    'aggregation weights are not stated', ...
    sprintf('with equal weights over 9 dimensions, 20%% on d_3 caps the aggregate at %.1f%% (< 95%%); the example requires d_3 weight <= 1/16', 100*eqMax));
